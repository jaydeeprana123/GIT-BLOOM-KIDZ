import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Networks/api_endpoint.dart';
import 'package:bloom_kidz/Networks/api_response.dart';
import 'package:bloom_kidz/Utils/preference_utils.dart';
import 'package:bloom_kidz/Utils/share_predata.dart';
import 'package:bloom_kidz/Notification/models/notification_response.dart';

class NotificationController extends GetxController {
  RxList<NotificationItem> notificationList = <NotificationItem>[].obs;
  RxInt unreadCount = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool isMoreDataAvailable = true.obs;
  int pageNumber = 1;

  Future<void> callNotificationsAPI(BuildContext context, {bool isToClearList = true}) async {
    if (pageNumber == 1) {
      if (isToClearList) {
        notificationList.clear();
      }
      isLoading.value = true;
    } else {
      isPaginationLoading.value = true;
    }

    try {
      String token = await MySharedPref().getStringValue(
        SharePreData.keyAccessToken,
      );

      String url = "$urlBase$urlNotificationList?page=$pageNumber";
      printData("url", url);

      final apiReq = Request();
      final value = await apiReq.getMethodAPI(url, null, token);
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callNotificationsAPI response ${res.statusCode}",
      );

      final valueData = await res.stream.bytesToString();
      printData(runtimeType.toString(), "callNotificationsAPI value $valueData");

      isLoading.value = false;
      isPaginationLoading.value = false;

      if (res.statusCode == 200) {
        Map<String, dynamic> responseMap = json.decode(valueData);
        NotificationResponse notificationResponse = NotificationResponse.fromJson(responseMap);

        if (notificationResponse.status ?? false) {
          final data = notificationResponse.data;
          unreadCount.value = data?.unreadCount ?? 0;
          final fetchedNotifications = data?.notifications ?? [];
          final pagination = data?.pagination;

          if (pageNumber == 1) {
            notificationList.value = fetchedNotifications;
          } else {
            notificationList.addAll(fetchedNotifications);
          }

          if (pagination != null) {
            isMoreDataAvailable.value = pagination.hasMore ?? (pagination.currentPage! < pagination.lastPage!);
            pageNumber = pagination.currentPage! + 1;
          } else {
            isMoreDataAvailable.value = false;
          }
        } else if (notificationResponse.code == 401) {
          logoutFromTheApp();
        } else {
          snackBarRapid(context, notificationResponse.message ?? "");
        }
      } else if (res.statusCode == 401) {
        logoutFromTheApp();
      } else {
        snackBarRapid(context, "Failed to load notifications");
      }
    } catch (e) {
      isLoading.value = false;
      isPaginationLoading.value = false;
      printData("Error in callNotificationsAPI", e.toString());
      snackBarRapid(context, "An error occurred while fetching notifications");
    }
  }

  void resetPagination() {
    pageNumber = 1;
    isMoreDataAvailable.value = true;
  }

  Future<void> callMarkAsReadAPI(BuildContext context, int id) async {
    // Locally mark as read first for immediate UI responsiveness
    final index = notificationList.indexWhere((item) => item.id == id);
    bool wasUnread = false;
    if (index != -1) {
      if (notificationList[index].readStatus == 'N') {
        notificationList[index].readStatus = 'Y';
        notificationList.refresh();
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
        wasUnread = true;
      }
    }

    try {
      String token = await MySharedPref().getStringValue(
        SharePreData.keyAccessToken,
      );

      String url = "$urlBase$urlNotificationMarkAsRead";
      printData("url", url);

      final apiReq = Request();
      final body = {
        'notification_id': id.toString(),
        'id': id.toString(),
      };

      final value = await apiReq.postAPI(url, body, token);
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callMarkAsReadAPI response ${res.statusCode}",
      );

      if (res.statusCode == 200) {
        final valueData = await res.stream.bytesToString();
        printData(runtimeType.toString(), "callMarkAsReadAPI value $valueData");
        Map<String, dynamic> responseMap = json.decode(valueData);
        if (responseMap["status"] ?? false) {
          // Success
        } else {
          // Revert if API fails
          if (wasUnread && index != -1) {
            notificationList[index].readStatus = 'N';
            notificationList.refresh();
            unreadCount.value++;
          }
          snackBarRapid(context, responseMap["message"] ?? "");
        }
      } else if (res.statusCode == 401) {
        logoutFromTheApp();
      } else {
        // Revert if API fails
        if (wasUnread && index != -1) {
          notificationList[index].readStatus = 'N';
          notificationList.refresh();
          unreadCount.value++;
        }
      }
    } catch (e) {
      printData("Error in callMarkAsReadAPI", e.toString());
    }
  }

  Future<void> callClearAllAPI(BuildContext context) async {
    isLoading.value = true;
    try {
      String token = await MySharedPref().getStringValue(
        SharePreData.keyAccessToken,
      );

      String url = "$urlBase$urlNotificationClearAll";
      printData("url", url);

      final apiReq = Request();
      final value = await apiReq.postAPI(url, null, token);
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callClearAllAPI response ${res.statusCode}",
      );

      isLoading.value = false;

      if (res.statusCode == 200) {
        final valueData = await res.stream.bytesToString();
        printData(runtimeType.toString(), "callClearAllAPI value $valueData");
        Map<String, dynamic> responseMap = json.decode(valueData);
        if (responseMap["status"] ?? false) {
          notificationList.clear();
          unreadCount.value = 0;
          snackBarRapid(context, responseMap["message"] ?? "All notifications cleared");
        } else {
          snackBarRapid(context, responseMap["message"] ?? "");
        }
      } else if (res.statusCode == 401) {
        logoutFromTheApp();
      } else {
        snackBarRapid(context, "Failed to clear notifications");
      }
    } catch (e) {
      isLoading.value = false;
      printData("Error in callClearAllAPI", e.toString());
      snackBarRapid(context, "An error occurred while clearing notifications");
    }
  }
}
