import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import 'news_feed_card.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(title: "News Feed", showMenu: true),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return const NewsFeedCard();
        },
      ),
    );
  }
}
