import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/Profile/model/profile_response.dart';
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
class ProfileController extends GetxController {
  /// Editing controller for text field
  Rx<TextEditingController> emailController = TextEditingController().obs;

  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;

  Rx<TextEditingController> pinController = TextEditingController().obs;


  Rx<LoginResponse> loginResponse = LoginResponse().obs;
  Rx<ProfileUser> profileUser = ProfileUser().obs;
  RxBool isLoading = false.obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// Get Profile API
  callGetProfileAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlGetProfile;

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
         ProfileResponse profileResponse = ProfileResponse.fromJson(userModel);

          if (profileResponse.status ?? false) {
            profileUser.value = profileResponse.data?.user??ProfileUser();
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }


  /// Change Password API
  Future<void> callChangePasswordAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlChangePassword;

    final apiReq = Request();

    dynamic body = {
      'current_password': passwordController.value.text,
      "new_password": newPasswordController.value.text,
      "new_password_confirmation": confirmPasswordController.value.text
    };

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            Navigator.pop(context);
            snackBar(context, baseModel.message ?? "");
            logoutFromTheApp();
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }


  /// Set Pin API
  Future<void> callSetPinAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlSetPin;

    final apiReq = Request();

    dynamic body = {
      'pin_code': pinController.value.text,
    };

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            Navigator.pop(context);
            snackBar(context, baseModel.message ?? "");
          } else {
            snackBar(context, baseModel.message ?? "");
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
