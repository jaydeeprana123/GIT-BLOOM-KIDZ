// To parse this JSON data, do
//
//     final extraBookingsResponse = extraBookingsResponseFromJson(jsonString);

import 'dart:convert';

ExtraBookingsResponse extraBookingsResponseFromJson(String str) =>
    ExtraBookingsResponse.fromJson(json.decode(str));

String extraBookingsResponseToJson(ExtraBookingsResponse data) =>
    json.encode(data.toJson());

class ExtraBookingsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ExtraBookingsResponse({this.status, this.message, this.code, this.data});

  factory ExtraBookingsResponse.fromJson(Map<String, dynamic> json) =>
      ExtraBookingsResponse(
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

  Data({this.extraBookings});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    extraBookings: json["extra_bookings"] == null
        ? []
        : List<ExtraBooking>.from(
            json["extra_bookings"]!.map((x) => ExtraBooking.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "extra_bookings": extraBookings == null
        ? []
        : List<dynamic>.from(extraBookings!.map((x) => x.toJson())),
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
  int? priceBand;
  List<Day>? days;
  int? approvedBy;
  DateTime? approvedAt;
  String? approvedUser;
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
    this.approvedBy,
    this.approvedAt,
    this.approvedUser,
  });

  factory ExtraBooking.fromJson(Map<String, dynamic> json) => ExtraBooking(
    id: json["id"],
    childId: json["child_id"],
    planStart: json["plan_start"] == null
        ? null
        : DateTime.parse(json["plan_start"]),
    planEnd: json["plan_end"] == null ? null : DateTime.parse(json["plan_end"]),
    subtotal: json["subtotal"],
    totalAmount: json["total_amount"],
    status: json["status"],
    priceBand: json["price_band"],
    days: json["days"] == null
        ? []
        : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
    approvedUser: json["approved_user"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "child_id": childId,
    "plan_start":
        "${planStart!.year.toString().padLeft(4, '0')}-${planStart!.month.toString().padLeft(2, '0')}-${planStart!.day.toString().padLeft(2, '0')}",
    "plan_end":
        "${planEnd!.year.toString().padLeft(4, '0')}-${planEnd!.month.toString().padLeft(2, '0')}-${planEnd!.day.toString().padLeft(2, '0')}",
    "subtotal": subtotal,
    "total_amount": totalAmount,
    "status": status,
    "price_band": priceBand,
    "days": days == null
        ? []
        : List<dynamic>.from(days!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "approved_by": approvedBy,
    "approved_at": approvedAt?.toIso8601String(),
    "approved_user": approvedUser,
  };
}

class Day {
  String? day;
  List<Session>? sessions;
  List<ExtraCharge>? extraCharges;

  Day({this.day, this.sessions, this.extraCharges});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    sessions: json["sessions"] == null
        ? []
        : List<Session>.from(json["sessions"]!.map((x) => Session.fromJson(x))),
    extraCharges: json["extra_charges"] == null
        ? []
        : List<ExtraCharge>.from(
            json["extra_charges"]!.map((x) => ExtraCharge.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "sessions": sessions == null
        ? []
        : List<dynamic>.from(sessions!.map((x) => x.toJson())),
    "extra_charges": extraCharges == null
        ? []
        : List<dynamic>.from(extraCharges!.map((x) => x.toJson())),
  };
}

class ExtraCharge {
  int? id;
  String? name;
  String? price;
  bool? selected;

  ExtraCharge({this.id, this.name, this.price, this.selected});

  factory ExtraCharge.fromJson(Map<String, dynamic> json) => ExtraCharge(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "selected": selected,
  };
}

class Session {
  int? id;
  String? bandName;
  String? startTime;
  String? endTime;
  String? price;
  bool? selected;

  Session({
    this.id,
    this.bandName,
    this.startTime,
    this.endTime,
    this.price,
    this.selected,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json["id"],
    bandName: json["band_name"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    price: json["price"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "band_name": bandName,
    "start_time": startTime,
    "end_time": endTime,
    "price": price,
    "selected": selected,
  };
}
