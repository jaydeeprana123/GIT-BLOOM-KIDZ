// To parse this JSON data, do
//
//     final sendMessageNotGroupRequest = sendMessageNotGroupRequestFromJson(jsonString);

import 'dart:convert';

SendMessageNotGroupRequest sendMessageNotGroupRequestFromJson(String str) => SendMessageNotGroupRequest.fromJson(json.decode(str));

String sendMessageNotGroupRequestToJson(SendMessageNotGroupRequest data) => json.encode(data.toJson());

class SendMessageNotGroupRequest {
  List<Receiver>? receivers;
  String? message;

  SendMessageNotGroupRequest({
    this.receivers,
    this.message,
  });

  factory SendMessageNotGroupRequest.fromJson(Map<String, dynamic> json) => SendMessageNotGroupRequest(
    receivers: json["receivers"] == null ? [] : List<Receiver>.from(json["receivers"]!.map((x) => Receiver.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "receivers": receivers == null ? [] : List<dynamic>.from(receivers!.map((x) => x.toJson())),
    "message": message,
  };
}

class Receiver {
  int? id;
  String? name;

  Receiver({
    this.id,
    this.name,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
