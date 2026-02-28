// To parse this JSON data, do
//
//     final yearListResponse = yearListResponseFromJson(jsonString);

import 'dart:convert';

YearListResponse yearListResponseFromJson(String str) => YearListResponse.fromJson(json.decode(str));

String yearListResponseToJson(YearListResponse data) => json.encode(data.toJson());

class YearListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  YearListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory YearListResponse.fromJson(Map<String, dynamic> json) => YearListResponse(
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
  List<Year>? years;
  Pagination? pagination;

  Data({
    this.years,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    years: json["years"] == null ? [] : List<Year>.from(json["years"]!.map((x) => Year.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "years": years == null ? [] : List<dynamic>.from(years!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
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

class Year {
  int? id;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  String? flag;
  String? status;
  int? nurseryId;

  Year({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.flag,
    this.status,
    this.nurseryId,
  });

  factory Year.fromJson(Map<String, dynamic> json) => Year(
    id: json["id"],
    name: json["name"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    flag: json["flag"],
    status: json["status"],
    nurseryId: json["nursery_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "flag": flag,
    "status": status,
    "nursery_id": nurseryId,
  };
}
