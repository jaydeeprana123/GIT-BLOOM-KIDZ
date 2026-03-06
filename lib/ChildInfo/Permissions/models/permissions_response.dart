// To parse this JSON data, do
//
//     final permissionsResponse = permissionsResponseFromJson(jsonString);

import 'dart:convert';

PermissionsResponse permissionsResponseFromJson(String str) =>
    PermissionsResponse.fromJson(json.decode(str));

String permissionsResponseToJson(PermissionsResponse data) =>
    json.encode(data.toJson());

class PermissionsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  PermissionsResponse({this.status, this.message, this.code, this.data});

  factory PermissionsResponse.fromJson(Map<String, dynamic> json) =>
      PermissionsResponse(
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

  Data({this.permissions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    permissions: json["permissions"] == null
        ? []
        : List<ChildPermission>.from(
            json["permissions"]!.map((x) => ChildPermission.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "permissions": permissions == null
        ? []
        : List<dynamic>.from(permissions!.map((x) => x.toJson())),
  };
}

class ChildPermission {
  int? permissionId;
  String? name;
  String? description;
  String? selectedStatus;
  String? selectedLabel;

  ChildPermission({
    this.permissionId,
    this.name,
    this.description,
    this.selectedStatus,
    this.selectedLabel,
  });

  factory ChildPermission.fromJson(Map<String, dynamic> json) =>
      ChildPermission(
        permissionId: json["permission_id"],
        name: json["name"],
        description: json["description"],
        selectedStatus: json["selected_status"],
        selectedLabel: json["selected_label"],
      );

  Map<String, dynamic> toJson() => {
    "permission_id": permissionId,
    "name": name,
    "description": description,
    "selected_status": selectedStatus,
    "selected_label": selectedLabel,
  };
}
