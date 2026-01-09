import 'dart:ffi';
import 'dart:io';
import 'package:bloom_kidz/Authentication/View/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Styles/my_icons.dart';
import '../utils/preference_utils.dart';
import '../utils/share_predata.dart';

File imageFile = File("");
final String _text =
    'Toda persona tiene derecho a la educación. La educación debe ser gratuita, al menos en lo concerniente a la instrucción elemental y fundamental. La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada; el acceso a los estudios superiores será igual para todos, en función de los méritos respectivos.';
// TranslationModel _translated = TranslationModel(translatedText: '', detectedSourceLanguage: '');
// TranslationModel _detected = TranslationModel(translatedText: '', detectedSourceLanguage: '');

void showSomethingWentWrongDialog({String? message}) {
  Get.defaultDialog(
    title: "Error",
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    middleText: message ?? "Please try again later.",
    textConfirm: "OK",
    onConfirm: () => Get.back(),
    radius: 10,
  );
}

/// logout from the app
logoutFromTheApp() async {
  var preferences = MySharedPref();
  await preferences.clearData(SharePreData.keySaveLoginModel);
  await preferences.clearData(SharePreData.keyAccessToken);
  Get.offAll(() => LoginScreen());
}

void showBlockedDialog() {
  Get.defaultDialog(
    title: "Access Denied",
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    barrierDismissible: false,
    radius: 16,
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "You are blocked. Please contact support for assistance.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Example: open support page or navigate
              // Get.toNamed('/support');
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade100,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Contact Support"),
          ),
        ],
      ),
    ),
  );
}

snackBar(BuildContext? context, String message) {
  if (!Get.isOverlaysOpen) {
    GetSnackBar(
      backgroundColor: Colors.black,
      duration: const Duration(seconds: 8 ?? 2),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily: fontInterRegular,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    ).show();
  }

  // return ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     behavior: SnackBarBehavior.floating,
  //     content: Text(message),
  //     duration: const Duration(seconds: 2),
  //   ),
  // );
}

snackBarLongTime(BuildContext? context, String message) {
  if (!Get.isOverlaysOpen) {
    GetSnackBar(
      backgroundColor: Colors.black,
      duration: const Duration(seconds: 60 ?? 2),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily: fontInterRegular,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    ).show();
  }

  // return ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     behavior: SnackBarBehavior.floating,
  //     content: Text(message),
  //     duration: const Duration(seconds: 2),
  //   ),
  // );
}

snackBarRed(BuildContext context, String message) {
  if (!Get.isOverlaysOpen) {
    GetSnackBar(
      backgroundColor: Colors.red.shade400,
      duration: Duration(seconds: 3 ?? 2),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: TextStyle(fontFamily: fontInterRegular, fontSize: 14),
      ),
    ).show();
  }

  // return ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     backgroundColor: Colors.red.shade400,
  //     behavior: SnackBarBehavior.floating,
  //     content: Text(message),
  //     duration: const Duration(seconds: 2),
  //   ),
  // );
}

topSnackBar(BuildContext context, String title, String description) {
  return Get.snackbar(
    margin: const EdgeInsets.all(5),
    title,
    description,
    backgroundColor: Colors.white,
    colorText: bg_btn_199a8e,
  );
}

snackBarRapid(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}

goToWelcomeScreen() async {
  var preferences = MySharedPref();
  await preferences.clearData(SharePreData.keySaveLoginModel);
  await preferences.clearData(SharePreData.keySaveCart);
  Get.offAll(() => const LoginScreen());
}

void printData(String str, String val) {
  print("$str :::::::::::::  $val");
}

createdDateConverted(String originalDate) {
  String result = "";
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy | hh:mm a").format(date);
  return result;
}

getTimeInAmPM(DateTime dateTime) {
  String result = "";
  result = DateFormat("hh:mm a").format(dateTime);
  return result;
}

getDateOnly(String originalDate) {
  String result = "";
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy").format(date);
  return result;
}

getDateFormtYYYYMMDDOnly(DateTime originalDate) {
  String result = "";
  result = DateFormat("yyyy-MM-dd").format(originalDate);
  return result;
}

getDateOnlyInIndianFormat(DateTime originalDate) {
  String result = "";
  result = DateFormat("dd-MM-yyyy").format(originalDate);
  return result;
}

getDateIndMMYYYYFormat(DateTime originalDate) {
  String result = "";
  result = DateFormat("d MMM, yyyy").format(originalDate);
  return result;
}

createdDateTimeConverted(String originalDate) {
  String result = "";
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy\nhh:mm a").format(date);
  return result;
}

/// A reusable AlertDialog with callback
void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmed,
  VoidCallback? onCancelled,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              if (onCancelled != null) onCancelled();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              onConfirmed(); // trigger callback
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

Future<String> openCamera(BuildContext context) async {
  String imagePathOfFile = "";
  await _getFile(ImageSource.camera).then((value) {
    if (imageFile.toString() != "File: ''") {
      // poster = imagePath;
      int sizeInBytes = imageFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      printData("File SizeFile Size ", sizeInMb.toString());

      if (sizeInMb > 5) {
        // This file is Longer
        snackBar(context, "Selected profile size is more than 5 MB");
        return;
      } else {
        imagePathOfFile = imageFile.path.toString();
      }
    }
  });

  return imagePathOfFile;
}

// Select Photo
Future<String> selectPhoto(BuildContext context, bool isGalleryVisible) async {
  String imagePathOfFile = "";

  await showImagePicker(context, isGalleryVisible).then((value) {
    if (imageFile.toString() != "File: ''") {
      // poster = imagePath;
      int sizeInBytes = imageFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      printData("File SizeFile Size ", sizeInMb.toString());

      if (sizeInMb > 5) {
        // This file is Longer
        snackBar(context, "Selected profile size is more than 5 MB");
        return;
      } else {
        imagePathOfFile = imageFile.path.toString();
      }
    }

    // printData(runtimeType.toString(),imagePath.toString());
  });

  return imagePathOfFile;
}

Future showImagePicker(context, bool isGalleryVisible) {
  // imagePath = null;
  Future<void> future = showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: isGalleryVisible
              ? Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        _getFile(
                          ImageSource.gallery,
                        ).then((value) => Navigator.of(context).pop());
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        _getFile(
                          ImageSource.camera,
                        ).then((value) => Navigator.of(context).pop());
                      },
                    ),
                  ],
                )
              : Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        _getFile(
                          ImageSource.camera,
                        ).then((value) => Navigator.of(context).pop());
                      },
                    ),
                  ],
                ),
        ),
      );
    },
  );
  return future;
}

Future _getFile(ImageSource source) async {
  final XFile? image = await ImagePicker().pickImage(
    source: source,
    imageQuality: 10,
    preferredCameraDevice: CameraDevice.front,
  );
  print("Image Path " + (image?.path ?? ""));

  if (image != null) {
    return imageFile = File(image.path);
  } else {
    return "";
  }
}

void onLoading(BuildContext context, String msg) {
  Future.delayed(Duration.zero, () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
          // Image.asset(icon_waiting, height: 80.w, width: 80.h)
          // SizedBox(
          //   height: 200.w,
          //   width: 200.h,
          //   child: CircularProgressIndicator()
          //
          //   // Lottie.asset(
          //   //   icon_loader_json,
          //   //   repeat: true,
          //   //   reverse: true,
          //   //   animate: true,
          //   // ),
          // ),
          // Container(
          //     width: 50,
          //     height: 50,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.green,
          //       ) , child: Image.asset(icon_waiting, height: 35, width: 35)),
        );
        // child: const CircularProgressIndicator(
        //   backgroundColor: Colors.white,
        //   valueColor: AlwaysStoppedAnimation<Color>(
        //     bg_btn_199a8e, //<-- SEE HERE
        //   ),
        // )),
        // );
      },
    );
  });
}


Future<void> pickDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onSelected,
    ) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 2),
  );

  if (picked != null) {
    onSelected(picked);
  }
}
