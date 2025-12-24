import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../CommonWidgets/common_widget.dart';

class Request {
  final String? url;
  final dynamic body;

  Request({this.url, this.body});

  // Future<http.StreamedResponse> postAPIwithoutBearer(url, body) async {
  //   Map<String, String> headersWithBearer = {
  //     'Content-Type': 'application/json',
  //   };
  //
  //   printData("url", url);
  //   printData("Body", body.toString());
  //   printData("Header", headersWithBearer.toString());
  //
  //   if (body != null) {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.fields.addAll(body);
  //     request.headers.addAll(headersWithBearer);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 403) {
  //       showBlockedDialog();
  //     }
  //
  //     return response;
  //   } else {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.headers.addAll(headersWithBearer);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 403) {
  //       showBlockedDialog();
  //     }
  //
  //     return response;
  //   }
  // }

  Future<http.StreamedResponse> postAPIwithoutBearer(url, body) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      printData("url", url);
      printData("Body", body.toString());
      printData("Header", headers.toString());

      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (body != null) {
        request.fields.addAll(body);
      }

      request.headers.addAll(headers);

      /// 15 sec timeout just like other API
      http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 403) {
        showBlockedDialog();
      } else if (response.statusCode != 200) {
        // showSomethingWentWrongDialog(
        //   message: "Error ${response.statusCode}",
        // );
      }

      return response;
    }
    // -----------------------------
    // Timeout Exception
    // -----------------------------
    on TimeoutException {
      showSomethingWentWrongDialog(message: "Connection timed out.");

      return http.StreamedResponse(
        const Stream.empty(),
        0,
        reasonPhrase: "Timeout",
      );
    }
    // -----------------------------
    // No Internet / Socket Error
    // -----------------------------
    on SocketException {
      showSomethingWentWrongDialog(message: "No Internet connection.");

      return http.StreamedResponse(
        const Stream.empty(),
        0,
        reasonPhrase: "No Internet",
      );
    }
    // -----------------------------
    // Any Other Error
    // -----------------------------
    catch (e) {
      showSomethingWentWrongDialog(message: "Something went wrong.");

      return http.StreamedResponse(
        const Stream.empty(),
        0,
        reasonPhrase: "Unknown Error",
      );
    }
  }

  Future<http.StreamedResponse> postWithOutTokenAPI(url, body) async {
    printData("url", url);
    printData("Body", body.toString());

    if (body != null) {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll(body);

      http.StreamedResponse response = await request.send();

      return response;
    } else {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 403) {
        showBlockedDialog();
      }

      return response;
    }
  }

  Future<http.StreamedResponse> postMedicartAPI(url, body, token) async {
    Map<String, String> headersWithBearer = Map();

    if (body != null) {
      if (token != null) {
        headersWithBearer = {
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + token,
        };
      }

      log("url :: " + url.toString());
      log("Header :: " + headersWithBearer.toString());
      log("body :: " + body.toString());

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    } else {
      if (token != null) {
        headersWithBearer = {
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + token,
        };
      }

      var request = http.Request('GET', Uri.parse(url));

      //  var request = http.MultipartRequest('GET', Uri.parse(url));

      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    }
  }

  Future<http.StreamedResponse> postMethodMedicartAPI(url, body, token) async {
    Map<String, String> headersWithBearer = Map();

    if (token != null) {
      headersWithBearer = {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + token,
      };
    }

    printData("url", url);
    // printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());

    if (body != null) {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    } else {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    }
  }

  // Future<http.StreamedResponse> postAPI(url, body, token) async {
  //   Map<String, String> headersWithBearer;
  //
  //   headersWithBearer = {
  //     'Content-Type': 'application/json',
  //     // ignore: prefer_interpolation_to_compose_strings
  //     'Authorization': 'Bearer ' + token,
  //   };
  //
  //   printData("url", url);
  //   printData("Body", body.toString());
  //   printData("Header", headersWithBearer.toString());
  //
  //   if (body != null) {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.fields.addAll(body);
  //     request.headers.addAll(headersWithBearer);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 403) {
  //       showBlockedDialog();
  //     } else if (response.statusCode == 401) {
  //       logoutFromTheApp();
  //     } else if (response.statusCode != 200) {
  //       showSomethingWentWrongDialog();
  //     }
  //
  //     // await response.stream.bytesToString().then((response) async {
  //     //   printData("Mayank test", "0");
  //     //   Map<String, dynamic> userModel = json.decode(response.toString());
  //     //   BaseModel model = BaseModel.fromJson(userModel);
  //     //
  //     //   if (model.statusCode == 403) {
  //     //     logoutFromTheApp();
  //     //   }
  //     //   printData("Mayank result", "0");
  //     //
  //     // });
  //
  //     return response;
  //   } else {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.headers.addAll(headersWithBearer);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 403) {
  //       showBlockedDialog();
  //     }
  //
  //     // await response.stream.bytesToString().then((response) async {
  //     //   printData("Mayank test", response);
  //     //
  //     //   String abc = response;
  //     //   Map<String, dynamic> userModel = json.decode(abc);
  //     //   BaseModel model = BaseModel.fromJson(userModel);
  //     //
  //     //   if (model.statusCode == 403) {
  //     //     logoutFromTheApp();
  //     //   }
  //     //   printData("Mayank result", "1");
  //     //
  //     // });
  //
  //     return response;
  //   }
  // }

  Future<http.StreamedResponse> postAPI(url, body, token) async {
    try {
      Map<String, String> headersWithBearer = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      printData("url", url);
      printData("Body", body.toString());
      printData("Header", headersWithBearer.toString());

      var request = http.MultipartRequest('POST', Uri.parse(url));
      if (body != null) request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);

      http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 403) {
        showBlockedDialog();
      } else if (response.statusCode == 401) {
        logoutFromTheApp();
      } else if (response.statusCode != 200) {
        // showSomethingWentWrongDialog(message: "Error ${response.statusCode}");
      }

      return response;
    } on TimeoutException {
      showSomethingWentWrongDialog(message: "Connection timed out.");

      // return dummy response
      return http.StreamedResponse(
        const Stream.empty(),
        0, // custom status code for timeout
        reasonPhrase: "Timeout",
      );
    } on SocketException {
      showSomethingWentWrongDialog(message: "No Internet connection.");

      return http.StreamedResponse(
        const Stream.empty(),
        0, // custom status code for no network
        reasonPhrase: "No Internet",
      );
    } catch (e) {
      showSomethingWentWrongDialog(message: "Something went wrong.");

      return http.StreamedResponse(
        const Stream.empty(),
        0, // generic error
        reasonPhrase: "Error",
      );
    }
  }

  Future<http.StreamedResponse> postAPIWithoutTimeException(
    url,
    body,
    token,
  ) async {
    try {
      Map<String, String> headersWithBearer = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      printData("url", url);
      printData("Body", body.toString());
      printData("Header", headersWithBearer.toString());

      var request = http.MultipartRequest('POST', Uri.parse(url));
      if (body != null) request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);

      http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 403) {
        showBlockedDialog();
      } else if (response.statusCode == 401) {
        logoutFromTheApp();
      } else if (response.statusCode != 200) {
        // showSomethingWentWrongDialog(message: "Error ${response.statusCode}");
      }

      return response;
    } on SocketException {
      showSomethingWentWrongDialog(message: "No Internet connection.");

      return http.StreamedResponse(
        const Stream.empty(),
        0, // custom status code for no network
        reasonPhrase: "No Internet",
      );
    } catch (e) {
      showSomethingWentWrongDialog(message: "Something went wrong.");

      return http.StreamedResponse(
        const Stream.empty(),
        0, // generic error
        reasonPhrase: "Error",
      );
    }
  }

  Future<http.StreamedResponse> postAPIForABHAUserVerify(
    url,
    Map<String, dynamic> body,
    tToken,
    token,
  ) async {
    Map<String, String> headersWithBearer;

    printData("tToken", tToken);
    printData("tokennnn", token);
    headersWithBearer = {
      'T-TOKEN': 'Bearer ' + tToken,
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());

    if (body != null) {
      var request = http.Request('POST', Uri.parse(url));
      request.body = jsonEncode(body);
      request.headers.addAll(headersWithBearer);

      http.StreamedResponse response = await request.send();

      // await response.stream.bytesToString().then((response) async {
      //   printData("Mayank test", "0");
      //   Map<String, dynamic> userModel = json.decode(response.toString());
      //   BaseModel model = BaseModel.fromJson(userModel);
      //
      //   if (model.statusCode == 403) {
      //     logoutFromTheApp();
      //   }
      //   printData("Mayank result", "0");
      //
      // });

      return response;
    } else {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      // await response.stream.bytesToString().then((response) async {
      //   printData("Mayank test", response);
      //
      //   String abc = response;
      //   Map<String, dynamic> userModel = json.decode(abc);
      //   BaseModel model = BaseModel.fromJson(userModel);
      //
      //   if (model.statusCode == 403) {
      //     logoutFromTheApp();
      //   }
      //   printData("Mayank result", "1");
      //
      // });

      return response;
    }
  }

  Future<http.StreamedResponse> postAPIForABHAProfile(
    String url,
    Map<String, dynamic>? body,
    String xtoken,
    String token,
  ) async {
    try {
      Map<String, String> headers = {
        'X-TOKEN': 'Bearer $xtoken',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      printData("URL", url);
      printData("Body", body.toString());
      printData("Headers", headers.toString());

      http.StreamedResponse response;

      // -------------------------------
      // JSON BODY → http.Request
      // -------------------------------
      if (body != null) {
        var request = http.Request('POST', Uri.parse(url));
        request.headers.addAll(headers);
        request.body = jsonEncode(body);

        response = await request.send().timeout(const Duration(seconds: 15));
      }
      // -------------------------------
      // MULTIPART BODY → http.MultipartRequest
      // -------------------------------
      else {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);

        response = await request.send().timeout(const Duration(seconds: 15));
      }

      // Handle status codes
      if (response.statusCode == 403)
        showBlockedDialog();
      else if (response.statusCode == 401)
        logoutFromTheApp();
      else if (response.statusCode != 200) {
        // showSomethingWentWrongDialog(
        //   message: "Error ${response.statusCode}",
        // );
      }

      return response;
    }
    // -------------------------------
    // TIMEOUT
    // -------------------------------
    on TimeoutException {
      showSomethingWentWrongDialog(message: "Connection timed out.");
      return _errorResponse(408, "Connection timed out");
    }
    // -------------------------------
    // NO INTERNET
    // -------------------------------
    on SocketException {
      showSomethingWentWrongDialog(message: "No Internet connection.");
      return _errorResponse(503, "No Internet");
    }
    // -------------------------------
    // OTHER UNKNOWN ERRORS
    // -------------------------------
    catch (e) {
      showSomethingWentWrongDialog(message: "Something went wrong.");
      return _errorResponse(500, "Unknown error: $e");
    }
  }

  http.StreamedResponse _errorResponse(int code, String message) {
    final stream = Stream.value(utf8.encode(jsonEncode({"error": message})));
    return http.StreamedResponse(stream, code);
  }

  // Future<http.StreamedResponse> postAPIForABHAProfile(
  //     url, Map<String, dynamic> body, xtoken, token) async {
  //   Map<String, String> headersWithBearer;
  //
  //   printData("xtoken", xtoken);
  //   printData("tokennnn", token);
  //   headersWithBearer = {
  //     'X-TOKEN': 'Bearer ' + xtoken,
  //     'Authorization': 'Bearer ' + token,
  //     'Content-Type': 'application/json',
  //   };
  //
  //   printData("url", url);
  //   printData("Body", body.toString());
  //   printData("Header", headersWithBearer.toString());
  //
  //   if (body != null) {
  //     var request = http.Request('POST', Uri.parse(url));
  //     request.body = jsonEncode(body);
  //     request.headers.addAll(headersWithBearer);
  //
  //     http.StreamedResponse response = await request.send();
  //
  //     // await response.stream.bytesToString().then((response) async {
  //     //   printData("Mayank test", "0");
  //     //   Map<String, dynamic> userModel = json.decode(response.toString());
  //     //   BaseModel model = BaseModel.fromJson(userModel);
  //     //
  //     //   if (model.statusCode == 403) {
  //     //     logoutFromTheApp();
  //     //   }
  //     //   printData("Mayank result", "0");
  //     //
  //     // });
  //
  //     return response;
  //   } else {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.headers.addAll(headersWithBearer);
  //     http.StreamedResponse response = await request.send();
  //
  //     // await response.stream.bytesToString().then((response) async {
  //     //   printData("Mayank test", response);
  //     //
  //     //   String abc = response;
  //     //   Map<String, dynamic> userModel = json.decode(abc);
  //     //   BaseModel model = BaseModel.fromJson(userModel);
  //     //
  //     //   if (model.statusCode == 403) {
  //     //     logoutFromTheApp();
  //     //   }
  //     //   printData("Mayank result", "1");
  //     //
  //     // });
  //
  //     return response;
  //   }
  // }

  Future<http.StreamedResponse> getMethodAPI(url, body, token) async {
    Map<String, String> headersWithBearer;

    headersWithBearer = {
      'Content-Type': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + token,
    };

    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());

    if (body != null) {
      var request = http.MultipartRequest('GET', Uri.parse(url));

      request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    } else {
      printData("body ", "is nullll");

      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headersWithBearer);
      return await request.send();

      //
      // var request = http.MultipartRequest('GET', Uri.parse(url));
      //
      // request.headers.addAll(headersWithBearer);
      // http.StreamedResponse response = await request.send();
      //
      // return response;
    }
  }

  Future<http.StreamedResponse> getMethodAPIWithoutToken(url, body) async {
    Map<String, String> headersWithBearer;

    headersWithBearer = {'Content-Type': 'application/json'};

    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());

    if (body != null) {
      var request = http.MultipartRequest('GET', Uri.parse(url));

      request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    } else {
      var request = http.MultipartRequest('GET', Uri.parse(url));

      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    }
  }

  Future<http.StreamedResponse> getMethodAPIForABHAProfile(
    url,
    body,
    abdmToken,
    token,
    isFromAbhaAddress,
  ) async {
    Map<String, String> headersWithBearer;

    headersWithBearer = {
      'X-TOKEN': 'Bearer ' + abdmToken,
      'Authorization': 'Bearer ' + token,
      "is-abha-address": isFromAbhaAddress.toString(),
    };

    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());

    if (body != null) {
      var request = http.MultipartRequest('GET', Uri.parse(url));

      request.fields.addAll(body);
      request.headers.addAll(headersWithBearer);
      http.StreamedResponse response = await request.send();

      return response;
    } else {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headersWithBearer);
      return await request.send();

      // var request = http.MultipartRequest('GET', Uri.parse(url));
      //
      // request.headers.addAll(headersWithBearer);
      // http.StreamedResponse response = await request.send();
      //
      // return response;
    }
  }

  // // logout from the app
  // logoutFromTheApp() async {
  //   printData("Session out", '403');
  //   var preferences = MySharedPref();
  //   await preferences.clearData(SharePreData.keySaveLoginModel);
  //   await preferences.clearData(SharePreData.keyToken);
  //   Get.offAll(const LoginViaMobileNumView());
  //
  // }

  Future<http.StreamedResponse> postAPIWithMedia(
    url,
    body,
    token,
    String strImg,
    Uint8List? strImgBytes,
  ) async {
    Map<String, String> headersWithBearer = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    };
    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());
    printData("strImg", strImg);

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields.addAll(body);

    if (kIsWeb && strImgBytes != null) {
      printData("is web", "And UILISt");

      // 📌 For Web → use bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          strImgBytes,
          filename: 'upload.jpg',
        ),
      );
    } else if (!kIsWeb && strImg != null && strImg.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', strImg));
    }

    request.headers.addAll(headersWithBearer);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 403) {
      showBlockedDialog();
    }

    return response;
  }

  Future<http.StreamedResponse> postAPIWithMediaWithoutBearer(
    url,
    body,
    strImg,
  ) async {
    Map<String, String> headersWithBearer = {
      'Content-Type': 'multipart/form-data',
    };

    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());
    printData("strImg", strImg);

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (strImg != null && strImg.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', strImg));
    }

    request.fields.addAll(body);

    request.headers.addAll(headersWithBearer);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> postAPIWithMediaWithoutToken(
    url,
    body,
    strImg,
  ) async {
    Map<String, String> headersWithBearer = {
      'Content-Type': 'application/json',
      // 'Authorization': token,
    };
    printData("url", url);
    printData("Body", body.toString());
    printData("Header", headersWithBearer.toString());
    printData("strImg", strImg);

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (strImg != null && strImg != "") {
      request.files.add(await http.MultipartFile.fromPath('image', strImg));
    }

    request.fields.addAll(body);

    request.headers.addAll(headersWithBearer);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.Response> postWithoutBearer(url, token) {
    Map<String, String> headersWithBearer = {
      'Content-Type': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + token,
    };

    printData("", url);
    printData("", body);
    printData("", headersWithBearer.toString());
    return http
        .post(Uri.parse(url), headers: headersWithBearer, body: body)
        .timeout(const Duration(minutes: 5));
  }

  Future<http.Response> postWithBearer(url, body, token) {
    Map<String, String> headersWithBearer = {
      'Authorization': 'Bearer ' + token,
    };

    printData("", url);
    printData("", body);
    printData("", headersWithBearer.toString());
    return http
        .post(Uri.parse(url), headers: headersWithBearer, body: body)
        .timeout(const Duration(minutes: 5));
  }

  Future<http.Response> postWithoutToken(url) {
    Map<String, String> headersWithBearer = {
      'Content-Type': 'application/json',
    };

    printData("", url);
    printData("", body);
    printData("", headersWithBearer.toString());
    return http
        .post(Uri.parse(url), headers: headersWithBearer)
        .timeout(const Duration(minutes: 5));
  }
}
