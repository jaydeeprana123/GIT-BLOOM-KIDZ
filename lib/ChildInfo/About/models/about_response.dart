// To parse this JSON data, do
//
//     final bookingsResponse = bookingsResponseFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final aboutResponse = aboutResponseFromJson(jsonString);

import 'dart:convert';

AboutResponse aboutResponseFromJson(String str) => AboutResponse.fromJson(json.decode(str));

String aboutResponseToJson(AboutResponse data) => json.encode(data.toJson());

class AboutResponse {
  bool? status;
  String? message;
  int? code;
  AboutData? data;

  AboutResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) => AboutResponse(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : AboutData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class AboutData {
  BasicInfo? basicInfo;
  HealthInfo? healthInfo;
  ReligionInfo? religionInfo;
  RoomMoves? roomMoves;

  AboutData({
    this.basicInfo,
    this.healthInfo,
    this.religionInfo,
    this.roomMoves,
  });

  factory AboutData.fromJson(Map<String, dynamic> json) => AboutData(
    basicInfo: json["basicInfo"] == null ? null : BasicInfo.fromJson(json["basicInfo"]),
    healthInfo: json["healthInfo"] == null ? null : HealthInfo.fromJson(json["healthInfo"]),
    religionInfo: json["religionInfo"] == null ? null : ReligionInfo.fromJson(json["religionInfo"]),
    roomMoves: json["room_moves"] == null ? null : RoomMoves.fromJson(json["room_moves"]),
  );

  Map<String, dynamic> toJson() => {
    "basicInfo": basicInfo?.toJson(),
    "healthInfo": healthInfo?.toJson(),
    "religionInfo": religionInfo?.toJson(),
    "room_moves": roomMoves?.toJson(),
  };
}

class BasicInfo {
  int? id;
  String? firstName;
  String? lastName;
  DateTime? dob;
  String? gender;
  String? birthPlace;
  String? nationality;
  String? room;
  String? profileImage;
  List<String>? liveWith;
  List<String>? parentalResponsibility;
  String? keyPerson;
  dynamic secondKeyPerson;
  String? specialNote;

  BasicInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.birthPlace,
    this.nationality,
    this.room,
    this.profileImage,
    this.liveWith,
    this.parentalResponsibility,
    this.keyPerson,
    this.secondKeyPerson,
    this.specialNote,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    birthPlace: json["birth_place"],
    nationality: json["nationality"],
    room: json["room"],
    profileImage: json["profile_image"],
    liveWith: json["live_with"] == null ? [] : List<String>.from(json["live_with"]!.map((x) => x)),
    parentalResponsibility: json["parental_responsibility"] == null ? [] : List<String>.from(json["parental_responsibility"]!.map((x) => x)),
    keyPerson: json["key_person"],
    secondKeyPerson: json["second_key_person"],
    specialNote: json["special_note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "birth_place": birthPlace,
    "nationality": nationality,
    "room": room,
    "profile_image": profileImage,
    "live_with": liveWith == null ? [] : List<dynamic>.from(liveWith!.map((x) => x)),
    "parental_responsibility": parentalResponsibility == null ? [] : List<dynamic>.from(parentalResponsibility!.map((x) => x)),
    "key_person": keyPerson,
    "second_key_person": secondKeyPerson,
    "special_note": specialNote,
  };
}

class HealthInfo {
  int? toleratesPenicillin;
  String? specialDietaryConsiderations;
  String? vaccines;
  String? allergy;
  String? specialNote;

  HealthInfo({
    this.toleratesPenicillin,
    this.specialDietaryConsiderations,
    this.vaccines,
    this.allergy,
    this.specialNote,
  });

  factory HealthInfo.fromJson(Map<String, dynamic> json) => HealthInfo(
    toleratesPenicillin: json["tolerates_penicillin"],
    specialDietaryConsiderations: json["special_dietary_considerations"],
    vaccines: json["vaccines"],
    allergy: json["allergy"],
    specialNote: json["special_note"],
  );

  Map<String, dynamic> toJson() => {
    "tolerates_penicillin": toleratesPenicillin,
    "special_dietary_considerations": specialDietaryConsiderations,
    "vaccines": vaccines,
    "allergy": allergy,
    "special_note": specialNote,
  };
}

class ReligionInfo {
  String? religion;
  String? ethnicity;

  ReligionInfo({
    this.religion,
    this.ethnicity,
  });

  factory ReligionInfo.fromJson(Map<String, dynamic> json) => ReligionInfo(
    religion: json["religion"],
    ethnicity: json["ethnicity"],
  );

  Map<String, dynamic> toJson() => {
    "religion": religion,
    "ethnicity": ethnicity,
  };
}

class RoomMoves {
  String? rooms;
  DateTime? startDate;
  dynamic endDate;

  RoomMoves({
    this.rooms,
    this.startDate,
    this.endDate,
  });

  factory RoomMoves.fromJson(Map<String, dynamic> json) => RoomMoves(
    rooms: json["rooms"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "rooms": rooms,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": endDate,
  };
}

