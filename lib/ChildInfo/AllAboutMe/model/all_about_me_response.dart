// To parse this JSON data, do
//
//     final allAboutMeResponse = allAboutMeResponseFromJson(jsonString);

import 'dart:convert';

AllAboutMeResponse allAboutMeResponseFromJson(String str) => AllAboutMeResponse.fromJson(json.decode(str));

String allAboutMeResponseToJson(AllAboutMeResponse data) => json.encode(data.toJson());

class AllAboutMeResponse {
  bool? status;
  String? message;
  Data? data;

  AllAboutMeResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AllAboutMeResponse.fromJson(Map<String, dynamic> json) => AllAboutMeResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  AllAboutMe? allAboutMe;

  Data({
    this.allAboutMe,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    allAboutMe: json["all_about_me"] == null ? null : AllAboutMe.fromJson(json["all_about_me"]),
  );

  Map<String, dynamic> toJson() => {
    "all_about_me": allAboutMe?.toJson(),
  };
}

class AllAboutMe {
  int? childId;
  String? childName;
  String? birthDate;
  String? startDate;
  String? preferredName;
  String? homeLanguage;
  String? spokenLanguages;
  String? celebrations;
  String? happyThings;
  String? favouriteBooksSongs;
  String? dislikes;
  String? eatingDrinking;
  dynamic foodDislikes;
  dynamic healthConditions;
  dynamic allergies;
  dynamic allergyTreatment;
  String? daySleep;
  String? sleepRoutine;
  String? comfortMethod;
  dynamic supportBeforeStart;
  String? primaryCollector;
  String? alternateCollector;
  dynamic additionalNotes;

  AllAboutMe({
    this.childId,
    this.childName,
    this.birthDate,
    this.startDate,
    this.preferredName,
    this.homeLanguage,
    this.spokenLanguages,
    this.celebrations,
    this.happyThings,
    this.favouriteBooksSongs,
    this.dislikes,
    this.eatingDrinking,
    this.foodDislikes,
    this.healthConditions,
    this.allergies,
    this.allergyTreatment,
    this.daySleep,
    this.sleepRoutine,
    this.comfortMethod,
    this.supportBeforeStart,
    this.primaryCollector,
    this.alternateCollector,
    this.additionalNotes,
  });

  factory AllAboutMe.fromJson(Map<String, dynamic> json) => AllAboutMe(
    childId: json["child_id"],
    childName: json["child_name"],
    birthDate: json["birth_date"],
    startDate: json["start_date"],
    preferredName: json["preferred_name"],
    homeLanguage: json["home_language"],
    spokenLanguages: json["spoken_languages"],
    celebrations: json["celebrations"],
    happyThings: json["happy_things"],
    favouriteBooksSongs: json["favourite_books_songs"],
    dislikes: json["dislikes"],
    eatingDrinking: json["eating_drinking"],
    foodDislikes: json["food_dislikes"],
    healthConditions: json["health_conditions"],
    allergies: json["allergies"],
    allergyTreatment: json["allergy_treatment"],
    daySleep: json["day_sleep"],
    sleepRoutine: json["sleep_routine"],
    comfortMethod: json["comfort_method"],
    supportBeforeStart: json["support_before_start"],
    primaryCollector: json["primary_collector"],
    alternateCollector: json["alternate_collector"],
    additionalNotes: json["additional_notes"],
  );

  Map<String, dynamic> toJson() => {
    "child_id": childId,
    "child_name": childName,
    "birth_date": birthDate,
    "start_date": startDate,
    "preferred_name": preferredName,
    "home_language": homeLanguage,
    "spoken_languages": spokenLanguages,
    "celebrations": celebrations,
    "happy_things": happyThings,
    "favourite_books_songs": favouriteBooksSongs,
    "dislikes": dislikes,
    "eating_drinking": eatingDrinking,
    "food_dislikes": foodDislikes,
    "health_conditions": healthConditions,
    "allergies": allergies,
    "allergy_treatment": allergyTreatment,
    "day_sleep": daySleep,
    "sleep_routine": sleepRoutine,
    "comfort_method": comfortMethod,
    "support_before_start": supportBeforeStart,
    "primary_collector": primaryCollector,
    "alternate_collector": alternateCollector,
    "additional_notes": additionalNotes,
  };
}
