import 'dart:async';
import 'dart:math';
import 'package:bloom_kidz/Authentication/View/login_screen.dart';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Enums/user_type_enum.dart';
import '../Styles/my_colors.dart';
import '../Styles/my_icons.dart';
import '../utils/preference_utils.dart';
import '../utils/share_predata.dart';

// To parse this JSON data, do
//
//     final versionResponse = versionResponseFromJson(jsonString);

import 'dart:convert';

VersionResponse versionResponseFromJson(String str) => VersionResponse.fromJson(json.decode(str));

String versionResponseToJson(VersionResponse data) => json.encode(data.toJson());

class VersionResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  VersionResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) => VersionResponse(
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
  AppVersion? appVersion;

  Data({
    this.appVersion,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    appVersion: json["app_version"] == null ? null : AppVersion.fromJson(json["app_version"]),
  );

  Map<String, dynamic> toJson() => {
    "app_version": appVersion?.toJson(),
  };
}

class AppVersion {
  bool? isForceUpdate;
  String? androidVersion;
  String? iosVersion;

  AppVersion({
    this.isForceUpdate,
    this.androidVersion,
    this.iosVersion,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
    isForceUpdate: json["is_force_update"],
    androidVersion: json["android_version"],
    iosVersion: json["ios_version"],
  );

  Map<String, dynamic> toJson() => {
    "is_force_update": isForceUpdate,
    "android_version": androidVersion,
    "ios_version": iosVersion,
  };
}

