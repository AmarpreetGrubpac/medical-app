import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/core/utils/screen_size.dart';
import 'package:grubpac_driver/helper/get_di.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await AppPreference.initMySharedPreferences();
      HttpOverrides.global = MyHttpOverrides();
      CachedNetworkImage.logLevel = CacheManagerLogLevel.none;

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      await init();
      await ScreenUtil.ensureScreenSize();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const MyApp());
    },
    (error, stack) {
      if (kDebugMode) {
        log("error==========>>>>>>>>>\n$error");
        log("stack==========>>>>>>>>>\n$stack");
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppString.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: AppTheme.isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: RouteHelper.splash,
        // initialRoute: RouteHelper.maintenanceScreen,
        getPages: RouteHelper.pages,
        builder: (context, child) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarIconBrightness:
                  AppTheme.isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  AppTheme.isDark ? Brightness.light : Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
          );

          return ScreenUtilInit(
            designSize: Size(390, 880),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, _) {
              ScreenSize.init(context);

              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: GestureDetector(
                    onTap: () => AppUtils.hideKeyboardInApp(context),
                    child: MediaQuery.withNoTextScaling(
                        child: child ?? const SizedBox()),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
