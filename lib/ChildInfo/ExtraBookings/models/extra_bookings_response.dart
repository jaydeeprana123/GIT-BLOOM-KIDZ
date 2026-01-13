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
  int? priceBandId;
  List<ExtraBookings>? extraBookingList;

  Data({this.priceBandId, this.extraBookingList});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    priceBandId: json["price_band_id"],
    extraBookingList: json["days"] == null
        ? []
        : List<ExtraBookings>.from(
            json["days"]!.map((x) => ExtraBookings.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "price_band_id": priceBandId,
    "days": extraBookingList == null
        ? []
        : List<dynamic>.from(extraBookingList!.map((x) => x.toJson())),
  };
}

class ExtraBookings {
  String? day;
  List<Session>? sessions;
  List<ExtraCharge>? extraCharges;

  ExtraBookings({this.day, this.sessions, this.extraCharges});

  factory ExtraBookings.fromJson(Map<String, dynamic> json) => ExtraBookings(
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
