# GrubPac Medical App (Release) 

Welcome to the **GrubPac Medical** application. This repository contains the code for the main production environment of the app.

---

## 🚀 Getting Started

Follow these steps to set up the project on your local machine and run the production application.

### 1. Prerequisites (Setting up Flutter)
Ensure you have the following installed on your machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.22.x or later is recommended)
* [Dart SDK](https://dart.dev/get-dart)
* Android Studio (with Android SDK) or Visual Studio Code
* Xcode (for iOS development, macOS only)

To verify your Flutter installation, run:
```bash
flutter doctor
```

### 2. Clone the Repository
Clone the project repository to your local machine:
```bash
git clone <repository_url>
cd medical-app
```

### 3. Switch to Main Branch
Ensure you are on the `main` branch which contains the production-ready code:
```bash
git checkout main
```

### 4. Fetch Dependencies
Download the required packages defined in `pubspec.yaml`:
```bash
flutter pub get
```

### 5. Running the Application (Production Flavor)
The app is configured using Flutter flavors. To run the production environment, you must specify the `prod` flavor and the `main_prod.dart` entry point.

Run on an attached device or emulator:
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### 6. Build a Production APK

Configure `android/key.properties` with the release keystore's `storeFile`, `storePassword`, `keyAlias`, and `keyPassword`. Keep the keystore and passwords private.

From the project root:
```bash
flutter pub get
flutter build apk --release --flavor prod -t lib/main_prod.dart
```

The APK is generated at `build/app/outputs/flutter-apk/app-prod-release.apk`.

Install it on a connected Android device with Android SDK Platform Tools:
```bash
adb install -r build/app/outputs/flutter-apk/app-prod-release.apk
```

To build a production App Bundle (AAB) for Google Play:
```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

---

## 🌍 URLs and Endpoints

**Production (Live) URL:**
* `https://43.204.34.10.nip.io/api/v1`

*(Note: Production endpoints connect to the live backend server. All API requests are routed through the `/medical-mobile/owner` path.)*

---

## 🏗️ Architecture

The app is built using a structured combination of **Clean Architecture** principles and **GetX** for state management, dependency injection, and routing.

### Key Architectural Layers:
1. **View/Presentation Layer (`lib/screens/`)**: Contains the Flutter UI code (`_screen.dart` files) and GetX Controllers (`_controller.dart`). The views observe state changes from the controllers.
2. **Domain/Repository Layer (`lib/screens/.../repo/`)**: Contains repository classes that act as the single source of truth for data fetching. They abstract the API client from the controllers.
3. **Data/Network Layer (`lib/data/`)**:
   * **`ApiClient`**: A centralized HTTP client wrapper handling token injection, timeouts, error parsing, and multipart requests.
   * **`TokenStore`**: Manages secure storage and refreshing of JWT auth tokens.
4. **Configuration Layer (`lib/core/flavor/`)**:
   * **`AppFlavorConfig`**: Manages environment-specific variables like app name, package ID, base URLs, and feature flags based on the active flavor (`prod`).

### State Management & DI
* **GetX** is used extensively. Dependency Injection (DI) is initialized in `lib/helper/get_di.dart`, where all Repositories, Controllers, and core services (like `ApiClient` and `SharedPreferences`) are lazily registered (`Get.lazyPut()`).

---

## ⚡ CI/CD Automation & Deployment Workflows

This repository includes production-ready **GitHub Actions CI/CD workflows** for automated continuous integration, in-place Google Drive build version updates, and multi-track Google Play Console branch deployments.

### 📊 Pipelines Overview

| Workflow | Triggers | Artifact Built | Destination |
| :--- | :--- | :--- | :--- |
| **`Build & Upload to Google Drive`**<br>`build-and-upload-drive.yml` | • `push` to `main`<br>• Manual `workflow_dispatch` | Release `.apk` (or `.aab`) for `dev` & `prod` | • GitHub Actions Run Artifacts<br>• **Google Drive** (in-place version update) |
| **`Branch Deploy to Play Console`**<br>`deploy-play-console.yml` | • `push` to `release/**`<br>• `push` to `deploy/**`<br>• Manual `workflow_dispatch` | Signed Release `.aab` (Android App Bundle) | • **Google Play Console** (`internal`, `alpha`, `beta`, `production`) |

---

### 1. 🔄 Google Drive In-Place Version Updater

When code is merged into `main`, GitHub Actions automatically:
1. Runs `flutter analyze` code quality gates.
2. Compiles release APKs for both flavors (`dev` and `prod`).
3. Uses `.github/scripts/upload_to_gdrive.py` to **update the existing file in-place** on Google Drive via the Drive REST API (`files.update`).

#### Key Benefit: Permanent Shareable Link
* The Google Drive link you share with testers/QA (**`https://drive.google.com/file/d/<FILE_ID>/view`**) **never changes**.
* Google Drive automatically registers a new version in its **"Manage versions"** revision history on every push.

---

### 2. 🚀 Branch Deploy to Google Play Console

The Play Console deployment workflow is triggered either **automatically** on branch push or **manually** via the GitHub UI.

#### Automated Versioning:
* **`versionCode` (Build Number)**: Automatically calculated as:
  $$\text{versionCode} = \text{Base Code from pubspec.yaml} + \text{GITHUB\_RUN\_NUMBER}$$
  This guarantees that Google Play Console **never rejects builds** due to duplicate or lower version codes.
* **`versionName`**: Automatically extracted from the branch name if following standard conventions (e.g. pushing `release/v1.2.0` automatically sets `versionName` to `1.2.0`), or can be overridden in manual UI dispatch.

#### Supported Tracks:
* **Dev Flavor (`com.grubpac.medical.test`)**: Automatically published to the **Internal testing** track.
* **Prod Flavor (`com.grubpac.medical`)**: Published to the chosen track (**`internal`**, **`alpha`**, **`beta`**, or **`production`**) with support for staged rollout fractions (e.g. `0.1` to `1.0`).

---

### 3. 🔐 Required GitHub Repository Secrets Checklist

Go to **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**:

#### A. Android Keystore (For Signed Release Builds)
| Secret Name | Value Description | Example / Command |
| :--- | :--- | :--- |
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded string of `upload-keystore.jks` | Run PowerShell command below |
| `KEYSTORE_PASSWORD` | Password for the keystore file | `grub2026` |
| `KEY_ALIAS` | Key alias name | `upload` |
| `KEY_PASSWORD` | Password for the key alias | `grub2026` |

> **PowerShell command to copy keystore as Base64 to clipboard:**
> ```powershell
> [Convert]::ToBase64String([IO.File]::ReadAllBytes("android\upload-keystore.jks")) | Set-Clipboard
> ```

#### B. Google Drive Integration
| Secret Name | Value Description | How to get it |
| :--- | :--- | :--- |
| `GDRIVE_SERVICE_ACCOUNT_KEY` | Entire JSON content of Google Cloud Service Account key | Google Cloud Console -> IAM -> Service Accounts -> Keys -> JSON |
| `GDRIVE_FOLDER_ID` | Google Drive folder ID where APKs live | From folder URL: `drive.google.com/drive/folders/<FOLDER_ID>` |
| `GDRIVE_DEV_FILE_ID` | File ID of existing `grubpac-medical-dev.apk` | From file link: `drive.google.com/file/d/<FILE_ID>/view` |
| `GDRIVE_PROD_FILE_ID` | File ID of existing `grubpac-medical-prod.apk` | From file link: `drive.google.com/file/d/<FILE_ID>/view` |

> [!IMPORTANT]
> **Avoid 0 MB Quota Error**: Google Service Accounts have 0 MB personal quota and cannot own files in personal Google Drive folders. Pre-upload a placeholder file named **`grubpac-medical-dev.apk`** to your folder yourself, copy its File ID into `GDRIVE_DEV_FILE_ID`, and share the folder with the Service Account email as **Editor**. The Service Account will update the file in-place with zero quota limitations.

#### C. Google Play Console Integration
| Secret Name | Value Description | Where to get it |
| :--- | :--- | :--- |
| `PLAY_STORE_JSON_KEY` | Entire JSON key of Service Account linked to Play Console | Google Play Console -> Setup -> API access |

---

### 4. 🛠️ Google Play Console Setup Steps

1. **First-Time Initial Upload**: Google Play Developer API requires the *very first build* of a new application ID (`com.grubpac.medical.test` / `com.grubpac.medical`) to be uploaded manually once via the Play Console web UI (**Internal testing** -> **Create new release**).
2. **Invite Service Account**:
   * Open [Google Play Console](https://play.google.com/console) -> **Users and permissions** -> **Invite new users**.
   * Email: `amar-github@onyx-sequencer-513608-f6.iam.gserviceaccount.com` (or your service account email).
   * **App permissions**: Add `GrubPac Medical App`.
   * **Account permissions**: Check:
     * [x] **Manage testing track releases (Internal, Closed, Open)**
     * [x] **Manage production releases**
     * [x] **Edit and delete draft releases**
     * [x] **View app information (read-only)**
   * Click **Invite user**.

---

### 5. 🎯 How to Trigger Pipelines

#### Trigger Google Drive Build:
* **Automatic**: Push or merge into the `main` branch:
  ```bash
  git push origin main
  ```
* **Manual**: Go to **Actions** -> **Build & Upload to Google Drive** -> Click **Run workflow**.

#### Trigger Google Play Console Deployment:
* **Automatic via Branch Push**:
  ```bash
  git checkout -b release/v1.0.5
  git push origin release/v1.0.1
  ```
* **Manual**: Go to **Actions** -> **Branch Deploy to Google Play Console** -> Click **Run workflow** -> Choose flavor (`both`, `dev`, or `prod`) and target track (`internal` or `production`).

---

### 6. 📱 Local Flutter Flavor Commands

| Action | Dev Flavor (`com.grubpac.medical.test`) | Prod Flavor (`com.grubpac.medical`) |
| :--- | :--- | :--- |
| **Run Locally** | `flutter run --flavor dev -t lib/main_dev.dart` | `flutter run --flavor prod -t lib/main_prod.dart` |
| **Build APK** | `flutter build apk --flavor dev -t lib/main_dev.dart --release` | `flutter build apk --flavor prod -t lib/main_prod.dart --release` |
| **Build AAB** | `flutter build appbundle --flavor dev -t lib/main_dev.dart --release` | `flutter build appbundle --flavor prod -t lib/main_prod.dart --release` |
