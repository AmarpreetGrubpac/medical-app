# Plan

Migrate the Flutter app from delivery-mobile APIs to the centralized Medical Owner vertical while preserving confirmed-compatible box contracts. Harden authentication, remove blocked OTP lock behavior, and keep user-visible states accurate.

## Scope

- In: Medical Owner route migration, secure token handling, bounded refresh, claim/direct-lock flows, notification pagination, owner copy, error/loading states, and safe simulator polling.
- Out: Blocked endpoints and unused dashboard, location, bulk GrubLock, or support-answer integrations.

## Action Items

- [x] Centralize the configurable Medical Owner base path and replace active delivery routes.
- [x] Add secure token storage with legacy SharedPreferences migration and logout cleanup.
- [x] Refactor `ApiClient` URI building, authentication options, logging, structured errors, and bounded refresh behavior.
- [x] Update repositories for Medical Owner auth, claim, direct lock, profile, notifications, and support contracts.
- [x] Remove lock OTP state and calls across home, box management, and box details; add explicit lock/unlock confirmation.
- [x] Correct owner box-connection semantics and owner-facing claim, role, recovery, and delivery copy.
- [x] Add distinct loading, empty, data, and retry states for boxes and support; append notification pages safely.
- [x] Make simulator heartbeat debug-only, lifecycle-aware, and single-flight.
- [x] Add focused contract and behavior tests for changed API-client and repository logic.
- [x] Format, analyze, test, and search for remaining active delivery routes or sensitive logging.

## Open Questions

- Live success verification for claim and direct lock requires a test box assigned to the Medical Owner account.
