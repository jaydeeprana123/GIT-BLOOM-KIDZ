import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../Authentication/controller/login_controller.dart';
import '../NewsFeed/View/event_calender_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());

    loginController.getUserInfo();

    return Drawer(
      child: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: color_secondary),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            loginController
                                    .loginResponse
                                    .value
                                    .data
                                    ?.user
                                    ?.profile ??
                                "",
                          ),
                        ),

                        SizedBox(height: 6),
                        BlackLargeBoldText(
                          loginController
                                  .loginResponse
                                  .value
                                  .data
                                  ?.user
                                  ?.name ??
                              "",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔵 Calendar Events option
                ListTile(
                  leading: const Icon(Icons.event),
                  title: BlackLargeBoldText('Calendar Events'),
                  onTap: () {
                    Navigator.pop(context); // close drawer

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalendarScreen()),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: BlackLargeBoldText('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    loginController.callLogoutAPI(context);
                  },
                ),
              ],
            ),

            if (loginController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
