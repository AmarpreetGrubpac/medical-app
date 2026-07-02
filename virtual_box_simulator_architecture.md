# Virtual Box Simulator Architecture

This document describes the architecture, data flow, API contracts, and edge cases for the Grublock Virtual Box Simulator.

---

## 1. Understanding Summary & Context

* **Goal**: Provide a web-based (React) simulator that mimics physical Grublock boxes to facilitate development, testing, and QA of the Grubpac Driver mobile application.
* **Problem Solved**: Developers lack physical boxes to test hardware-dependent app features (like live temperature gauges, lock/unlock sheet triggers, GPS tracking, and battery alarms).
* **Target Audience**: Mobile developers, backend developers, and QA engineers.
* **Real-time Mechanism**:
  * **Telemetry Uplink**: Simulator updates the server every 5 seconds via `PATCH /api/v1/simulator/boxes/{box_id}/state` with physical readings.
  * **Command Downlink**: Server returns the desired driver-configured targets and states (e.g., target temperature, lock command status) in the heartbeat response. The simulator updates its local state accordingly.
* **OTP Flow**: Since OTPs are delivered via email, the simulator does not need to display OTP codes on the virtual LCD.

---

## 2. Technical Assumptions

1. **Heartbeat Frequency**: 5 seconds is standard. It provides near-real-time updates without overloading local backend instances.
2. **Persistence**: The backend database holds the source-of-truth record for the virtual box. The simulator writes telemetry to it, and the Flutter app reads from it.
3. **Environment**: Primarily targeted at localhost or staging deployments.

---

## 3. Decision Log

| Issue / Design point | Options Considered | Decision Made | Rationale |
|---|---|---|---|
| **State Synchronization Protocol** | 1. HTTP Heartbeat Polling<br>2. Bidirectional WebSockets<br>3. Server-Sent Events (SSE) | **Option 1: HTTP Heartbeat Polling** | Simpler to implement on both the server and React client. Standard HTTP is stateless, handles retry logic automatically, and avoids persistent connection overhead. |
| **Command Downlink Protocol** | 1. Heartbeat response payload<br>2. Dedicated command polling<br>3. WebSockets for command channel | **Option 1: Heartbeat response payload** | Keeps operations atomic. By returning desired states directly in the response of the `/state` heartbeat, we avoid creating extra polling loops or endpoints. |
| **Box Identification & Setup** | 1. Dynamic provisioning (POST)<br>2. Query parameter identification<br>3. Pre-seeded list | **Option 1 & 2 Combined** | The user inputs a `box_id` in the React UI, which is validated against the backend. Alternatively, the app allows provisioning a new ID via `POST /api/v1/simulator/boxes`. |
| **OTP Display on Box** | 1. Display on virtual LCD screen<br>2. Bypass verification<br>3. Deliver via email | **Option 3: Deliver via email** | Matches production behavior where OTPs are sent to email rather than displayed on the box's LCD screen. |
| **QR Code Registration** | 1. Raw Box ID string<br>2. JSON `{"box_display_id": "display_id"}` | **Option 2: JSON payload** | Matches the mobile app's barcode scanner parser inside `scan_box_controller.dart`. |

---

## 4. Refined API Specifications

All endpoints are hosted on the backend server.

### 4.1 State Telebeat (Heartbeat & Telemetry)
* **Endpoint**: `PATCH /api/v1/simulator/boxes/{box_id}/state`
* **Request Payload**:
  ```json
  {
    "connection_status": "weak", // "strong" | "weak" | "offline"
    "battery_1_level": 14,
    "battery_2_level": 20,
    "battery_level": 17,
    "ambient_temp": 35,
    "zone_1_temp": 12,
    "zone_2_temp": 38,
    "gps_available": true,
    "latitude": 40.7128,
    "longitude": -74.0060,
    "solar_panel": true,
    "220V_110V_port": true,
    "Memorycard_used": 0.8,
    "gyrosensor": "ok", // "ok" | "not_detected" | "error"
    "turn_signals": "ok"
  }
  ```
* **Response Payload (200 OK)**:
  ```json
  {
    "status": "success",
    "data": {
      "is_locked": false,
      "driver_id": "USR_123ABCD",
      "restaurant_id": "REST_987XYZ",
      "settings": {
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
    }
  }
  ```

### 4.2 Manual Overrides & Trigger Alerts (Simulator Dashboard Inputs)
* **Forced Lock/Unlock**:
  * `PATCH /api/v1/simulator/boxes/{box_id}/lock` -> Forces the box to lock physically.
  * `PATCH /api/v1/simulator/boxes/{box_id}/unlock` -> Forces the box to unlock physically.
* **Alert Trigger**:
  * `POST /api/v1/simulator/boxes/{box_id}/events/trigger-alert`
  * Payload:
    ```json
    {
      "category": "battery", // "battery" | "temperature" | "camera" | "sensor"
      "type": "warning", // "warning" | "critical"
      "title": "Low Battery Alert",
      "description": "Virtual box battery level dropped below 15%"
    }
    ```

---

## 5. React Frontend Architecture

```
src/
├── components/
│   ├── BoxLCDScreen.jsx      # Mimics physical LCD screen (glowing battery/temp icons)
│   ├── SensorSliders.jsx     # Controls for battery, temp, ambient temp, memory card
│   ├── TriggerAlarms.jsx     # Action buttons to POST custom hardware alerts
│   ├── MapLocationPicker.jsx # Map pointer or Lat/Long inputs for GPS simulation
│   ├── ConnectionState.jsx   # Wifi/Cellular toggles & pair status indicators
│   └── QRCodeGenerator.jsx   # Renders a QR code encoding {"box_display_id": "current_display_id"}
├── context/
│   └── SimulatorContext.jsx  # Context provider for managing heartbeat state and fetch intervals
├── App.jsx                   # Layout container split into Controls, LCD screen, and Heartbeat logs
└── index.css                 # Custom glassmorphic styling (dark/neon mode)
```

### Simulation Loops & Edge Cases

1. **Auto-Temperature Regulation Loop**:
   If enabled, a client-side timer checks:
   * If `zone_1_temp < zone_1_target_temp` -> increment `zone_1_temp` by `0.2°C` every 10 seconds.
   * If `zone_1_temp > zone_1_target_temp` -> decrement `zone_1_temp` by `0.2°C` every 10 seconds.
2. **Network Offline Simulation**:
   When marked "Offline", the simulator cancels the `setInterval` heartbeat loop. The backend will flag the box as offline in the database if no heartbeat occurs for 15 seconds.
3. **QR Registration scanning**:
   The `QRCodeGenerator.jsx` component uses a library like `qrcode.react` to generate and render a QR code containing the exact JSON payload `{"box_display_id": "<current_box_display_id>"}` dynamically. This allows testers to pair the app by scanning the screen.
