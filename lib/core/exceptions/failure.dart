import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

class Failure implements Exception {
  final String message;
  final Response? response;

  Failure({this.message = AppString.somethingWentWrong, this.response});
}
