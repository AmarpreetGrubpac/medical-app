import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alert_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/widget/filter_bottom_sheet.dart';

class AlertsController extends GetxController {
  final AlertRepo alertRepo;

  AlertsController({required this.alertRepo});

  late final List<AlertModel> alerts = [
    AlertModel(
      title: AppString.batteryBelow,
      message: AppString.batteryDrainMessage,
      time: AppString.timeToday,
      type: AlertType.medium,
      boxName: "#BOX-1245",
      date: DateTime.now(),
      category: AlertCategory.battery,
    ),
    AlertModel(
      title: AppString.cameraNotWorking,
      message: AppString.cameraNotWorkingMsg,
      time: AppString.timeToday,
      type: AlertType.high,
      boxName: "#GP123df4",
      date: DateTime.now(),
      category: AlertCategory.camera,
    ),
    AlertModel(
      title: AppString.lockOpened,
      message: AppString.lockOpenedMsg,
      time: "Yesterday | 12:15 PM",
      type: AlertType.success,
      boxName: "#BOX-1245",
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: AlertCategory.lock,
    ),
    AlertModel(
      title: "Display glitch detected",
      message: "The external display registered a brief disconnection. Monitor display function.",
      time: "3 days ago | 04:10 PM",
      type: AlertType.medium,
      boxName: "#GP123df4",
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: AlertCategory.display,
    ),
    AlertModel(
      title: "Firmware updated",
      message: "System firmware updated to version 1.4.2 successfully.",
      time: "5 days ago | 09:30 AM",
      type: AlertType.success,
      boxName: "#BOX-1245",
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: AlertCategory.other,
    ),
    AlertModel(
      title: AppString.cameraNotWorking,
      message: AppString.cameraNotWorkingMsg,
      time: "10 days ago | 01:23 PM",
      type: AlertType.high,
      boxName: "#GP123df4",
      date: DateTime.now().subtract(const Duration(days: 10)),
      category: AlertCategory.camera,
    ),
  ];

  String selectedBox = "All";
  String selectedDateRange = "All"; // All, Today, Yesterday, Last 7 Days
  String selectedAlertSeverity = "All"; // All, Warning, Error, Success
  String selectedCategory = "All"; // All, Camera, Battery, Lock, Display, Other

  List<String> get availableBoxes => ["All", ...alerts.map((a) => a.boxName).toSet()];

  List<AlertModel> get filteredAlerts {
    return alerts.where((alert) {
      if (selectedBox != "All" && alert.boxName != selectedBox) {
        return false;
      }

      if (selectedDateRange != "All") {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        final last7Days = today.subtract(const Duration(days: 7));

        if (selectedDateRange == "Today") {
          if (alert.date.isBefore(today)) return false;
        } else if (selectedDateRange == "Yesterday") {
          if (alert.date.isBefore(yesterday) || alert.date.isAfter(today.subtract(const Duration(seconds: 1)))) {
            return false;
          }
        } else if (selectedDateRange == "Last 7 Days") {
          if (alert.date.isBefore(last7Days)) return false;
        }
      }

      if (selectedAlertSeverity != "All") {
        if (selectedAlertSeverity == "Warning" && alert.type != AlertType.medium) return false;
        if (selectedAlertSeverity == "Error" && alert.type != AlertType.high) return false;
        if (selectedAlertSeverity == "Success" && alert.type != AlertType.success) return false;
      }

      if (selectedCategory != "All") {
        final catStr = alert.category.name;
        if (catStr.toLowerCase() != selectedCategory.toLowerCase()) return false;
      }

      return true;
    }).toList();
  }

  void applyFilters({
    required String box,
    required String dateRange,
    required String alertSeverity,
    required String category,
  }) {
    selectedBox = box;
    selectedDateRange = dateRange;
    selectedAlertSeverity = alertSeverity;
    selectedCategory = category;
    update();
  }

  void resetFilters() {
    selectedBox = "All";
    selectedDateRange = "All";
    selectedAlertSeverity = "All";
    selectedCategory = "All";
    update();
  }

  /// FILTER
  void onFilterTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(controller: this),
    );
  }
}

