// To parse this JSON data, do
//
//     final quickPinResponse = quickPinResponseFromJson(jsonString);

import 'dart:convert';

QuickPinResponse quickPinResponseFromJson(String str) =>
    QuickPinResponse.fromJson(json.decode(str));

String quickPinResponseToJson(QuickPinResponse data) =>
    json.encode(data.toJson());

class QuickPinResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  QuickPinResponse({this.status, this.message, this.code, this.data});

  factory QuickPinResponse.fromJson(Map<String, dynamic> json) =>
      QuickPinResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  String? pinCode;
  bool? isPinSet;

  Data({this.pinCode, this.isPinSet});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(pinCode: json["pin_code"], isPinSet: json["is_pin_set"]);

  Map<String, dynamic> toJson() => {
    "pin_code": pinCode,
    "is_pin_set": isPinSet,
  };
}
