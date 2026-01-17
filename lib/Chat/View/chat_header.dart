import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
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

import '../controller/chat_controller.dart';
import '../models/conversation_list_response.dart';

class ChatHeader extends StatelessWidget {

  ChatController chatController = Get.find<ChatController>();

   ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
           CircleAvatar(
            radius: 22,
            backgroundColor: color_secondary,
            child: Text(
                (chatController.groupChatResponse.value.data?.group?.name??"")
              .isNotEmpty
                  ? (chatController.groupChatResponse.value.data?.group?.name??"")[0].toUpperCase()
                  : '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                BlueLargeBoldText(
                  getMembersName((chatController.groupChatResponse.value.data?.members??[])),
      
                ),
                // SizedBox(height: 2),
                // BlackSmallRegularText(
                //   "Employees Designation",
                //  color: Colors.black
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getMembersName(List<Member> members){
    String membersNameString = members
        ?.where((m) => m.name != null && m.name!.isNotEmpty && m.id != chatController.loginResponse.value.data?.user?.id)
        .map((m) => m.name!)
        .join(', ')
        ?? '';

    return membersNameString;

  }
}



