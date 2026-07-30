# Session Architecture

## Overview

The application follows a single source of truth approach for authentication.

- `SessionManager` owns the authenticated session.
- `AppCubit` reflects the current application state.
- `GoRouter` reacts to `AppCubit`.
- Feature packages (`auth`, `box`, `alert`, `profile`) never communicate directly with each other.

---

# High Level Flow

```text
                        User
                          │
                          ▼
                    Login Screen
                          │
                          ▼
                     LoginCubit
                          │
                          ▼
                    LoginUseCase
                          │
                          ▼
                   AuthRepository
                          │
                          ▼
                     AppSession
                          │
                          ▼
                  SessionManager.login()
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
 Save SecureStorage   Cache Session   Emit Session Stream
                                              │
                                              ▼
                                         AppCubit
                                              │
                                              ▼
                                         AppState
                                              │
                                              ▼
                                           GoRouter
                                              │
                                              ▼
                                         Home Screen
```

---

# Package Responsibilities

## main_app

Responsible for

- Session Management
- Routing
- App State
- Navigation
- DI
- Coordinators

```
main_app
│
├── app/
│   ├── cubit/
│   ├── navigation/
│   ├── session/
│   ├── coordinator/
│   └── di/
```

---

## auth package

Responsible only for authentication.

```
Login
Register
Forgot Password
Delete Account

↓

AuthRepository

↓

AppSession
```

It **does not**

- save tokens
- navigate
- update AppCubit

---

## SessionManager

Single source of truth for authenticated session.

Responsibilities

- Store current session
- Persist session
- Restore session
- Refresh current user
- Logout
- Disconnect MQTT
- Disconnect BLE
- Emit session changes

---

# AppSession

```dart
class AppSession {

  final User user;

  final AuthTokens tokens;

  final Brand brand;

}
```

Contains only authenticated session information.

---

# SessionManager API

```dart
abstract class SessionManager {

  AppSession? get current;

  Stream<AppSession?> get sessionStream;

  Future<void> login(AppSession session);

  Future<void> logout();

  Future<void> restore();

  Future<void> refreshUser();

}
```

---

# Login Flow

```text
LoginCubit
      │
      ▼
LoginUseCase
      │
      ▼
AuthRepository.login()
      │
      ▼
returns AppSession
      │
      ▼
SessionManager.login()
      │
      ▼
Session Stream emits
      │
      ▼
AppCubit
      │
      ▼
Authenticated
      │
      ▼
GoRouter Redirect
```

---

# Restore Session Flow

Executed when app starts.

```text
main()
    │
    ▼
DI
    │
    ▼
SessionManager.restore()
    │
    ▼
Secure Storage
    │
    ▼
Has Session?
    │
 ┌──┴──────────────┐
 │                 │
No               Yes
 │                 │
 ▼                 ▼
Login      refreshUser()
                     │
                     ▼
           AuthRepository.getUser()
                     │
                     ▼
           Updated AppSession
                     │
                     ▼
             Session Stream
                     │
                     ▼
                AppCubit
                     │
                     ▼
                Home Screen
```

---

# Logout Flow

```text
ProfileCubit
      │
      ▼
SessionManager.logout()
      │
      ├── Optional API Logout
      ├── Clear Secure Storage
      ├── Disconnect MQTT
      ├── Disconnect BLE
      ├── Clear Cached Session
      └── Emit null
               │
               ▼
          AppCubit
               │
               ▼
      AppStatus.unauthenticated
               │
               ▼
          GoRouter Redirect
               │
               ▼
             Login
```

---

# AppCubit Responsibilities

AppCubit **does not**

- Login
- Logout
- Save Tokens
- Refresh User

AppCubit **only reflects application state.**

```dart
AppState

- session
- status
- locale
- themeMode
- brand
```

It subscribes to SessionManager.

```text
SessionManager

↓

sessionStream

↓

AppCubit

↓

AppState
```

---

# GoRouter

GoRouter listens to AppCubit.

```dart
refreshListenable:
GoRouterRefreshStream(
    getIt<AppCubit>().stream,
)
```

Redirect example

```text
Authenticated

↓

Home

Unauthenticated

↓

Login
```

---

# Feature Dependencies

```text
                 main_app
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
    auth           box          profile
      │
      ▼
    core
```

Feature packages never depend on each other.

❌ box → alert

❌ alert → profile

❌ profile → auth

---

# SessionManager Dependencies

```text
SessionManager
│
├── SecureStorage
├── AuthRepository
├── MQTTManager
├── BLEManager
└── Session Stream
```

---

# Future Extensions

SessionManager is the correct place to add

- Refresh Token
- Token Expiry
- Silent Login
- Force Logout
- MQTT Connection
- BLE Cleanup
- User Refresh
- Session Expiry
- Multi-brand Switching

No feature package needs to change.

---

# Design Principles

✅ Single Source of Truth

Only SessionManager owns the authenticated session.

---

✅ Reactive

Everything reacts to Session changes.

```
SessionManager

↓

AppCubit

↓

GoRouter

↓

UI
```

---

✅ Clean Architecture

- Auth authenticates.
- SessionManager manages session.
- AppCubit reflects app state.
- Router performs navigation.

Each class has one responsibility.

---

# Recommended Dependency Flow

```text
UI
│
▼
Cubit
│
▼
UseCase
│
▼
Repository
│
▼
SessionManager (if authentication changes)
│
▼
AppCubit
│
▼
GoRouter
│
▼
Screen
```

This keeps authentication centralized while allowing every feature package to remain independent.