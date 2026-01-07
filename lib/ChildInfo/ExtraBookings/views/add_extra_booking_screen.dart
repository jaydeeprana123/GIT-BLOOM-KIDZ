import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
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
import '../../../CommonWidgets/date_field.dart';
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

import '../models/extra_bookings_request.dart';


class AddExtraBookingScreen extends StatefulWidget {
  final String childId;

  const AddExtraBookingScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<AddExtraBookingScreen> createState() => _AddExtraBookingScreenState();
}

class _AddExtraBookingScreenState extends State<AddExtraBookingScreen> {
  ChildInfoController controller = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();


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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CommonAppBar(
        title: 'Add Extra Booking',
        showBack: true,
      ),
      body: Obx(() {
        return Stack(
          children: [

            Positioned.fill(
              child: SvgPicture.asset(app_bg, fit: BoxFit.cover),
            ),

            Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => DateField(
                          label: "Plan Start",
                          value: controller.planStartDate.value,
                          onTap: () => pickDate(
                            context,
                            controller.planStartDate.value,
                            controller.setPlanStart,
                          ),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => DateField(
                          label: "Plan End",
                          value: controller.planEndDate.value,
                          onTap: () async{ await pickDate(
                            context,
                            controller.planEndDate.value,
                            controller.setPlanEnd,
                          );

                          controller.callGetPriceBandAPI(context, widget.childId);

                            },
                        )),
                      ),
                    ],
                  ),
                ),



                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.priceBandList.length,
                    itemBuilder: (_, index) {
                      final day = controller.priceBandList[index];
                  
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                  
                              /// DAY TITLE
                              BlueLargeBoldText(
                                day.day ?? "",
                                fontSize: 18
                              ),
                  
                              const SizedBox(height: 8),
                  
                              /// SESSIONS
                              BlackMediumBoldText("Sessions",
                                color: Colors.black),
                              Wrap(
                                spacing: 8,
                                children: day.sessions!.map((session) {
                                  final isSelected = controller
                                      .selectedSessions[day.day]
                                      ?.contains(session.id) ??
                                      false;
                  
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ChoiceChip(
                                      label: Column(
                                        children: [
                                          BlackMediumBoldText(
                                            "${session.startTime}-${session.endTime} ",
                                              fontSize: 12,
                                              color: isSelected?Colors.white:Colors.black
                                          ),

                                          BlackMediumBoldText(
                                            "(£${session.price})",
                                            fontSize: 12,
                                            color: isSelected?Colors.white:Colors.black
                                          ),

                                        ],
                                      ),
                                      selected: isSelected,
                                      selectedColor: color_secondary,
                                        checkmarkColor: Colors.white,
                                      onSelected: (_) {
                                        controller.toggleSession(day.day!, session.id??0);
                                        setState(() {

                                        });
                                      }
                                          ,
                                    ),
                                  );
                                }).toList(),
                              ),
                  
                              const SizedBox(height: 10),
                  
                              /// EXTRA CHARGES
                               BlackMediumBoldText("Extra Charges",
                                  color: Colors.black),
                              Wrap(
                                spacing: 8,
                                children: day.extraCharges!.map((charge) {
                                  final isSelected = controller
                                      .selectedExtraCharges[day.day]
                                      ?.contains(charge.id) ??
                                      false;
                  
                                  return FilterChip(
                                    label: BlackMediumBoldText(
                                      "${charge.name} (£${charge.price})",
                                        fontSize: 12,
                                        color: isSelected?Colors.white:Colors.black

                                    ),
                                    selected: isSelected,
                                    selectedColor: color_secondary,
                                      checkmarkColor: Colors.white,
                                    onSelected: (_) {
                                      controller.toggleExtraCharge(day.day!, charge.id??0);
                                      setState(() {

                                      });
                                    }
                                       ,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                CommonGradientButton(
                  btnTitle: "Submit  (£${controller.totalAmount.value})",
                  onPressed: () {

                    controller.callAddExtraBookingsAPI(context, (controller.buildRequest()), widget.childId);

                    // print(extraBookingsRequestToJson(controller.buildRequest()));
                  },
                )

              ],
            ),

            if(controller.isLoading.value)Center(child: CircularProgressIndicator(),)
          ],
        );
      }),

    );
  }
}



