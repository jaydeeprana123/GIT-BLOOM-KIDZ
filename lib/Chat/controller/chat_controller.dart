import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/Chat/models/create_group_member_request.dart';
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
import '../models/group_chat_response.dart';
import '../models/people_list_response.dart';
import '../models/send_message_not_group_request.dart';

/// Controller
class ChatController extends GetxController {

  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxList<ChatPerson> peopleList = <ChatPerson>[].obs;

  RxBool isLoading = false.obs;
  RxList<String> imagePath = <String>[].obs;

  Rx<GroupChatResponse> groupChatResponse = GroupChatResponse().obs;
  RxList<TextEditingController> messageController = <TextEditingController>[].obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
  }

  /// People List API
  callPeopleListAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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

  /// Send Message Not Group API
  callSendMessageNotGroupAPI(
      BuildContext context,
      SendMessageNotGroupRequest sendMessageNotGroupRequest,
      String childId,
      ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlSendMessage";

    final apiReq = Request();
    Map<String, dynamic> body = sendMessageNotGroupRequest.toJson();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('POST', Uri.parse(url));

    request.headers.addAll(headers);
    request.body = json.encode(sendMessageNotGroupRequest.toJson());
    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {
      await response.stream.bytesToString().then((valueData) async {
        printData("callSendMessageNotGroupAPI", valueData);

        Map<String, dynamic> userModel = json.decode(valueData);
        BaseModel baseModel = BaseModel.fromJson(userModel);

        if (baseModel.status ?? false) {
          snackBar(context, baseModel.message ?? "");
          Navigator.pop(context);
        } else {
          snackBar(context, baseModel.message ?? "");
        }
      });
    } else {
      print(response.reasonPhrase);
    }

    // await apiReq.postAPI(url, body, token).then((
    //     value,
    //     ) async {
    //   http.StreamedResponse res = value;
    //   printData(runtimeType.toString(), "callAddExtraBookingsAPI API response ${res.statusCode}");
    //
    //   await res.stream.bytesToString().then((valueData) async {
    //     printData(runtimeType.toString(), "callAddExtraBookingsAPI API value ${valueData}");
    //
    //     isLoading.value = false;
    //
    //     if (res.statusCode == 200) {
    //       Map<String, dynamic> userModel = json.decode(valueData);
    //       BaseModel baseModel = BaseModel.fromJson(userModel);
    //
    //       if (baseModel.status ?? false) {
    //         snackBar(context, baseModel.message ?? "");
    //
    //         Navigator.pop(context);
    //       } else {
    //         snackBar(context, baseModel.message ?? "");
    //       }
    //     }
    //   });
    // });
  }



  /// Add Observation API
  callSendMessageWithMediaInGroupAPI(BuildContext context, String groupId, String groupName, String message,) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlSendMessage";

    final apiReq = Request();

    dynamic body = {'group_id': groupId, groupName : message,};

    await apiReq
        .postAPIWithMedia(url, body, token, "", imagePath)
        .then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callSendMessageWithMediaInGroupAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callSendMessageWithMediaInGroupAPI API value ${valueData}",
        );

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



  /// Get Group Chat API
  callGetGroupChatAPI(BuildContext context, String id) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetGroupChat/$id";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetGroupChatAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetGroupChatAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          groupChatResponse.value = GroupChatResponse.fromJson(
            userModel,
          );

          if (groupChatResponse.value.status ?? false) {
          } else {
            snackBar(context, groupChatResponse.value.message ?? "");
          }
        }
      });
    });
  }


  /// Delete Message API
  callDeleteMessageAPI(
      BuildContext context,
      String id,

      ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlDeleteMessage";

    final apiReq = Request();

    dynamic body = {"message_id": id};

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



  /// Add Group Member API
  callAddGroupMemberAPI(
      BuildContext context,
      CreateGroupMemberRequest createGroupMemberRequest,
      ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddGroupMember";

    final apiReq = Request();
    Map<String, dynamic> body = createGroupMemberRequest.toJson();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('POST', Uri.parse(url));

    request.headers.addAll(headers);
    request.body = json.encode(createGroupMemberRequest.toJson());
    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {
      await response.stream.bytesToString().then((valueData) async {
        printData("callAddGroupMemberAPI", valueData);

        Map<String, dynamic> userModel = json.decode(valueData);
        BaseModel baseModel = BaseModel.fromJson(userModel);

        if (baseModel.status ?? false) {
          snackBar(context, baseModel.message ?? "");
          Navigator.pop(context);
        } else {
          snackBar(context, baseModel.message ?? "");
        }
      });
    } else {
      print(response.reasonPhrase);
    }

    // await apiReq.postAPI(url, body, token).then((
    //     value,
    //     ) async {
    //   http.StreamedResponse res = value;
    //   printData(runtimeType.toString(), "callAddExtraBookingsAPI API response ${res.statusCode}");
    //
    //   await res.stream.bytesToString().then((valueData) async {
    //     printData(runtimeType.toString(), "callAddExtraBookingsAPI API value ${valueData}");
    //
    //     isLoading.value = false;
    //
    //     if (res.statusCode == 200) {
    //       Map<String, dynamic> userModel = json.decode(valueData);
    //       BaseModel baseModel = BaseModel.fromJson(userModel);
    //
    //       if (baseModel.status ?? false) {
    //         snackBar(context, baseModel.message ?? "");
    //
    //         Navigator.pop(context);
    //       } else {
    //         snackBar(context, baseModel.message ?? "");
    //       }
    //     }
    //   });
    // });
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
