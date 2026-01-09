import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
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

import '../../CommonWidgets/common_appbar.dart';
import '../models/child_info_list_response.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

class ChildDetailsScreen extends StatelessWidget {
  final ChildInfo childInfo;
  final ChildInfoController childInfoController;
  const ChildDetailsScreen({super.key, required this.childInfo, required this.childInfoController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "Child Details",
        showMenu: true,
        showBack: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

          SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                ChildProfileCard(childInfo: childInfo,childInfoController: childInfoController,),
                SizedBox(height: 16),
                ChildOptionsGrid(childId: childInfo.id.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
