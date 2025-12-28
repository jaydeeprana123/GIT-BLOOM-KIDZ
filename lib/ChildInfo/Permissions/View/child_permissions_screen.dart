import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/black_medium_regular_text.dart';
import '../../../CommonWidgets/blue_large_bold_text.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChildrenPermissionScreen extends StatefulWidget {
  final String childId;

  const ChildrenPermissionScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<ChildrenPermissionScreen> createState() => _ChildrenPermissionScreenState();
}

class _ChildrenPermissionScreenState extends State<ChildrenPermissionScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    childInfoController.callGetChildPermissionsAPI(context, widget.childId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "Child Permissions", showMenu: true, showBack: true,),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 Background SVG
            Positioned.fill(
              child: SvgPicture.asset(
                app_bg,
                fit: BoxFit.cover,
              ),
            ),

            Obx(
                    () =>Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: childInfoController.childPermissionList.length,
                  itemBuilder: (context, index) {
                    return _permissionCard(childInfoController.childPermissionList[index]);
                  },
                ),

                if(childInfoController.isLoading.value)Center(child: CircularProgressIndicator(),)
              ],
            )),
          ],
        ),
      ),

    );
  }

  /// 🧾 Permission Card
  Widget _permissionCard(ChildPermission childPermission) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: color_secondary,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlueMediumBoldText(
                    childPermission.name??"",
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    _yesNoButton("YES", true, childPermission.id.toString()),
                    const SizedBox(width: 6),
                    _yesNoButton("NO", false, childPermission.id.toString()),
                  ],
                ),
              ],
            ),

            // const SizedBox(height: 10),

            /// Description
            Html(
              data: childPermission.description??"",
              style: {
                "*": Style(
                  fontSize: FontSize(13),
                  color: text_color,
                  lineHeight: LineHeight(1.4),
                ),
              },
            )
          ],
        ),
      ),
    );
  }

  /// YES / NO Button
  Widget _yesNoButton(String text, bool selected, String permissionId) {
    return InkWell(
      onTap: (){
        showWarningDialog(
          context: context,
          title: "Confirmation",
          message: selected?"Are you sure you want to approve this?":"Are you sure you want to reject this?",
          onYes: () {
            childInfoController.callConfirmPermissionAPI(context, widget.childId, permissionId, selected);
          },
        );

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ?color_secondary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color_secondary),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : color_secondary,
          ),
        ),
      ),
    );
  }


  void showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onYes,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: BlueLargeBoldText(title),
          content: BlackMediumRegularText(
            message,
            color: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("NO"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color_secondary,
              ),
              onPressed: () {
                Navigator.pop(context);
                onYes();
              },
              child: const Text("YES", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

}

