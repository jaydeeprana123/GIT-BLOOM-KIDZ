import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/ChildInfo/About/models/about_response.dart';
import 'package:bloom_kidz/ChildInfo/Documents/models/documents_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/ChildInfo/models/child_activity_response.dart';
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
import '../../Activity/model/activity_response_for_select.dart';
import '../../Networks/api_response.dart';
import '../Bookings/models/bookings_response.dart';
import '../ExtraBookings/models/extra_bookings_request.dart';
import '../ExtraBookings/models/extra_bookings_response.dart';
import '../ExtraBookings/models/price_band_response.dart';
import '../SafeGuarding/models/accident_list_response.dart';
import '../SafeGuarding/models/medication_list_response.dart';
import '../View/ChildActivity/itemline_card.dart';
import '../View/ChildActivity/models/timeline_item.dart';
import '../models/family_contact_list_response.dart';

/// Controller
class ChildInfoController extends GetxController {
  RxList<ChildInfo> childInfoList = <ChildInfo>[].obs;
  RxList<Observation> observationList = <Observation>[].obs;
  RxList<int> removedMediaIds = <int>[].obs;
  Rx<Observation> selectedObservation = Observation().obs;
  Rx<ExtraBooking> selectedExtraBooking = ExtraBooking().obs;

  RxInt medicineRefreshIndex = (-1).obs;

  RxList<DocumentData> documentList = <DocumentData>[].obs;

  RxList<ChildPermission> childPermissionList = <ChildPermission>[].obs;
  RxList<bool> isLikeList = <bool>[].obs;

  RxList<ActivityData> activityList = <ActivityData>[].obs;
  RxList<ActivityForSelect> activityListForSelect = <ActivityForSelect>[].obs;

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

  Rx<TextEditingController> noteController = TextEditingController().obs;

  Rx<TextEditingController> collectionPinController =
      TextEditingController().obs;

  Rx<TextEditingController> observationController = TextEditingController().obs;

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

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Rx<AboutData> aboutChildren = AboutData().obs;

  RxInt selectedTab = 0.obs; // 0 = Basic, 1 = Health, 2 = Sensitive

  RxList<Medication> medicationList = <Medication>[].obs;
  RxList<Accident> accidentList = <Accident>[].obs;

  Rx<ActivityForSelect?> selectedActivity = Rx<ActivityForSelect?>(null);

  /// Load from API response
  void setActivities(ActivityResponseForSelect response) {
    activityListForSelect.value = response.data?.activities ?? [];
  }

  int? get selectedActivityId => selectedActivity.value?.id;

  void setPlanStart(DateTime date) {
    planStartDate.value = date;
  }

  void setPlanEnd(DateTime date) {
    planEndDate.value = date;
  }

  void setStart(DateTime date) {
    startDate.value = date;
  }

  void setEnd(DateTime date) {
    endDate.value = date;
  }

  void toggleSession(String day, int sessionId) {
    // If already selected → remove
    if (selectedSessions[day]?.contains(sessionId) ?? false) {
      selectedSessions.remove(day);
    } else {
      // Replace any previous selection
      selectedSessions[day] = [sessionId];
    }

    calculateTotal();
    selectedSessions.refresh();
  }

  void toggleExtraCharge(String day, int chargeId) {
    // If already selected → remove
    if (selectedExtraCharges[day]?.contains(chargeId) ?? false) {
      selectedExtraCharges.remove(day);
    } else {
      // Replace any previous selection
      selectedExtraCharges[day] = [chargeId];
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

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
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

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value, []).then((
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

    String token = await MySharedPref().getStringValue(
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

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value, []).then((
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
  callChildActivityListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlChildActivityList/$childId";

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

  /// ActivityList API
  callActivityListForSelectAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlActivityList";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callActivityListAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callActivityListAPI value ${valueData}",
        );

        isLoading.value = false;

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          ActivityResponseForSelect activityResponseForSelect =
              ActivityResponseForSelect.fromJson(userModel);

          if (activityResponseForSelect.status ?? false) {
            activityListForSelect.value =
                activityResponseForSelect.data?.activities ?? [];

            /// RESET SELECTION AFTER LOAD
            selectedDateIndex.value = 0;
          } else {
            snackBar(context, activityResponseForSelect.message ?? "");
          }
        }
      });
    });
  }

  /// Get Family Contacts API
  callGetFamilyContactsAPI(BuildContext context) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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
      String token = await MySharedPref().getStringValue(
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

  /// Delete Extra Bookings API
  Future<void> callDeleteExtraBookingsAPI(
    BuildContext context,
    String chidlId,
    String bookingId,
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
      String url = "$urlBase$urlDeleteExtraBooking/$chidlId/delete/$bookingId";

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
          callGetExtraBookingsAPI(context, chidlId);
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

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlConfirmChildPermission";

    final apiReq = Request();

    dynamic body = {
      "permission_id": id,
      "status": approve ? "1" : "0",
      "child_id": childId,
    };

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value, []).then((
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

  /// get Bookings API
  callGetBookingsAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlGetExtraBookingList/$childId";

    final apiReq = Request();

    await apiReq.getMethodAPI(url, null, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callGetExtraBookingsAPI response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callGetExtraBookingsAPI value ${valueData}",
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

    String token = await MySharedPref().getStringValue(
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
          AboutResponse aboutResponse = AboutResponse.fromJson(userModel);

          if (aboutResponse.status ?? false) {
            aboutChildren.value = aboutResponse.data ?? AboutData();
          } else {
            snackBar(context, aboutResponse.message ?? "");
          }
        }
      });
    });
  }

  /// get Price Band API
  callGetPriceBandAPI(
    BuildContext context,
    String childId,
    bool isUpdate,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({"plan_start": planStart, "plan_end": planEnd});
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

          if (isUpdate) {
            for (
              int j = 0;
              j < (selectedExtraBooking.value.days ?? []).length;
              j++
            ) {
              for (int i = 0; i < priceBandList.length; i++) {
                if (selectedExtraBooking.value.days?[j].day ==
                    priceBandList[i].day) {
                  for (
                    int z = 0;
                    z <
                        (selectedExtraBooking.value.days?[j].sessions ?? [])
                            .length;
                    z++
                  ) {
                    for (
                      int x = 0;
                      x < (priceBandList[i].sessions ?? []).length;
                      x++
                    ) {
                      if (selectedExtraBooking.value.days?[j].sessions?[z].id ==
                          priceBandList[i].sessions?[x].id) {
                        priceBandList[i].sessions?[x].selected =
                            selectedExtraBooking
                                .value
                                .days?[j]
                                .sessions?[z]
                                .selected;

                        toggleSession(
                          selectedExtraBooking.value.days?[j].day ?? "",
                          selectedExtraBooking.value.days?[j].sessions?[z].id ??
                              0,
                        );
                      }
                    }
                  }

                  for (
                    int z = 0;
                    z <
                        (selectedExtraBooking.value.days?[j].extraCharges ?? [])
                            .length;
                    z++
                  ) {
                    for (
                      int x = 0;
                      x < (priceBandList[i].extraCharges ?? []).length;
                      x++
                    ) {
                      if (selectedExtraBooking
                              .value
                              .days?[j]
                              .extraCharges?[z]
                              .id ==
                          priceBandList[i].extraCharges?[x].id) {
                        priceBandList[i].extraCharges?[x].selected =
                            selectedExtraBooking
                                .value
                                .days?[j]
                                .extraCharges?[z]
                                .selected;

                        toggleExtraCharge(
                          selectedExtraBooking.value.days?[j].day ?? "",
                          selectedExtraBooking
                                  .value
                                  .days?[j]
                                  .extraCharges?[z]
                                  .id ??
                              0,
                        );
                      }
                    }
                  }
                }
              }
            }
          }
        } else {
          snackBar(context, priceBandResponse.message ?? "");
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  /// Observation list API
  callObservationListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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

    String token = await MySharedPref().getStringValue(
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

            callObservationListAPI(context, childId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Add Like API
  callObservationAddLikeAPI(
    BuildContext context,
    String childId,
    String observationId,
    int index,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url =
        "$urlBase$urlLikeUnlikeObservation/$childId/$observationId/like";

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
            // observationList[index].isLike = true;

            callObservationListAPI(context, childId);
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
  callAddLikeCommentAPI(
    BuildContext context,
    String childId,
    String observationId,
    String commentId,
    int index,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
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
  callAddExtraBookingsAPI(
    BuildContext context,
    ExtraBookingsRequest extraBookingsJson,
    String childId,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddExtraBooking/$childId";

    final apiReq = Request();
    Map<String, dynamic> body = extraBookingsJson.toJson();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
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

  /// Update Extra bookings API
  callUpdateExtraBookingsAPI(
    BuildContext context,
    ExtraBookingsRequest extraBookingsJson,
    String childId,
    String bookingId,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddExtraBooking/$childId/update/$bookingId";

    final apiReq = Request();
    Map<String, dynamic> body = extraBookingsJson.toJson();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
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
  }

  /// Add Observation API
  callAddObservationAPI(BuildContext context, String childInfo) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddObservation/$childInfo";

    final apiReq = Request();

    dynamic body = {'observation': observationController.value.text};

    await apiReq
        .postAPIWithMedia(url, body, token, "", observationImagePath)
        .then((value) async {
          http.StreamedResponse res = value;
          printData(
            runtimeType.toString(),
            "callUpdateObservationAPI API response ${res.statusCode}",
          );

          await res.stream.bytesToString().then((valueData) async {
            printData(
              runtimeType.toString(),
              "callAddObservationAPI API value ${valueData}",
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

  /// Update Observation API
  callUpdateObservationAPI(
    BuildContext context,
    String childInfo,
    String observationId,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlAddObservation/$childInfo/$observationId";

    final apiReq = Request();

    dynamic body = {'observation': observationController.value.text};

    await apiReq
        .postAPIWithMedia(url, body, token, "", observationImagePath)
        .then((value) async {
          http.StreamedResponse res = value;
          printData(
            runtimeType.toString(),
            "callUpdateObservationAPI API response ${res.statusCode}",
          );

          await res.stream.bytesToString().then((valueData) async {
            printData(
              runtimeType.toString(),
              "callUpdateObservationAPI API value ${valueData}",
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

  /// Add Leave API
  callAddLeaveAPI(
    BuildContext context,
    String childId,
    String activityId,
  ) async {
    isLoading.value = true;

    var startDateStr = getDateFormtYYYYMMDDOnly(
      startDate.value ?? DateTime(2026),
    );
    var endDateStr = getDateFormtYYYYMMDDOnly(endDate.value ?? DateTime(2026));

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    printData("toekn", token);

    String url = urlBase + urlLeaveRequest;

    final apiReq = Request();

    dynamic body = {
      "child_id": childId,
      "activity_id": activityId,
      "start_date": startDateStr,
      "end_date": endDateStr,
      "note": noteController.value.text,
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('POST', Uri.parse(url));

    request.headers.addAll(headers);
    request.body = jsonEncode(body);
    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {
      await response.stream.bytesToString().then((valueData) async {
        printData("callAddLeaveAPI", valueData);

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

    // await apiReq.postAPI(url, body, token).then((value) async {
    //   http.StreamedResponse res = value;
    //   printData(runtimeType.toString(), "Login API response ${res.statusCode}");
    //
    //   await res.stream.bytesToString().then((valueData) async {
    //     printData(runtimeType.toString(), "Login API value ${valueData}");
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

  /// Set Pin API
  Future<void> callCollectionSetPinAPI(
    BuildContext context,
    String childId,
  ) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlSetCollectionPin + "/" + childId;

    final apiReq = Request();

    dynamic body = {
      'set_collection_password': collectionPinController.value.text,
    };

    await apiReq.postAPI(url, body, token).then((value) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callCollectionSetPinAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callCollectionSetPinAPI API value ${valueData}",
        );

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

  /// Medication list API
  callMedicationListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = "$urlBase$urlMedicationList/$childId";

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
          MedicationListResponse medicationListResponse =
              MedicationListResponse.fromJson(userModel);

          if (medicationListResponse.status ?? false) {
            medicationList.value =
                medicationListResponse.data?.medications ?? [];

            /// RESET SELECTION AFTER LOAD
            selectedDateIndex.value = 0;
          } else {
            snackBar(context, medicationListResponse.message ?? "");
          }
        }
      });
    });
  }

  /// Accident list API
  callAccidentListAPI(BuildContext context, String childId) async {
    isLoading.value = true;

    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    printData("token", token);
    String url = "$urlBase$urlAccidentList/$childId";

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
          AccidentListResponse accidentListResponse =
              AccidentListResponse.fromJson(userModel);

          if (accidentListResponse.status ?? false) {
            accidentList.value = accidentListResponse.data?.accidents ?? [];

            /// RESET SELECTION AFTER LOAD
            selectedDateIndex.value = 0;
          } else {
            snackBar(context, accidentListResponse.message ?? "");
          }
        }
      });
    });
  }

  /// Add Family API
  callAddMedicationAcknowledgeAPI(
    BuildContext context,
    int medicationId,
    String childId,
  ) async {
    medicineRefreshIndex.value = medicationList.indexWhere(
      (e) => e.id == medicationId,
    );
    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddAcknowledgeMedication;

    final apiReq = Request();

    dynamic body = {'medication_id': medicationId.toString()};

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value, []).then((
      value,
    ) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callAddAcknowledgeAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callAddAcknowledgeAPI API value ${valueData}",
        );

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");
            acknowledgeMedication(medicationId, context, childId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  /// Add Family API
  callAddAccidentAcknowledgeAPI(
    BuildContext context,
    int accidentId,
    String childId,
  ) async {
    medicineRefreshIndex.value = accidentList.indexWhere(
      (e) => e.id == accidentId,
    );
    String token = await MySharedPref().getStringValue(
      SharePreData.keyAccessToken,
    );

    String url = urlBase + urlAddAcknowledgeAccident;

    final apiReq = Request();

    dynamic body = {'accident_id': accidentId.toString()};

    await apiReq.postAPIWithMedia(url, body, token, imagePath.value, []).then((
      value,
    ) async {
      http.StreamedResponse res = value;
      printData(
        runtimeType.toString(),
        "callAddAccidentAcknowledgeAPI API response ${res.statusCode}",
      );

      await res.stream.bytesToString().then((valueData) async {
        printData(
          runtimeType.toString(),
          "callAddAccidentAcknowledgeAPI API value ${valueData}",
        );

        if (res.statusCode == 200) {
          Map<String, dynamic> userModel = json.decode(valueData);
          BaseModel baseModel = BaseModel.fromJson(userModel);

          if (baseModel.status ?? false) {
            snackBar(context, baseModel.message ?? "");
            acknowledgeAccident(accidentId, context, childId);
          } else {
            snackBar(context, baseModel.message ?? "");
          }
        }
      });
    });
  }

  void acknowledgeMedication(
    int medicationId,
    BuildContext context,
    String childId,
  ) {
    // call acknowledge API here
    // after success:
    final index = medicationList.indexWhere((e) => e.id == medicationId);
    if (index != -1) {
      medicationList[index].parentAck?.status = true;
      medicationList.refresh();
    }

    medicineRefreshIndex.value = -1;
    callMedicationListAPI(context, childId);
  }

  void acknowledgeAccident(
    int accidentId,
    BuildContext context,
    String childId,
  ) {
    // call acknowledge API here
    // after success:
    final index = accidentList.indexWhere((e) => e.id == accidentId);
    if (index != -1) {
      accidentList[index].acknowledgement?.status = true;
      accidentList.refresh();
    }

    medicineRefreshIndex.value = -1;
    callMedicationListAPI(context, childId);
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
