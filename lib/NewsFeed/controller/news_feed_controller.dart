import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_caleneder_response.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
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
  RxList<CalenderNewsEvent> calenderNewsFeedList = <CalenderNewsEvent>[].obs;
  RxList<Appointment> appointments = <Appointment>[].obs;
  Rx<NewsFeedData> newsFeedData = NewsFeedData().obs;
  Rx<LoginResponse> loginResponse = LoginResponse().obs;
  RxList<TextEditingController> replyController = <TextEditingController>[].obs;
  RxBool isLoading = false.obs;

  RxList<bool> isLikeList = <bool>[].obs;

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

            for (int i = 0; i < newsFeedList.length; i++) {
              replyController.add(TextEditingController());
            }
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// NewsFeed API
  callNewsFeedCalenderAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlNewsFeedCalenderList;

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callNewsFeedCalenderAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callNewsFeedCalenderAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          NewsFeedCalenerResponse newsFeedCalenderResponse =
              NewsFeedCalenerResponse.fromJson(userModel);

          if (newsFeedCalenderResponse.status ?? false) {
            calenderNewsFeedList.value =
                newsFeedCalenderResponse.data?.events ?? [];

            parseEvents(calenderNewsFeedList);
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// Add Comment API
  callAddCommentAPI(BuildContext context, String id, String comment) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddCommentInNewsFeed + "/${id}/comment";

    final apiReq = Request();

    dynamic body = {"comment": comment};

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callLeaveRequestAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callLeaveRequestAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Add Like API
  callAddLikeAPI(
    BuildContext context,
    String newsId,
    String commentId,
    int index,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlAddLikeInNewsFeedComment/$newsId/comment/$commentId";

    final apiReq = Request();

    await apiReq.postAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callLeaveRequestAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callLeaveRequestAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            isLikeList[index] = true;
            update();

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

  /// Convert API → Appointment (NO custom model)
  void parseEvents(List<CalenderNewsEvent> events) {
    appointments.value = events.map((e) {
      return Appointment(
        subject: e.title ?? "", // event name
        startTime: (e.start ?? DateTime(2025)),
        endTime: (e.end ?? DateTime(2025)),
        isAllDay: e.allDay ?? false,
        color: Colors.teal,
      );
    }).toList();
  }
}
