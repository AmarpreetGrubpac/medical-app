import 'package:flutter/material.dart';
import '../../box_management/controller/box_management_controller.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alert_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/widget/filter_bottom_sheet.dart';

class AlertsController extends GetxController {
  final AlertRepo alertRepo;

  AlertsController({required this.alertRepo});

  RxList<AlertModel> alerts = RxList<AlertModel>();
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null &&
        args["box_name"] != null &&
        args["box_name"].toString().isNotEmpty) {
      selectedBox = args["box_name"];
    }
    if (args is Map && args['box_id'] != null)
      selectedBoxId = args['box_id'].toString();
    getAlerts();
  }

  String selectedBox = "All";
  String? selectedBoxId;
  String selectedDateRange = "All"; // All, Today, Yesterday, Last 7 Days
  String selectedAlertSeverity = "All"; // All, Warning, Error, Success
  String selectedCategory = "All"; // All, Camera, Battery, Lock, Display, Other
  bool isloading = false;
  bool isLoadingMore = false;
  int _page = 1;
  int _totalPages = 1;
  static const int _limit = 20;

  bool get hasMorePages => _page < _totalPages;

  Future<void> getAlerts({bool reset = true}) async {
    if (reset && isloading) return;
    if (!reset && (isLoadingMore || !hasMorePages)) return;
    try {
      if (reset) {
        isloading = true;
        _page = 1;
      } else {
        isLoadingMore = true;
      }
      update();
      final requestedPage = reset ? 1 : _page + 1;
      var res = await alertRepo.getAlerts(page: requestedPage, limit: _limit);
      if (res.statusCode == 200) {
        if (reset) alerts.clear();
        final data = res.body["data"] as Map<String, dynamic>? ?? {};
        _totalPages = (data['total_pages'] as num?)?.toInt() ?? 1;
        var alertList = data["data"] as List? ?? const [];
        for (var alert in alertList) {
          try {
            final parsed = AlertModel.fromJson(alert);
            if (Get.isRegistered<BoxManagementController>()) {
              for (final box in Get.find<BoxManagementController>().boxes) {
                if (box.id == parsed.boxId) {
                  parsed.boxName =
                      box.name.isNotEmpty ? box.name : box.boxDisplayId;
                  parsed.boxDisplayId = box.boxDisplayId;
                  break;
                }
              }
            }
            if (!alerts.any((existing) => existing.id == parsed.id)) {
              alerts.add(parsed);
            }
          } catch (e) {
            debugPrint("Alert parse error: $e");
          }
        }
        _page = requestedPage;
      } else {
        AppToast.showError(
          message: res.statusText ?? 'Failed to load alerts',
        );
      }
    } catch (e) {
      AppToast.showError(message: "Failed to load alerts");
    } finally {
      isloading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> loadMore() => getAlerts(reset: false);

  Future<void> onRefresh() async {
    await getAlerts(reset: true);
  }

  List<String> get availableBoxes =>
      ["All", ...alerts.map((a) => a.boxName).toSet()];

  List<AlertModel> get filteredAlerts {
    return alerts.where((alert) {
      if (selectedBoxId != null && alert.boxId != selectedBoxId) return false;
      if (selectedBoxId == null &&
          selectedBox != "All" &&
          alert.boxName != selectedBox) {
        return false;
      }

      if (selectedDateRange != "All") {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        final last7Days = today.subtract(const Duration(days: 7));

        if (selectedDateRange == "Today") {
          if (alert.createdAt.isBefore(today)) return false;
        } else if (selectedDateRange == "Yesterday") {
          if (alert.createdAt.isBefore(yesterday) ||
              alert.createdAt
                  .isAfter(today.subtract(const Duration(seconds: 1)))) {
            return false;
          }
        } else if (selectedDateRange == "Last 7 Days") {
          if (alert.createdAt.isBefore(last7Days)) return false;
        }
      }

      if (selectedAlertSeverity != "All") {
        if (selectedAlertSeverity == "Warning" &&
            alert.type != AlertType.warning) return false;
        if (selectedAlertSeverity == "Error" && alert.type != AlertType.error)
          return false;
        if (selectedAlertSeverity == "Success" &&
            alert.type != AlertType.success) return false;
      }

      if (selectedCategory != "All") {
        final catStr = alert.category.name;
        if (catStr.toLowerCase() != selectedCategory.toLowerCase())
          return false;
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
    selectedBoxId = null;
    selectedBox = box;
    selectedDateRange = dateRange;
    selectedAlertSeverity = alertSeverity;
    selectedCategory = category;
    update();
  }

  void resetFilters() {
    selectedBoxId = null;
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

  Future<void> onView(String id) async {
    try {
      final index = alerts.indexWhere((element) => element.id == id);
      if (index != -1 && alerts[index].isRead) {
        return;
      }
      Response res = await alertRepo.updateNotifications(
        ids: [id],
        isRead: true,
      );
      if (res.statusCode == 200) {
        if (index != -1) {
          alerts[index].isRead = true;
          update();
        }
      } else {
        debugPrint("Failed to mark alert as read: ${res.statusText}");
      }
    } catch (e) {
      debugPrint("Error marking alert as read: $e");
    }
  }

  Future<void> onClickDismiss(String id) async {
    try {
      Response res = await alertRepo.updateNotifications(
        ids: [id],
        isDismissed: true,
      );
      if (res.statusCode == 200) {
        alerts.removeWhere((element) => element.id == id);
        update();
        AppToast.showSuccess(message: "Notification dismissed");
      } else {
        AppToast.showError(message: "Failed to dismiss notification");
      }
    } catch (e) {
      AppToast.showError(message: "Error dismissing notification: $e");
    }
  }
}
