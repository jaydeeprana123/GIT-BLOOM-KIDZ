import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/child_activity_response.dart';
import 'models/timeline_item.dart';

class TimelineCard extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;

  const TimelineCard({
    super.key,
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight( // ⭐ KEY LINE
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIMELINE
          SizedBox(
            width: 40,
            child: Column(
              children: [

                SizedBox(height: 2,),
                exactTimelineDot(),

                /// LINE MATCHES CARD HEIGHT
                // if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: EdgeInsets.only(bottom: 20),
                      color: color_secondary,
                    ),
                  ),
              ],
            ),
          ),

          /// CARD
          Expanded(
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.only(right: 16, bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [


                  Container(
                    padding: EdgeInsets.all(8),
                    child: item.title == "Nappy/Toilet"?Align(alignment: Alignment.bottomRight, child: SvgPicture.asset(NappyIcon,width: 70,)):item.title == "Activity"?Align(alignment: Alignment.bottomRight,child: SvgPicture.asset(SignOutIcon,width: 70,)):Align(alignment: Alignment.bottomRight,child: SvgPicture.asset(MealIcon,width: 70,)),
                      
                  ),



                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        BlueLargeBoldText(item.title),

                        const SizedBox(height: 8),

                        /// DETAILS
                        ...item.subItems.map(
                              (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// SUBTITLE + TIME
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              BlackMediumBoldText(
                                                e.subTitle,
                                                fontSize: (item.title == "Nappy/Toilet" || item.title == "Activity")?12:13,
                                                color: Colors.black,
                                              ),

                                              if ((e.statusForNappy ?? "").isNotEmpty)
                                                BlackMediumBoldText(
                                                  " (${e.statusForNappy})",
                                                  fontSize: (item.title == "Nappy/Toilet" || item.title == "Activity")?12:13,
                                                  color: Colors.black,
                                                ),
                                            ],
                                          ),
                                        ),

                                        BlueMediumBoldText(
                                          e.time,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    /// BULLETS
                                    if ((e.details).isNotEmpty)
                                      ...e.details.map(
                                            (f) => Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                             if((f != "No food recorded")) const Icon(
                                                Icons.circle,
                                                size: 6,
                                                color: Color(0xFF1E78B7),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: BlackSmallMediumText(
                                                  f,
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                                         ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget exactTimelineDot() {
    return SizedBox(
      width: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Vertical line (behind)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                height: double.infinity,
                color: color_secondary,
              ),
            ),
          ),

          /// Outer circle (hollow)
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: color_secondary,
                width: 2,
              ),
            ),
          ),

          /// Inner filled dot
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: color_secondary,
            ),
          ),
        ],
      ),
    );
  }

}

