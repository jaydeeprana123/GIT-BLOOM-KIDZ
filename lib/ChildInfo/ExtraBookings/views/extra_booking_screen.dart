import 'package:bloom_kidz/ChildInfo/ExtraBookings/views/add_extra_booking_screen.dart';
import 'package:bloom_kidz/ChildInfo/ExtraBookings/views/update_extra_booking_screen.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/dotted_line.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../CommonWidgets/common_appbar.dart';
import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';

import 'package:flutter/material.dart';

import '../models/extra_bookings_response.dart';

class ExtraBookingScreen extends StatefulWidget {
  final String childId;

  const ExtraBookingScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<ExtraBookingScreen> createState() => _ExtraBookingScreenState();
}

class _ExtraBookingScreenState extends State<ExtraBookingScreen> {
  ChildInfoController controller = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.extraBookingList.clear();

      controller.callGetExtraBookingsAPI(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: 'Extra Bookings',
        showBack: true,
        showAddButton: true,
        onAddButtonTap: () {
          Get.to(AddExtraBookingScreen(childId: widget.childId))?.then((value) {
            controller.callGetExtraBookingsAPI(context, widget.childId);
          });
        },
      ),

      body: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.extraBookingList.isEmpty) {
              return  Center(
                child: BlueLargeBoldText("No Data Found"),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: controller.extraBookingList.length,
              itemBuilder: (context, index) {
                final booking = controller.extraBookingList[index];

                return Card(
                  color: Colors.white,
                  shadowColor: color_secondary,
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DATE RANGE
                        Row(
                          children: [
                            Expanded(
                              child: BlueLargeBoldText(
                                '${DateFormat('dd MMM yyyy').format(booking.planStart!)}'
                                ' - ${DateFormat('dd MMM yyyy').format(booking.planEnd!)}',
                                fontSize: 15,
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                showUpdateDeleteDialog(
                                  context,
                                  widget.childId,
                                  (controller.extraBookingList[index].id ?? 0)
                                      .toString(),
                                  controller.extraBookingList[index],
                                );
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: color_secondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // DAYS
                        if (booking.days!.isNotEmpty)
                          Column(
                            children: booking.days!.map((day) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: color_secondary),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: BlueMediumBoldText(
                                        day.day!.substring(0, 3),
                                        fontFamily: fontInterBold,
                                      ),
                                    ),

                                    if ((day.sessions ?? []).isNotEmpty)
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                BlueMediumBoldText(
                                                  '${selectedSession(day)?.startTime} - ${selectedSession(day)?.endTime}',
                                                ),

                                                SizedBox(width: 3),
                                                BlueMediumBoldText(
                                                  fontFamily: fontInterSemiBold,
                                                  "(${calculateTotalHours(selectedSession(day)?.startTime ?? "", selectedSession(day)?.endTime ?? "")})",
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),

                                            if ((day.extraCharges ?? [])
                                                .isNotEmpty)
                                              for (
                                                int i = 0;
                                                i <
                                                    (day.extraCharges ?? [])
                                                        .length;
                                                i++
                                              )
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: BlueMediumBoldText(
                                                    '${day.extraCharges?[i].name}',
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),

                                    if ((day.sessions ?? []).isNotEmpty)
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            BlueMediumBoldText(
                                              "£" +
                                                  (day.sessions?[0].price ??
                                                      "0"),
                                              fontFamily: fontInterSemiBold,
                                            ),
                                            SizedBox(height: 8),
                                            if ((day.extraCharges ?? [])
                                                .isNotEmpty)
                                              for (
                                                int i = 0;
                                                i <
                                                    (day.extraCharges ?? [])
                                                        .length;
                                                i++
                                              )
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: BlueMediumBoldText(
                                                    '£${day.extraCharges?[i].price}',
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        SizedBox(height: 8),
                        DottedLine(color: color_secondary),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: BlueLargeBoldText(
                                "Total",

                                fontFamily: fontInterBold,
                              ),
                            ),

                            BlueLargeBoldText(
                              controller.extraBookingList[index].totalAmount ??
                                  "0",
                              fontFamily: fontInterBold,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        DottedLine(color: color_secondary),

                        SizedBox(height: 8),

                        if ((booking.approvedUser ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                BlueLargeBoldText(
                                  "Approved By : ",

                                  fontFamily: fontInterMedium,
                                ),

                                BlueLargeBoldText(
                                  booking.approvedUser ?? "",

                                  fontFamily: fontInterBold,
                                ),
                              ],
                            ),
                          ),

                        if (booking.days!.isEmpty)
                          BlueMediumBoldText(
                            'No sessions or extra charges available',
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  String calculateTotalHours(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return '--';

    final startParts = startTime.split(':');
    final endParts = endTime.split(':');

    if (startParts.length < 2 || endParts.length < 2) return '--';

    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    final diffMinutes = endMinutes - startMinutes;
    if (diffMinutes <= 0) return '0';

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    }

    return '0';
  }

  void showUpdateDeleteDialog(
    BuildContext context,
    String childId,
    String id,
    ExtraBooking extraBooking,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlueMediumBoldText(
                  "Action",
                  fontSize: 16,
                  color: color_secondary,
                ),

                const SizedBox(height: 16),

                /// ✏️ Update
                ListTile(
                  leading: const Icon(Icons.edit_note, color: color_secondary),
                  title: BlueMediumBoldText("Update"),
                  onTap: () {
                    controller.selectedExtraBooking.value = extraBooking;
                    Navigator.pop(context);
                    Get.to(UpdateExtraBookingScreen(childId: childId))?.then((
                      value,
                    ) {
                      controller.callGetExtraBookingsAPI(
                        context,
                        widget.childId,
                      );
                    });
                  },
                ),

                const Divider(),

                /// 🗑 Delete
                if ((extraBooking.approvedUser ?? "").isEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      showDeleteWarningDialog(
                        context,
                        onConfirm: () {
                          controller.callDeleteExtraBookingsAPI(
                            context,
                            childId,
                            id,
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteWarningDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ⚠️ Icon
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 50,
                ),

                const SizedBox(height: 12),

                /// Title
                BlueMediumBoldText(
                  "Delete Contact",
                  fontSize: 16,
                  color: Colors.red,
                ),

                const SizedBox(height: 8),

                /// Message
                const Text(
                  "Are you sure you want to delete this booking?\nThis action cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Session? selectedSession(Day day) {
    Session? selectedSession = day.sessions?.firstWhere(
      (s) => s.selected == true,
      orElse: () => Session(),
    );

    return selectedSession;
  }

  ExtraCharge? selectedExtraCharge(Day day) {
    ExtraCharge? selectedExtraCharge = day.extraCharges?.firstWhere(
      (s) => s.selected == true,
      orElse: () => ExtraCharge(),
    );

    return selectedExtraCharge;
  }
}
