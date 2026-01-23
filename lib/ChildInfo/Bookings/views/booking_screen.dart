import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
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

class BookingScreen extends StatefulWidget {
  final String childId;

  const BookingScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedDayIndex = 0;
  int selectedSlotIndex = 3;

  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.bookingList.clear();
      childInfoController.callGetBookingsAPI(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CommonAppBar(
        title: "Bookings",
        showMenu: false,
        showBack: true,
      ),

      body: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.fill)),

          Obx(() {
            if (childInfoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (childInfoController.bookingList.isEmpty) {
              return const SizedBox();
            }

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    for (
                      int i = 0;
                      i < childInfoController.bookingList.length;
                      i++
                    )
                      Column(
                        children: [
                          /// DATE + STATUS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlackMediumRegularText(
                                  childInfoController
                                          .bookingList[i]
                                          .planStart ??
                                      "",
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: BlueLargeBoldText(
                                    childInfoController
                                            .bookingList[i]
                                            .statusLabel ??
                                        "",
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// DAYS WITH TIMELINE
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TIMELINE DOTS
                                Column(
                                  children: List.generate(
                                    childInfoController
                                            .bookingList[i]
                                            .days
                                            ?.length ??
                                        0,
                                    (index) => Column(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: color_secondary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        if (index !=
                                            (childInfoController
                                                    .bookingList[i]
                                                    .days!
                                                    .length -
                                                1))
                                          Container(
                                            width: 2,
                                            height: 42,
                                            color: color_secondary.withOpacity(
                                              0.4,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// DAY LIST
                                Expanded(
                                  child: Column(
                                    children: List.generate(
                                      childInfoController
                                              .bookingList[i]
                                              .days
                                              ?.length ??
                                          0,
                                      (dayIndex) {
                                        final dayObj = childInfoController
                                            .bookingList[i]
                                            .days![dayIndex];

                                        final isSelected =
                                            dayIndex == selectedDayIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDayIndex = dayIndex;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: isSelected
                                                  ? const LinearGradient(
                                                      colors: [
                                                        Color(0xFFF9B233),
                                                        Color(0xFFFFD37A),
                                                      ],
                                                    )
                                                  : null,
                                              color: isSelected
                                                  ? null
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: color_secondary,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                /// DAY
                                                Text(
                                                  (dayObj.day ?? '').length >= 3
                                                      ? dayObj.day!.substring(
                                                          0,
                                                          3,
                                                        )
                                                      : dayObj.day ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.orange,
                                                  ),
                                                ),

                                                /// TIME
                                                Text(
                                                  dayObj
                                                              .mainSessions
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? dayObj
                                                                .mainSessions![0]
                                                                .label ??
                                                            ''
                                                      : '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? Colors.black87
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
