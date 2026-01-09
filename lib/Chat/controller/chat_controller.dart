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
import '../models/people_list_response.dart';

/// Controller
class ChatController extends GetxController {


  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxList<ChatPerson> peopleList = <ChatPerson>[].obs;

  RxBool isLoading = false.obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// People List API
  callPeopleListAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlPeopleList";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callChildInfoAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callChildInfoAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          PeopleListResponse peopleListResponse = PeopleListResponse.fromJson(
            userModel,
          );

          if (peopleListResponse.status ?? false) {
            peopleList.value = peopleListResponse.data?.people ?? [];

          } else {
            snackBar(context, peopleListResponse.message ?? "");
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
