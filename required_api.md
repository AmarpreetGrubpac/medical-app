# Required API Specifications for Virtual Box Simulator

This document provides the complete API contracts for the backend server to communicate with both the **React Simulator** and the **Flutter Driver App**.

All endpoints are versioned under `/api/v1/simulator` and follow standard REST semantics.

---

## 1. Heartbeat & Telemetry Update

### `PATCH /api/v1/simulator/boxes/{box_id}/state`
* **Description**: React Simulator uploads the current physical hardware telemetry every 5 seconds and receives the driver's desired configuration in the response.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {
    "connection_status": "strong", // "strong" | "weak" | "offline"
    "battery_1_level": 80,
    "battery_2_level": 80,
    "battery_level": 80,
    "ambient_temp": 32,
    "zone_1_temp": 4.2,
    "zone_2_temp": 4.5,
    "gps_available": true,
    "latitude": 28.6139,
    "longitude": 77.2090,
    "solar_panel": false,
    "220V_110V_port": true,
    "Memorycard_used": 0.15,
    "gyrosensor": "ok", // "ok" | "not_detected" | "error"
    "turn_signals": "ok" // "ok" | "not_detected"
  }
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success",
    "data": {
      "box_id": "01KV7DXTM1R7XYMHP03AN1DB3X",
      "display_id": "GP-1245",
      "is_locked": false,
      "driver_id": "USR_123ABCD",
      "restaurant_id": "REST_987XYZ",
      "settings": {
        "is_power_on": true,
        "is_dual_zone": false,
        "zone_1_target_temp": 4,
        "zone_2_target_temp": 4,
        "zone_1_status": true,
        "zone_2_status": false,
        "saveToCard": true,
        "Adas": true,
        "BoxCam": true,
        "advert_screen": true,
        "ioniser": false,
        "light_status": false
      }
    }
  }
  ```

---

## 2. Lock & Security Action APIs

### `PATCH /api/v1/simulator/boxes/{box_id}/lock`
* **Description**: Forces the physical lock state to `locked` directly from the simulator dashboard.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {}
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success",
    "lock_status": "locked"
  }
  ```

### `PATCH /api/v1/simulator/boxes/{box_id}/unlock`
* **Description**: Forces the physical lock state to `unlocked` directly from the simulator dashboard.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {}
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success",
    "lock_status": "unlocked"
  }
  ```

---

## 3. Event & Alert Injector APIs

### `POST /api/v1/simulator/boxes/{box_id}/events/trigger-alert`
* **Description**: Simulates hardware alarm events on the box, which dispatches notification updates to the driver app.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {
    "box_id": "01KV7DXTM1R7XYMHP03AN1DB3X",
    "category": "battery", // "battery" | "temperature" | "camera" | "sensor"
    "type": "warning", // "warning" | "critical"
    "title": "Low Battery Alert",
    "description": "Battery level is under 15%"
  }
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success"
  }
  ```

---

## 4. Diagnostics & Diagnostics Health APIs

### `GET /api/v1/simulator/boxes/{box_id}/health`
* **Description**: Returns whether the simulated box is active ("on") or inactive ("off").
* **Headers**: `Content-Type: application/json`
* **Request Body**: none
* **Response Body (200 OK)**:
  ```json
  {
    "status": "on" // "on" | "off"
  }
  ```

---

## 5. Driver Control & Pairing Sync APIs

*Note: These endpoints are triggered when settings are modified by the driver in the Flutter app or when unpairing.*

### `PATCH /api/v1/simulator/boxes/{box_id}/settings`
* **Description**: Updates target temperatures, modes, or other settings on the server database.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {
    "is_power_on": true,
    "is_dual_zone": false,
    "zone_1_target_temp": 13,
    "zone_2_target_temp": 40,
    "zone_1_status": true,
    "zone_2_status": false,
    "saveToCard": true,
    "Adas": true,
    "BoxCam": true,
    "advert_screen": true,
    "ioniser": false,
    "light_status": false
  }
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success"
  }
  ```

### `POST /api/v1/simulator/boxes/{box_id}/connection`
* **Description**: Pairs a driver and restaurant with the virtual box.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {
    "driver_id": "USR_123ABCD",
    "restaurant_id": "REST_987XYZ"
  }
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success"
  }
  ```

### `DELETE /api/v1/simulator/boxes/{box_id}/connection`
* **Description**: Unpairs the driver from the box.
* **Headers**: `Content-Type: application/json`
* **Request Body**:
  ```json
  {}
  ```
* **Response Body (200 OK)**:
  ```json
  {
    "status": "success"
  }
  ```
