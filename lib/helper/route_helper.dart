import 'package:get/get.dart';
import 'package:grubpac_driver/screens/auth/view/existing_user.dart';
import 'package:grubpac_driver/screens/auth/view/forgot_password_screen.dart';
import 'package:grubpac_driver/screens/auth/view/set_new_password_screen.dart';
import 'package:grubpac_driver/screens/auth/view/login_screen.dart';
import 'package:grubpac_driver/screens/auth/view/set_password_screen.dart';
import 'package:grubpac_driver/screens/auth/view/verify_otp_screen.dart';
import 'package:grubpac_driver/screens/auth/view/welcome_screen.dart';
import 'package:grubpac_driver/screens/box_details/view/box_details_screen.dart';
import 'package:grubpac_driver/screens/dashboard/view/dashboard_screen.dart';
import 'package:grubpac_driver/screens/fallback_screens/maintance_screen.dart';
import 'package:grubpac_driver/screens/fallback_screens/no_internet_screen.dart';
import 'package:grubpac_driver/screens/fallback_screens/update_screen.dart';
import 'package:grubpac_driver/screens/fallback_screens/versions_screen.dart';
import 'package:grubpac_driver/screens/help_section/faq_answer/view/faq_answer_screen.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/view/help_faq_list_screen.dart';
import 'package:grubpac_driver/screens/home_section/box_connection/box_connecting/view/box_connecting_screen.dart';
import 'package:grubpac_driver/screens/home_section/box_connection/box_connection_error/view/box_connection_error_screen.dart';
import 'package:grubpac_driver/screens/home_section/box_connection/connect_box_instructions/view/connect_box_instructions_screen.dart';
import 'package:grubpac_driver/screens/home_section/box_connection/disconnect_box/view/disconnect_box_screen.dart';
import 'package:grubpac_driver/screens/home_section/box_connection/remove_box/view/remove_box_screen.dart';
import 'package:grubpac_driver/screens/scan_box/view/scan_box_screen.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/view/alerts_screen.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/view/box_management_screen.dart';
import 'package:grubpac_driver/screens/settings_section/profile/change_pass/view/change_password_screen.dart';
import 'package:grubpac_driver/screens/settings_section/profile/delete_ac/view/delete_ac_screen.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/view/profile_details_screen.dart';
import 'package:grubpac_driver/screens/splash/view/splash_screen.dart';

import '../screens/fallback_screens/buttons_screens.dart';
import '../screens/fallback_screens/internel_server_error_screen.dart';

class RouteHelper {
  static const defaultTransition = Transition.rightToLeft;

  /// KEYS
  static const String splash = '/splash-screen';

  // AUTH
  static const String login = '/login-screen';
  static const String verifyOtp = '/verify-otp-screen';
  static const String setPassword = '/set-password-screen';
  static const String setNewPassword = '/set-new-password-screen';
  static const String existingUserScreen = '/ExistingUserScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String maintenanceScreen = '/maintenanceScreen';
  static const String updateScreen = '/updateScreen';
  static const String newVersionAvailableScreen = '/newVersionAvailableScreen';
  static const String noInternetScreen = '/noInternetScreen';
  static const String statusButtonsScreen = '/statusButtonsScreen';
  static const String internelServerErrorScreen = '/internelServerErrorScreen';


  // WELCOME
  static const String welcome = '/welcome-screen';
  static const String scanBox = '/scan-box-screen';

  // DASHBOARD
  static const String dashboard = '/dashboard-screen';

  // SETTINGS
  static const String alerts = '/alerts-screen';
  static const String boxManagement = '/box-management-screen';
  static const String profileDetails = '/profile-details-screen';
  static const String changePass = '/change-password-screen';
  static const String deleteAc = '/delete-ac-screen';

  // HELP
  static const String helpFaqList = '/help-faq-list-screen';
  static const String faqAnswer = '/faq-answer-screen';

  // HOME / CONNECT-BOX
  static const String connectBoxInstructions = '/connect-box-instructions-screen';
  static const String boxConnecting = '/box-connecting-screen';
  static const String boxConnectionError = '/box-connection-error-screen';
  static const String disconnectBox = '/disconnect-box-screen';
  static const String removeBox = '/remove-box-screen';

  // BOX DETAILS
  static const String boxDetails = '/box-details-screen';

  /// PAGES
  static List<GetPage<dynamic>> pages = [
    GetPage<dynamic>(name: splash, page: () => const SplashScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: login, page: () => LoginScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: verifyOtp, page: () => VerifyOtpScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: setPassword, page: () => SetPasswordScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: welcome, page: () => WelcomeScreen(), transition: defaultTransition),
  GetPage<dynamic>(name: scanBox, page: () => ScanBoxScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: dashboard, page: () => DashboardScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: helpFaqList, page: () => HelpFaqListScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: faqAnswer, page: () => FaqAnswerScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: boxManagement, page: () => BoxManagementScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: profileDetails, page: () => ProfileDetailsScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: alerts, page: () => AlertsScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: changePass, page: () => ChangePasswordScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: deleteAc, page: () => const DeleteAcScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: forgotPasswordScreen, page: () =>  ForgotPasswordScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: setNewPassword, page: () =>  SetNewPasswordScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: maintenanceScreen, page: () =>  MaintenanceScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: updateScreen, page: () =>  UpdateScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: newVersionAvailableScreen, page: () =>  NewVersionAvailableScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: noInternetScreen, page: () =>  NoInternetScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: statusButtonsScreen, page: () =>  StatusButtonsScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: internelServerErrorScreen, page: () =>  InternelServerErrorScreen(), transition: defaultTransition),
    GetPage<dynamic>(
      name: connectBoxInstructions,
      page: () => ConnectBoxInstructionsScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: boxConnecting,
      page: () => const BoxConnectingScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: boxConnectionError,
      page: () => BoxConnectionErrorScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(name: disconnectBox, page: () => DisconnectBoxScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: removeBox, page: () => RemoveBoxScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: boxDetails, page: () => BoxDetailsScreen(), transition: defaultTransition),
    GetPage<dynamic>(name: existingUserScreen, page: () => ExistingUserScreen(), transition: defaultTransition),
  ];
}
