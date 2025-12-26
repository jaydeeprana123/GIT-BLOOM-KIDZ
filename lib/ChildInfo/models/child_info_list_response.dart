// To parse this JSON data, do
//
//     final childInfoListResponse = childInfoListResponseFromJson(jsonString);

import 'dart:convert';

ChildInfoListResponse childInfoListResponseFromJson(String str) =>
    ChildInfoListResponse.fromJson(json.decode(str));

String childInfoListResponseToJson(ChildInfoListResponse data) =>
    json.encode(data.toJson());

class ChildInfoListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ChildInfoListResponse({this.status, this.message, this.code, this.data});

  factory ChildInfoListResponse.fromJson(Map<String, dynamic> json) =>
      ChildInfoListResponse(
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
  List<ChildInfo>? children;

  Data({this.children});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    children: json["children"] == null
        ? []
        : List<ChildInfo>.from(
            json["children"]!.map((x) => ChildInfo.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}

class ChildInfo {
  int? id;
  String? firstName;
  String? lastName;
  String? room;
  String? profile;
  String? status;

  ChildInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.room,
    this.profile,
    this.status,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) => ChildInfo(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    room: json["room"],
    profile: json["profile"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "room": room,
    "profile": profile,
    "status": status,
  };
}
