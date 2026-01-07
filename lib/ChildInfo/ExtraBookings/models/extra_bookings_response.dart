// To parse this JSON data, do
//
//     final extraBookingsResponse = extraBookingsResponseFromJson(jsonString);

import 'dart:convert';

ExtraBookingsResponse extraBookingsResponseFromJson(String str) => ExtraBookingsResponse.fromJson(json.decode(str));

String extraBookingsResponseToJson(ExtraBookingsResponse data) => json.encode(data.toJson());

class ExtraBookingsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ExtraBookingsResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory ExtraBookingsResponse.fromJson(Map<String, dynamic> json) => ExtraBookingsResponse(
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
  List<ExtraBooking>? extraBookings;

  Data({
    this.extraBookings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    extraBookings: json["extra_bookings"] == null ? [] : List<ExtraBooking>.from(json["extra_bookings"]!.map((x) => ExtraBooking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "extra_bookings": extraBookings == null ? [] : List<dynamic>.from(extraBookings!.map((x) => x.toJson())),
  };
}

class ExtraBooking {
  int? id;
  int? childId;
  DateTime? planStart;
  DateTime? planEnd;
  String? subtotal;
  String? totalAmount;
  String? status;
  dynamic priceBand;
  List<Day>? days;
  DateTime? createdAt;

  ExtraBooking({
    this.id,
    this.childId,
    this.planStart,
    this.planEnd,
    this.subtotal,
    this.totalAmount,
    this.status,
    this.priceBand,
    this.days,
    this.createdAt,
  });

  factory ExtraBooking.fromJson(Map<String, dynamic> json) => ExtraBooking(
    id: json["id"],
    childId: json["child_id"],
    planStart: json["plan_start"] == null ? null : DateTime.parse(json["plan_start"]),
    planEnd: json["plan_end"] == null ? null : DateTime.parse(json["plan_end"]),
    subtotal: json["subtotal"],
    totalAmount: json["total_amount"],
    status: json["status"],
    priceBand: json["price_band"],
    days: json["days"] == null ? [] : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "child_id": childId,
    "plan_start": "${planStart!.year.toString().padLeft(4, '0')}-${planStart!.month.toString().padLeft(2, '0')}-${planStart!.day.toString().padLeft(2, '0')}",
    "plan_end": "${planEnd!.year.toString().padLeft(4, '0')}-${planEnd!.month.toString().padLeft(2, '0')}-${planEnd!.day.toString().padLeft(2, '0')}",
    "subtotal": subtotal,
    "total_amount": totalAmount,
    "status": status,
    "price_band": priceBand,
    "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Day {
  String? day;
  String? startTime;
  String? endTime;
  String? duration;

  Day({
    this.day,
    this.startTime,
    this.endTime,
    this.duration,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "start_time": startTime,
    "end_time": endTime,
    "duration": duration,
  };
}
