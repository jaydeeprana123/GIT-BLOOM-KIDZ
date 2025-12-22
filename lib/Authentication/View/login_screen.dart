import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Chat/View/chat_screen.dart';
import '../../ChildInfo/View/child_info_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FB3C2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// Logo
            Column(
              children: [
                Image.asset(
                  icon_logo, // add your logo
                  height: 80,
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// White Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
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

                  /// Email Field
                  CommonTextField(
                    hint: "Email I'd....",
                  ),

                  const SizedBox(height: 16),

                  /// Password Field
                  CommonTextField(
                    hint: "Password....",
                    isPassword: true,
                  ),

                  const SizedBox(height: 16),

                  /// Remember & Forgot
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        activeColor: const Color(0xFF1F77C8),
                      ),
                      const Text("Remember me"),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password ?",
                          style: TextStyle(
                            color: Color(0xFF1F77C8),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Sign In Button
                  SizedBox(
                    width: 160,
                    height: 45,
                    child: CommonGradientButton(btnTitle: "SIGN IN",onPressed: (){
                      Get.to(BottomNavigationView(selectTabPosition: 0,));
                    })



                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "© 2025 Bloomkidz.net",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

