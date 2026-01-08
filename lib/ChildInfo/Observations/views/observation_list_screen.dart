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

  const ObservationListScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<ObservationListScreen> createState() => _ObservationListScreenState();
}

class _ObservationListScreenState extends State<ObservationListScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.callObservationListAPI(context, widget.childId);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Journey", showMenu: false, showBack: true,showAddButton: true, onAddButtonTap: (){
        Get.to(ObservationAddScreen(childId: widget.childId,));
      },),
      body: Obx(
        () => Stack(
          children: [

            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: childInfoController.observationList.length,
              itemBuilder: (context, index) {
                return ObservationCard(
                  childInfoController: childInfoController,
                  observation: childInfoController.observationList[index],
                  index: index,
                  childId: widget.childId,
                );
              },
            ),

            if (childInfoController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
