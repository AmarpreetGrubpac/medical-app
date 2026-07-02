|Endpoint|Method|Req Payload|Res||
|---|---|---|---|---|
|/api/v1/simulator/boxes/{box_id}/state|PATCH|{<br>"connection_status": "weak",<br>"battery_1_level": 14,<br>"battery_2_level": 20,<br>"battery_level": 17, (MISSING)<br>"zone_1_temp": 12,<br>"zone_1_target_temp": 13,<br>"zone_2_temp": 38,<br>"zone_2_target_temp": 40,<br>"ambient_temp": 35,<br>"is_power_on": false,<br>"bluetooth_available": false,<br>"wifi_connected": false,<br>"cellular_active": false,<br>"zone_1_status": false,<br>"zone_2_status": false,<br>"is_dual_zone": false,<br>"gps_available": true,<br>"latitude": 40.7128, (MISSING)<br>"longitude": -74.0060, (MISSING)<br>"solar_panel": true,<br>"220V/110V_port": true,<br>"Memorycard_used": 0.8,<br>"saveToCard": true,<br>"Adas": true,<br>"BoxCam": true,<br>"advert_screen": true, (MISSING)<br>"ioniser": false, (MISSING)<br>"light_status": false, (MISSING)<br>"gyrosensor": "not_detected", (MISSING)<br>"turn_signals": "not_detected" (MISSING)<br>}|{ "status": "success" }||
|/api/v1/simulator/boxes/{box_id}/lock|Patch||||
|/api/v1/simulator/boxes/{box_id}/unlock|Patch||||
|**/api/v1/simulator/boxes/{box_id}/events/trigger-**<br>**alert**|Post|{<br>"box_id": "01KV7DXTM1R7XYMHP03AN1DB3X",<br>"category": "battery",<br>"type": "warning",<br>"title": "Low Battery",<br>"description": "Battery is under 15%"<br>}|||
|/api/v1/simulator/boxes/{box_id}/health|Get||{ status : on/off}||
|/api/v1/simulator/boxes/{box_id}/settings|PATCH|{<br>"ioniser": true,<br>"dual_zone": false,<br>"ext_thermostat_sensor": 10,<br>"advert_screen": true,<br>"box_cam_360": true,<br>"adas": true,<br>"save_to_card": true<br>}|{ "status": "success" }|(Note: Sent by backend when driver changes box settings in app)|
|/api/v1/simulator/boxes/{box_id}/connection|POST|{<br>"driver_id": "USR_123ABCD",<br>"restaurant_id": "REST_987XYZ"<br>}<br>(Note: Sent by backend when a driver links to the b|o<br>{ "status": "success" }||
|/api/v1/simulator/boxes/{box_id}/connection|DELETE|{}|{ "status": "success" }||



