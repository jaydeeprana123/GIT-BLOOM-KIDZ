import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../../Drawer/app_drawer.dart';
import 'child_.card.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  ChildInfoController childInfoController = Get.put(ChildInfoController());
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.callChildInfoAPI(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar:  CommonAppBar(title: "Child Info", showMenu: true, onMenuTap: (){
        _scaffoldKey.currentState?.openDrawer(); // 👈 OPEN DRAWER
      }),
      drawer: const AppDrawer(), // 👈 Navigation Drawer
      body: Obx(
        () => Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: childInfoController.childInfoList.length,
              itemBuilder: (context, index) {
                return ChildCard(
                  childInfo: childInfoController.childInfoList[index],
                  childInfoController: childInfoController,
                );
              },
            ),

            if(childInfoController.isLoading.value)Center(child: CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }
}
