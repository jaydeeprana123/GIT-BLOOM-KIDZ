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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController observationListScrollController = ScrollController();

  Future<void> _onRefresh() async {
    newsFeedController.newsFeedList.clear();
    newsFeedController.replyController.clear();
    newsFeedController.pageNumberObservation = 1;
    await newsFeedController.callNewsFeedAPI(context);
  }

  void initUpcomingConsultationListScrolling(BuildContext context) {
    observationListScrollController.addListener(() async {
      if (!observationListScrollController.hasClients) return;

      final position = observationListScrollController.position;

      if (position.pixels >= position.maxScrollExtent - 50) {
        if (newsFeedController.isDoctorListPaginationLoading.value &&
            !newsFeedController.isPaginationApiCalling.value) {
          newsFeedController.isPaginationApiCalling.value = true;

          newsFeedController.callNewsFeedAPI(context);

          newsFeedController.isPaginationApiCalling.value = false;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      newsFeedController.newsFeedList.clear();
      newsFeedController.pageNumberObservation = 1;

      initUpcomingConsultationListScrolling(context);

      newsFeedController.callNewsFeedAPI(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "News Feed",
        showMenu: true,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // 👈 OPEN DRAWER
        },
      ),
      drawer: const AppDrawer(), // 👈 Navigation Drawer
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: color_primary,
                    child: ListView.builder(
                      controller: observationListScrollController,
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
                  ),
                ),

                if (newsFeedController.isNewAddedObservationLoading.value)
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: bg_btn_199a8e),
                    ),
                  ),
              ],
            ),

            if (newsFeedController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
