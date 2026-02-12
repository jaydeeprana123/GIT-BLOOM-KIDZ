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
import 'observation_add_screen.dart';
import 'observation_card.dart';

class ObservationListScreen extends StatefulWidget {
  final String childId;

  const ObservationListScreen({Key? key, required this.childId})
    : super(key: key);

  @override
  State<ObservationListScreen> createState() => _ObservationListScreenState();
}

class _ObservationListScreenState extends State<ObservationListScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController observationListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      childInfoController.pageNumberObservation = 1;

      initUpcomingConsultationListScrolling(context);

      await childInfoController.callObservationListAPI(context, widget.childId);
    });
  }

  Future<void> _onRefresh() async {
    childInfoController.observationList.clear();
    childInfoController.pageNumberObservation = 1;
    await childInfoController.callObservationListAPI(context);
  }

  void initUpcomingConsultationListScrolling(BuildContext context) {
    observationListScrollController.addListener(() async {
      if (!observationListScrollController.hasClients) return;

      final position = observationListScrollController.position;

      if (position.pixels >= position.maxScrollExtent - 50) {
        if (childInfoController.isDoctorListPaginationLoading.value &&
            !childInfoController.isPaginationApiCalling.value) {
          childInfoController.isPaginationApiCalling.value = true;

          await childInfoController.callObservationListAPI(
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
        showAddButton: true,
        onAddButtonTap: () {
          Get.to(ObservationAddScreen(childId: widget.childId))?.then((value) {
            childInfoController.pageNumberObservation = 1;
            childInfoController.callObservationListAPI(context, widget.childId);
          });
        },
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
                      controller: observationListScrollController,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: childInfoController.observationList.length,
                      itemBuilder: (context, index) {
                        return ObservationCard(
                          childInfoController: childInfoController,
                          observation:
                              childInfoController.observationList[index],
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
