import 'package:get/get_connect/http/src/response/response.dart';

class MockDataProvider {
  static Response? getMockResponse(String uri, String method, {dynamic body}) {
    final cleanUri = uri.trim();

    // 1. Config API
    if (cleanUri.contains('/config')) {
      return Response(
        statusCode: 200,
        body: {
          "success": true,
          "code": 200,
          "data": {
            "config": {
              "maintenanceMode": "false",
              "minAndroidVersion": "1.0.0",
              "minIosVersion": "1.0.0",
              "privacyPolicyR": "https://www.grubpac.com/privacypolicy",
              "termsNConditionsR": "https://www.grubpac.com/toc"
            }
          }
        },
      );
    }

    // 2. Auth APIs
    if (cleanUri.contains('/auth/check-account')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "is_account_found": true,
          "is_password_set": true,
          "persona": "owner",
          "api_prefix": "medical-mobile/owner/"
        },
      );
    }

    if (cleanUri.contains('/auth/login')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "persona": "owner",
          "api_prefix": "medical-mobile/owner/",
          "data": {
            "auth_token": "mock_demo_jwt_token_medical_12345",
            "refresh_token": "mock_demo_refresh_token_67890",
            "persona": "owner",
            "api_prefix": "medical-mobile/owner/"
          }
        },
      );
    }

    if (cleanUri.contains('/auth/send-otp') ||
        cleanUri.contains('/auth/resend-otp') ||
        cleanUri.contains('/auth/forget-password/otp/send') ||
        cleanUri.contains('/auth/forget-password/otp/resend')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Demo OTP sent (Code: 123456)"
        },
      );
    }

    if (cleanUri.contains('/auth/verify-otp') ||
        cleanUri.contains('/auth/forget-password/otp/verify')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "persona": "owner",
          "api_prefix": "medical-mobile/owner/",
          "data": {
            "auth_token": "mock_demo_jwt_token_medical_12345",
            "refresh_token": "mock_demo_refresh_token_67890",
            "persona": "owner",
            "api_prefix": "medical-mobile/owner/"
          }
        },
      );
    }

    if (cleanUri.contains('/auth/set-password') ||
        cleanUri.contains('/auth/forget-password/set-password')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Password set successfully"
        },
      );
    }

    if (cleanUri.contains('/auth/logout')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Logged out successfully"
        },
      );
    }

    if (cleanUri.contains('/auth/refresh')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "data": {
            "auth_token": "mock_demo_jwt_token_medical_12345",
            "refresh_token": "mock_demo_refresh_token_67890"
          }
        },
      );
    }

    // 3. User Profile API
    if (cleanUri.contains('/profile') || cleanUri.contains('/account')) {
      if (method == 'GET') {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "user_id": "DEMO-MED-001",
            "data": {
              "id": "DEMO-MED-001",
              "first_name": "Demo",
              "last_name": "Doctor",
              "email": "demo.doctor@grubpac.com",
              "mobile_number": "9876543210",
              "country_code": "+91",
              "employee_id": "GP-MED-007",
              "role": "Medical Owner",
              "joining_date": "10 Jan 2026",
              "profile_pic": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=600&auto=format&fit=crop"
            }
          },
        );
      } else if (method == 'DELETE') {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Account deleted successfully"
          },
        );
      } else {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Profile updated successfully"
          },
        );
      }
    }

    // 4. Box Lock / Grublock
    if (cleanUri.contains('/grublock/lock') || cleanUri.contains('/grublock/emergency_unlock')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Grublock action completed successfully"
        },
      );
    }

    if (cleanUri.contains('/lock')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Box lock state updated successfully"
        },
      );
    }

    // 5. Simulator Health Check
    if (cleanUri.contains('/simulator/boxes/') && cleanUri.contains('/health')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "data": {
            "id": "GP-MED-BOX-001",
            "box_display_id": "MED-001",
            "name": "GrubBox Medical Pro",
            "is_connected": true,
            "is_driver_connected": true,
            "driver_id": "DEMO-MED-001",
            "battery_level": 92,
            "battery_1_level": 92,
            "battery_2_level": 95,
            "is_locked": false,
            "zone_1_temp": 4,
            "zone_2_temp": -18,
            "ext_temp": 22,
            "connection_status": "online",
            "power_status": "on",
            "health_status": "good",
            "gps_available": true,
            "latitude": 28.6139,
            "longitude": 77.2090,
            "solar_panel": true,
            "220V_110V_port": true,
            "usb_port": true,
            "Memorycard_used": 28.5,
            "gyrosensor": "stable",
            "turn_signals": "normal",
            "is_dual_zone": true,
            "bluetooth_available": true,
            "wifi_connected": true,
            "settings": {
              "is_dual_zone": true,
              "zone_1_temp": 4,
              "zone_2_temp": -18,
              "advert_display_enabled": true,
              "ioniser_enabled": true,
              "light_enabled": true,
              "zone_1_status": true,
              "zone_2_status": true,
              "saveToCard": true,
              "Adas": true,
              "BoxCam": true,
              "flood_light": false,
              "is_power_on": true,
              "is_charging": false
            }
          }
        },
      );
    }

    // 6. Box List / Details / Claim / Connect / Settings
    if (cleanUri.contains('/boxes')) {
      // Box settings update
      if (cleanUri.contains('/settings') && (method == 'PATCH' || method == 'PUT')) {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Box settings updated successfully"
          },
        );
      }

      // Box connection
      if (cleanUri.contains('/connection')) {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Box connection updated successfully"
          },
        );
      }

      // Box claim
      if (cleanUri.contains('/claim') && method == 'POST') {
        String scannedId = "MED-NEW-99";
        if (body is Map && body['scanned_code'] != null) {
          scannedId = body['scanned_code'].toString();
        }
        return Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Box claimed successfully",
            "data": {
              "id": "GP-MED-BOX-${scannedId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}",
              "box_display_id": scannedId,
              "name": "GrubBox Medical $scannedId",
              "is_connected": true,
              "is_driver_connected": true,
              "driver_id": "DEMO-MED-001",
              "connected_user": {
                "driver_id": "DEMO-MED-001",
                "name": "Demo Doctor"
              },
              "battery_level": 100,
              "battery_1_level": 100,
              "battery_2_level": 100,
              "is_locked": false,
              "zone_1_temp": 4,
              "zone_2_temp": -15,
              "ext_temp": 22,
              "connection_status": "online",
              "power_status": "on",
              "health_status": "good",
              "is_dual_zone": true,
              "bluetooth_available": true,
              "wifi_connected": true,
              "gps_available": true,
              "latitude": 28.6139,
              "longitude": 77.2090,
              "solar_panel": true,
              "220V_110V_port": true,
              "usb_port": true,
              "Memorycard_used": 10.0,
              "gyrosensor": "stable",
              "turn_signals": "normal",
              "settings": {
                "is_dual_zone": true,
                "zone_1_temp": 4,
                "zone_2_temp": -15,
                "advert_display_enabled": true,
                "ioniser_enabled": true,
                "light_enabled": true,
                "zone_1_status": true,
                "zone_2_status": true,
                "saveToCard": true,
                "Adas": true,
                "BoxCam": true,
                "flood_light": false,
                "is_power_on": true,
                "is_charging": false
              }
            }
          },
        );
      }

      // Box remove
      if (method == 'DELETE') {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Box removed successfully"
          },
        );
      }

      // Box list (GET)
      if (method == 'GET') {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "data": [
              {
                "id": "GP-MED-BOX-001",
                "box_display_id": "MED-001",
                "name": "GrubBox Medical Pro",
                "is_connected": true,
                "is_driver_connected": true,
                "driver_id": "DEMO-MED-001",
                "connected_user": {
                  "driver_id": "DEMO-MED-001",
                  "name": "Demo Doctor"
                },
                "battery_level": 92,
                "battery_1_level": 92,
                "battery_2_level": 95,
                "is_locked": false,
                "zone_1_temp": 4,
                "zone_2_temp": -18,
                "ext_temp": 22,
                "connection_status": "online",
                "power_status": "on",
                "health_status": "good",
                "gps_available": true,
                "latitude": 28.6139,
                "longitude": 77.2090,
                "solar_panel": true,
                "220V_110V_port": true,
                "usb_port": true,
                "Memorycard_used": 28.5,
                "gyrosensor": "stable",
                "turn_signals": "normal",
                "is_dual_zone": true,
                "bluetooth_available": true,
                "wifi_connected": true,
                "settings": {
                  "is_dual_zone": true,
                  "zone_1_temp": 4,
                  "zone_2_temp": -18,
                  "advert_display_enabled": true,
                  "ioniser_enabled": true,
                  "light_enabled": true,
                  "zone_1_status": true,
                  "zone_2_status": true,
                  "saveToCard": true,
                  "Adas": true,
                  "BoxCam": true,
                  "flood_light": false,
                  "is_power_on": true,
                  "is_charging": false
                }
              },
              {
                "id": "GP-MED-BOX-002",
                "box_display_id": "MED-002",
                "name": "GrubBox Medical Lite",
                "is_connected": false,
                "is_driver_connected": false,
                "driver_id": null,
                "battery_level": 78,
                "battery_1_level": 78,
                "battery_2_level": null,
                "is_locked": true,
                "zone_1_temp": 6,
                "zone_2_temp": null,
                "ext_temp": 23,
                "connection_status": "standby",
                "power_status": "on",
                "health_status": "good",
                "gps_available": true,
                "latitude": 28.6145,
                "longitude": 77.2095,
                "solar_panel": false,
                "220V_110V_port": false,
                "usb_port": true,
                "Memorycard_used": 15.0,
                "gyrosensor": "stable",
                "turn_signals": "normal",
                "is_dual_zone": false,
                "bluetooth_available": true,
                "wifi_connected": false,
                "settings": {
                  "is_dual_zone": false,
                  "zone_1_temp": 6,
                  "zone_2_temp": null,
                  "advert_display_enabled": false,
                  "ioniser_enabled": false,
                  "light_enabled": false,
                  "zone_1_status": true,
                  "zone_2_status": false,
                  "saveToCard": false,
                  "Adas": false,
                  "BoxCam": false,
                  "flood_light": false,
                  "is_power_on": true,
                  "is_charging": false
                }
              }
            ]
          },
        );
      }

      // Default box action
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "message": "Box updated successfully"
        },
      );
    }

    // 7. Notifications / Alerts
    if (cleanUri.contains('/notification')) {
      if (method == 'GET') {
        return Response(
          statusCode: 200,
          body: {
            "success": true,
            "data": {
              "data": [
                {
                  "id": "alert-1",
                  "title": "Temperature Normalised",
                  "message": "Zone 1 temperature is optimal at 4°C for medical supplies.",
                  "box_name": "GrubBox Medical Pro",
                  "type": "success",
                  "category": "temperature",
                  "is_read": false,
                  "created_at": DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String()
                },
                {
                  "id": "alert-2",
                  "title": "Battery at 92%",
                  "message": "Solar charging active on MED-001.",
                  "box_name": "GrubBox Medical Pro",
                  "type": "warning",
                  "category": "battery",
                  "is_read": false,
                  "created_at": DateTime.now().subtract(const Duration(hours: 2)).toIso8601String()
                },
                {
                  "id": "alert-3",
                  "title": "Smart Lock Secured",
                  "message": "Box lock verified and secured.",
                  "box_name": "GrubBox Medical Lite",
                  "type": "success",
                  "category": "lock",
                  "is_read": true,
                  "created_at": DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
                }
              ]
            }
          },
        );
      } else {
        return const Response(
          statusCode: 200,
          body: {
            "success": true,
            "message": "Notification status updated"
          },
        );
      }
    }

    // 8. Help FAQ & Categories
    if (cleanUri.contains('/support/category')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "code": 200,
          "data": {
            "faq_categories": [
              {
                "id": "cat-1",
                "name": "Box Connectivity & Bluetooth",
                "icon": {
                  "id": "icon-1",
                  "name": "bluetooth",
                  "bucket_key": "icons/bluetooth.png"
                },
                "_count": {
                  "questions": 4
                }
              },
              {
                "id": "cat-2",
                "name": "Temperature Control & Dual Zones",
                "icon": {
                  "id": "icon-2",
                  "name": "temperature",
                  "bucket_key": "icons/temp.png"
                },
                "_count": {
                  "questions": 5
                }
              },
              {
                "id": "cat-3",
                "name": "Medical Supply Storage",
                "icon": {
                  "id": "icon-3",
                  "name": "medical",
                  "bucket_key": "icons/medical.png"
                },
                "_count": {
                  "questions": 3
                }
              }
            ],
            "count": 3
          }
        },
      );
    }

    if (cleanUri.contains('/support/faq')) {
      return const Response(
        statusCode: 200,
        body: {
          "success": true,
          "code": 200,
          "data": {
            "faqs": [
              {
                "id": "faq-1",
                "question": "How do I claim a GrubBox for my organization?",
                "answer": "Make sure the GrubBox is powered on. Go to Settings > Box Management and tap 'Claim Box'. Scan the QR code on the box to register it."
              },
              {
                "id": "faq-2",
                "question": "How do Dual Temperature Zones work?",
                "answer": "Zone 1 is configured for ambient temperature items, while Zone 2 is optimized for cold-chain medical supplies. You can adjust targets individually from Box Details."
              },
              {
                "id": "faq-3",
                "question": "What is Demo Mode?",
                "answer": "Demo Mode allows you to preview all features of GrubPac Medical with mock telemetry, boxes, and alerts without needing hardware or live server access."
              }
            ],
            "count": 3
          }
        },
      );
    }

    // Default fallback mock response
    return const Response(
      statusCode: 200,
      body: {
        "success": true,
        "message": "Mock operation successful"
      },
    );
  }
}
