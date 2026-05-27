import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloom_kidz/Notification/controller/notification_controller.dart';
import 'package:bloom_kidz/Notification/view/notification_screen.dart';

import '../Styles/my_font.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final bool showBack;
  final bool? showAddButton;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAddButtonTap;
  final bool? showEditButton;
  final bool? showNotificationButton;
  final bool? showClearAllButton;
  final VoidCallback? onClearAllTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showMenu = false,
    this.showBack = false,
    this.onMenuTap,
    this.showAddButton,
    this.onAddButtonTap,
    this.showEditButton,
    this.showNotificationButton,
    this.showClearAllButton,
    this.onClearAllTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      backgroundColor: const Color(0xff1f78c8),
      elevation: 0,

      /// 👇 THIS MAKES BACK ARROW WHITE
      iconTheme: const IconThemeData(color: Colors.white),

      titleSpacing: showBack ? 0 : 42,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: fontInterSemiBold,
          color: Colors.white,
        ),
      ),
      actions: [
        if (showClearAllButton ?? false)
          TextButton(
            onPressed: onClearAllTap,
            child: const Text(
              "Clear All",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        if (showNotificationButton ?? showMenu)
          Obx(() {
            final NotificationController notificationController = Get.put(NotificationController());
            final unread = notificationController.unreadCount.value;
            return InkWell(
              onTap: () {
                Get.to(() => const NotificationScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: color_primary,
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

        if (showMenu)
          InkWell(
            onTap: onMenuTap, // 👈 callback call
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: color_primary,
                child: const Icon(
                  Icons.menu_open_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

        if (showAddButton??false)
          InkWell(
            onTap: onAddButtonTap, // 👈 callback call
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: color_primary,
                child: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

        if (showEditButton??false)
          InkWell(
            onTap: onAddButtonTap, // 👈 callback call
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: color_primary,
                child: const Icon(
                  Icons.edit_calendar,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),


      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(34), // curved bottom
        ),
      ),
    );
  }
}
