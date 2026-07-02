# Plan - Virtual Box Simulator API Design

## Goal
Design a RESTful, resource-oriented API specification for a Virtual Box Simulator to mock and manipulate physical Grublock box behaviors (temperatures, battery, lock state, connection status, and alerts) for testing and development.

---

## API Design Specifications (RESTful Contracts)

All endpoints are versioned under `/api/v1/simulator` and follow standard HTTP semantics.

### 1. Box Provisioning & Simulation State

#### `GET /api/v1/simulator/boxes`
* **Description**: List all currently running virtual box instances.
* **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "box_ulid_1",
        "display_id": "GP-1245",
        "name": "Delhi Depot Box 1",
        "connection_status": "connected",
        "lock_status": "locked",
        "battery_level": 85,
        "zone_1_temp": 4,
        "zone_2_temp": 42,
        "ambient_temp": 32,
        "is_power_on": true,
        "bluetooth_available": true,
        "wifi_connected": true,
        "cellular_active": true,
        "zone_1_status": true,
        "zone_2_status": true,
        "is_dual_zone": true
      }
    ]
  }
  ```

#### `POST /api/v1/simulator/boxes`
* **Description**: Create/provision a new virtual box instance.
* **Request Payload**:
  ```json
  {
    "name": "Simulator Box 3",
    "display_id": "GP-9876",
    "initial_battery_level": 100,
    "ambient_temp": 32,
    "is_power_on": true,
    "bluetooth_available": true,
    "wifi_connected": true,
    "cellular_active": true,
    "zone_1_status": true,
    "zone_2_status": true,
    "is_dual_zone": true
  }
  ```
* **Response (201 Created)**: Returns the newly provisioned virtual box object.

#### `PATCH /api/v1/simulator/boxes/{box_id}/state`
* **Description**: Modify/simulate state changes on the box (e.g. change battery, fluctuate temperatures, toggle power/wireless status). Used by the simulator dashboard UI.
* **Request Payload**:
  ```json
  {
    "connection_status": "weak",
    "battery_level": 14,
    "zone_1_temp": 12,
    "zone_2_temp": 38,
    "ambient_temp": 35,
    "is_power_on": false,
    "bluetooth_available": false,
    "wifi_connected": false,
    "cellular_active": false,
    "zone_1_status": false,
    "zone_2_status": false,
    "is_dual_zone": false
  }
  ```
* **Response (200 OK)**: Returns the updated virtual box state.

---

### 2. Lock & Security Action APIs

#### `POST /api/v1/simulator/boxes/{box_id}/lock/otp`
* **Description**: Simulates the box requesting an OTP for locking/unlocking from the backend, or returning the expected OTP for the simulator dashboard to display.
* **Request Payload**:
  ```json
  {
    "action": "unlock"
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "otp_code": "123456",
      "expires_at": "2026-07-01T14:15:00Z"
    }
  }
  ```

#### `POST /api/v1/simulator/boxes/{box_id}/lock/verify`
* **Description**: Simulates submitting the OTP to the box or verifying it, triggering the physical unlocking/locking action.
* **Request Payload**:
  ```json
  {
    "otp_code": "123456",
    "action": "unlock"
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "success": true,
    "message": "Box successfully unlocked",
    "data": {
      "lock_status": "unlocked"
    }
  }
  ```

---

### 3. Event & Alert Emulation

#### `POST /api/v1/simulator/boxes/{box_id}/events/trigger-alert`
* **Description**: Manually trigger sensor failures or critical conditions (like low battery, camera failure, or tamper alert) to dispatch Webhooks/APIs to the backend and push alerts to the Driver App.
* **Request Payload**:
  ```json
  {
    "category": "camera",
    "type": "error",
    "title": "Camera Obstructed",
    "description": "It seems the camera is obstructed or not functioning."
  }
  ```
* **Response (200 OK)**: Returns the generated Alert model.

---

### 4. Simulation Logic & Automatic Triggers

To make the simulation realistic, the Virtual Box Simulator implements the following automated triggers:

* **Battery Threshold Alert**:
  - Whenever a `PATCH /state` request causes the `battery_level` to fall below `20` (and it wasn't already below 20), the simulator automatically sends a webhook request/notification payload to the backend alerting the user: `category: "battery", type: "warning", title: "Battery Level Below 20%"`.
* **Lock State Transition Alert**:
  - Whenever the lock state changes (e.g. from `locked` to `unlocked` via `POST /lock/verify` or manual simulation update), the simulator immediately triggers a notification event to the backend: `category: "lock", type: "success", title: "Lock opened"`.

---

## Action Items

- [ ] **Task 1: Spec Review** → Verify: Ensure API paths do not use action verbs and use proper plural nouns.
- [ ] **Task 2: Define Models** → Verify: Create request and response model definitions (e.g., `VirtualBoxState`, `OtpAction`).
- [ ] **Task 3: Implement Provisioning Endpoints** → Verify: Test `GET /boxes` and `POST /boxes` return 200/201 status codes.
- [ ] **Task 4: Implement State Modification (PATCH)** → Verify: Mutate state via PATCH and check if GET returns updated values.
- [ ] **Task 5: Implement Security Actions** → Verify: Trigger OTP and verify with valid/invalid codes, testing status transitions.
- [ ] **Task 6: Implement Event Trigger Webhooks** → Verify: Trigger an alert event, verify the backend receives and dispatches notification.
- [ ] **Task 7: Implement Automated Trigger Logic** → Verify: Drop battery below 20% or trigger lock/unlock, confirm event webhook dispatches automatically.

## Done When
- [ ] All API contracts are designed and verified against REST best practices.
- [ ] The API plan is documented in the project root.

## Notes
- This API allows testing the mobile driver app's reactive UI (such as temperature alerts, lock/unlock bottom sheets, and real-time connectivity states) under controlled simulated environments.
- The simulator should keep the box states in memory (or a lightweight Redis store) for fast reads and updates during simulation.
