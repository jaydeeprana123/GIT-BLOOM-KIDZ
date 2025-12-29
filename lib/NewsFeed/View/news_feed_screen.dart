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
import '../../Drawer/app_drawer.dart';
import 'news_feed_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  NewsFeedController newsFeedController = Get.put(NewsFeedController());
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    newsFeedController.callNewsFeedAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(title: "News Feed", showMenu: true, onMenuTap: (){
        _scaffoldKey.currentState?.openDrawer(); // 👈 OPEN DRAWER
      },),
      drawer: const AppDrawer(), // 👈 Navigation Drawer
      body: Obx(
        () => Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: newsFeedController.newsFeedList.length,
              itemBuilder: (context, index) {
                return NewsFeedCard(
                  newsFeedController: newsFeedController,
                  newsFeed: newsFeedController.newsFeedList[index],
                  index: index,
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
