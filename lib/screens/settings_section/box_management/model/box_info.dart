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
  final BoxSettings? settings;

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
    this.settings,
  });

  factory BoxInfo.fromJson(Map<String, dynamic> json) => BoxInfo(
        id: json['id'] as String,
        boxDisplayId: json['box_display_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        isConnected: json['is_connected'] as bool? ?? false,
        batteryLevel: json['battery_level'] as int? ?? 0,
        isLocked: json['is_locked'] as bool? ?? false,
        zone1Temp: json['zone_1_temp'] as int?,
        zone2Temp: json['zone_2_temp'] as int?,
        extTemp: json['ext_temp'] as int?,
        connectionStatus: json['connection_status'] as String?,
        powerStatus: json['power_status'] as String?,
        healthStatus: json['health_status'] as String?,
        settings: json['settings'] != null
            ? BoxSettings.fromJson(json['settings'] as Map<String, dynamic>)
            : null,
      );

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
        'settings': settings?.toJson(),
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
    BoxSettings? settings,
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
        settings: settings ?? this.settings,
      );
}

class BoxSettings {
  final bool isDualZone;
  final int? zone1Temp;
  final int? zone2Temp;
  final bool advertDisplayEnabled;
  final bool ioniserEnabled;
  final bool lightEnabled;

  BoxSettings({
    required this.isDualZone,
    this.zone1Temp,
    this.zone2Temp,
    required this.advertDisplayEnabled,
    required this.ioniserEnabled,
    required this.lightEnabled,
  });

  factory BoxSettings.fromJson(Map<String, dynamic> json) => BoxSettings(
        isDualZone: json['is_dual_zone'] as bool? ?? false,
        zone1Temp: json['zone_1_temp'] as int?,
        zone2Temp: json['zone_2_temp'] as int?,
        advertDisplayEnabled: json['advert_display_enabled'] as bool? ?? false,
        ioniserEnabled: json['ioniser_enabled'] as bool? ?? false,
        lightEnabled: json['light_enabled'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'is_dual_zone': isDualZone,
        'zone_1_temp': zone1Temp,
        'zone_2_temp': zone2Temp,
        'advert_display_enabled': advertDisplayEnabled,
        'ioniser_enabled': ioniserEnabled,
        'light_enabled': lightEnabled,
      };

  BoxSettings copyWith({
    bool? isDualZone,
    int? zone1Temp,
    int? zone2Temp,
    bool? advertDisplayEnabled,
    bool? ioniserEnabled,
    bool? lightEnabled,
  }) =>
      BoxSettings(
        isDualZone: isDualZone ?? this.isDualZone,
        zone1Temp: zone1Temp ?? this.zone1Temp,
        zone2Temp: zone2Temp ?? this.zone2Temp,
        advertDisplayEnabled: advertDisplayEnabled ?? this.advertDisplayEnabled,
        ioniserEnabled: ioniserEnabled ?? this.ioniserEnabled,
        lightEnabled: lightEnabled ?? this.lightEnabled,
      );
}
