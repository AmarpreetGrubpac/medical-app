import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/custom_loader.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/screens/fallback_screens/no_internet_screen.dart';
import 'package:grubpac_driver/screens/splash/controller/splash_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = Get.find<SplashController>();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Future.delayed(const Duration(seconds: 3));
      _checkInternetConnection();
    });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi);
    });

    if (_isConnected) {
      // _controller.redirectToNext();
      Get.find<SplashController>().getConfigData().then((isSuccess) {
        if (isSuccess) {
          _controller.redirectToNext();
        } else {
          Get.to(
            () => NoInternetScreen(
              onRetryPressed: () async {
                var connectivityResult =
                    await Connectivity().checkConnectivity();

                final isConnected =
                    connectivityResult.contains(ConnectivityResult.mobile) ||
                        connectivityResult.contains(ConnectivityResult.wifi);

                if (isConnected) {
                  Get.back(); // close no internet screen
                  _controller.redirectToNext();
                } else {
                  AppToast.showError(
                    message: AppString.noInternet,
                  );
                }
              },
            ),
          );
        }
      });
    } else {
      Get.to(
        () => NoInternetScreen(
          onRetryPressed: () async {
            var connectivityResult = await Connectivity().checkConnectivity();

            final isConnected =
                connectivityResult.contains(ConnectivityResult.mobile) ||
                    connectivityResult.contains(ConnectivityResult.wifi);

            if (isConnected) {
              Get.back(); // close no internet screen
              _controller.redirectToNext();
            } else {
              AppToast.showError(
                message: AppString.noInternet,
              );
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  IconAsset.splashLogo,
                  height: 180.h,
                  width: 280.w,
                ),
                24.h.verticalSpace,
                AppText(
                  text: AppString.splashTagline,
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.contentOnPrimary,
                ),
              ],
            ),
            const Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: CustomLoader(),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: AppText(
                  text: AppConstants.appversion,
                  textAlign: TextAlign.center,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
