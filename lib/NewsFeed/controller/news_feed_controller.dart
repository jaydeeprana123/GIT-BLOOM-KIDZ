import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart' hide User;
import 'package:bloom_kidz/NewsFeed/models/news_feed_caleneder_response.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
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
  RxBool isDoctorListPaginationLoading = false.obs;
  RxBool isPaginationApiCalling = false.obs;
  int pageNumberObservation = 1;
  RxList<bool> isLikeList = <bool>[].obs;
  RxBool isNewAddedObservationLoading = false.obs;

  // Tracks current page index per news card
  final RxMap<int, int> imagePageMap = <int, int>{}.obs;

  void updateImagePage(int cardIndex, int page) {
    imagePageMap[cardIndex] = page;
  }

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  getUserInfo() async {
    /// Set login model into shared preference
    loginResponse.value =
        (await MySharedPref().getLoginModel(SharePreData.keySaveLoginModel)) ??
        LoginResponse();
    update();
  }

  /// NewsFeed API
  callNewsFeedAPI(BuildContext context, {bool? isToClearList}) async {
    if (pageNumberObservation == 1) {
      // clearning list before getting response

      if (isToClearList ?? true) {
        newsFeedList.clear();
        replyController.clear();
      }

      isLoading.value = true;
    } else {
      isNewAddedObservationLoading.value = true;
    }

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlNewsFeedList?page=$pageNumberObservation";

    printData("url", url);

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

          // Debug likes structure
          try {
            final firstFeed = (userModel["data"]?["newsfeeds"] as List?)?.first;
            if (firstFeed != null) {
              final debugData = {
                "feed_id": firstFeed["id"],
                "likes": firstFeed["likes"],
                "liked_users": firstFeed["liked_users"],
                "likedUsers": firstFeed["likedUsers"],
                "comments": (firstFeed["comments"] as List?)
                    ?.map(
                      (c) => {
                        "comment_id": c["id"],
                        "likes": c["likes"],
                        "liked_users": c["liked_users"],
                        "likedUsers": c["likedUsers"],
                      },
                    )
                    .toList(),
              };
              File(
                "likes_debug.json",
              ).writeAsStringSync(json.encode(debugData));
            }
          } catch (e) {
            // ignore
          }

          NewsFeedResponse newsFeedResponse = NewsFeedResponse.fromJson(
            userModel,
          );

          if (newsFeedResponse.status ?? false) {
            if (pageNumberObservation == 1) {
              replyController.clear();
              newsFeedList.value = newsFeedResponse.data?.newsfeeds ?? [];
            } else {
              newsFeedList.addAll(newsFeedResponse.data?.newsfeeds ?? []);
            }

            // consultDoctorList
            //     .addAll(await removeLesserTimeFromNow(model.data ?? []));

            // consultDoctorList.addAll(model.data ?? []);
            isDoctorListPaginationLoading.value = true;
            pageNumberObservation = pageNumberObservation + 1;

            isNewAddedObservationLoading.value = false;

            for (
              int i = 0;
              i < (newsFeedResponse.data?.newsfeeds ?? []).length;
              i++
            ) {
              replyController.add(TextEditingController());
            }
          } else if (newsFeedResponse.code == 401) {
            logoutFromTheApp();
          } else {
            snackBarRapid(context, newsFeedResponse.message ?? "");
          }
        } else if (res.statusCode == 401) {
          logoutFromTheApp();
        }
      });
    });
  }

  /// NewsFeed API
  callNewsFeedCalenderAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
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

            pageNumberObservation = 1;
            callNewsFeedAPI(context);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Add Comment API
  callAInterestedNotInterestedAPI(
    BuildContext context,
    String id,
    String status,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddCommentInNewsFeed + "/${id}/response";

    final apiReq = Request();

    dynamic body = {"status": status};

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callAInterestedNotInterestedAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callAInterestedNotInterestedAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            // Update local event response immediately for responsive UI
            final feedIndex = newsFeedList.indexWhere(
              (feed) => feed.id.toString() == id,
            );
            if (feedIndex != -1) {
              newsFeedList[feedIndex].eventResponse =
                  status == "1" ? "interested" : "not_interested";
              newsFeedList.refresh();
            }

            snackBar(context, baseModel.message ?? "");

            pageNumberObservation = 1;
            callNewsFeedAPI(context);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Leave Request API
  Future<void> callNewsDeleteCommentAPI(
    BuildContext context,
    String newsId,
    String id,
  ) async {
    try {
      isLoading.value = true;

      /// 🔑 Token
      String token = await MySharedPref().getStringValue(
        SharePreData.keyAccessToken,
      );

      /// 🧾 Headers
      Map<String, String> headersWithBearer = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      /// 🌐 URL
      String url = "$urlBase$urlAddCommentInNewsFeed/$newsId/comment/$id";

      /// 🔥 Request
      var request = http.Request('DELETE', Uri.parse(url));
      printData(runtimeType.toString(), "callDeleteCommentAPI response ${url}");
      request.headers.addAll(headersWithBearer);

      /// 📡 Send Request
      http.StreamedResponse response = await request.send();

      /// 📥 Read Response Body
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonData = json.decode(responseBody);

      /// 📦 Parse Base Model
      BaseModel baseModel = BaseModel.fromJson(jsonData);
      printData(
        runtimeType.toString(),
        "callDeleteCommentAPI response ${response.statusCode}",
      );
      if (response.statusCode == 200) {
        if (baseModel.status == true) {
          snackBar(context, baseModel.message ?? "Deleted successfully");
          Navigator.pop(context);
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

  /// Add Like API
  callAddLikeInNewsFeedAPI(
    BuildContext context,
    String newsId,
    int index,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddLikeInNewsFeed/$newsId/like";

    final apiReq = Request();

    await apiReq.postAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callAddLikeInNewsFeedAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callAddLikeInNewsFeedAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            final newsItem = newsFeedList[index];
            final myUserId = loginResponse.value.data?.user?.id;

            if (newsItem.likes == null) {
              newsItem.likes = [];
            }
            final int likeIndex = newsItem.likes!.indexWhere(
              (like) => like.userId == myUserId,
            );
            final bool isLiked = likeIndex != -1;

            if (isLiked) {
              // Unlike locally
              newsItem.likes!.removeAt(likeIndex);
              newsItem.likesCount = ((newsItem.likesCount ?? 0) - 1).clamp(
                0,
                999999,
              );
              newsItem.likedUsers?.removeWhere((u) => u.id == myUserId);
            } else {
              // Like locally
              newsItem.likes!.add(Like(userId: myUserId));
              newsItem.likesCount = (newsItem.likesCount ?? 0) + 1;
              if (newsItem.likedUsers == null) {
                newsItem.likedUsers = [];
              }
              if (!newsItem.likedUsers!.any((u) => u.id == myUserId)) {
                newsItem.likedUsers!.add(
                  User(
                    id: myUserId,
                    name: loginResponse.value.data?.user?.name,
                    profile: loginResponse.value.data?.user?.profile,
                  ),
                );
              }
            }

            newsFeedList[index] = newsItem;
            newsFeedList.refresh();
            update();

            snackBar(context, baseModel.message ?? "");
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Add Like API
  callAddLikeInCommentAPI(
    BuildContext context,
    String newsId,
    String commentId,
    int index,
    Comment? comment,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlAddLikeInNewsFeedComment/$newsId/comment/$commentId/like";

    final apiReq = Request();

    await apiReq.postAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callAddLikeInNewsFeedAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callAddLikeInNewsFeedAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            final bool currentlyLiked = isLikeList[index];
            isLikeList[index] = !currentlyLiked;

            if (comment != null) {
              if (isLikeList[index]) {
                comment.likes = (comment.likes ?? 0) + 1;
                if (comment.likedUsers == null) {
                  comment.likedUsers = [];
                }
                if (!comment.likedUsers!.any(
                  (u) => u.id == loginResponse.value.data?.user?.id,
                )) {
                  comment.likedUsers!.add(
                    User(
                      id: loginResponse.value.data?.user?.id,
                      name: loginResponse.value.data?.user?.name,
                      profile: loginResponse.value.data?.user?.profile,
                    ),
                  );
                }
              } else {
                comment.likes = ((comment.likes ?? 0) - 1).clamp(0, 999999);
                comment.likedUsers?.removeWhere(
                  (u) => u.id == loginResponse.value.data?.user?.id,
                );
              }
            }

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
        color: color_secondary,
      );
    }).toList();
  }
}
