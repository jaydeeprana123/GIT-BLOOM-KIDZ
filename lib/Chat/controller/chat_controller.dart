import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/Chat/View/chat_screen.dart';
import 'package:bloom_kidz/Chat/models/conversation_list_response.dart';
import 'package:bloom_kidz/Chat/models/create_group_member_request.dart';
import 'package:bloom_kidz/Chat/models/send_message_response.dart';
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
  late TabController tabController;
  Rx<LoginResponse> loginResponse = LoginResponse().obs;
  ScrollController scrollController = ScrollController();

  List<ChatPerson> _allPeopleMaster = [];
  RxList<ChatPerson> peopleList = <ChatPerson>[].obs;

  RxList<ConversationData> conversationList = <ConversationData>[].obs;

  RxInt selectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxString imagePath = "".obs;

  Rx<GroupChatResponse> groupChatResponse = GroupChatResponse().obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();

    update();
  }

  void scrollToBottom(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            _allPeopleMaster = List<ChatPerson>.from(
              peopleListResponse.data?.people ?? [],
            );

            peopleList.assignAll(
              List<ChatPerson>.from(peopleListResponse.data?.people ?? []),
            );
          } else {
            snackBar(context, peopleListResponse.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// Conversation List API
  Future<void> callConversationListAPI(
    BuildContext context, {
    List<ChatPerson>? selectedPersons,
    bool? fromChildInfo,
  }) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlConversations";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callConversationListAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callConversationListAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          ConversationListResponse conversationListResponse =
              ConversationListResponse.fromJson(userModel);

          if (conversationListResponse.status ?? false) {
            conversationList.value = conversationListResponse.data ?? [];

            if ((selectedPersons ?? []).isNotEmpty) {
              if (selectedPersons!.length == 1) {
                List<ConversationData> conversationList = getGroupForSingle(
                  selectedPersons[0].id ?? 0,
                );

                if (conversationList.length == 1) {
                  printData("Here", "Here");
                  Get.to(
                    ChatScreen(
                      groupId: (conversationList[0].groupId ?? 0).toString(),
                    ),
                  )?.then((value) {
                    callConversationListAPI(context);
                  });
                } else if (conversationList.length > 1) {
                  printData("get conversationList", "more than 1");
                  tabController.animateTo(1); // ✅ SWITCH TAB
                } else {
                  SendMessageNotGroupRequest sendMessageNotGroupRequest =
                      SendMessageNotGroupRequest();
                  sendMessageNotGroupRequest.message = "";
                  sendMessageNotGroupRequest.receivers = [];

                  for (int i = 0; i < (selectedPersons ?? []).length; i++) {
                    sendMessageNotGroupRequest.receivers?.add(
                      Receiver(
                        id: selectedPersons[i].id ?? 0,
                        name: selectedPersons[i].name ?? "",
                      ),
                    );
                  }

                  Get.to(
                    ChatScreen(
                      groupId: "",
                      sendMessageNotGroupRequest: sendMessageNotGroupRequest,
                    ),
                  );

                  // callSendMessageNotGroupAPI(
                  //   context,
                  //   sendMessageNotGroupRequest,
                  // );
                }
              } else {
                List<ConversationData> conversationList =
                    getExactGroupConversation(selectedPersons);
                printData(
                  "conversationList length",
                  conversationList.length.toString(),
                );
                if (conversationList.length == 1) {
                  Get.to(
                    ChatScreen(
                      groupId: (conversationList[0].groupId ?? 0).toString(),
                    ),
                  )?.then((value) {
                    callConversationListAPI(context);
                  });
                } else if (conversationList.length > 1) {
                  tabController.animateTo(1); // ✅ SWITCH TAB
                } else {
                  SendMessageNotGroupRequest sendMessageNotGroupRequest =
                      SendMessageNotGroupRequest();
                  sendMessageNotGroupRequest.message = "Hello";
                  sendMessageNotGroupRequest.receivers = [];

                  for (int i = 0; i < (selectedPersons ?? []).length; i++) {
                    sendMessageNotGroupRequest.receivers?.add(
                      Receiver(
                        id: selectedPersons[i].id ?? 0,
                        name: selectedPersons[i].name ?? "",
                      ),
                    );
                  }

                  Get.to(
                    ChatScreen(
                      groupId: "",
                      sendMessageNotGroupRequest: sendMessageNotGroupRequest,
                    ),
                  );

                  // callSendMessageNotGroupAPI(
                  //   context,
                  //   sendMessageNotGroupRequest,
                  // );
                }
              }
            }
          } else {
            snackBar(context, conversationListResponse.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// Send Message Not Group API
  callSendMessageNotGroupAPI(
    BuildContext context,
    SendMessageNotGroupRequest sendMessageNotGroupRequest, {
    bool? isFromChatScreen,
  }) async {
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
        SendMessageResponse baseModel = SendMessageResponse.fromJson(userModel);

        if (baseModel.status ?? false) {
          if (isFromChatScreen ?? false) {
            messageController.value.text = "";
            callGetGroupChatAPI(
              context,
              (baseModel.data?.groupId ?? 0).toString(),
            );
          } else {
            Get.to(
              ChatScreen(groupId: (baseModel.data?.groupId ?? 0).toString()),
            )?.then((value) {
              callConversationListAPI(context);
            });
          }
        } else {
          snackBar(context, baseModel.message ?? "");
        }
      });
    } else if (response.statusCode == 401) {
      logoutFromTheApp();
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

  /// Delete Message API
  callSendMessageInGroupAPI(
    BuildContext context,
    String groupId,
    String message,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlSendMessage";

    final apiReq = Request();

    dynamic body = {"group_id": groupId, "message": message};

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callSendMessageInGroupAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callSendMessageInGroupAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");
            messageController.value.text = "";

            callGetGroupChatAPI(context, groupId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// Add Observation API
  callSendMessageWithMediaInGroupAPI(
    BuildContext context,
    String groupId,
    String groupName,
    String message,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlSendMessage";

    final apiReq = Request();

    dynamic body = {'group_id': groupId, groupName: message};

    await apiReq
        .postAPIWithAttachment(url, body, token, "", imagePath.value)
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

                callGetGroupChatAPI(context, groupId);
              } else {
                snackBar(context, baseModel.message ?? "");
              }
            } else if (res.statusCode == 401) {
              logoutFromTheApp();
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
          groupChatResponse.value = GroupChatResponse.fromJson(userModel);

          if (groupChatResponse.value.status ?? false) {
            scrollToBottom(scrollController);
          } else {
            snackBar(context, groupChatResponse.value.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// Delete Message API
  callDeleteMessageAPI(BuildContext context, String groupId, String id) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlDeleteMessage";

    final apiReq = Request();

    dynamic body = {"message_id": id};

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callDeleteMessageAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callDeleteMessageAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");

            callGetGroupChatAPI(context, groupId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// Edit Message API
  callEditMessageAPI(
    BuildContext context,
    String groupId,
    String id,
    String message,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlEditMessage";

    final apiReq = Request();

    dynamic body = {"id": id, "message": message};

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callEditMessageAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callEditMessageAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");

            callGetGroupChatAPI(context, groupId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
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
    } else if (response.statusCode == 401) {
      logoutFromTheApp();
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

  List<ConversationData> getGroupForSingle(int userId) {
    return conversationList
        .where(
          (conversation) =>
              conversation.isGroup == "single" &&
              (conversation.members?.any((member) => member.id == userId) ??
                  false),
        )
        .toList();
  }

  List<ConversationData> getExactGroupConversation(List<ChatPerson> users) {
    List<ConversationData> availableConversations = [];

    // convert selected users to ID set
    final Set<int> userIdSet = users.map((u) => u.id).whereType<int>().toSet();

    userIdSet.add(loginResponse.value.data?.user?.id ?? 0);

    printData("userIdSet length", userIdSet.length.toString());

    return conversationList.where((conversation) {
      if (conversation.isGroup != "group") return false;

      final members = conversation.members;

      printData("members", (members?.length ?? 0).toString());

      if (members == null) return false;

      final Set<int> memberIdSet = members
          .map((m) => m.id)
          .whereType<int>()
          .toSet();

      printData("memberIdSet", (memberIdSet.length ?? 0).toString());

      if (memberIdSet.containsAll(userIdSet) &&
          memberIdSet.length == userIdSet.length) {
        availableConversations.add(conversation);

        printData("memberIdSet", "trueeeee");
      }

      // EXACT MATCH: count + same IDs
      return memberIdSet.length == userIdSet.length &&
          memberIdSet.containsAll(userIdSet);
    }).toList();
  }

  void filterPeople(String search) {
    printData("all people list", _allPeopleMaster.length.toString());

    if (search.trim().isEmpty) {
      peopleList.assignAll(_allPeopleMaster);
      return;
    }

    peopleList.assignAll(
      _allPeopleMaster.where((person) {
        final name = person.name?.toLowerCase() ?? '';
        return name.contains(search.toLowerCase());
      }).toList(),
    );
  }

  String getReceiverNames(List<Receiver>? receivers) {
    return receivers
            ?.map((r) => r.name)
            .where((name) => name != null && name!.isNotEmpty)
            .join(', ') ??
        '';
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
