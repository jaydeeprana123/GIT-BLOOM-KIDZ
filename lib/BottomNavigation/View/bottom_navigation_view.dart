import 'dart:developer';

import 'package:bloom_kidz/Chat/View/chat_screen.dart';
import 'package:bloom_kidz/ChildInfo/View/child_info_screen.dart';
import 'package:bloom_kidz/NewsFeed/View/news_feed_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_icons.dart';
import '../controller/bottom_navigation_controller.dart';

class BottomNavigationView extends StatefulWidget {
  final int selectTabPosition;

  const BottomNavigationView({Key? key, required this.selectTabPosition})
    : super(key: key);

  @override
  _BottomNavigationViewState createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  BottomNavigationController bottomNavController = Get.put(
    BottomNavigationController(),
  );

  // int _currentIndex = HomeTabEnum.Home.index;
  final tabs = [
    NewsFeedScreen(),
    ChildInfoScreen(),
    ChatScreen(),
    ChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      bottomNavController.currentIndex.value = widget.selectTabPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.transparent, // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.light, //navigation bar icons' color
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => tabs[bottomNavController.currentIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavController.currentIndex.value,
        selectedItemColor: const Color(0xff1f78c8),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: "News Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: "Child Info",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Profile",
          ),
        ],

        onTap: (index) {
          setState(() {
            bottomNavController.currentIndex.value = index;
          });
        },
      ),

      // ),
    );
  }
}
