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

import '../NewsFeed/View/event_calender_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff1f78c8),
            ),
            child: Row(
              children:  [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 12),
                BlackLargeBoldText(
                  'Menu',
                  color: Colors.white,
                  fontSize: 20
                ),
              ],
            ),
          ),

          // 🔵 Calendar Events option
          ListTile(
            leading: const Icon(Icons.event),
            title:  BlackLargeBoldText('Calendar Events'),
            onTap: () {
              Navigator.pop(context); // close drawer

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalendarScreen(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}




