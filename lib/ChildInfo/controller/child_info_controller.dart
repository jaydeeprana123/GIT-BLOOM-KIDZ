import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/ChildInfo/models/activity_response.dart';
import 'package:bloom_kidz/ChildInfo/models/child_info_list_response.dart';
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
import '../View/ChildActivity/itemline_card.dart';
import '../View/ChildActivity/models/timeline_item.dart';
import '../models/family_contact_list_response.dart';

/// Controller
class ChildInfoController extends GetxController {
  RxList<ChildInfo> childInfoList = <ChildInfo>[].obs;
  RxList<ActivityData> activityList = <ActivityData>[].obs;
  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxList<FamilyContact> familyContactList = <FamilyContact>[].obs;
  Rx<FamilyContact> selectedFamilyContact = FamilyContact().obs;


  RxBool isLoading = false.obs;

  RxInt selectedDateIndex = 0.obs;

  /// Editing controller for text field
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> relationController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  RxString imagePath = "".obs;

  ActivityData? get selectedDayData {
    if (activityList.isEmpty) return null;
    if (selectedDateIndex.value >= activityList.length) return null;
    return activityList[selectedDateIndex.value];
  }

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// Child Info API
  callChildInfoAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlChildInfoList;

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
          ChildInfoListResponse childInfoListResponse =
              ChildInfoListResponse.fromJson(userModel);

          if (childInfoListResponse.status ?? false) {
            childInfoList.value = childInfoListResponse.data?.children ?? [];
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// Add Family API
  callAddFamilyAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddFamily;

    final apiReq = Request();

    dynamic body = {
      'first_name': firstNameController.value.text,
      'last_name': lastNameController.value.text,
      'relation': relationController.value.text,
      'email': emailController.value.text,
      'mobile': mobileController.value.text,
    };

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value).then((
      value,
    ) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");

            Navigator.pop(context);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }


  /// Update Family API
  callUpdateFamilyAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddFamily;

    final apiReq = Request();

    dynamic body = {
      'first_name': firstNameController.value.text,
      'last_name': lastNameController.value.text,
      'relation': relationController.value.text,
      'email': emailController.value.text,
      'mobile': mobileController.value.text,
    };

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value).then((
        value,
        ) async {
      http.StreamedResponse res = value;
      printData(runtimeType.toString(), "Login API response ${res.statusCode}");

      await res.stream.bytesToString().then((valueData) async {
        printData(runtimeType.toString(), "Login API value ${valueData}");

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");

            Navigator.pop(context);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }


  /// ActivityList API
  callActivityListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlActivityList/$childId";

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
          ActivityResponse activityResponse = ActivityResponse.fromJson(
            userModel,
          );

          if (activityResponse.status ?? false) {
            activityList.value = activityResponse.data ?? [];

            /// RESET SELECTION AFTER LOAD
            selectedDateIndex.value = 0;
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// Get Family Contacts API
  callGetFamilyContactsAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlGetFamilyContacts;

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
          FamilyContactListResponse familyContactListResponse =
              FamilyContactListResponse.fromJson(userModel);

          if (familyContactListResponse.status ?? false) {
            familyContactList.value =
                familyContactListResponse.data?.contacts ?? [];
          } else {
            snackBar(context, loginResponse.value.message ?? "");
          }
        }
      });
    });
  }

  /// Leave Request API
  Future<void> callDeleteContactAPI(
      BuildContext context,
      String id,
      ) async {
    try {
      isLoading.value = true;

      /// 🔑 Token
      String token = await MySharedPref().getAccessToken(
        SharePreData.keyAccessToken,
      );

      /// 🧾 Headers
      Map<String, String> headersWithBearer = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      /// 🌐 URL
      String url = "$urlBase$urlDeleteContact/$id";

      /// 🔥 Request
      var request = http.Request(
        'DELETE',
        Uri.parse(url),
      );

      request.headers.addAll(headersWithBearer);

      /// 📡 Send Request
      http.StreamedResponse response = await request.send();

      /// 📥 Read Response Body
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonData = json.decode(responseBody);

      /// 📦 Parse Base Model
      BaseModel baseModel = BaseModel.fromJson(jsonData);

      if (response.statusCode == 200) {
        if (baseModel.status == true) {
          snackBar(context, baseModel.message ?? "Deleted successfully");
          callGetFamilyContactsAPI(context);
        } else {
          snackBar(context, baseModel.message ?? "Something went wrong");
        }
      } else {
        snackBar(context, "Server error (${response.statusCode})");
      }
    } catch (e) {
      snackBar(context, "Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  /// Leave Request API
  callLeaveRequestAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlLeaveRequest;

    final apiReq = Request();

    dynamic body = {
      "child_id": 306,
      "activity_id": 2,
      "start_date": "2026-01-11",
      "end_date": "2026-01-15",
      "note": "Child will be sick for these days",
    };

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

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    //
    // printData("onClose", "onClose login controller");
    // Get.delete<LoginController>();
  }
}
