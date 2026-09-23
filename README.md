# GrubPac Medical App (Production)

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
