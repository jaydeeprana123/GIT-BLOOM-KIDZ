import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/ChildInfo/SafeGuarding/views/accident_list_screen.dart';
import 'package:bloom_kidz/ChildInfo/SafeGuarding/views/medications_list_screen.dart';
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
import '../../../CommonWidgets/black_small_regular_text.dart';
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

import '../models/accident_list_response.dart';
import '../models/medication_list_response.dart';



class SafeguardingScreen extends StatelessWidget {
  
  final String childId;
  
  const SafeguardingScreen({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar : AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: const Color(0xff1f78c8),
          elevation: 0,

          /// 👇 THIS MAKES BACK ARROW WHITE
          iconTheme: const IconThemeData(color: Colors.white),

          titleSpacing: 0,
          title: Text(
            "Safeguarding",
            style: const TextStyle(
              fontSize: 18,
              fontFamily: fontInterSemiBold,
              color: Colors.white,
            ),
          ),

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(34), // curved bottom
            ),
          ),

          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontFamily: fontInterSemiBold
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
                fontFamily: fontInterSemiBold
            ),
            tabs: [
              Tab(text: "Medications"),
              Tab(text: "Accidents"),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            MedicationListScreen(childId: childId),
            AccidentListScreen(childId: childId),
          ],
        ),
      ),
    );
  }
}



