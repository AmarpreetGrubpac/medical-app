# Plan: Flutter App Simulator Heartbeat Integration

Integrate a clean, removable periodic heartbeat/polling loop into the Flutter Driver App (`BoxDetailsController`) that queries the virtual box state from the simulator endpoint.

## Scope

- **In**:
  - Add `getSimulatorState` to `BoxManagementRepo` pointing to `/simulator/boxes/{box_id}/state` (PATCH with empty body).
  - Add periodic `Timer` to `BoxDetailsController` that fetches state and updates UI.
  - Implement a toggle constant `enableSimulatorHeartbeat` to turn it on/off easily.
- **Out**:
  - Any permanent modifications to standard production endpoints.

## Action Items

1. [ ] Add `getSimulatorState(String boxId)` to [box_repo.dart](file:///Users/robin/Desktop/driver_app-zabee_working/lib/screens/settings_section/box_management/controller/box_repo.dart).
2. [ ] Add `_enableSimulatorHeartbeat` toggle, `_simulatorHeartbeatTimer`, and `_startSimulatorHeartbeat()` implementation to [box_details_controller.dart](file:///Users/robin/Desktop/driver_app-zabee_working/lib/screens/box_details/controller/box_details_controller.dart).
3. [ ] Initialize and cancel the timer in the controller's lifecycle hooks (`onInitMethod` / `onClose`).
4. [ ] Verify that there are no compilation errors in the Flutter project.

## Open Questions

- None. (Implementation is fully isolated and easy to remove).
