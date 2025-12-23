import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';

class NewsFeedCard extends StatelessWidget {
  const NewsFeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: color_primary,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _titleText(),
          _image(),
          _description(),
          _actions(),
          _replyBox(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/user.jpg"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlackLargeBoldText("Dummy Name"),
                SizedBox(height: 2),
                BlueSmallRegularText("10% • 26-11-2025"),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  Widget _titleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: BlueMediumBoldText(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      ),
    );
  }

  Widget _image() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/news.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: BlackMediumBoldText(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        fontSize: 12,
      ),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.favorite, color: color_secondary, size: 16),
          SizedBox(width: 4),
          BlueMediumRegularText("10"),
          SizedBox(width: 16),
          Icon(Icons.chat, size: 16, color: color_secondary),
          SizedBox(width: 4),
          BlueMediumRegularText("3"),
        ],
      ),
    );
  }

  Widget _replyBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: color_secondary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
