import 'package:bloom_kidz/ChildInfo/ExtraBookings/views/add_extra_booking_screen.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
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
            if (controller.extraBookingList.isEmpty) {
              return const Center(
                child: Text(
                  'No Extra Bookings Found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (controller.isLoading.value) {
              const Center(child: CircularProgressIndicator());
            }

            return Card(
              color: Colors.white,
              shadowColor: color_secondary,
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.extraBookingList.length,
                itemBuilder: (context, index) {
                  final booking = controller.extraBookingList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlueMediumBoldText(booking.day ?? ""),

                        SizedBox(height: 6),

                        for (
                          int i = 0;
                          i <
                              (controller.extraBookingList[index].sessions ??
                                      [])
                                  .length;
                          i++
                        )
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlueMediumBoldText(
                                '${(controller.extraBookingList[index].sessions?[i].startTime ?? "")}'
                                ' - ${(controller.extraBookingList[index].sessions?[i].endTime ?? "")}',
                              ),
                              BlueMediumBoldText(
                                '£${controller.extraBookingList[index].sessions?[i].price ?? "0"}',
                              ),
                            ],
                          ),

                        const SizedBox(height: 12),

                        for (
                          int i = 0;
                          i <
                              (controller
                                          .extraBookingList[index]
                                          .extraCharges ??
                                      [])
                                  .length;
                          i++
                        )
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlueMediumBoldText(
                                '${(controller.extraBookingList[index].extraCharges?[i].name ?? "")}',
                              ),
                              BlueMediumBoldText(
                                '£${controller.extraBookingList[index].extraCharges?[i].price ?? "0"}',
                              ),
                            ],
                          ),

                        if ((controller.extraBookingList[index].sessions ?? [])
                                .isEmpty &&
                            (controller.extraBookingList[index].extraCharges ??
                                    [])
                                .isEmpty)
                          BlueMediumBoldText(
                            'No sessions & extra charges available',
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
