# GrubPac Medical App CI/CD & Deployment Guide

This guide describes how the automated GitHub Actions pipelines work for **Google Drive Build Distribution** and **Google Play Console Branch Deployment**.

---

## 1. Pipelines Overview

| Workflow | Triggers | Artifact Produced | Target Destination |
| :--- | :--- | :--- | :--- |
| **`Build & Upload to Google Drive`** (`.github/workflows/build-and-upload-drive.yml`) | • Push to `main`<br>• Manual `workflow_dispatch` | APKs (and/or AABs) for `dev` & `prod` | • GitHub Actions Run Artifacts<br>• Google Drive (in-place version update) |
| **`Branch Deploy to Play Console`** (`.github/workflows/deploy-play-console.yml`) | • Push to `release/**`<br>• Push to `deploy/**`<br>• Manual `workflow_dispatch` | Signed Android App Bundles (`.aab`) | • Google Play Console tracks (`internal`, `alpha`, `beta`, `production`) |

---

## 2. In-Place Google Drive Version Updating

When code is pushed to `main`, the workflow compiles the APKs and uses `.github/scripts/upload_to_gdrive.py` to upload the build to Google Drive.

### How it preserves the link and updates the version:
1. Google Drive assigns a unique **`fileId`** to each file.
2. The upload script calls the Google Drive REST API `files.update` endpoint with `keepRevisionForever: true`.
3. **The file's URL never changes**: Testers and team members keep the exact same Google Drive link (`https://drive.google.com/file/d/<fileId>/view`).
4. Google Drive tracks each upload in its **"Manage versions"** history tab, showing the upload timestamp and user.
5. If you provide a `GDRIVE_FOLDER_ID` instead of a `fileId`, the script automatically searches the folder for `grubpac-medical-dev.apk` or `grubpac-medical-prod.apk`. If it exists, it updates that file's version; if not, it creates it and provides the link.

---

## 3. Required GitHub Secrets Checklist

Navigate to your GitHub repository -> **Settings** -> **Secrets and variables** -> **Actions** and add the following secrets:

### A. Android Release Signing Keystore
| Secret Name | Description | Example |
| :--- | :--- | :--- |
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded string of your `.jks` keystore file | *(See command below)* |
| `KEYSTORE_PASSWORD` | Password for the keystore file | `grub2026` |
| `KEY_ALIAS` | Key alias inside the keystore | `upload` |
| `KEY_PASSWORD` | Password for the key alias | `grub2026` |

> **To generate `ANDROID_KEYSTORE_BASE64` on your machine:**
> - **PowerShell (Windows)**:
>   ```powershell
>   [Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\upload-keystore.jks")) | Set-Clipboard
>   ```
> - **macOS / Linux**:
>   ```bash
>   base64 -w 0 path/to/upload-keystore.jks | pbcopy
>   ```

---

### B. Google Drive Integration
| Secret Name | Description | Where to get it |
| :--- | :--- | :--- |
| `GDRIVE_SERVICE_ACCOUNT_KEY` | Full JSON string of a Google Cloud Service Account key | Google Cloud Console -> IAM & Admin -> Service Accounts |
| `GDRIVE_FOLDER_ID` *(Recommended)* | Google Drive folder ID where APKs are stored | Last segment of the Drive folder URL: `drive.google.com/drive/folders/<FOLDER_ID>` |
| `GDRIVE_DEV_FILE_ID` *(Optional)* | Existing File ID for Dev APK | URL segment: `drive.google.com/file/d/<FILE_ID>/view` |
| `GDRIVE_PROD_FILE_ID` *(Optional)* | Existing File ID for Prod APK | URL segment: `drive.google.com/file/d/<FILE_ID>/view` |

#### Setting up the Google Cloud Service Account:
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select a project (e.g. `GrubPac-Mobile`).
3. Enable the **Google Drive API** in APIs & Services -> Library.
4. Navigate to **IAM & Admin** -> **Service Accounts** -> **Create Service Account**.
5. Click on the created service account -> **Keys** tab -> **Add Key** -> **Create new key** -> **JSON**.
6. Open the downloaded JSON file and paste its entire content into the `GDRIVE_SERVICE_ACCOUNT_KEY` GitHub secret.
7. **Important**: Open your Google Drive folder, click **Share**, and share the folder with the Service Account email address (e.g. `service-account@project.iam.gserviceaccount.com`) as **Editor**.

---

### C. Google Play Console Integration
| Secret Name | Description | Where to get it |
| :--- | :--- | :--- |
| `PLAY_STORE_JSON_KEY` | Full JSON key of a Google Cloud Service Account linked to Play Console | Google Play Console -> Setup -> API access |

#### Linking Service Account to Google Play Console:
1. Open the [Google Play Console](https://play.google.com/console).
2. Go to **Setup** -> **API access**.
3. Link your Google Cloud Project or create a new linked service account.
4. Grant the Service Account the **Releases** permission:
   - "Manage production releases"
   - "Manage testing track releases (Internal, Closed, Open)"
5. In Google Cloud Console, download the JSON key for that service account and paste its content into `PLAY_STORE_JSON_KEY`.

---

## 4. Triggering Deployments

### Triggering Google Drive Builds:
* **Automatic**: Push any commit or merge a PR into the `main` branch.
* **Manual**: In GitHub Actions, select **Build & Upload to Google Drive** -> Click **Run workflow** -> Choose Flavor (`all`, `dev`, `prod`) and Type (`apk`, `aab`, `both`).

### Triggering Play Console Deployments:
* **Via Branch Push**:
  * Push to a branch starting with `release/` or `deploy/`:
    ```bash
    git checkout -b release/v1.0.1
    git push origin release/v1.0.1
    ```
* **Via GitHub Actions UI**:
  * Navigate to **Actions** -> **Branch Deploy to Google Play Console**.
  * Click **Run workflow**.
  * Configure:
    * **Flavor**: `both`, `dev`, or `prod`.
    * **Track**: `internal` (recommended for testing) or `production`.
    * **Rollout fraction**: e.g., `1.0` (100%) or `0.2` (20% staged rollout).
    * **Release notes**: Short message describing the update.
