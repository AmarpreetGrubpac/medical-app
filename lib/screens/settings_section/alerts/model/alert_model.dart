// To parse this JSON data, do
//
//     final alertModel = alertModelFromJson(jsonString);

import 'dart:convert';

import 'package:grubpac_driver/core/utils/enums.dart';

class AlertModel {
  String id;
  String clientId;
  String? verticalId;
  String boxId;
  String boxDisplayId;
  String boxName;
  String? restaurantName;
  AlertCategory category;
  AlertType type;
  String title;
  String description;
  bool isRead;
  bool isDismissed;
  DateTime createdAt;
  DateTime updatedAt;

  AlertModel({
    required this.id,
    required this.clientId,
    required this.verticalId,
    required this.boxId,
    required this.boxDisplayId,
    required this.boxName,
    required this.restaurantName,
    required this.category,
    required this.type,
    required this.title,
    required this.description,
    required this.isRead,
    required this.isDismissed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json["id"] ?? "N.A",
        clientId: json["client_id"] ?? "N.A",
        verticalId: json["vertical_id"] ?? "N.A",
        boxId: json["box_id"],
        boxDisplayId: json["box_display_id"] ?? "N.A",
        boxName: json["box_name"] ?? "N.A",
        restaurantName: json["restaurant_name"] ?? "N.A",
        category: _parseCategory(json["category"] ?? ""),
        type: _parseType(json["type"] ?? ''),
        title: json["title"] ?? "N.A",
        description: json["description"] ?? "N.A",
        isRead: json["is_read"] ?? false,
        isDismissed: json["is_dismissed"] ?? false,
        createdAt:
            DateTime.parse(json["created_at"] ?? DateTime.now().toString())
                .toLocal(),
        updatedAt:
            DateTime.parse(json["updated_at"] ?? DateTime.now().toString())
                .toLocal(),
      );

  static AlertCategory _parseCategory(String? val) {
    return AlertCategory.values.firstWhere(
      (e) => e.name == val?.toLowerCase(),
      orElse: () => AlertCategory.other,
    );
  }

  static AlertType _parseType(String? val) {
    final lower = val?.toLowerCase();
    // if (lower == 'medium') return AlertType.warning;
    // if (lower == 'high') return AlertType.error;
    return AlertType.values.firstWhere(
      (e) => e.name == lower,
      orElse: () => AlertType.notification,
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "client_id": clientId,
  //       "vertical_id": verticalId,
  //       "box_id": boxId,
  //       "box_display_id": boxDisplayId,
  //       "box_name": boxName,
  //       "restaurant_name": restaurantName,
  //       "category": category,
  //       "type": type,
  //       "title": title,
  //       "description": description,
  //       "is_read": isRead,
  //       "is_dismissed": isDismissed,
  //       "created_at": createdAt.toIso8601String(),
  //       "updated_at": updatedAt.toIso8601String(),
  //     };
}
