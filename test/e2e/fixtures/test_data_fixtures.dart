/// Test Data Fixtures for Grubpac Driver E2E Tests.
/// Following E2E Testing Patterns: isolated test data definitions.
class TestDataFixtures {
  // --- USERS ---
  static const driverUser = {
    "auth": "driver@grubpac.com",
    "phone": "+919876543210",
    "password": "Password123!",
    "persona": "driver",
    "api_prefix": "medical-mobile/driver/",
    "client_id": "client-driver-001",
    "user_id": "usr-driver-789",
    "token": "mock-jwt-driver-auth-token-xyz",
    "refresh_token": "mock-refresh-driver-token-xyz",
  };

  static const ownerUser = {
    "auth": "owner@grubpac.com",
    "phone": "+919123456780",
    "password": "OwnerPassword456!",
    "persona": "owner",
    "api_prefix": "medical-mobile/owner/",
    "client_id": "client-owner-002",
    "user_id": "usr-owner-321",
    "token": "mock-jwt-owner-auth-token-abc",
    "refresh_token": "mock-refresh-owner-token-abc",
  };

  // --- CONFIG ---
  static Map<String, dynamic> standardConfig({
    String maintenanceMode = "false",
    String minAndroidVersion = "1.0.0",
    String minIosVersion = "1.0.0",
  }) {
    return {
      "success": true,
      "code": 200,
      "data": {
        "config": {
          "maintenanceMode": maintenanceMode,
          "minAndroidVersion": minAndroidVersion,
          "minIosVersion": minIosVersion,
          "privacyPolicyR": "https://grubpac.com/privacy",
          "termsNConditionsR": "https://grubpac.com/terms"
        }
      }
    };
  }

  // --- PROFILE ---
  static Map<String, dynamic> driverProfile = {
    "success": true,
    "code": 200,
    "data": {
      "id": "usr-driver-789",
      "first_name": "Alex",
      "last_name": "Courier",
      "email": "driver@grubpac.com",
      "phone": "+919876543210",
      "country_code": "+91",
      "image": "",
      "role": "driver"
    }
  };

  // --- BOXES ---
  static Map<String, dynamic> emptyBoxList = {
    "success": true,
    "code": 200,
    "data": <Map<String, dynamic>>[]
  };

  static Map<String, dynamic> singleConnectedBox = {
    "success": true,
    "code": 200,
    "data": [
      {
        "id": "box-med-101",
        "display_id": "MED-BOX-101",
        "name": "Smart Med Carrier 01",
        "is_connected": true,
        "is_locked": false,
        "battery_level": 88,
        "zone1_temp": 4,
        "zone2_temp": 18,
        "ext_temp": 24,
        "connection_status": "ONLINE",
        "health_status": "GOOD",
        "power_status": "ON",
        "settings": {
          "is_dual_zone": true,
          "zone1_status": true,
          "zone2_status": true,
          "zone1_temp": 4,
          "zone2_temp": 18,
          "advert_display_enabled": false,
          "ioniser_enabled": true
        }
      }
    ]
  };

  static Map<String, dynamic> newlyClaimedBox({String displayId = "MED-BOX-99"}) {
    return {
      "success": true,
      "code": 200,
      "data": {
        "id": "box-claimed-99",
        "display_id": displayId,
        "name": "Smart Med Box $displayId",
        "is_connected": true,
        "is_locked": true,
        "battery_level": 95,
        "zone1_temp": 5,
        "zone2_temp": 20,
        "ext_temp": 22,
        "connection_status": "ONLINE",
        "health_status": "GOOD",
        "power_status": "ON",
        "settings": {
          "is_dual_zone": true,
          "zone1_status": true,
          "zone2_status": true,
          "zone1_temp": 5,
          "zone2_temp": 20
        }
      }
    };
  }

  // --- ALERTS ---
  static Map<String, dynamic> sampleAlerts = {
    "success": true,
    "code": 200,
    "data": [
      {
        "id": "alert-1",
        "title": "Temperature Normal",
        "message": "Zone 1 stabilized at 4°C",
        "created_at": "2026-10-22T10:00:00Z"
      }
    ]
  };
}
