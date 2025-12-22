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

import 'chat_bubble.dart';
import 'chat_header.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final TextEditingController messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xff030b4f),
        elevation: 0,
        title: const Text(
          "Chat",
          style: TextStyle(fontSize: 18, fontFamily: fontInterSemiBold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color(0xff43b8a6),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const ChatHeader(),
          const Divider(height: 1),
          Expanded(child: _chatList()),
          _replyBox(),
        ],
      ),

    );
  }

  /// 🔹 Chat Messages
  Widget _chatList() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ChatBubble(
          message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          isSender: false,
          time: "18:57",
        ),
        ChatBubble(
          message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          isSender: true,
          time: "18:57",
        ),
        ChatBubble(
          message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          isSender: false,
          time: "18:57",
        ),
      ],
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
                controller: messageCtrl,
                decoration: const InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xff1f78c8)),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}


