import 'package:bloom_kidz/Chat/controller/chat_controller.dart';
import 'package:bloom_kidz/Chat/models/group_chat_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../../CommonWidgets/common_widget.dart';
import 'chat_bubble.dart';
import 'chat_header.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;

  const ChatScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = Get.find<ChatController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.scrollController = ScrollController();
      chatController.getUserInfo();
      if (widget.groupId.isNotEmpty) {
        chatController.callGetGroupChatAPI(context, widget.groupId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "Chat",
        showMenu: false,
        showBack: true,
      ),
      body: Obx(
              () =>Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.fill)),

          Card(
            color: Colors.white,
            shadowColor: color_secondary,
            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                22,
              ), // change 16 to any radius you like
            ),
            child: Column(
              children: [
                const ChatHeader(),
                const Divider(height: 1),
                Expanded(child: _chatList()),
                _replyBox(),
              ],
            ),
          ),

          if(chatController.isLoading.value)Center(child: CircularProgressIndicator(),)
        ],
      )),
    );
  }

  /// 🔹 Chat Messages
  Widget _chatList() {
    return ListView.builder(
      controller: chatController.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          (chatController.groupChatResponse.value.data?.messages ?? []).length,
      itemBuilder: (context, index) {

        final messages =
            chatController.groupChatResponse.value.data?.messages ?? [];

        final currentMessage = messages[index];
        final previousMessage =
        index > 0 ? messages[index - 1] : null;

        /// ✅ WhatsApp-style condition
        final bool showSenderName =
            index == 0 ||
                currentMessage.senderId != previousMessage?.senderId;

        return ChatBubble(
          message:
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .message ??
              "",
          isSender:
              chatController.loginResponse.value.data?.user?.id ==
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .senderId,
          time: getTimeInAmPM(
            chatController
                    .groupChatResponse
                    .value
                    .data
                    ?.messages?[index]
                    .createdAt ??
                DateTime(2026),
          ),
          isGroup: true,
          nameOfUser:
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .senderName ??
              "",
          showSenderName: showSenderName,
        );
      },
    );
  }

  /// 🔹 Reply Box
  Widget _replyBox() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xff1f78c8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatController.messageController.value,
                decoration: const InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xff1f78c8)),
              onPressed: () {
                chatController.callSendMessageInGroupAPI(context, (chatController.groupChatResponse.value.data?.group?.id??0).toString(), chatController.messageController.value.text);
              },
            ),
          ],
        ),
      ),
    );
  }


}
