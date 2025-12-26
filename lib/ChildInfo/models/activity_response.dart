// To parse this JSON data, do
//
//     final activityResponse = activityResponseFromJson(jsonString);

import 'dart:convert';

ActivityResponse activityResponseFromJson(String str) =>
    ActivityResponse.fromJson(json.decode(str));

String activityResponseToJson(ActivityResponse data) =>
    json.encode(data.toJson());

class ActivityResponse {
  bool? status;
  String? message;
  int? code;
  List<ActivityData>? data;
  Meta? meta;

  ActivityResponse({
    this.status,
    this.message,
    this.code,
    this.data,
    this.meta,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) =>
      ActivityResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<ActivityData>.from(
                json["data"]!.map((x) => ActivityData.fromJson(x)),
              ),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class ActivityData {
  DateTime? date;
  String? displayDate;
  List<Meal>? meals;
  List<Nappy>? nappy;
  List<Activity>? activities;

  ActivityData({
    this.date,
    this.displayDate,
    this.meals,
    this.nappy,
    this.activities,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    displayDate: json["display_date"],
    meals: json["meals"] == null
        ? []
        : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
    nappy: json["nappy"] == null
        ? []
        : List<Nappy>.from(json["nappy"]!.map((x) => Nappy.fromJson(x))),
    activities: json["activities"] == null
        ? []
        : List<Activity>.from(
            json["activities"]!.map((x) => Activity.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "display_date": displayDate,
    "meals": meals == null
        ? []
        : List<dynamic>.from(meals!.map((x) => x.toJson())),
    "nappy": nappy == null
        ? []
        : List<dynamic>.from(nappy!.map((x) => x.toJson())),
    "activities": activities == null
        ? []
        : List<dynamic>.from(activities!.map((x) => x.toJson())),
  };
}

class Activity {
  int? activityId;
  String? activityName;
  String? time;
  dynamic temperature;
  String? icon;

  Activity({
    this.activityId,
    this.activityName,
    this.time,
    this.temperature,
    this.icon,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    activityId: json["activity_id"],
    activityName: json["activity_name"],
    time: json["time"],
    temperature: json["temperature"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "activity_id": activityId,
    "activity_name": activityName,
    "time": time,
    "temperature": temperature,
    "icon": icon,
  };
}

class Meal {
  String? mealType;
  String? mealTime;
  List<Food>? foods;

  Meal({this.mealType, this.mealTime, this.foods});

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    mealType: json["meal_type"],
    mealTime: json["meal_time"],
    foods: json["foods"] == null
        ? []
        : List<Food>.from(json["foods"]!.map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meal_type": mealType,
    "meal_time": mealTime,
    "foods": foods == null
        ? []
        : List<dynamic>.from(foods!.map((x) => x.toJson())),
  };
}

class Food {
  int? foodId;
  String? foodName;
  String? amount;

  Food({this.foodId, this.foodName, this.amount});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    foodId: json["food_id"],
    foodName: json["food_name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "food_id": foodId,
    "food_name": foodName,
    "amount": amount,
  };
}

class Nappy {
  String? time;
  Type? type;
  String? status;

  Nappy({this.time, this.type, this.status});

  factory Nappy.fromJson(Map<String, dynamic> json) =>
      Nappy(time: json["time"], type: json["type"], status: json["status"]);

  Map<String, dynamic> toJson() => {
    "time": time,
    "type": type,
    "status": status,
  };
}

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  bool? hasMore;

  Meta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.hasMore,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "has_more": hasMore,
  };
}
