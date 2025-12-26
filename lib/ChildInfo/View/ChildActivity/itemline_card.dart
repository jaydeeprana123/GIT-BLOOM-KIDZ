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

import '../../models/activity_response.dart';
import 'models/timeline_item.dart';

class TimelineCard extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;

  const TimelineCard({super.key, required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TIMELINE
        SizedBox(
          width: 40,
          child: Column(
            children: [
              _dot(),
              if (!isLast)
                Container(height: 120, width: 2, color: Colors.blue.shade300),
            ],
          ),
        ),

        /// CARD
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(right: 16, bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE + TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (item.icon != null)
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 8),
                            //   child: Image.network(
                            //     item.icon ?? "",
                            //     width: 20,
                            //     height: 20,
                            //   ),
                            // ),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E78B7),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E78B7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// DETAILS
                  ...item.details.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: Color(0xFF1E78B7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 3),
      ),
    );
  }
}
