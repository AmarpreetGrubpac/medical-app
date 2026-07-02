# Plan: Flutter App Global Simulator Heartbeat via Health API

Refactor the simulator heartbeat polling loop to query the global GET `/health` endpoint instead of PATCH `/state`, and move the timer logic to `BoxManagementController` to sync state globally across both the list view and detail view.

## Scope

- **In**:
  - Add `getSimulatorHealth(boxId)` to `BoxManagementRepo` calling `GET /simulator/boxes/{box_id}/health`.
  - Remove `getSimulatorState(boxId)` from `BoxManagementRepo` and `_startSimulatorHeartbeat()` from `BoxDetailsController`.
  - Add `_simulatorHeartbeatTimer`, `_enableSimulatorHeartbeat` toggle, and global polling loop to `BoxManagementController`.
  - The global loop updates `BoxManagementController.boxes` and checks if `BoxDetailsController` is active to sync the detailed view UI.
- **Out**:
  - Polling inside `BoxDetailsController`.

## Action Items

1. [x] Update [box_repo.dart](file:///Users/robin/Desktop/driver_app-zabee_working/lib/screens/settings_section/box_management/controller/box_repo.dart): replace `getSimulatorState` with `getSimulatorHealth(String boxId)`.
2. [x] Update [box_details_controller.dart](file:///Users/robin/Desktop/driver_app-zabee_working/lib/screens/box_details/controller/box_details_controller.dart): remove the heartbeat timer, initialization hook, and local heartbeat method.
3. [x] Update [box_management_controller.dart](file:///Users/robin/Desktop/driver_app-zabee_working/lib/screens/settings_section/box_management/controller/box_management_controller.dart):
    - Add `_enableSimulatorHeartbeat` toggle.
    - Add `_simulatorHeartbeatTimer` and `_startGlobalSimulatorHeartbeat()` polling all boxes in the list.
    - If `BoxDetailsController` is currently open for a box, dynamically update its state properties and call its `update()`.
    - Initialize the timer in `onInit` and cancel it in `onClose`.
4. [x] Verify compilation of the Flutter application.

## Open Questions

- None. (This approach ensures seamless global sync between list and detail views).
