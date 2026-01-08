import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/ChildInfo/About/models/about_response.dart';
import 'package:bloom_kidz/ChildInfo/Documents/models/documents_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
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
import '../Bookings/models/bookings_response.dart';
import '../ExtraBookings/models/extra_bookings_request.dart';
import '../ExtraBookings/models/extra_bookings_response.dart';
import '../ExtraBookings/models/price_band_response.dart';
import '../View/ChildActivity/itemline_card.dart';
import '../View/ChildActivity/models/timeline_item.dart';
import '../models/family_contact_list_response.dart';

/// Controller
class ChildInfoController extends GetxController {
  RxList<ChildInfo> childInfoList = <ChildInfo>[].obs;
  RxList<Observation> observationList = <Observation>[].obs;

  RxList<DocumentData> documentList = <DocumentData>[].obs;

  RxList<ChildPermission> childPermissionList = <ChildPermission>[].obs;
  RxList<bool> isLikeList = <bool>[].obs;

  RxList<ActivityData> activityList = <ActivityData>[].obs;
  Rx<LoginResponse> loginResponse = LoginResponse().obs;

  RxList<FamilyContact> familyContactList = <FamilyContact>[].obs;
  Rx<FamilyContact> selectedFamilyContact = FamilyContact().obs;

  RxList<Booking> bookingList = <Booking>[].obs;
  RxList<PriceBandDay> priceBandList = <PriceBandDay>[].obs;
  RxList<TextEditingController> replyController = <TextEditingController>[].obs;

  RxInt selectedDayIndex = 0.obs;
  RxInt selectedSlotIndex = (-1).obs;
  RxList<ExtraBooking> extraBookingList = <ExtraBooking>[].obs;

  RxBool isLoading = false.obs;

  RxInt selectedDateIndex = 0.obs;

  /// Editing controller for text field
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> relationController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  RxString imagePath = "".obs;
  RxList<String> observationImagePath = <String>[].obs;
  RxDouble totalAmount = 0.0.obs;

  /// session selections → DayName : [sessionIds]
  RxMap<String, List<int>> selectedSessions = <String, List<int>>{}.obs;
  RxMap<String, List<int>> selectedExtraCharges = <String, List<int>>{}.obs;


  Rx<DateTime?> planStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> planEndDate = Rx<DateTime?>(null);

  Rx<AboutData> aboutChildren = AboutData().obs;


  RxInt selectedTab = 0.obs; // 0 = Basic, 1 = Health, 2 = Sensitive

  void setPlanStart(DateTime date) {
    planStartDate.value = date;
  }

  void setPlanEnd(DateTime date) {
    planEndDate.value = date;
  }

  void toggleSession(String day, int sessionId) {
    selectedSessions.putIfAbsent(day, () => []);

    if (selectedSessions[day]!.contains(sessionId)) {
      selectedSessions[day]!.remove(sessionId);
      if (selectedSessions[day]!.isEmpty) {
        selectedSessions.remove(day);
      }
    } else {
      selectedSessions[day]!.add(sessionId);
    }
    calculateTotal();
    selectedSessions.refresh();
  }


  void toggleExtraCharge(String day, int chargeId) {
    selectedExtraCharges.putIfAbsent(day, () => []);

    if (selectedExtraCharges[day]!.contains(chargeId)) {
      selectedExtraCharges[day]!.remove(chargeId);
      if (selectedExtraCharges[day]!.isEmpty) {
        selectedExtraCharges.remove(day);
      }
    } else {
      selectedExtraCharges[day]!.add(chargeId);
    }

    calculateTotal();

    selectedExtraCharges.refresh();
  }


  void calculateTotal() {
    double total = 0;

    for (var day in priceBandList) {
      final dayName = day.day ?? "";

      /// sessions price (if any)
      for (var session in day.sessions ?? []) {
        if (selectedSessions[dayName]?.contains(session.id) ?? false) {
          total += double.tryParse(session.price ?? "0") ?? 0;
        }
      }

      /// extra charges
      for (var charge in day.extraCharges ?? []) {
        if (selectedExtraCharges[dayName]?.contains(charge.id) ?? false) {
          total += double.tryParse(charge.price ?? "0") ?? 0;
        }
      }
    }

    totalAmount.value = total;
  }

  ExtraBookingsRequest buildRequest() {
    return ExtraBookingsRequest(
      planStart: planStartDate.value,
      planEnd: planEndDate.value,
      sessions: selectedSessions,
      extraCharges: selectedExtraCharges,
      totalAmount: totalAmount.value,
    );
  }

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
            snackBar(context, childInfoListResponse.message ?? "");
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
  callUpdateFamilyAPI(BuildContext context, String id) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlUpdateFamily/$id";

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
      printData(
        runtimeType.toString(),
        "callUpdateFamilyAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callUpdateFamilyAPI API value ${valueData}",
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
            snackBar(context, activityResponse.message ?? "");
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
            snackBar(context, familyContactListResponse.message ?? "");
          }
        }
      });
    });
  }

  /// Leave Request API
  Future<void> callDeleteContactAPI(BuildContext context, String id) async {
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
      var request = http.Request('DELETE', Uri.parse(url));

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

  /// get Documents API
  callGetDocumentsAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetDocumentList/$childId";

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
          DocumentsResponse documentsResponse = DocumentsResponse.fromJson(
            userModel,
          );

          if (documentsResponse.status ?? false) {
            documentList.value = documentsResponse.data?.document ?? [];
          } else {
            snackBar(context, documentsResponse.message ?? "");
          }
        }
      });
    });
  }

  /// get Child Permissions API
  callGetChildPermissionsAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetChildPermissionsList/$childId";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetChildPermissionsAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetChildPermissionsAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          PermissionsResponse permissionsResponse =
              PermissionsResponse.fromJson(userModel);

          if (permissionsResponse.status ?? false) {
            childPermissionList.value =
                permissionsResponse.data?.permissions ?? [];
          } else {
            snackBar(context, permissionsResponse.message ?? "");
          }
        }
      });
    });
  }

  /// Confirm Permission API
  callConfirmPermissionAPI(
    BuildContext context,
    String childId,
    String id,
    bool approve,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlConfirmChildPermission";

    final apiReq = Request();

    dynamic body = {
      "permission_id": id,
      "status": approve ? "1" : "0",
      "child_id": childId,
    };

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value).then((
      value,
    ) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callUpdateFamilyAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callUpdateFamilyAPI API value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");
            callGetChildPermissionsAPI(context, childId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
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

  /// get Bookings API
  callGetBookingsAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetBookingList/$childId/bookings";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetChildPermissionsAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetChildPermissionsAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BookingsResponse bookingsResponse = BookingsResponse.fromJson(
            userModel,
          );

          if (bookingsResponse.status ?? false) {
            bookingList.value = bookingsResponse.data?.bookings ?? [];
          } else {
            snackBar(context, bookingsResponse.message ?? "");
          }
        }
      });
    });
  }

  /// get Extra Bookings API
  callGetExtraBookingsAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetExtraBookingList/$childId";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetChildPermissionsAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetChildPermissionsAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          ExtraBookingsResponse extraBookingsResponse =
              ExtraBookingsResponse.fromJson(userModel);

          if (extraBookingsResponse.status ?? false) {
            extraBookingList.value =
                extraBookingsResponse.data?.extraBookings ?? [];
          } else {
            snackBar(context, extraBookingsResponse.message ?? "");
          }
        }
      });
    });
  }


  /// get About API
  callGetAboutChildAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetAbout/$childId";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetAboutChildAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetAboutChildAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          AboutResponse aboutResponse =
          AboutResponse.fromJson(userModel);

          if (aboutResponse.status ?? false) {
            aboutChildren.value =
                aboutResponse.data??AboutData();
          } else {
            snackBar(context, aboutResponse.message ?? "");
          }
        }
      });
    });
  }

  /// get Price Band API
  callGetPriceBandAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetPriceBandList/$childId/get-price-band/data";

    final apiReq = Request();

    String planStart = getDateFormtYYYYMMDDOnly(
      planStartDate.value ?? DateTime(2026),
    );

    String planEnd = getDateFormtYYYYMMDDOnly(
      planEndDate.value ?? DateTime(2026),
    );



    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({
      "plan_start": planStart,
      "plan_end": planEnd,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {

      await response.stream.bytesToString().then((valueData) async {
        Map<String, dynamic> userModel = json.decode(valueData);
        PriceBandResponse priceBandResponse = PriceBandResponse.fromJson(
          userModel,
        );

        if (priceBandResponse.status ?? false) {
          priceBandList.value = priceBandResponse.data?.days ?? [];
        } else {
          snackBar(context, priceBandResponse.message ?? "");
        }
      });}

    else {
      print(response.reasonPhrase);
    }

  }

  /// Observation list API
  callObservationListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetObservationList/$childId";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callObservationListAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callObservationListAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          ObservationListResponse observationListResponse =
              ObservationListResponse.fromJson(userModel);

          if (observationListResponse.status ?? false) {
            observationList.value =
                observationListResponse.data?.observations ?? [];

            for (int i = 0; i < observationList.length; i++) {
              replyController.add(TextEditingController());
            }
          } else {
            snackBar(context, observationListResponse.message ?? "");
          }
        }
      });
    });
  }

  /// Add Comment API
  callAddCommentAPI(
    BuildContext context,
    String childId,
    String observationId,
    String comment,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlAddCommentInObservation/$childId/$observationId/comment";

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
    String childId,
    String observationId,
    String commentId,
    int index,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlLikeUnlikeObservation/$childId/$observationId/comment/$commentId/like";

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


  /// Add Extra bookings API
  callAddExtraBookingsAPI(BuildContext context, ExtraBookingsRequest extraBookingsJson, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getAccessToken(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddExtraBooking/$childId";

    final apiReq = Request();
    Map<String, dynamic> body = extraBookingsJson.toJson();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('POST', Uri.parse(url));

    request.headers.addAll(headers);
    request.body = json.encode(extraBookingsJson.toJson());
    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {

      await response.stream.bytesToString().then((valueData) async {

        printData("callAddExtraBookingsAPI", valueData);

        Map<String, dynamic> userModel = json.decode(valueData);
        BaseModel baseModel = BaseModel.fromJson(
          userModel,
        );

        if (baseModel.status ?? false) {
          snackBar(context, baseModel.message ?? "");
          Navigator.pop(context);
        } else {
          snackBar(context, baseModel.message ?? "");
        }
      });}

    else {
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
