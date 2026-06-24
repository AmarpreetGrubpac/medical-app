import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alert_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';

class AlertsController extends GetxController {
  final AlertRepo alertRepo;

  AlertsController({required this.alertRepo});
  final List<AlertModel> alerts = [
    AlertModel(
      title: AppString.batteryBelow,
      message: AppString.batteryDrainMessage,
      time: AppString.timeToday,
      type: AlertType.medium,
    ),
    AlertModel(
      title: AppString.cameraNotWorking,
      message: AppString.cameraNotWorkingMsg,
      time: AppString.timeToday,
      type: AlertType.high,
    ),
    AlertModel(
      title: AppString.lockOpened,
      message: AppString.lockOpenedMsg,
      time: AppString.timeToday,
      type: AlertType.success,
    ),
    AlertModel(
      title: AppString.batteryBelow,
      message: AppString.batteryDrainMessage,
      time: AppString.timeToday,
      type: AlertType.medium,
    ),
    AlertModel(
      title: AppString.cameraNotWorking,
      message: AppString.cameraNotWorkingMsg,
      time: AppString.timeToday,
      type: AlertType.high,
    ),
    AlertModel(
      title: AppString.lockOpened,
      message: AppString.lockOpenedMsg,
      time: AppString.timeToday,
      type: AlertType.success,
    ),
  ];

  /// FILTER
  void onFilterTap() {}
}
