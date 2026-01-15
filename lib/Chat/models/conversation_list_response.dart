// To parse this JSON data, do
//
//     final conversationListResponse = conversationListResponseFromJson(jsonString);

import 'dart:convert';

ConversationListResponse conversationListResponseFromJson(String str) => ConversationListResponse.fromJson(json.decode(str));

String conversationListResponseToJson(ConversationListResponse data) => json.encode(data.toJson());

class ConversationListResponse {
  bool? status;
  String? message;
  int? code;
  List<ConversationData>? data;

  ConversationListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) => ConversationListResponse(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<ConversationData>.from(json["data"]!.map((x) => ConversationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ConversationData {
  int? groupId;
  String? groupName;
  String? isGroup;
  List<Member>? members;
  String? lastMessage;
  DateTime? lastTime;
  int? unreadCount;

  ConversationData({
    this.groupId,
    this.groupName,
    this.isGroup,
    this.members,
    this.lastMessage,
    this.lastTime,
    this.unreadCount,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) => ConversationData(
    groupId: json["group_id"],
    groupName: json["group_name"],
    isGroup: json["is_group"],
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
    lastMessage: json["last_message"],
    lastTime: json["last_time"] == null ? null : DateTime.parse(json["last_time"]),
    unreadCount: json["unread_count"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "group_name": groupName,
    "is_group": isGroup,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
    "last_message": lastMessage,
    "last_time": lastTime?.toIso8601String(),
    "unread_count": unreadCount,
  };
}

class Member {
  int? id;
  String? name;
  String? profile;

  Member({
    this.id,
    this.name,
    this.profile,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"],
    name: json["name"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile": profile,
  };
}
