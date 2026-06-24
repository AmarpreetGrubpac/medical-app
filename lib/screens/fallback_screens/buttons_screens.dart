import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/helper/navigation.dart';

import '../../helper/route_helper.dart';

class StatusButtonsScreen extends StatelessWidget {
  const StatusButtonsScreen({super.key});

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FallBack Screens"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              text: "Maintenance",
              onTap: () {
                Get.toNamed(RouteHelper.maintenanceScreen);

              },
            ),
            const SizedBox(height: 12),

            _buildButton(
              text: "Update App",
              onTap: () {
                Get.toNamed(RouteHelper.updateScreen);

              },
            ),
            const SizedBox(height: 12),

            _buildButton(
              text: "New Version",
              onTap: () {
                Get.toNamed(RouteHelper.newVersionAvailableScreen);

              },
            ),
            const SizedBox(height: 12),

            _buildButton(
              text: "Internal Server Error",
              onTap: () {
              //   Navigation.p
              //       RouteHelper.internelServerErrorScreen
              //   );
                Get.toNamed(RouteHelper.internelServerErrorScreen);
               },
            ),
            const SizedBox(height: 12),

            _buildButton(
              text: "No Internet",
              onTap: () {
                Get.toNamed(RouteHelper.noInternetScreen);

              },
            ),
          ],
        ),
      ),
    );
  }
}
