enum AppFlavor {
  dev,
  prod,
}

class AppFlavorConfig {
  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final String packageId;
  final bool hasTestMode;

  AppFlavorConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.packageId,
    required this.hasTestMode,
  });

  static late AppFlavorConfig _instance;

  static AppFlavorConfig get current => _instance;

  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  static void init(AppFlavorConfig config) {
    _instance = config;
    _isInitialized = true;
  }

  static bool get isDev => _isInitialized && _instance.flavor == AppFlavor.dev;
  static bool get isProd =>
      _isInitialized && _instance.flavor == AppFlavor.prod;

  /// Default Dev / Test configuration
  static final AppFlavorConfig dev = AppFlavorConfig(
    flavor: AppFlavor.dev,
    appName: "GrubPac Medical Dev",
    baseUrl: "https://preprod.43.204.34.10.nip.io/api/v1",
    packageId: "com.grubpac.medical.test",
    hasTestMode: true,
  );

  /// Default Prod / Live configuration
  static final AppFlavorConfig prod = AppFlavorConfig(
    flavor: AppFlavor.prod,
    appName: "GrubPac Medical",
    baseUrl: "https://43.204.34.10.nip.io/api/v1",
    packageId: "com.grubpac.medical",
    hasTestMode: false,
  );
}
