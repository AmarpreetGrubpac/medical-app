import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/dashboard/view/dashboard_screen.dart';
import 'package:grubpac_driver/screens/dashboard/widgets/bottom_bar_item.dart';
import 'package:grubpac_driver/screens/home_section/home/view/home_screen.dart';

/// Page Object for DashboardScreen and HomeScreen interactions.
class DashboardPage {
  final WidgetTester tester;
  DashboardPage(this.tester);

  Finder get dashboardFinder => find.byType(DashboardScreen);
  Finder get homeTabFinder => find.widgetWithText(BottomBarItem, AppString.home);
  Finder get settingsTabFinder => find.widgetWithText(BottomBarItem, AppString.settings);
  Finder get helpTabFinder => find.widgetWithText(BottomBarItem, AppString.help);

  Finder get emptyWelcomeFinder => find.text(AppString.welcomeTrip);
  Finder get addMyBoxButtonFinder => find.widgetWithText(CommonButton, AppString.addMyBox);
  Finder get connectedViewFinder => find.byType(ConnectedView);

  void verifyVisible() {
    expect(dashboardFinder, findsOneWidget);
  }

  void verifyEmptyState() {
    expect(emptyWelcomeFinder, findsOneWidget);
    expect(addMyBoxButtonFinder, findsOneWidget);
  }

  void verifyConnectedBoxState() {
    expect(connectedViewFinder, findsOneWidget);
  }

  Future<void> tapAddMyBox() async {
    await tester.tap(addMyBoxButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  Future<void> selectHomeTab() async {
    await tester.tap(homeTabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  Future<void> selectSettingsTab() async {
    await tester.tap(settingsTabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  Future<void> selectHelpTab() async {
    await tester.tap(helpTabFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }
}
