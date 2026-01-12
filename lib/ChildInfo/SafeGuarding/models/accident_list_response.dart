// To parse this JSON data, do
//
//     final accidentListResponse = accidentListResponseFromJson(jsonString);

import 'dart:convert';

AccidentListResponse accidentListResponseFromJson(String str) => AccidentListResponse.fromJson(json.decode(str));

String accidentListResponseToJson(AccidentListResponse data) => json.encode(data.toJson());

class AccidentListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  AccidentListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory AccidentListResponse.fromJson(Map<String, dynamic> json) => AccidentListResponse(
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
  List<Accident>? accidents;

  Data({
    this.accidents,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accidents: json["accidents"] == null ? [] : List<Accident>.from(json["accidents"]!.map((x) => Accident.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "accidents": accidents == null ? [] : List<dynamic>.from(accidents!.map((x) => x.toJson())),
  };
}

class Accident {
  int? id;
  String? kind;
  String? dateTime;
  ApprovedBy? child;
  String? location;
  String? nature;
  String? firstAid;
  String? parentsNotified;
  ApprovedBy? witness;
  ApprovedBy? approvedBy;
  Acknowledgement? acknowledgement;
  BodyMap? bodyMap;

  Accident({
    this.id,
    this.kind,
    this.dateTime,
    this.child,
    this.location,
    this.nature,
    this.firstAid,
    this.parentsNotified,
    this.witness,
    this.approvedBy,
    this.acknowledgement,
    this.bodyMap,
  });

  factory Accident.fromJson(Map<String, dynamic> json) => Accident(
    id: json["id"],
    kind: json["kind"],
    dateTime: json["date_time"],
    child: json["child"] == null ? null : ApprovedBy.fromJson(json["child"]),
    location: json["location"],
    nature: json["nature"],
    firstAid: json["first_aid"],
    parentsNotified: json["parents_notified"],
    witness: json["witness"] == null ? null : ApprovedBy.fromJson(json["witness"]),
    approvedBy: json["approved_by"] == null ? null : ApprovedBy.fromJson(json["approved_by"]),
    acknowledgement: json["acknowledgement"] == null ? null : Acknowledgement.fromJson(json["acknowledgement"]),
    bodyMap: json["body_map"] == null ? null : BodyMap.fromJson(json["body_map"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kind": kind,
    "date_time": dateTime,
    "child": child?.toJson(),
    "location": location,
    "nature": nature,
    "first_aid": firstAid,
    "parents_notified": parentsNotified,
    "witness": witness?.toJson(),
    "approved_by": approvedBy?.toJson(),
    "acknowledgement": acknowledgement?.toJson(),
    "body_map": bodyMap?.toJson(),
  };
}

class Acknowledgement {
  bool? status;
  int? by;
  DateTime? date;

  Acknowledgement({
    this.status,
    this.by,
    this.date,
  });

  factory Acknowledgement.fromJson(Map<String, dynamic> json) => Acknowledgement(
    status: json["status"],
    by: json["by"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "by": by,
    "date": date?.toIso8601String(),
  };
}

class ApprovedBy {
  int? id;
  String? name;

  ApprovedBy({
    this.id,
    this.name,
  });

  factory ApprovedBy.fromJson(Map<String, dynamic> json) => ApprovedBy(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class BodyMap {
  List<Front>? front;
  List<Front>? back;
  List<Front>? head;
  List<Front>? sideface;

  BodyMap({
    this.front,
    this.back,
    this.head,
    this.sideface,
  });

  factory BodyMap.fromJson(Map<String, dynamic> json) => BodyMap(
    front: json["front"] == null ? [] : List<Front>.from(json["front"]!.map((x) => Front.fromJson(x))),
    back: json["back"] == null ? [] : List<Front>.from(json["back"]!.map((x) => Front.fromJson(x))),
    head: json["head"] == null ? [] : List<Front>.from(json["head"]!.map((x) => Front.fromJson(x))),
    sideface: json["sideface"] == null ? [] : List<Front>.from(json["sideface"]!.map((x) => Front.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "front": front == null ? [] : List<dynamic>.from(front!.map((x) => x.toJson())),
    "back": back == null ? [] : List<dynamic>.from(back!.map((x) => x)),
    "head": head == null ? [] : List<dynamic>.from(head!.map((x) => x.toJson())),
    "sideface": sideface == null ? [] : List<dynamic>.from(sideface!.map((x) => x)),
  };
}

class Front {
  double? x;
  double? y;
  DateTime? timestamp;

  Front({
    this.x,
    this.y,
    this.timestamp,
  });

  factory Front.fromJson(Map<String, dynamic> json) => Front(
    x: json["x"]?.toDouble(),
    y: json["y"]?.toDouble(),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
    "timestamp": timestamp?.toIso8601String(),
  };
}
