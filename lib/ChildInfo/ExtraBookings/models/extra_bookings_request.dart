// To parse this JSON data, do
//
//     final extraBookingsRequest = extraBookingsRequestFromJson(jsonString);

import 'dart:convert';

ExtraBookingsRequest extraBookingsRequestFromJson(String str) =>
    ExtraBookingsRequest.fromJson(json.decode(str));

String extraBookingsRequestToJson(ExtraBookingsRequest data) =>
    json.encode(data.toJson());

class ExtraBookingsRequest {
  DateTime? planStart;
  DateTime? planEnd;
  Map<String, List<int>>? sessions;
  Map<String, List<int>>? extraCharges;
  double? totalAmount;

  ExtraBookingsRequest({
    this.planStart,
    this.planEnd,
    this.sessions,
    this.extraCharges,
    this.totalAmount,
  });

  factory ExtraBookingsRequest.fromJson(Map<String, dynamic> json) {
    return ExtraBookingsRequest(
      planStart: json["plan_start"] == null
          ? null
          : DateTime.parse(json["plan_start"]),
      planEnd: json["plan_end"] == null
          ? null
          : DateTime.parse(json["plan_end"]),
      sessions: json["sessions"] == null
          ? {}
          : Map<String, List<int>>.from(
        json["sessions"].map(
              (k, v) => MapEntry(k, List<int>.from(v)),
        ),
      ),
      extraCharges: json["extra_charges"] == null
          ? {}
          : Map<String, List<int>>.from(
        json["extra_charges"].map(
              (k, v) => MapEntry(k, List<int>.from(v)),
        ),
      ),
      totalAmount: json["total_amount"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "plan_start":
    "${planStart!.year.toString().padLeft(4, '0')}-${planStart!.month.toString().padLeft(2, '0')}-${planStart!.day.toString().padLeft(2, '0')}",
    "plan_end":
    "${planEnd!.year.toString().padLeft(4, '0')}-${planEnd!.month.toString().padLeft(2, '0')}-${planEnd!.day.toString().padLeft(2, '0')}",
    "sessions": sessions ?? {},
    "extra_charges": extraCharges ?? {},
    "total_amount": totalAmount,
  };
}

