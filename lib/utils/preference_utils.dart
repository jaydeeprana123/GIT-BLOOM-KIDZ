import 'dart:convert';
import 'package:bloom_kidz/Authentication/model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Created by Vrusti Patel
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../CommonWidgets/common_widget.dart';

class MySharedPref {
  static MySharedPref? classInstance;
  static SharedPreferences? preferences;

  static Future<MySharedPref?> getInstance() async {
    classInstance ??= MySharedPref();
    preferences ??= await SharedPreferences.getInstance();
    return classInstance;
  }

  _getFromDisk(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.get(key);
    printData("", "Value Model got... .... $value");
    return value;
  }

  Future<void> setString(String key, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printData("", "Value Set ::::::$content");
    prefs.setString(key, content);
  }

  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString(key) ?? "";

    return stringValue;
  }

  getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool? boolVal = prefs.getBool(key);
    printData("", "Value get ::::::$boolVal");
    boolVal ??= false;
    return boolVal;
  }

  // It clears preference data by unique key name
  Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.remove(key);
  }

  // It clears preference whole data
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.clear();
  }

  // Used to save user's information
  setLoginModel(LoginResponse model, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    prefs.setString(key, json.encode(model.toJson()));
  }

  // // Used to save user's information when user click on remember me
  // setRememberModel(SigninModel model, String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   printData("","Value set model ::::::" + model.data!.id.toString());
  //   prefs.setString(key, json.encode(model.toJson()));
  // }
  //

  // Used to get user's information
  Future<LoginResponse?> getLoginModel(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    var myJson = prefs.getString(key);
    if (myJson == null) {
      return null;
    }
    return LoginResponse.fromJson(json.decode(myJson));
  }

  //
  // // Used to get user's information
  // Future<SigninModel?> getRememberModel(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var myJson = prefs.getString(key);
  //   if (myJson == null) {
  //     return null;
  //   }
  //   return SigninModel.fromJson(json.decode(myJson));
  // }
  //
  // // Used to set user's address
  // setAddressDatumModel(AddressDatum model, String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   printData("","Value set model :::::::" + model.id.toString());
  //   prefs.setString(key, json.encode(model.toJson()));
  // }
  //
  // // Used to set user's address
  // setSelectedAddressModel(AddressDatum model, String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   printData("","Value set model :::::::" + model.id.toString());
  //   prefs.setString(key, json.encode(model.toJson()));
  // }
  //
  // // Used to get user's address
  // Future<AddressDatum?> getDatumModel(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var myJson = prefs.getString(key);
  //   if (myJson == null) {
  //     return null;
  //   }
  //   return AddressDatum.fromJson(json.decode(myJson));
  // }
  //
  // // Used to get user's address
  // Future<AddressDatum?> getSelectedAddressModel(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var myJson = prefs.getString(key);
  //   if (myJson == null) {
  //     return null;
  //   }
  //   return AddressDatum.fromJson(json.decode(myJson));
  // }
  //
  // // Used to save Location Information
  // setLocationModel(LocationModel model, String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   printData("","Value set model ::::::" + model.latitude.toString());
  //   prefs.setString(key, json.encode(model.toJson()));
  // }
  //
  // // Used to get location information
  // Future<LocationModel?> getLocationModel(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var myJson = prefs.getString(key);
  //   if (myJson == null) {
  //     return null;
  //   }
  //
  //   return LocationModel.fromJson(json.decode(myJson));
  // }
}

// class MySharedPref {
//   static final MySharedPref _instance = MySharedPref._internal();
//   factory MySharedPref() => _instance;
//   MySharedPref._internal();
//
//   static late SharedPreferences preferences;
//
//   static Future<MySharedPref> getInstance() async {
//     preferences = await SharedPreferences.getInstance();
//     return _instance;
//   }
//   // ---------------- BASIC ----------------
//
//   _getFromDisk(String key) async {
//     var value = preferences?.get(key);
//     print("Value Model got... .... $value");
//     return value;
//   }
//
//   Future<void> setString(String key, String content) async {
//     print("Value Set ::::::$content");
//     await preferences?.setString(key, content);
//   }
//
//   Future<void> setBool(String key, bool value) async {
//     print("Value set ::::::$value");
//     await preferences?.setBool(key, value);
//   }
//
//   Future<String> getStringValue(String key) async {
//     String stringValue = preferences?.getString(key) ?? "";
//     print("Value get ::::::$stringValue");
//     return stringValue;
//   }
//
//   getBoolValue(String key) async {
//     bool boolVal = preferences?.getBool(key) ?? false;
//     print("Value get ::::::$boolVal");
//     return boolVal;
//   }
//
//   // ---------------- CLEAR ----------------
//
//   Future<void> clearData(String key) async {
//     await preferences?.remove(key);
//   }
//
//   Future<void> clear() async {
//     await preferences?.clear();
//   }
//
//   // ---------------- MODELS ----------------
//
//   setLoginModel(LoginResponse model, String key) async {
//     preferences?.setString(key, json.encode(model.toJson()));
//   }
//
//   Future<LoginResponse?> getLoginModel(String key) async {
//     await preferences?.reload();
//     var myJson = preferences?.getString(key);
//
//     printData(runtimeType.toString(), "myJson " + myJson.toString());
//
//     if (myJson == null) {
//       return null;
//     }
//     return LoginResponse.fromJson(json.decode(myJson));
//   }
//
//   setAccessToken(String accessToken, String key) async {
//     await preferences?.setString(key, accessToken);
//   }
//
//   Future<String> getStringValue(String key) async {
//     return preferences?.getString(key) ?? "";
//   }
// }
