import 'package:bloom_kidz/Authentication/View/login_screen.dart';
import 'package:bloom_kidz/Authentication/controller/login_controller.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Profile/controller/profile_controller.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Chat/View/chat_screen.dart';
import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/black_large_regular_text.dart';
import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_medium_bold_text.dart';
import '../../CommonWidgets/common_appbar.dart';

import 'package:flutter/material.dart';

class QuickAccessPinScreen extends StatefulWidget {
  const QuickAccessPinScreen({Key? key}) : super(key: key);

  @override
  State<QuickAccessPinScreen> createState() => _QuickAccessPinScreenState();
}

class _QuickAccessPinScreenState extends State<QuickAccessPinScreen> {
  // Dummy controller (replace with your actual controller)
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Access Pin"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Authenticate With Quick Access PIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),

              /// 🔑 Current Password
              CommonTextField(
                hint: "Enter Pin",
                controller: loginController.pinController.value,
                isPassword: true,
              ),

              const SizedBox(height: 20),

              /// 🔘 Full width button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color_secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (loginController.pinController.value.text.isEmpty) {
                      snackBarRapid(context, "Enter pin");
                      return;
                    }

                    await loginController.callLoginWithPinAPI(context);
                  },
                  child: const Text(
                    "Enter Quick Pin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              InkWell(
                onTap: () {
                  Get.to(LoginScreen());
                },
                child: const Text(
                  "Go To Login Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontFamily: fontInterSemiBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------
/// Dummy controller + dialog (replace with real ones)
/// ----------------------------------------------------

void showChangePinDialog(BuildContext context, ProfileController controller) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text("Set PIN"),
        content: const Text("Change PIN dialog goes here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

/// Dummy color (replace with your theme color)
const Color color_secondary = Colors.blue;
