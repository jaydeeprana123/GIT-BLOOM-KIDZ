import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import 'news_feed_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  NewsFeedController newsFeedController = Get.put(NewsFeedController());

  @override
  void initState() {
    super.initState();

    newsFeedController.callNewsFeedAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(title: "News Feed", showMenu: true),
      body: Obx(
        () => Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: newsFeedController.newsFeedList.length,
              itemBuilder: (context, index) {
                return NewsFeedCard(
                  newsFeed: newsFeedController.newsFeedList[index],
                );
              },
            ),

            if (newsFeedController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
