// To parse this JSON data, do
//
//     final permissionsResponse = permissionsResponseFromJson(jsonString);

import 'dart:convert';

PermissionsResponse permissionsResponseFromJson(String str) => PermissionsResponse.fromJson(json.decode(str));

String permissionsResponseToJson(PermissionsResponse data) => json.encode(data.toJson());

class PermissionsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  PermissionsResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory PermissionsResponse.fromJson(Map<String, dynamic> json) => PermissionsResponse(
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
  List<ChildPermission>? permissions;

  Data({
    this.permissions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    permissions: json["permissions"] == null ? [] : List<ChildPermission>.from(json["permissions"]!.map((x) => ChildPermission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
  };
}

class ChildPermission {
  int? id;
  String? name;
  String? description;
  int? nurseryId;
  int? createdId;
  DateTime? createdAt;
  int? updatedId;
  DateTime? updatedAt;
  dynamic deletedId;
  dynamic deletedAt;
  DeletedStatus? deletedStatus;
  List<Detail>? details;

  ChildPermission({
    this.id,
    this.name,
    this.description,
    this.nurseryId,
    this.createdId,
    this.createdAt,
    this.updatedId,
    this.updatedAt,
    this.deletedId,
    this.deletedAt,
    this.deletedStatus,
    this.details,
  });

  factory ChildPermission.fromJson(Map<String, dynamic> json) => ChildPermission(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    nurseryId: json["nursery_id"],
    createdId: json["created_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedId: json["updated_id"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedId: json["deleted_id"],
    deletedAt: json["deleted_at"],
    deletedStatus: deletedStatusValues.map[json["deleted_status"]]!,
    details: json["details"] == null ? [] : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "nursery_id": nurseryId,
    "created_id": createdId,
    "created_at": createdAt?.toIso8601String(),
    "updated_id": updatedId,
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_id": deletedId,
    "deleted_at": deletedAt,
    "deleted_status": deletedStatusValues.reverse[deletedStatus],
    "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x.toJson())),
  };
}

enum DeletedStatus {
  N
}

final deletedStatusValues = EnumValues({
  "N": DeletedStatus.N
});

class Detail {
  int? id;
  int? masterId;
  int? childId;
  String? status;
  int? nurseryId;
  int? createdId;
  DateTime? createdAt;
  int? updatedId;
  DateTime? updatedAt;

  Detail({
    this.id,
    this.masterId,
    this.childId,
    this.status,
    this.nurseryId,
    this.createdId,
    this.createdAt,
    this.updatedId,
    this.updatedAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    masterId: json["master_id"],
    childId: json["child_id"],
    status: json["status"],
    nurseryId: json["nursery_id"],
    createdId: json["created_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedId: json["updated_id"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "master_id": masterId,
    "child_id": childId,
    "status": status,
    "nursery_id": nurseryId,
    "created_id": createdId,
    "created_at": createdAt?.toIso8601String(),
    "updated_id": updatedId,
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
