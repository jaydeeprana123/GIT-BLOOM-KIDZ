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

            if (childInfoController.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }


            if (childInfoController.bookingList.isEmpty) {
              return const SizedBox();
            }

            return Card(
              color: Colors.white,
              shadowColor: color_secondary,
              elevation: 14,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        // DATE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center
                          ,children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color_secondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: BlackMediumRegularText(
                                childInfoController.bookingList[i].planStart ?? "",

                                color: Colors.white,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: BlueLargeBoldText(
                                childInfoController.bookingList[i].statusLabel ??
                                    "",
                                color:
                                (childInfoController.bookingList[i].status ??
                                    "1") ==
                                    "0"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(
                              childInfoController.bookingList[i].days?.length ?? 0,
                                  (dayIndex) {
                                final dayObj =
                                childInfoController.bookingList[i].days![dayIndex];

                                final isSelected = dayIndex == selectedDayIndex;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDayIndex = dayIndex;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color_secondary : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: color_secondary),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// DAY
                                        BlueMediumBoldText(
                                          (dayObj.day ?? '').length >= 3
                                              ? dayObj.day!.substring(0, 3)
                                              : dayObj.day ?? '',
                                          color: isSelected ? Colors.white : Colors.blue,
                                        ),

                                        /// SLOT (Only one)
                                        BlueMediumBoldText(
                                          dayObj.mainSessions?.isNotEmpty == true
                                              ? dayObj.mainSessions![0].label ?? ''
                                              : '',
                                          color: isSelected ? Colors.white : Colors.blue,
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
                ],
              ),
            );
          }),


        ],
      ),
    );
  }
}
