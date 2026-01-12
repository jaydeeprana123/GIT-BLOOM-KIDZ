// To parse this JSON data, do
//
//     final activityResponseForSelect = activityResponseForSelectFromJson(jsonString);

import 'dart:convert';

ActivityResponseForSelect activityResponseForSelectFromJson(String str) =>
    ActivityResponseForSelect.fromJson(json.decode(str));

String activityResponseForSelectToJson(ActivityResponseForSelect data) =>
    json.encode(data.toJson());

class ActivityResponseForSelect {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ActivityResponseForSelect({this.status, this.message, this.code, this.data});

  factory ActivityResponseForSelect.fromJson(Map<String, dynamic> json) =>
      ActivityResponseForSelect(
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
  List<ActivityForSelect>? activities;

  Data({this.activities});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    activities: json["activities"] == null
        ? []
        : List<ActivityForSelect>.from(
            json["activities"]!.map((x) => ActivityForSelect.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "activities": activities == null
        ? []
        : List<dynamic>.from(activities!.map((x) => x.toJson())),
  };
}

class ActivityForSelect {
  int? id;
  String? name;
  String? color;
  String? icon;
  String? status;
  int? nurseryId;
  String? isDefault;
  int? createdId;
  DateTime? createdAt;
  int? updatedId;
  DateTime? updatedAt;
  int? deletedBy;
  DateTime? deletedAt;
  String? deletedStatus;
  String? isSigninValidate;

  ActivityForSelect({
    this.id,
    this.name,
    this.color,
    this.icon,
    this.status,
    this.nurseryId,
    this.isDefault,
    this.createdId,
    this.createdAt,
    this.updatedId,
    this.updatedAt,
    this.deletedBy,
    this.deletedAt,
    this.deletedStatus,
    this.isSigninValidate,
  });

  factory ActivityForSelect.fromJson(Map<String, dynamic> json) =>
      ActivityForSelect(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        icon: json["icon"],
        status: json["status"],
        nurseryId: json["nursery_id"],
        isDefault: json["is_default"],
        createdId: json["created_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedId: json["updated_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedBy: json["deleted_by"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        deletedStatus: json["deleted_status"],
        isSigninValidate: json["is_signin_validate"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color,
    "icon": icon,
    "status": status,
    "nursery_id": nurseryId,
    "is_default": isDefault,
    "created_id": createdId,
    "created_at": createdAt?.toIso8601String(),
    "updated_id": updatedId,
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_by": deletedBy,
    "deleted_at": deletedAt?.toIso8601String(),
    "deleted_status": deletedStatus,
    "is_signin_validate": isSigninValidate,
  };
}
