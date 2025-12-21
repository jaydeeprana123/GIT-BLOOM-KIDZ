import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';
import 'package:get/get.dart';

class NotAtLocationDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onExit;
  const NotAtLocationDialog({Key? key, required this.onRetry, required this.onExit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent the dialog from being dismissed when the back button is pressed
        return false; // return false to prevent popping
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          height: 380.h, // Use ScreenUtil for responsive height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 80, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                "You Are Not at the Location",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                "Please go to the specified location to mark your attendance.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                    ),
                    child: Text(
                      "Retry",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),

                  SizedBox(width: 16,),

                  ElevatedButton(
                    onPressed: () {
                      onExit();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: color_primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                    ),
                    child: Text(
                      "Exit",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
