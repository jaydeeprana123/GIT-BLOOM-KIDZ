// To parse this JSON data, do
//
//     final peopleListResponse = peopleListResponseFromJson(jsonString);

import 'dart:convert';

PeopleListResponse peopleListResponseFromJson(String str) => PeopleListResponse.fromJson(json.decode(str));

String peopleListResponseToJson(PeopleListResponse data) => json.encode(data.toJson());

class PeopleListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  PeopleListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory PeopleListResponse.fromJson(Map<String, dynamic> json) => PeopleListResponse(
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
  List<ChatPerson>? people;
  dynamic defaultUser;

  Data({
    this.people,
    this.defaultUser,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    people: json["people"] == null ? [] : List<ChatPerson>.from(json["people"]!.map((x) => ChatPerson.fromJson(x))),
    defaultUser: json["default_user"],
  );

  Map<String, dynamic> toJson() => {
    "people": people == null ? [] : List<dynamic>.from(people!.map((x) => x.toJson())),
    "default_user": defaultUser,
  };
}

class ChatPerson {
  int? id;
  String? name;
  String? userType;
  String? profileImage;
  String? onlineStatus;
  int? unreadCount;
  bool? isDefault;

  ChatPerson({
    this.id,
    this.name,
    this.userType,
    this.profileImage,
    this.onlineStatus,
    this.unreadCount,
    this.isDefault,
  });

  factory ChatPerson.fromJson(Map<String, dynamic> json) => ChatPerson(
    id: json["id"],
    name: json["name"],
    userType: json["user_type"],
    profileImage: json["profile_image"],
    onlineStatus: json["online_status"],
    unreadCount: json["unread_count"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_type": userType,
    "profile_image": profileImage,
    "online_status": onlineStatus,
    "unread_count": unreadCount,
    "is_default": isDefault,
  };
}



