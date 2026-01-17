// To parse this JSON data, do
//
//     final groupChatResponse = groupChatResponseFromJson(jsonString);

import 'dart:convert';

import 'conversation_list_response.dart';

GroupChatResponse groupChatResponseFromJson(String str) => GroupChatResponse.fromJson(json.decode(str));

String groupChatResponseToJson(GroupChatResponse data) => json.encode(data.toJson());

class GroupChatResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  GroupChatResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory GroupChatResponse.fromJson(Map<String, dynamic> json) => GroupChatResponse(
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
  Group? group;
  List<Member>? members;
  List<Message>? messages;

  Data({
    this.group,
    this.members,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    group: json["group"] == null ? null : Group.fromJson(json["group"]),
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": group?.toJson(),
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Group {
  int? id;
  String? name;
  String? isGroup;

  Group({
    this.id,
    this.name,
    this.isGroup,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
    isGroup: json["is_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_group": isGroup,
  };
}


class Message {
  int? id;
  int? senderId;
  String? senderName;
  String? message;
  List<Attachment>? attachments;
  DateTime? createdAt;

  Message({
    this.id,
    this.senderId,
    this.senderName,
    this.message,
    this.attachments,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    senderId: json["sender_id"],
    senderName: json["sender_name"],
    message: json["message"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "sender_name": senderName,
    "message": message,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
  };
}


class Attachment {
  String? url;
  String? type;

  Attachment({
    this.url,
    this.type,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    url: json["url"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "type": type,
  };
}
