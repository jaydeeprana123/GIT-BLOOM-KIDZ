import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String nameOfUser;
  final String time;
  final bool isGroup;
  final bool showSenderName;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.nameOfUser,
    required this.time,
    required this.isGroup,
    required this.showSenderName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          if (isGroup && showSenderName) BlueMediumBoldText(
              nameOfUser,
              color: color_secondary,
              fontSize: 12
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: BlackSmallRegularText(
                time,
                color: Colors.black

            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 12),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isSender
                  ? color_primary
                  : color_secondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: BlackMediumRegularText(
              message,
             color: Colors.white,
              fontSize: 12
            ),
          ),

        ],
      ),
    );
  }
}



