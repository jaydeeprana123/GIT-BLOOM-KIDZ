import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../CommonWidgets/common_widget.dart';
import '../../../../CommonWidgets/internet_connection_dialog.dart';
import '../../../../CommonWidgets/time_out_dialog.dart';
import '../../../../Networks/api_endpoint.dart';
import '../../../../Networks/model/base_model.dart';
import '../../../../Utils/preference_utils.dart';
import '../../../../Utils/share_predata.dart';
import '../../../BottomNavigation/view/bottom_navigation_view.dart';
import '../../Networks/api_response.dart';

/// Controller
class LoginController extends GetxController {
  /// Editing controller for text field
  Rx<TextEditingController> emailController = TextEditingController().obs;

  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxBool isPolicyAccepted = false.obs;
  String? deviceToken;
  Rx<TextEditingController> otpText = TextEditingController().obs;

  RxBool isLoading = false.obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// login API
  callLoginAPI(BuildContext context) async {
    isLoading.value = true;
    String url = urlBase + urlLogin;

    final apiReq = Request();

    dynamic body = {
      'email': emailController.value.text,
      "password": passwordController.value.text,
    };

    await apiReq.postAPIwithoutBearer(url, body).then((value) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          loginResponse.value = LoginResponse.fromJson(userModel);

          if (loginResponse.value.status ?? false) {
            /// Set login model into shared preference

            await MySharedPref().setAccessToken(
              loginResponse.value.data?.token ?? "",
              SharePreData.keyAccessToken,
            );

            await MySharedPref().setLoginModel(
              loginResponse.value,
              SharePreData.keySaveLoginModel,
            );

            Get.offAll(BottomNavigationView(selectTabPosition: 0));
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// login API
  callLogoutAPI(BuildContext context) async {
    isLoading.value = true;
    String url = urlBase + urlLogout;
    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    final apiReq = Request();


    await apiReq.postAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            logoutFromTheApp();
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    //
    // printData("onClose", "onClose login controller");
    // Get.delete<LoginController>();
  }
}
