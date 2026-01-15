import 'package:bloom_kidz/Chat/View/conversation_list_screen.dart';
import 'package:bloom_kidz/Chat/View/people_list_screen.dart';
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


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Drawer/app_drawer.dart';


class UsersScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
   UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),


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
          actions: [
              InkWell(
                onTap: (){
                  _scaffoldKey.currentState?.openDrawer();
                }, // 👈 callback call
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: color_primary,
                    child: const Icon(
                      Icons.menu_open_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

          ],
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
              Tab(text: "All"),
              Tab(text: "Conversations"),
            ],
          ),
        ),

        body:  TabBarView(
          children: [
            PeopleListScreen(),
            ConversationListScreen(),
          ],
        ),
      ),
    );
  }
}



