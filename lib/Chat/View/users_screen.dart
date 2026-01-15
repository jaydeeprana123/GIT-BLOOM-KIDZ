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
        appBar:  CommonAppBar(title: "Chat", showMenu: true, showBack: false, onMenuTap: (){
          _scaffoldKey.currentState?.openDrawer(); // 👈 OPEN DRAWER
        }),

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



