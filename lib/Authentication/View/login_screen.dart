import 'package:bloom_kidz/Authentication/controller/login_controller.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Chat/View/chat_screen.dart';
import '../../ChildInfo/View/child_info_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                          const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: fontInterSemiBold,
                              color: color_secondary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Enter your username and password",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 30),

                          /// Email
                          CommonTextField(
                            hint: "Email I'd....",
                            controller: loginController.emailController.value,
                          ),

                          const SizedBox(height: 16),

                          /// Password
                          CommonTextField(
                            hint: "Password....",
                            isPassword: true,
                            controller:
                                loginController.passwordController.value,
                          ),

                          const SizedBox(height: 16),

                          /// Remember & Forgot
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (_) {},
                                activeColor: const Color(0xFF1F77C8),
                              ),
                              const Text("Remember me"),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password ?",
                                  style: TextStyle(color: Color(0xFF1F77C8)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// Sign In Button
                          SizedBox(
                            width: 160,
                            height: 45,
                            child: CommonGradientButton(
                              btnTitle: "SIGN IN",
                              onPressed: () {
                                if (loginController
                                    .passwordController
                                    .value
                                    .text
                                    .isEmpty) {
                                  snackBarRapid(context, "Enter password");
                                  return;
                                }

                                if (loginController
                                    .emailController
                                    .value
                                    .text
                                    .isEmpty) {
                                  snackBarRapid(context, "Enter email");
                                  return;
                                }

                                loginController.callLoginAPI(context);
                              },
                            ),
                          ),

                          const SizedBox(height: 40),

                          const Text(
                            "© 2025 Bloomkidz.net",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
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
    );
  }
}
