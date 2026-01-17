// To parse this JSON data, do
//
//     final sendMessageResponse = sendMessageResponseFromJson(jsonString);

import 'dart:convert';

SendMessageResponse sendMessageResponseFromJson(String str) => SendMessageResponse.fromJson(json.decode(str));

String sendMessageResponseToJson(SendMessageResponse data) => json.encode(data.toJson());

class SendMessageResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  SendMessageResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) => SendMessageResponse(
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
  int? groupId;
  int? messageId;

  Data({
    this.groupId,
    this.messageId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    groupId: json["group_id"],
    messageId: json["message_id"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "message_id": messageId,
  };
}
