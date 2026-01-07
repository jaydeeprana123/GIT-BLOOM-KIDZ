import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Styles/my_font.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final bool showBack;
  final bool? showAddButton;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAddButtonTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showMenu = false,
    this.showBack = false,
    this.onMenuTap,
    this.showAddButton,
    this.onAddButtonTap
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

      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(34), // curved bottom
        ),
      ),
    );
  }
}
