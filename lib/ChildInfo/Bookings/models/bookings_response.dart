// To parse this JSON data, do
//
//     final bookingsResponse = bookingsResponseFromJson(jsonString);

import 'dart:convert';

BookingsResponse bookingsResponseFromJson(String str) => BookingsResponse.fromJson(json.decode(str));

String bookingsResponseToJson(BookingsResponse data) => json.encode(data.toJson());

class BookingsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  BookingsResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) => BookingsResponse(
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
  List<Booking>? bookings;

  Data({
    this.bookings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  int? id;
  int? childId;
  String? planStart;
  String? status;
  String? statusLabel;
  List<Day>? days;

  Booking({
    this.id,
    this.childId,
    this.planStart,
    this.status,
    this.statusLabel,
    this.days,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    childId: json["child_id"],
    planStart: json["plan_start"],
    status: json["status"],
    statusLabel: json["status_label"],
    days: json["days"] == null ? [] : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "child_id": childId,
    "plan_start": planStart,
    "status": status,
    "status_label": statusLabel,
    "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toJson())),
  };
}

class Day {
  String? day;
  List<MainSession>? mainSessions;
  List<dynamic>? extraSessions;

  Day({
    this.day,
    this.mainSessions,
    this.extraSessions,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    mainSessions: json["main_sessions"] == null ? [] : List<MainSession>.from(json["main_sessions"]!.map((x) => MainSession.fromJson(x))),
    extraSessions: json["extra_sessions"] == null ? [] : List<dynamic>.from(json["extra_sessions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "main_sessions": mainSessions == null ? [] : List<dynamic>.from(mainSessions!.map((x) => x.toJson())),
    "extra_sessions": extraSessions == null ? [] : List<dynamic>.from(extraSessions!.map((x) => x)),
  };
}

class MainSession {
  String? startTime;
  String? endTime;
  int? widthPercent;
  String? label;

  MainSession({
    this.startTime,
    this.endTime,
    this.widthPercent,
    this.label,
  });

  factory MainSession.fromJson(Map<String, dynamic> json) => MainSession(
    startTime: json["start_time"],
    endTime: json["end_time"],
    widthPercent: json["width_percent"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
    "width_percent": widthPercent,
    "label": label,
  };
}
