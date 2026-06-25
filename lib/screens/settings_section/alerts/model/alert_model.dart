import 'package:grubpac_driver/core/utils/enums.dart';

class AlertModel {
  final String title;
  final String message;
  final String time;
  final AlertType type;
  final String boxName;
  final DateTime date;
  final AlertCategory category;

  AlertModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.boxName,
    required this.date,
    required this.category,
  });
}

