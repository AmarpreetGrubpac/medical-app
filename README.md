# 🚚 GrubPac Driver App

---

## 🚀 Getting Started

This repository is the foundation for a **GrubPac Driver** app built using Flutter.

### 📚 Helpful Flutter Resources

- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter Docs](https://docs.flutter.dev/)

---

## ⚙️ Environment Setup

Ensure your development environment is configured as follows:

| Tool           | Version        |
|----------------|----------------|
| Flutter        | stable, 3.32.2 |
| Android Studio | 2024.3         |
| VS Code        | 1.100.3        |
| OpenJDK        | 21.0.5         |
| macOS          | 15.4.1 (ARM64) |

---

## 📁 Project Structure

```plaintext
lib/
├── main.dart               # App entry point
│
├── common_components/      # Reusable widgets like buttons, text fields, etc.
│
├── core/                   # Foundational code for theme and utilities
│   ├── theme/              # Light/Dark themes
│   │   ├── app_theme.dart
│   │   ├── dark_theme_colors.dart
│   │   └── light_theme_colors.dart
│   └── utils/              # Helpers and constants
│       ├── app_images.dart
│       ├── app_string.dart
│       ├── app_text_styles.dart
│       └── app_toast.dart
│
├── helper/                 # Routing and Dependency Injection
│   ├── get_di.dart
│   └── route_helper.dart
│
└── screens/                # App screens
    ├── auth_screens/
    │   ├── controller/     # GetX controllers for auth
    │   ├── data/           # Auth models and repositories
    │   └── view/           # Auth UI screens
    ├── dashboard_screen/
    ├── home_screen/
    └── splash_screen/

## Screen Module Structure

Each feature-specific screen directory (e.g., `auth_screens`, `dashboard_screen`) follows a consistent structure to keep related code organized. Here's a breakdown of the structure using `auth_screens` as an example:

*   `controller/`: This directory contains GetX controllers responsible for managing the screen's state and business logic. For example, in `auth_screens`, you might have a `LoginController` that handles form validation, API calls, and navigation.
*   `data/`: This directory holds data models and repositories specific to the feature. In the case of `auth_screens`, you might have a `UserModel` and a `AuthRepository` that encapsulates API calls for authentication.
*   `view/`: This directory contains the UI (widgets and screens) for the feature. For `auth_screens`, you might have a `LoginScreen` widget that uses the `LoginController` and displays the login form.

This structure helps maintain a clear separation of concerns, making it easier to develop, test, and maintain individual features within the application.

## State Management

This project uses **GetX** for state management, dependency injection, and route management.

## Flutter Commands

### Build Commands

*   **Generate APK:**
    ```sh
    flutter build apk --release
    ```
*   **Generate App Bundle (AAB):**
    ```sh
    flutter build appbundle --release
    ```

### Clean Command

*   To clean the project and remove the build directory:
    ```sh
    flutter clean
    ```

### iOS Pods

*   **Install/Update Pods:** (Navigate to the `ios` directory first)
    ```sh
    cd ios
    pod install
    ```

