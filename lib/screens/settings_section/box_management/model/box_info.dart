import 'package:get/get.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

class ConnectedUser {
  final String? driverId;
  final String? driverUserId;
  final String? employeeDisplayId;
  final String? name;

  ConnectedUser({
    this.driverId,
    this.driverUserId,
    this.employeeDisplayId,
    this.name,
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) => ConnectedUser(
        driverId: json['driver_id'] as String?,
        driverUserId: json['driver_user_id'] as String?,
        employeeDisplayId: json['employee_display_id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'driver_id': driverId,
        'driver_user_id': driverUserId,
        'employee_display_id': employeeDisplayId,
        'name': name,
      };

  ConnectedUser copyWith({
    String? driverId,
    String? driverUserId,
    String? employeeDisplayId,
    String? name,
  }) =>
      ConnectedUser(
        driverId: driverId ?? this.driverId,
        driverUserId: driverUserId ?? this.driverUserId,
        employeeDisplayId: employeeDisplayId ?? this.employeeDisplayId,
        name: name ?? this.name,
      );
}

class BoxInfo {
  final String id;
  final String boxDisplayId;
  final String name;
  final bool isConnected;
  final int batteryLevel;
  final bool isLocked;
  final int? zone1Temp;
  final int? zone2Temp;
  final int? extTemp;
  final String? connectionStatus;
  final String? powerStatus;
  final String? healthStatus;
  final int? battery1Level;
  final int? battery2Level;
  final bool? gpsAvailable;
  final double? latitude;
  final double? longitude;
  final bool? solarPanel;
  final bool? port220V110V;
  final double? memoryCardUsed;
  final String? gyroSensor;
  final String? turnSignals;
  final bool? isDualZone;
  final BoxSettings? settings;
  final bool? isDriverConnected;
  final bool? bluetoothAvailable;
  final bool? wifiConnected;
  final String? driverId;
  final ConnectedUser? connectedUser;

  BoxInfo({
    required this.id,
    required this.boxDisplayId,
    this.name = "",
    this.isConnected = false,
    this.batteryLevel = 0,
    this.isLocked = true,
    this.zone1Temp,
    this.zone2Temp,
    this.extTemp,
    this.connectionStatus,
    this.powerStatus,
    this.healthStatus,
    this.battery1Level,
    this.battery2Level,
    this.gpsAvailable,
    this.latitude,
    this.longitude,
    this.solarPanel,
    this.port220V110V,
    this.memoryCardUsed,
    this.gyroSensor,
    this.turnSignals,
    this.isDualZone,
    this.settings,
    this.isDriverConnected,
    this.bluetoothAvailable,
    this.wifiConnected,
    this.driverId,
    this.connectedUser,
  });

  factory BoxInfo.fromJson(Map<String, dynamic> json) {
    final rawIsConnected = (json['is_driver_connected'] ??
            json['is_connected'] ??
            (json['connection_status'] != 'offline')) as bool? ??
        false;

    String? driverId = json['driver_id'] as String?;
    if (driverId == null && json['connected_user'] != null) {
      driverId = json['connected_user']['driver_id'] as String?;
    }

    bool finalIsConnected = rawIsConnected;
    if (Get.isRegistered<ProfileDetailsController>()) {
      final profileController = Get.find<ProfileDetailsController>();
      final currentUserId = profileController.user_id;
      if (currentUserId.isNotEmpty) {
        if (driverId != currentUserId) {
          finalIsConnected = false;
        }
      }
    }

    return BoxInfo(
      id: (json['id'] ?? json['box_id']) as String,
      boxDisplayId:
          (json['box_display_id'] ?? json['display_id']) as String? ?? '',
      name: json['name'] as String? ?? '',
      isConnected: finalIsConnected,
      batteryLevel:
          (json['battery_level'] ?? json['battery_1_level'] ?? 0) as int,
      isLocked: json['is_locked'] as bool? ?? false,
      zone1Temp: json['zone_1_temp'] as int?,
      zone2Temp: json['zone_2_temp'] as int?,
      extTemp: (json['ext_temp'] ?? json['ambient_temp']) as int?,
      connectionStatus: json['connection_status'] as String?,
      powerStatus: json['power_status'] as String? ??
          (json['is_power_on'] == true ? "on" : "off"),
      healthStatus: json['health_status'] as String?,
      battery1Level: json['battery_1_level'] as int?,
      battery2Level: json['battery_2_level'] as int?,
      gpsAvailable: json['gps_available'] as bool?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      solarPanel: json['solar_panel'] as bool?,
      port220V110V: json['220V_110V_port'] as bool?,
      memoryCardUsed: (json['Memorycard_used'] as num?)?.toDouble(),
      gyroSensor: json['gyrosensor'] as String?,
      turnSignals: json['turn_signals'] as String?,
      isDualZone: json['is_dual_zone'] as bool?,
      settings: json['settings'] != null
          ? BoxSettings.fromJson(
              json['settings'] as Map<String, dynamic>,
              temp1: json['zone_1_temp'] as int?,
              temp2: json['zone_2_temp'] as int?,
            )
          : null,
      isDriverConnected: json['is_driver_connected'] as bool?,
      bluetoothAvailable: json['bluetooth_available'] as bool?,
      wifiConnected: json['wifi_connected'] as bool?,
      driverId: json['driver_id'] as String?,
      connectedUser: json['connected_user'] != null
          ? ConnectedUser.fromJson(
              json['connected_user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'box_display_id': boxDisplayId,
        'name': name,
        'is_connected': isConnected,
        'battery_level': batteryLevel,
        'is_locked': isLocked,
        'zone_1_temp': zone1Temp,
        'zone_2_temp': zone2Temp,
        'ext_temp': extTemp,
        'connection_status': connectionStatus,
        'power_status': powerStatus,
        'health_status': healthStatus,
        'battery_1_level': battery1Level,
        'battery_2_level': battery2Level,
        'gps_available': gpsAvailable,
        'latitude': latitude,
        'longitude': longitude,
        'solar_panel': solarPanel,
        '220V_110V_port': port220V110V,
        'Memorycard_used': memoryCardUsed,
        'gyrosensor': gyroSensor,
        'turn_signals': turnSignals,
        'is_dual_zone': isDualZone,
        'settings': settings?.toJson(),
        'is_driver_connected': isDriverConnected,
        'bluetooth_available': bluetoothAvailable,
        'wifi_connected': wifiConnected,
        'driver_id': driverId,
        'connected_user': connectedUser?.toJson(),
      };

  BoxInfo copyWith({
    String? id,
    String? boxDisplayId,
    String? name,
    bool? isConnected,
    int? batteryLevel,
    bool? isLocked,
    int? zone1Temp,
    int? zone2Temp,
    int? extTemp,
    String? connectionStatus,
    String? powerStatus,
    String? healthStatus,
    int? battery1Level,
    int? battery2Level,
    bool? gpsAvailable,
    double? latitude,
    double? longitude,
    bool? solarPanel,
    bool? port220V110V,
    double? memoryCardUsed,
    String? gyroSensor,
    String? turnSignals,
    bool? isDualZone,
    BoxSettings? settings,
    bool? isDriverConnected,
    bool? bluetoothAvailable,
    bool? wifiConnected,
    String? driverId,
    ConnectedUser? connectedUser,
  }) =>
      BoxInfo(
        id: id ?? this.id,
        boxDisplayId: boxDisplayId ?? this.boxDisplayId,
        name: name ?? this.name,
        isConnected: isConnected ?? this.isConnected,
        batteryLevel: batteryLevel ?? this.batteryLevel,
        isLocked: isLocked ?? this.isLocked,
        zone1Temp: zone1Temp ?? this.zone1Temp,
        zone2Temp: zone2Temp ?? this.zone2Temp,
        extTemp: extTemp ?? this.extTemp,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        powerStatus: powerStatus ?? this.powerStatus,
        healthStatus: healthStatus ?? this.healthStatus,
        battery1Level: battery1Level ?? this.battery1Level,
        battery2Level: battery2Level ?? this.battery2Level,
        gpsAvailable: gpsAvailable ?? this.gpsAvailable,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        solarPanel: solarPanel ?? this.solarPanel,
        port220V110V: port220V110V ?? this.port220V110V,
        memoryCardUsed: memoryCardUsed ?? this.memoryCardUsed,
        gyroSensor: gyroSensor ?? this.gyroSensor,
        turnSignals: turnSignals ?? this.turnSignals,
        isDualZone: isDualZone ?? this.isDualZone,
        settings: settings ?? this.settings,
        isDriverConnected: isDriverConnected ?? this.isDriverConnected,
        bluetoothAvailable: bluetoothAvailable ?? this.bluetoothAvailable,
        wifiConnected: wifiConnected ?? this.wifiConnected,
        driverId: driverId ?? this.driverId,
        connectedUser: connectedUser ?? this.connectedUser,
      );
}

class BoxSettings {
  final bool isDualZone;
  final int? zone1Temp;
  final int? zone2Temp;
  final bool advertDisplayEnabled;
  final bool ioniserEnabled;
  final bool lightEnabled;
  final bool zone1Status;
  final bool zone2Status;
  final bool saveToCard;
  final bool adas;
  final bool boxCam;
  final bool isPowerOn;
  final bool isCharging;

  BoxSettings({
    required this.isDualZone,
    this.zone1Temp,
    this.zone2Temp,
    required this.advertDisplayEnabled,
    required this.ioniserEnabled,
    required this.lightEnabled,
    this.zone1Status = true,
    this.zone2Status = false,
    this.saveToCard = false,
    this.adas = false,
    this.boxCam = false,
    this.isPowerOn = true,
    this.isCharging = false,
  });

  factory BoxSettings.fromJson(Map<String, dynamic> json,
          {int? temp1, int? temp2}) =>
      BoxSettings(
        isDualZone: json['is_dual_zone'] as bool? ?? false,
        zone1Temp: (json['zone_1_temp'] ?? temp1)
            as int?, //?? json['zone_1_target_temp']) as int?,
        zone2Temp: (json['zone_2_temp'] ?? temp2)
            as int?, //?? json['zone_2_target_temp']) as int?,
        advertDisplayEnabled: (json['advert_screen'] ??
                json['advert_display_enabled']) as bool? ??
            false,
        ioniserEnabled:
            (json['ioniser'] ?? json['ioniser_enabled']) as bool? ?? false,
        lightEnabled:
            (json['light_status'] ?? json['light_enabled']) as bool? ?? false,
        zone1Status: json['zone_1_status'] as bool? ?? true,
        zone2Status: json['zone_2_status'] as bool? ?? false,
        saveToCard: json['saveToCard'] as bool? ?? false,
        adas: json['Adas'] as bool? ?? false,
        boxCam: json['BoxCam'] as bool? ?? false,
        isPowerOn: json['is_power_on'] as bool? ?? true,
        isCharging: json['is_charging'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'is_dual_zone': isDualZone,
        'zone_1_temp': zone1Temp,
        'zone_2_temp': zone2Temp,
        'advert_display_enabled': advertDisplayEnabled,
        'ioniser_enabled': ioniserEnabled,
        'light_enabled': lightEnabled,
        'zone_1_status': zone1Status,
        'zone_2_status': zone2Status,
        'saveToCard': saveToCard,
        'Adas': adas,
        'BoxCam': boxCam,
        'is_power_on': isPowerOn,
        'is_charging': isCharging,
      };

  BoxSettings copyWith({
    bool? isDualZone,
    int? zone1Temp,
    int? zone2Temp,
    bool? advertDisplayEnabled,
    bool? ioniserEnabled,
    bool? lightEnabled,
    bool? zone1Status,
    bool? zone2Status,
    bool? saveToCard,
    bool? adas,
    bool? boxCam,
    bool? isPowerOn,
    bool? isCharging,
  }) =>
      BoxSettings(
        isDualZone: isDualZone ?? this.isDualZone,
        zone1Temp: zone1Temp ?? this.zone1Temp,
        zone2Temp: zone2Temp ?? this.zone2Temp,
        advertDisplayEnabled: advertDisplayEnabled ?? this.advertDisplayEnabled,
        ioniserEnabled: ioniserEnabled ?? this.ioniserEnabled,
        lightEnabled: lightEnabled ?? this.lightEnabled,
        zone1Status: zone1Status ?? this.zone1Status,
        zone2Status: zone2Status ?? this.zone2Status,
        saveToCard: saveToCard ?? this.saveToCard,
        adas: adas ?? this.adas,
        boxCam: boxCam ?? this.boxCam,
        isPowerOn: isPowerOn ?? this.isPowerOn,
        isCharging: isCharging ?? this.isCharging,
      );
}

class OtpDetails {
  bool status;
  String? type;
  List<String>? values;

  OtpDetails({
    this.status = false,
    this.type,
    this.values = const [],
  });

  factory OtpDetails.fromJson(Map<String, dynamic> json, {bool? status}) =>
      OtpDetails(
        type: json["type"],
        values: List<String>.from(json["values"].map((x) => x)),
        status: status ?? false,
      );
}
