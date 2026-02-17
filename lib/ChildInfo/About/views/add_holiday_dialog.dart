import 'package:bloom_kidz/Authentication/controller/login_controller.dart';
import 'package:bloom_kidz/BottomNavigation/View/bottom_navigation_view.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Profile/controller/profile_controller.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../../Activity/model/activity_response_for_select.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/date_field.dart';

class AddHolidayDialog extends StatelessWidget {
  final ChildInfoController controller;
  final String childId;
  final bool isHoliday;
  AddHolidayDialog({
    super.key,
    required this.controller,
    required this.childId,
    required this.isHoliday,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearDateField();
      controller.selectedActivity.value = ActivityForSelect();
      controller.selectedActivity.value = null;
      controller.callActivityListForSelectAPI(context, isHoliday);
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ❌ Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.cancel, color: color_secondary),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// 🔵 Title
                  BlueMediumBoldText(
                    isHoliday ? "Holiday Request" : "Sick Leave Request",
                    fontSize: 16,
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<ActivityForSelect>(
                    value: controller.selectedActivity.value,
                    hint: const Text("Select Activity"),

                    items: controller.activityListForSelect.map((activity) {
                      return DropdownMenuItem<ActivityForSelect>(
                        value: activity,
                        child: Text(activity.name ?? ""),
                      );
                    }).toList(),

                    onChanged: (value) {
                      controller.selectedActivity.value = value;
                      print("Selected ID: ${value?.id}");
                    },

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔑 Current Password
                  DateField(
                    label: "Start Date",
                    value: controller.startDate.value,
                    onTap: () => pickDate(
                      context,
                      controller.startDate.value,
                      controller.setStart,
                    ),
                  ),

                  const SizedBox(height: 20),

                  DateField(
                    label: "End Date",
                    value: controller.endDate.value,
                    onTap: () => pickDate(
                      context,
                      controller.endDate.value,
                      controller.setEnd,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    hint: "Note",
                    controller: controller.noteController.value,
                    isPassword: false,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 20),

                  /// 💾 Save Button
                  Center(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () async {
                          if (controller.startDate.value == null) {
                            snackBar(context, "Select Start Date");
                            return;
                          }

                          if (controller.endDate.value == null) {
                            snackBar(context, "Select End Date");
                            return;
                          }

                          if (controller.selectedActivity.value == null) {
                            snackBar(context, "Select Activity");
                            return;
                          }

                          await controller.callAddLeaveAPI(
                            context,
                            childId,
                            (controller.selectedActivity.value?.id ?? 0)
                                .toString(),
                          );
                        },
                        child: BlueMediumBoldText(
                          "Submit",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
