#!/usr/bin/env python3
"""
Upload or update builds on Google Drive.
Updates existing file versions in place (preserving the same fileId and shareable link).
"""

import os
import sys
import json
import argparse
from pathlib import Path

try:
    from google.oauth2 import service_account
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaFileUpload
    from googleapiclient.errors import HttpError
except ImportError:
    print("Error: Missing Google API packages. Install with:")
    print("  pip install google-api-python-client google-auth google-auth-httplib2")
    sys.exit(1)

SCOPES = ['https://www.googleapis.com/auth/drive']


def parse_args():
    parser = argparse.ArgumentParser(description="Upload or update APK/AAB to Google Drive.")
    parser.add_argument("--file-path", required=True, help="Path to local APK or AAB file")
    parser.add_argument("--file-name", required=False, help="Target file name on Drive (defaults to local file name)")
    parser.add_argument("--file-id", required=False, default=None, help="Specific Google Drive file ID to update")
    parser.add_argument("--folder-id", required=False, default=None, help="Target Google Drive folder ID")
    parser.add_argument("--flavor", required=False, default="app", help="Flavor name (dev, prod, etc.)")
    parser.add_argument("--service-account-json", required=False, default=None, help="Raw JSON string or file path")
    return parser.parse_args()


def get_drive_service(creds_input=None):
    creds_raw = creds_input or os.environ.get("GDRIVE_SERVICE_ACCOUNT_KEY")
    if not creds_raw or not creds_raw.strip():
        raise ValueError(
            "Google Drive Service Account Key is missing. "
            "Please provide --service-account-json or set the GDRIVE_SERVICE_ACCOUNT_KEY secret/env var."
        )

    creds_str = creds_raw.strip()
    if os.path.exists(creds_str):
        credentials = service_account.Credentials.from_service_account_file(creds_str, scopes=SCOPES)
    else:
        try:
            creds_data = json.loads(creds_str)
            credentials = service_account.Credentials.from_service_account_info(creds_data, scopes=SCOPES)
        except json.JSONDecodeError as e:
            raise ValueError(f"Failed to parse GDRIVE_SERVICE_ACCOUNT_KEY as JSON: {e}")

    return build('drive', 'v3', credentials=credentials)


def determine_mime_type(file_path: str) -> str:
    ext = Path(file_path).suffix.lower()
    if ext == '.apk':
        return 'application/vnd.android.package-archive'
    if ext == '.aab':
        return 'application/octet-stream'
    return 'application/octet-stream'


def update_existing_file(service, file_id: str, local_path: str, mime_type: str, new_name: str = None):
    print(f"--> Updating existing file version for ID: {file_id}")
    media = MediaFileUpload(local_path, mimetype=mime_type, resumable=True)

    body = {}
    if new_name:
        body['name'] = new_name

    updated_file = service.files().update(
        fileId=file_id,
        body=body if body else None,
        media_body=media,
        keepRevisionForever=True,
        fields='id, name, webViewLink, webContentLink, version, modifiedTime'
    ).execute()
    return updated_file


def search_file_in_folder(service, folder_id: str, file_name: str):
    query = f"'{folder_id}' in parents and name = '{file_name}' and trashed = false"
    response = service.files().list(
        q=query,
        spaces='drive',
        fields='files(id, name, webViewLink, webContentLink, version)',
        pageSize=10
    ).execute()
    files = response.get('files', [])
    return files[0] if files else None


def create_file_in_folder(service, folder_id: str, local_path: str, file_name: str, mime_type: str):
    print(f"--> Creating new file '{file_name}' in folder: {folder_id}")
    media = MediaFileUpload(local_path, mimetype=mime_type, resumable=True)
    body = {
        'name': file_name,
        'parents': [folder_id]
    }
    created_file = service.files().create(
        body=body,
        media_body=media,
        fields='id, name, webViewLink, webContentLink, version'
    ).execute()

    # Attempt to set public or shared viewer permission if allowed
    try:
        service.permissions().create(
            fileId=created_file['id'],
            body={'role': 'reader', 'type': 'anyone'}
        ).execute()
    except Exception as e:
        print(f"Note: Could not set public link permission (may be restricted by organization policy): {e}")

    return created_file


def append_step_summary(flavor, file_name, file_id, link, action):
    summary_file = os.environ.get("GITHUB_STEP_SUMMARY")
    if not summary_file:
        return
    try:
        with open(summary_file, "a", encoding="utf-8") as f:
            f.write(f"\n### Google Drive Build: `{flavor.upper()}`\n")
            f.write(f"- **Action**: {action}\n")
            f.write(f"- **File Name**: `{file_name}`\n")
            f.write(f"- **File ID**: `{file_id}`\n")
            f.write(f"- **Shareable Link**: [Open on Google Drive]({link})\n")
    except Exception as e:
        print(f"Could not write to GITHUB_STEP_SUMMARY: {e}")


def main():
    args = parse_args()
    local_path = os.path.abspath(args.file_path)

    if not os.path.isfile(local_path):
        print(f"Error: Local build file not found at: {local_path}")
        sys.exit(1)

    file_size_mb = os.path.getsize(local_path) / (1024 * 1024)
    target_name = args.file_name or os.path.basename(local_path)
    mime_type = determine_mime_type(local_path)

    print("==================================================")
    print(" Google Drive Artifact Upload / Version Updater")
    print("==================================================")
    print(f"Local File:    {local_path} ({file_size_mb:.2f} MB)")
    print(f"Target Name:   {target_name}")
    print(f"Target Flavor: {args.flavor}")
    print(f"Target File ID: {args.file_id or '(Not specified)'}")
    print(f"Target Folder:  {args.folder_id or '(Not specified)'}")
    print("==================================================")

    service = get_drive_service(args.service_account_json)

    target_file = None
    action_taken = ""

    # Strategy 1: Explicit file ID supplied
    if args.file_id and args.file_id.strip():
        file_id = args.file_id.strip()
        try:
            target_file = update_existing_file(service, file_id, local_path, mime_type, target_name)
            action_taken = "Updated Existing File Version"
        except HttpError as err:
            print(f"Warning: Failed to update by explicit File ID ({file_id}): {err}")
            if not args.folder_id:
                raise

    # Strategy 2: Folder ID supplied (find existing file or create)
    if not target_file and args.folder_id and args.folder_id.strip():
        folder_id = args.folder_id.strip()
        existing = search_file_in_folder(service, folder_id, target_name)
        if existing:
            file_id = existing['id']
            print(f"Found existing file with name '{target_name}' (ID: {file_id}). Updating version...")
            target_file = update_existing_file(service, file_id, local_path, mime_type, target_name)
            action_taken = "Updated Existing File Version"
        else:
            target_file = create_file_in_folder(service, folder_id, local_path, target_name, mime_type)
            action_taken = "Created New File"

    if not target_file:
        raise ValueError(
            "Neither a valid --file-id nor --folder-id was accessible to store the artifact."
        )

    file_id = target_file.get('id')
    link = target_file.get('webViewLink') or f"https://drive.google.com/file/d/{file_id}/view"
    version = target_file.get('version', 'N/A')

    print("==================================================")
    print(f" SUCCESS: {action_taken}")
    print(f" File ID:     {file_id}")
    print(f" File Name:   {target_file.get('name')}")
    print(f" Version:     {version}")
    print(f" Drive Link:  {link}")
    print("==================================================")

    append_step_summary(args.flavor, target_name, file_id, link, action_taken)

    # Set GitHub Actions output parameters if running in CI
    gh_output = os.environ.get("GITHUB_OUTPUT")
    if gh_output:
        try:
            with open(gh_output, "a", encoding="utf-8") as f:
                f.write(f"file_id={file_id}\n")
                f.write(f"drive_link={link}\n")
                f.write(f"file_name={target_name}\n")
        except Exception as e:
            print(f"Could not write to GITHUB_OUTPUT: {e}")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"FAILED: {e}")
        sys.exit(1)
