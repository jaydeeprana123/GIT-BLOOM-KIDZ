// To parse this JSON data, do
//
//     final createGroupMemberRequest = createGroupMemberRequestFromJson(jsonString);

import 'dart:convert';

CreateGroupMemberRequest createGroupMemberRequestFromJson(String str) => CreateGroupMemberRequest.fromJson(json.decode(str));

String createGroupMemberRequestToJson(CreateGroupMemberRequest data) => json.encode(data.toJson());

class CreateGroupMemberRequest {
  int? groupId;
  List<Member>? members;

  CreateGroupMemberRequest({
    this.groupId,
    this.members,
  });

  factory CreateGroupMemberRequest.fromJson(Map<String, dynamic> json) => CreateGroupMemberRequest(
    groupId: json["group_id"],
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
  };
}

class Member {
  int? id;
  String? type;

  Member({
    this.id,
    this.type,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
  };
}
