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
import '../../Notification/view/notification_screen.dart';


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
                        (loginController
                                        .loginResponse
                                        .value
                                        .data
                                        ?.user
                                        ?.profile ??
                                    "")
                                .isNotEmpty
                            ? CircleAvatar(
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
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: color_secondary,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  (loginController
                                                  .loginResponse
                                                  .value
                                                  .data
                                                  ?.user
                                                  ?.name !=
                                              null &&
                                          (loginController
                                                      .loginResponse
                                                      .value
                                                      .data
                                                      ?.user
                                                      ?.name ??
                                                  "")
                                              .isNotEmpty)
                                      ? (loginController
                                                    .loginResponse
                                                    .value
                                                    .data
                                                    ?.user
                                                    ?.name ??
                                                "")[0]
                                            .toUpperCase()
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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

                // 🔵 Notifications option
                ListTile(
                  leading: const Icon(Icons.notifications_none_outlined),
                  title: BlackLargeBoldText('Notifications'),
                  onTap: () {
                    Navigator.pop(context); // close drawer

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
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
