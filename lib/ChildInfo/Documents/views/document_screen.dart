import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
import 'document_card.dart';


class DocumentsScreen extends StatefulWidget {
  final String childId;

  const DocumentsScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    childInfoController.callGetDocumentsAPI(context, widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "Documents", showMenu: true, showBack: true,),
      body: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

          Obx(
                  () =>Stack(
            children: [
              ListView.builder(
                padding:  EdgeInsets.symmetric(vertical: 10),
                itemCount: childInfoController.documentList.length,
                itemBuilder: (context, index) {
                  return  DocumentCard(documentData: childInfoController.documentList[index], childId: widget.childId,);
                },
              ),

              if(childInfoController.isLoading.value)Center(child: CircularProgressIndicator(),)

            ],
          )),
        ],
      ),
    );
  }
}
