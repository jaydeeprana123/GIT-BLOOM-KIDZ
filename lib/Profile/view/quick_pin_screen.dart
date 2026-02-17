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
      backgroundColor: Colors.transparent,
      body: Obx(
        () => Stack(
          children: [
            /// Background SVG
            Positioned.fill(
              child: SvgPicture.asset(img_splash, fit: BoxFit.cover),
            ),

            /// Overlay
            Positioned.fill(child: Container(color: color_primary_transparent)),

            /// Content
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// Logo
                  Image.asset(icon_logo, height: 120),

                  const SizedBox(height: 30),

                  /// White Card (takes remaining space)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            const Text(
                              "Quick Access PIN",
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: fontInterSemiBold,
                                color: color_secondary,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// Email
                            CommonTextField(
                              hint: "Enter Pin",
                              controller: loginController.pinController.value,
                              isPassword: true,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                            ),

                            const SizedBox(height: 24),

                            /// Sign In Button
                            SizedBox(
                              width: 160,
                              height: 45,
                              child: CommonGradientButton(
                                btnTitle: "SUBMIT",
                                onPressed: () {
                                  if (loginController
                                      .pinController
                                      .value
                                      .text
                                      .isEmpty) {
                                    snackBarRapid(context, "Enter pin");
                                    return;
                                  }

                                  loginController.callLoginWithPinAPI(context);
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            InkWell(
                              onTap: () {
                                Get.to(LoginScreen());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don’t remember your PIN?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  Text(
                                    " Sign in.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: color_secondary,
                                      fontFamily: fontInterSemiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (loginController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
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
