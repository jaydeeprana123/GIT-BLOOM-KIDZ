import 'package:bloom_kidz/ChildInfo/About/views/add_holiday_dialog.dart';
import 'package:bloom_kidz/ChildInfo/About/views/collection_pin_dialog.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../CommonWidgets/black_small_medium_text.dart';
import '../../CommonWidgets/black_small_regular_text.dart';
import '../../CommonWidgets/blue_large_bold_text.dart';
import '../models/child_info_list_response.dart';

class ChildProfileCard extends StatelessWidget {
  final ChildInfo childInfo;
  final ChildInfoController childInfoController;

  const ChildProfileCard({
    super.key,
    required this.childInfo,
    required this.childInfoController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100, // same as diameter of circle avatar (2 * radius)
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              12,
            ), // change 12 for more/less rounding
            image: DecorationImage(
              image: NetworkImage(childInfo.profile ?? ""),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlueLargeBoldText(
                  "${childInfo.firstName ?? ""} ${childInfo.lastName ?? ""}",
                  fontSize: 15,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SvgPicture.asset(explorersIcon, width: 14, ),
                    // Icon(Icons.school, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    BlackSmallRegularText(
                      childInfo.room ?? "",
                      fontSize: 11,
                      color: Colors.black,
                        fontFamily: fontInterMedium
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(icon_sick, width: 14),
                    // Icon(Icons.sick, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        showLeaveDialog(
                          context,
                          childInfoController,
                          false,
                          childInfo.id.toString(),
                        );
                      },
                      child: BlackSmallRegularText(
                        "Sick",
                        fontSize: 11,
                        color: Colors.black,
                          fontFamily: fontInterMedium
                      ),
                    ),
                    SizedBox(width: 12),
                    SvgPicture.asset(holidayIcon, width: 14),
                    SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        showLeaveDialog(
                          context,
                          childInfoController,
                          true,
                          childInfo.id.toString(),
                        );
                      },
                      child: BlackSmallRegularText(
                        "Holiday",
                        fontSize: 11,
                        color: Colors.black,
                          fontFamily: fontInterMedium
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _actionButton(commentIcon, "Chat"),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {

                        childInfoController.collectionPinController.value.text = "";

                        showCollectionPinDialog(
                          context,
                          childInfoController,
                          childInfo.id.toString(),
                        );
                      },
                      child: _actionButton(
                        pin,
                        "Collection Pin",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showCollectionPinDialog(
    BuildContext context,
    ChildInfoController childInfoController,
    String childId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CollectionPinDialog(
          controller: childInfoController,
          childId: childId,
        );
      },
    );
  }

  void showLeaveDialog(
    BuildContext context,
    ChildInfoController childInfoController,
    bool isHoliday,
    String childId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddHolidayDialog(
          controller: childInfoController,
          childId: childId,
          isHoliday: isHoliday,
        );
      },
    );
  }

  Widget _actionButton(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon, color: Colors.white, width: 14),
          const SizedBox(width: 4),
          BlackSmallMediumText(text, color: Colors.white),
        ],
      ),
    );
  }
}
