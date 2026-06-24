import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_repo.dart';

class HelpController extends GetxController {
  final HelpRepo helpRepo;

  HelpController({required this.helpRepo});

  @override
  void onInit() {
    super.onInit();
  }
  final TextEditingController searchController = TextEditingController();

  void onTroubleshootingTap(String title) {
    Navigation.pushNamed(RouteHelper.helpFaqList, arg: {"title": title});
  }

  void onAlertsTap() => Navigation.pushNamed(RouteHelper.alerts);
}
