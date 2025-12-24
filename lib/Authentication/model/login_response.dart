// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  LoginResponse({this.status, this.message, this.code, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  User? user;
  String? token;
  TokenDetails? tokenDetails;

  Data({this.user, this.token, this.tokenDetails});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
    tokenDetails: json["token_details"] == null
        ? null
        : TokenDetails.fromJson(json["token_details"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "token_details": tokenDetails?.toJson(),
  };
}

class TokenDetails {
  int? expiryInMinutes;
  int? expireAtTimestamp;
  DateTime? expireAtReadable;

  TokenDetails({
    this.expiryInMinutes,
    this.expireAtTimestamp,
    this.expireAtReadable,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) => TokenDetails(
    expiryInMinutes: json["expiry_in_minutes"],
    expireAtTimestamp: json["expire_at_timestamp"],
    expireAtReadable: json["expire_at_readable"] == null
        ? null
        : DateTime.parse(json["expire_at_readable"]),
  );

  Map<String, dynamic> toJson() => {
    "expiry_in_minutes": expiryInMinutes,
    "expire_at_timestamp": expireAtTimestamp,
    "expire_at_readable": expireAtReadable?.toIso8601String(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? profile;

  User({this.id, this.name, this.email, this.phone, this.profile});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "profile": profile,
  };
}
