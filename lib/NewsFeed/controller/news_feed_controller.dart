import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
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
class NewsFeedController extends GetxController {
  RxList<Newsfeed> newsFeedList = <Newsfeed>[].obs;
  Rx<NewsFeedData> newsFeedData = NewsFeedData().obs;
  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxBool isLoading = false.obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// NewsFeed API
  callNewsFeedAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlNewsFeedList;

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callNewsFeedAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "callNewsFeedAPI value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          NewsFeedResponse newsFeedResponse = NewsFeedResponse.fromJson(
            userModel,
          );

          if (newsFeedResponse.status ?? false) {
            newsFeedData.value = newsFeedResponse.data ?? NewsFeedData();
            newsFeedList.value = newsFeedData.value.newsfeeds ?? [];
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
