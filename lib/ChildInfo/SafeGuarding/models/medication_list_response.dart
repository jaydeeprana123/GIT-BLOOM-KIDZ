// To parse this JSON data, do
//
//     final medicationListResponse = medicationListResponseFromJson(jsonString);

import 'dart:convert';

MedicationListResponse medicationListResponseFromJson(String str) => MedicationListResponse.fromJson(json.decode(str));

String medicationListResponseToJson(MedicationListResponse data) => json.encode(data.toJson());

class MedicationListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  MedicationListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory MedicationListResponse.fromJson(Map<String, dynamic> json) => MedicationListResponse(
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
  List<Medication>? medications;

  Data({
    this.medications,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    medications: json["medications"] == null ? [] : List<Medication>.from(json["medications"]!.map((x) => Medication.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "medications": medications == null ? [] : List<dynamic>.from(medications!.map((x) => x.toJson())),
  };
}

class Medication {
  int? id;
  String? medicine;
  String? reason;
  String? dose;
  String? frequency;
  NurseryAck? nurseryAck;
  ParentAck? parentAck;

  Medication({
    this.id,
    this.medicine,
    this.reason,
    this.dose,
    this.frequency,
    this.nurseryAck,
    this.parentAck,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
    id: json["id"],
    medicine: json["medicine"],
    reason: json["reason"],
    dose: json["dose"],
    frequency: json["frequency"],
    nurseryAck: json["nursery_ack"] == null ? null : NurseryAck.fromJson(json["nursery_ack"]),
    parentAck: json["parent_ack"] == null ? null : ParentAck.fromJson(json["parent_ack"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "medicine": medicine,
    "reason": reason,
    "dose": dose,
    "frequency": frequency,
    "nursery_ack": nurseryAck?.toJson(),
    "parent_ack": parentAck?.toJson(),
  };
}

class NurseryAck {
  int? id;
  String? name;

  NurseryAck({
    this.id,
    this.name,
  });

  factory NurseryAck.fromJson(Map<String, dynamic> json) => NurseryAck(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class ParentAck {
  bool? status;
  String? by;
  DateTime? date;

  ParentAck({
    this.status,
    this.by,
    this.date,
  });

  factory ParentAck.fromJson(Map<String, dynamic> json) => ParentAck(
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
