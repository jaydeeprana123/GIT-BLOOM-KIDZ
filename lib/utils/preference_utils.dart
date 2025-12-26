import 'dart:convert';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Created by Vrusti Patel
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../CommonWidgets/common_widget.dart';

class MySharedPref {
  static final MySharedPref _instance = MySharedPref._internal();
  factory MySharedPref() => _instance;
  MySharedPref._internal();

  static SharedPreferences? preferences;

  static Future<MySharedPref> getInstance() async {
    preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }
  // ---------------- BASIC ----------------

  _getFromDisk(String key) async {
    var value = preferences?.get(key);
    print("Value Model got... .... $value");
    return value;
  }

  Future<void> setString(String key, String content) async {
    print("Value Set ::::::$content");
    await preferences?.setString(key, content);
  }

  Future<void> setBool(String key, bool value) async {
    print("Value set ::::::$value");
    await preferences?.setBool(key, value);
  }

  getStringValue(String key) async {
    String stringValue = preferences?.getString(key) ?? "";
    print("Value get ::::::$stringValue");
    return stringValue;
  }

  getBoolValue(String key) async {
    bool boolVal = preferences?.getBool(key) ?? false;
    print("Value get ::::::$boolVal");
    return boolVal;
  }

  // ---------------- CLEAR ----------------

  Future<void> clearData(String key) async {
    await preferences?.remove(key);
  }

  Future<void> clear() async {
    await preferences?.clear();
  }

  // ---------------- MODELS ----------------

  setLoginModel(LoginResponse model, String key) async {
    preferences?.setString(key, json.encode(model.toJson()));
  }

  Future<LoginResponse?> getLoginModel(String key) async {
    await preferences?.reload();
    var myJson = preferences?.getString(key);

    printData(runtimeType.toString(), "myJson " + myJson.toString());

    if (myJson == null) {
      return null;
    }
    return LoginResponse.fromJson(json.decode(myJson));
  }

  setAccessToken(String accessToken, String key) async {
    await preferences?.setString(key, accessToken);
  }

  Future<String> getAccessToken(String key) async {
    return preferences?.getString(key) ?? "";
  }
}
