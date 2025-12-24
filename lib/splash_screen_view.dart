import 'dart:async';
import 'dart:math';
import 'package:bloom_kidz/Authentication/View/login_screen.dart';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Enums/user_type_enum.dart';
import '../Styles/my_colors.dart';
import '../Styles/my_icons.dart';
import '../utils/preference_utils.dart';
import '../utils/share_predata.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    initSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SvgPicture.asset(
              img_splash,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Container(
              color: color_primary_transparent,
              width: double.infinity,
              height: double.infinity,
            ),

            Center(child: Image.asset(icon_logo, width: 300)),
          ],
        ),
      ),
    );
  }

  void redirectOnPendingState() {
    Future.delayed(const Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      LoginResponse? loginResponse = (await MySharedPref().getLoginModel(
        SharePreData.keySaveLoginModel,
      ));

      if (loginResponse == null) {
        Get.off(() => LoginScreen());
      } else {
        Get.off(() => BottomNavigationView(selectTabPosition: 0));
      }
    });
  }

  initSharedPreference() async {
    // await MySharedPref.getInstance(); // 🔥 REQUIRED FOR RELEASE

    redirectOnPendingState();
  }
}
