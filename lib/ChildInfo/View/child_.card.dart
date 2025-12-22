import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/black_small_medium_text.dart';
import '../../CommonWidgets/black_small_regular_text.dart';
import 'child_details_screen.dart';

class ChildCard extends StatelessWidget {
  final String image;

  const ChildCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ChildDetailsScreen());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 35, backgroundImage: AssetImage(image)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlueLargeBoldText("Child Name"),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.school, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      BlackSmallRegularText("Explorers"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.sick, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      BlackSmallRegularText("Sick"),
                      SizedBox(width: 12),
                      Icon(Icons.beach_access, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      BlackSmallRegularText("Holiday"),
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
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(20),
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
