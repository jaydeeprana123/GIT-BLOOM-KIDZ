// To parse this JSON data, do
//
//     final familyContactListResponse = familyContactListResponseFromJson(jsonString);

import 'dart:convert';

FamilyContactListResponse familyContactListResponseFromJson(String str) => FamilyContactListResponse.fromJson(json.decode(str));

String familyContactListResponseToJson(FamilyContactListResponse data) => json.encode(data.toJson());

class FamilyContactListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  FamilyContactListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory FamilyContactListResponse.fromJson(Map<String, dynamic> json) => FamilyContactListResponse(
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
  List<FamilyContact>? contacts;
  Pagination? pagination;

  Data({
    this.contacts,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contacts: json["contacts"] == null ? [] : List<FamilyContact>.from(json["contacts"]!.map((x) => FamilyContact.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "contacts": contacts == null ? [] : List<dynamic>.from(contacts!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class FamilyContact {
  int? id;
  String? firstName;
  String? lastName;
  String? relation;
  String? email;
  String? mobile;
  String? imageUrl;
  dynamic createdAt;

  FamilyContact({
    this.id,
    this.firstName,
    this.lastName,
    this.relation,
    this.email,
    this.mobile,
    this.imageUrl,
    this.createdAt,
  });

  factory FamilyContact.fromJson(Map<String, dynamic> json) => FamilyContact(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    relation: json["relation"],
    email: json["email"],
    mobile: json["mobile"],
    imageUrl: json["image_url"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "relation": relation,
    "email": email,
    "mobile": mobile,
    "image_url": imageUrl,
    "created_at": createdAt,
  };
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}
