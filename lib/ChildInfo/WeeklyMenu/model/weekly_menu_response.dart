// To parse this JSON data, do
//
//     final weeklymenuResponse = weeklymenuResponseFromJson(jsonString);

import 'dart:convert';

WeeklymenuResponse weeklymenuResponseFromJson(String str) => WeeklymenuResponse.fromJson(json.decode(str));

String weeklymenuResponseToJson(WeeklymenuResponse data) => json.encode(data.toJson());

class WeeklymenuResponse {
  bool? status;
  String? message;
  int? code;
  WeeklyMenuData? data;

  WeeklymenuResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory WeeklymenuResponse.fromJson(Map<String, dynamic> json) => WeeklymenuResponse(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : WeeklyMenuData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class WeeklyMenuData {
  String? childId;
  DateTime? weekStart;
  DateTime? weekEnd;
  List<WeeklyMenu>? weeklyMenu;

  WeeklyMenuData({
    this.childId,
    this.weekStart,
    this.weekEnd,
    this.weeklyMenu,
  });

  factory WeeklyMenuData.fromJson(Map<String, dynamic> json) => WeeklyMenuData(
    childId: json["child_id"],
    weekStart: json["week_start"] == null ? null : DateTime.parse(json["week_start"]),
    weekEnd: json["week_end"] == null ? null : DateTime.parse(json["week_end"]),
    weeklyMenu: json["weekly_menu"] == null ? [] : List<WeeklyMenu>.from(json["weekly_menu"]!.map((x) => WeeklyMenu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "child_id": childId,
    "week_start": "${weekStart!.year.toString().padLeft(4, '0')}-${weekStart!.month.toString().padLeft(2, '0')}-${weekStart!.day.toString().padLeft(2, '0')}",
    "week_end": "${weekEnd!.year.toString().padLeft(4, '0')}-${weekEnd!.month.toString().padLeft(2, '0')}-${weekEnd!.day.toString().padLeft(2, '0')}",
    "weekly_menu": weeklyMenu == null ? [] : List<dynamic>.from(weeklyMenu!.map((x) => x.toJson())),
  };
}

class WeeklyMenu {
  String? day;
  List<Meal>? meals;

  WeeklyMenu({
    this.day,
    this.meals,
  });

  factory WeeklyMenu.fromJson(Map<String, dynamic> json) => WeeklyMenu(
    day: json["day"],
    meals: json["meals"] == null ? [] : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
  };
}

class Meal {
  String? mealType;
  String? mealName;
  List<Item>? items;

  Meal({
    this.mealType,
    this.mealName,
    this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    mealType: json["meal_type"],
    mealName: json["meal_name"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meal_type": mealType,
    "meal_name": mealName,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  int? id;
  String? name;
  List<String>? diets;

  Item({
    this.id,
    this.name,
    this.diets,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    diets: json["diets"] == null ? [] : List<String>.from(json["diets"]!.map((x) => x)),


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "diets": diets == null ? [] : List<dynamic>.from(diets!.map((x) => x)),

  };
}

