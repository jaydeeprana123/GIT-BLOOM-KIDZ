import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import '../../CommonWidgets/black_small_medium_text.dart';
import '../../CommonWidgets/black_small_regular_text.dart';
import '../../CommonWidgets/blue_large_bold_text.dart';

class ChildProfileCard extends StatelessWidget {
  const ChildProfileCard({super.key});

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
              image: AssetImage(child1),
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
                BlueLargeBoldText("Child Name", fontSize: 15),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.school, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    BlackSmallRegularText(
                      "Explorers",
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.sick, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    BlackSmallRegularText(
                      "Sick",
                      fontSize: 11,
                      color: Colors.black,
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.beach_access, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    BlackSmallRegularText(
                      "Holiday",
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _actionButton(Icons.chat, "Chat"),
                    const SizedBox(width: 8),
                    _actionButton(Icons.location_pin, "Collection Pin"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          BlackSmallMediumText(text, color: Colors.white),
        ],
      ),
    );
  }
}
