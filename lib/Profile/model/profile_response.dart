// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ProfileResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
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
  ProfileUser? user;

  Data({
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : ProfileUser.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class ProfileUser {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? status;
  String? imageUrl;

  ProfileUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.imageUrl,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    status: json["status"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "status": status,
    "image_url": imageUrl,
  };
}
