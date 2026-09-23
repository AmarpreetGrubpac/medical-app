# GrubPac Medical App (Demo Environment)

Welcome to the **GrubPac Medical** application. This branch (`demo`) contains the code configured with a fully mockable, offline Demo Mode designed for testing and showcasing the app without server interference.

---

## 🚀 Getting Started

Follow these steps to set up the project and run the demo application locally.

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

### 3. Switch to Demo Branch
Check out the `demo` branch to access the demo configuration and mock features:
```bash
git checkout demo
```

### 4. Fetch Dependencies
Download the required packages defined in `pubspec.yaml`:
```bash
flutter pub get
```

### 5. Running the Application (Demo Flavor)
The demo features are tied to the **Dev** flavor. To run the app with demo mode enabled, you must specify the `dev` flavor and the `main_dev.dart` entry point.

Run on an attached device or emulator:
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

To build a testing App Bundle (AAB):
```bash
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

*(You can toggle the Demo Mode directly from the app's Login Screen by clicking the "EXPLORE DEMO MODE" button).*

---

## 🌍 URLs and Endpoints

**Demo / Dev URL:**
* `https://preprod.43.204.34.10.nip.io/api/v1`

**Note on Mock Data:** 
When the "Demo Mode" toggle is activated in the app, the base URL is completely ignored. Instead, all API calls to `/medical-mobile/owner/...` endpoints are intercepted at the network layer and instant mock JSON responses are returned from the local code.

---

## 🏗️ Architecture

The app is built using a structured combination of **Clean Architecture** principles and **GetX** for state management. 

### Key Architectural Layers:
1. **View/Presentation Layer (`lib/screens/`)**: Contains the Flutter UI code and GetX Controllers.
2. **Domain/Repository Layer (`lib/screens/.../repo/`)**: Contains repository classes that act as the single source of truth for data fetching.
3. **Data/Network Layer (`lib/data/`)**: 
   * **`ApiClient`**: A centralized HTTP client wrapper. **In this branch, `ApiClient` is modified to check for the `isDemoMode` flag in SharedPreferences. If active, it intercepts outgoing GET/POST/PUT/DELETE requests.**
   * **`MockDataProvider`**: A dedicated service residing in `lib/data/mock/mock_data_provider.dart` that contains static, hardcoded JSON structures for all expected API responses.
   * **`TokenStore`**: Manages secure storage of JWT auth tokens.
4. **Configuration Layer (`lib/core/flavor/`)**: 
   * **`AppFlavorConfig`**: Manages environment-specific variables. The `dev` flavor explicitly sets `hasTestMode: true`, allowing the Demo Mode logic to execute.

### State Management & DI
* **GetX** is used extensively. Dependency Injection (DI) is initialized in `lib/helper/get_di.dart`, where all Repositories, Controllers, and core services are lazily registered (`Get.lazyPut()`). `SharedPreferences` is explicitly injected into `ApiClient` to allow instant reads of the demo state flag.
