import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../../../CommonWidgets/common_appbar.dart';
import 'group_observation_card.dart';

class GroupObservationListScreen extends StatefulWidget {
  final String childId;

  const GroupObservationListScreen({Key? key, required this.childId})
    : super(key: key);

  @override
  State<GroupObservationListScreen> createState() => _GroupObservationListScreenState();
}

class _GroupObservationListScreenState extends State<GroupObservationListScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController groupObservationListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      childInfoController.pageNumberObservation = 1;

      initUpcomingConsultationListScrolling(context);

      await childInfoController.callGroupObservationListAPI(context, widget.childId);
    });
  }

  Future<void> _onRefresh() async {
    childInfoController.groupObservationList.clear();
    childInfoController.replyController.clear();
    childInfoController.pageNumberObservation = 1;
    await childInfoController.callGroupObservationListAPI(context, widget.childId);
  }

  void initUpcomingConsultationListScrolling(BuildContext context) {
    groupObservationListScrollController.addListener(() async {
      if (!groupObservationListScrollController.hasClients) return;

      final position = groupObservationListScrollController.position;

      if (position.pixels >= position.maxScrollExtent - 50) {
        if (childInfoController.isDoctorListPaginationLoading.value &&
            !childInfoController.isPaginationApiCalling.value) {
          childInfoController.isPaginationApiCalling.value = true;

          await childInfoController.callGroupObservationListAPI(
            context,
            widget.childId,
          );

          childInfoController.isPaginationApiCalling.value = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Journey",
        showMenu: false,
        showBack: true,
        showAddButton: false,
        
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: groupObservationListScrollController,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: childInfoController.groupObservationList.length,
                      itemBuilder: (context, index) {
                        return GroupObservationCard(
                          childInfoController: childInfoController,
                          observation:
                              childInfoController.groupObservationList[index],
                          index: index,
                          childId: widget.childId,
                        );
                      },
                    ),
                  ),
                ),

                if (childInfoController.isNewAddedObservationLoading.value)
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: bg_btn_199a8e),
                    ),
                  ),
              ],
            ),

            if (childInfoController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
