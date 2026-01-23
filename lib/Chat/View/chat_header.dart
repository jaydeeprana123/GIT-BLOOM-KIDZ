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
import '../models/send_message_not_group_request.dart';

class ChatHeader extends StatelessWidget {
  ChatController chatController = Get.find<ChatController>();
  SendMessageNotGroupRequest? sendMessageNotGroupRequest;
  ChatHeader({super.key, required this.sendMessageNotGroupRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color_secondary,
            child: sendMessageNotGroupRequest != null
                ? Icon(
                    (sendMessageNotGroupRequest?.receivers ?? []).length == 1
                        ? Icons.person
                        : Icons.group,
              color: Colors.white,
                  )
                : Icon(
                    (chatController.groupChatResponse.value.data?.members ?? [])
                                .length ==
                            2
                        ? Icons.person
                        : Icons.group,
                color: Colors.white
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlueLargeBoldText(
                  sendMessageNotGroupRequest != null
                      ? chatController.getReceiverNames(
                          sendMessageNotGroupRequest?.receivers ?? [],
                        )
                      : getMembersName(
                          (chatController
                                  .groupChatResponse
                                  .value
                                  .data
                                  ?.members ??
                              []),
                        ),
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

  String getMembersName(List<Member> members) {
    String membersNameString =
        members
            ?.where(
              (m) =>
                  m.name != null &&
                  m.name!.isNotEmpty &&
                  m.id != chatController.loginResponse.value.data?.user?.id,
            )
            .map((m) => m.name!)
            .join(', ') ??
        '';

    return membersNameString;
  }
}
