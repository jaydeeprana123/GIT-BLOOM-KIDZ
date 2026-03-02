// To parse this JSON data, do
//
//     final weeklyPlanResponse = weeklyPlanResponseFromJson(jsonString);

import 'dart:convert';

WeeklyPlanResponse weeklyPlanResponseFromJson(String str) =>
    WeeklyPlanResponse.fromJson(json.decode(str));

String weeklyPlanResponseToJson(WeeklyPlanResponse data) =>
    json.encode(data.toJson());

class WeeklyPlanResponse {
  bool? status;
  String? message;
  int? code;
  WeeklyPlanData? data;

  WeeklyPlanResponse({this.status, this.message, this.code, this.data});

  factory WeeklyPlanResponse.fromJson(Map<String, dynamic> json) =>
      WeeklyPlanResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? null
            : WeeklyPlanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class WeeklyPlanData {
  String? childId;
  DateTime? planStart;
  DateTime? planEnd;
  List<WeeklyPlan>? weeklyPlan;

  WeeklyPlanData({this.childId, this.planStart, this.planEnd, this.weeklyPlan});

  factory WeeklyPlanData.fromJson(Map<String, dynamic> json) => WeeklyPlanData(
    childId: json["child_id"],
    planStart: json["plan_start"] == null
        ? null
        : DateTime.parse(json["plan_start"]),
    planEnd: json["plan_end"] == null ? null : DateTime.parse(json["plan_end"]),
    weeklyPlan: json["weekly_plan"] == null
        ? []
        : List<WeeklyPlan>.from(
            json["weekly_plan"]!.map((x) => WeeklyPlan.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "child_id": childId,
    "plan_start":
        "${planStart!.year.toString().padLeft(4, '0')}-${planStart!.month.toString().padLeft(2, '0')}-${planStart!.day.toString().padLeft(2, '0')}",
    "plan_end":
        "${planEnd!.year.toString().padLeft(4, '0')}-${planEnd!.month.toString().padLeft(2, '0')}-${planEnd!.day.toString().padLeft(2, '0')}",
    "weekly_plan": weeklyPlan == null
        ? []
        : List<dynamic>.from(weeklyPlan!.map((x) => x.toJson())),
  };
}

class WeeklyPlan {
  String? day;
  String? date;
  List<Activity>? activities;

  WeeklyPlan({this.day, this.date, this.activities});

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) => WeeklyPlan(
    day: json["day"],
    date: json["date"],
    activities: json["activities"] == null
        ? []
        : List<Activity>.from(
            json["activities"]!.map((x) => Activity.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "date": date,
    "activities": activities == null
        ? []
        : List<dynamic>.from(activities!.map((x) => x.toJson())),
  };
}

class Activity {
  int? id;
  String? title;
  String? description;
  String? image;

  Activity({this.id, this.title, this.description, this.image});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
  };
}
