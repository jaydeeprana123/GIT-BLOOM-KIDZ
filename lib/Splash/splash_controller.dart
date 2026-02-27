import 'dart:convert';
import 'dart:io';

import 'package:bloom_kidz/Profile/model/quick_pin_response.dart';
import 'package:bloom_kidz/Profile/view/quick_pin_screen.dart';
import 'package:bloom_kidz/version_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show StreamedResponse;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Authentication/View/login_screen.dart';
import '../BottomNavigation/View/bottom_navigation_view.dart';
import '../CommonWidgets/common_widget.dart';
import '../Networks/api_endpoint.dart';
import '../Networks/api_response.dart';
import '../Utils/preference_utils.dart';
import '../Utils/share_predata.dart';

class SplashController extends GetxController {
  RxBool isVersionCheck = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Get Profile API
  callGetVersionAPI(BuildContext context) async {
    String url = urlBase + urlGetVersion;

    final apiReq = Request();

    await apiReq.getMethodAPIWithoutToken(url, null).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetVersionAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetVersionAPI value ${valueData}",
        );

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          VersionResponse versionResponse = VersionResponse.fromJson(userModel);

          if (versionResponse.status ?? false) {
            String currentVersion = await getCurrentVersion();

            bool forceUpdate =
                versionResponse.data?.appVersion?.isForceUpdate ?? false;

            String latestVersion = Platform.isAndroid
                ? versionResponse.data?.appVersion?.androidVersion ?? "1"
                : versionResponse.data?.appVersion?.iosVersion ?? "1";

            if (isVersionLower(currentVersion, latestVersion)) {
              if (forceUpdate) {
                showForceUpdateDialog();
              } else {
                showOptionalUpdateDialog(context);
              }
            } else {
              isVersionCheck.value = true;

              redirectOnPendingState(context);
            }
          } else {
            isVersionCheck.value = true;
            redirectOnPendingState(context);
          }
        } else {
          isVersionCheck.value = true;
          redirectOnPendingState(context);
        }
      });
    });
  }

  Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // Example: 1.0.0
  }

  bool isVersionLower(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (currentParts[i] < latestParts[i]) return true;
      if (currentParts[i] > latestParts[i]) return false;
    }
    return false;
  }

  void openStore() async {
    final url = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.yourapp.package"
        : "https://apps.apple.com/in/app/bloomkidz/id6758726041";

    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void showForceUpdateDialog() {
    Get.defaultDialog(
      title: "Update Required",
      middleText: "Please update the app to continue.",
      barrierDismissible: false,
      confirm: ElevatedButton(onPressed: openStore, child: Text("Update Now")),
    );
  }

  void showOptionalUpdateDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Update Available",
      middleText: "A new version is available. Update for better experience.",
      confirm: ElevatedButton(onPressed: openStore, child: Text("Update")),
      cancel: TextButton(
        onPressed: () {
          Get.back();
          redirectOnPendingState(context);
        },
        child: Text("Later"),
      ),
    );
  }

  Future<void> redirectOnPendingState(BuildContext context) async {
    /// READ LOGIN MODEL
    var sharedPref = MySharedPref();
    String token = await sharedPref.getStringValue(SharePreData.keyAccessToken);

    String email = await sharedPref.getStringValue(SharePreData.keyEmail);

    Future.delayed(const Duration(seconds: 3), () async {
      /// INITIALIZE SHARED PREF

      printData("token", token);

      if (token.isEmpty) {
        if (email.isNotEmpty) {
          callViewPinAPI(context);
        } else {
          Get.off(() => LoginScreen());
        }
      } else {
        Get.off(() => BottomNavigationView(selectTabPosition: 0));
      }
    });
  }

  /// Set Pin API
  Future<void> callViewPinAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlViewPin;

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callViewPinAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callViewPinAPI API value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          QuickPinResponse quickPinResponse = QuickPinResponse.fromJson(
            userModel,
          );

          if ((quickPinResponse.data?.pinCode ?? "").isNotEmpty) {
            Get.off(() => QuickAccessPinScreen());
          }
        }
      });
    });
  }
}
