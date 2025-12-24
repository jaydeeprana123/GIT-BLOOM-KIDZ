// import 'dart:convert';
//
// import 'package:api_cache_manager/api_cache_manager.dart';
// import 'package:get/get.dart';
// import 'package:groceryboouser/Model/BaseModel.dart';
// import 'package:groceryboouser/Screens/Authentication/SignIn/model/SigninModel.dart';
// import 'package:groceryboouser/Screens/Networks/api_endpoint.dart';
// import 'package:groceryboouser/Screens/Networks/api_response.dart';
// import 'package:groceryboouser/Utils/common_widget.dart';
// import 'package:groceryboouser/Utils/preference_utils.dart';
// import 'package:groceryboouser/Utils/share_predata.dart';
// import 'package:groceryboouser/Welcome.dart';
// import 'package:http/http.dart' as http;
//
// class SessionOut {
//   SigninModel? myModel;
//
//   var preferences = MySharedPref();
//
//   userLogout() async {
//     printData(SharePreData.key_Checker, "Called session out ");
//     printData(SharePreData.key_Checker, "myModel.data.token.toString()");
//
//     String url = urlBase + urlLogout;
//      myModel = await preferences.getSignInModel(SharePreData.key_SaveSignInModel);
//
//
//     dynamic body = {
//       'user_id': myModel!.data!.id.toString(),
//       'device_token': myModel!.data!.currentToken.toString(),
//     };
//
//     final apiReq = Request();
//     await apiReq.postAPIwithoutBearer(url, body).then((value) async {
//       http.StreamedResponse res = value;
//
//       if (res.statusCode == 200) {
//         res.stream.bytesToString().then((value) async {
//           String strData = value;
//           Map<String, dynamic> userModel = json.decode(strData);
//           BaseModel model = BaseModel.fromJson(userModel);
//
//           printData("logout message", model.message.toString());
//
//           // if (model.statusCode == 500) {
//           //   final tokenUpdate = LogoutUser();
//           //   await tokenUpdate.updateToken();
//           //
//           //   userLogout();
//           // } else
//             if (model.statusCode == 200) {
//             logoutRequest();
//           } else {
//             printData("logout user ", model.statusCode.toString());
//
//           }
//         });
//       } else {
//         printData("",res.reasonPhrase);
//         // Navigator.pop(context); //pop
//       }
//     });
//   }
//
//   Future<void> logoutRequest() async {
//     bool boolRememberedUser = false;
//     boolRememberedUser =
//     await preferences.getBoolValue(SharePreData.key_remembered_user_info);
//     String pswd =
//     await preferences.getStringValue(SharePreData.key_remember_password);
//
//     await preferences.clear();
//
//     // It clears cache memory
//     APICacheManager().emptyCache();
//
//     if (boolRememberedUser
//         .toString()
//         .isNotEmpty &&
//         boolRememberedUser == true) {
//       myModel!.data!.password = pswd;
//       await preferences.setRememberModel(
//           myModel!, SharePreData.key_UserInfoModel);
//       await preferences.setBool(SharePreData.key_remembered_user_info, true);
//     }
//
//
//     Get.offAll(Welcome());
//
//   }
//
// }
