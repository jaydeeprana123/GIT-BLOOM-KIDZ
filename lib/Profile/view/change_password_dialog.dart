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

class ChangePasswordDialog extends StatelessWidget {
  
  final ProfileController controller;
  
  ChangePasswordDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
            () =>Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ❌ Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.cancel,
                      color: color_secondary,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                /// 🔵 Title
                BlueMediumBoldText(
                  "Change Password",
                  fontSize: 16,
                ),

                const SizedBox(height: 20),

                /// 🔑 Current Password
                CommonTextField(
                  hint: "Current Password",
                  controller: controller.passwordController.value,
                  isPassword: true,
                ),

                const SizedBox(height: 12),

                /// 🔑 New Password
                CommonTextField(
                  hint: "New Password",
                  controller:controller.newPasswordController.value,
                  isPassword: true,
                ),

                const SizedBox(height: 12),

                /// 🔑 Confirm Password
                CommonTextField(
                  hint: "Confirm New Password",
                  controller: controller.confirmPasswordController.value,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                /// 💾 Save Button
                Center(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color_secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () async{

                        await controller.callChangePasswordAPI(context);


                      },
                      child: BlueMediumBoldText(
                        "Save Password",
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if(controller.isLoading.value)Center(child: CircularProgressIndicator(),)
          ],
        )),
      ),
    );
  }
}


