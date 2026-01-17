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
import '../controller/chat_controller.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {

  final ChatController chatController = Get.put(ChatController());
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    chatController.getUserInfo();
    chatController.peopleList.clear();
    chatController.conversationList.clear();
    chatController.tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: chatController.selectedIndex.value,
    );

    chatController.tabController.addListener(() {
      if (!chatController.tabController.indexIsChanging) {
        chatController.selectedIndex.value =
            chatController.tabController.index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {



    return Obx(
            () => DefaultTabController(
      length: 2,
      initialIndex: chatController.selectedIndex.value, // 👈 predefined index
      child: Builder(
        builder: (context) {
          final TabController tabController =
          DefaultTabController.of(context);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              chatController.selectedIndex.value = tabController.index;
              print("Selected tab index: ${tabController.index}");
            }
          });


          return Scaffold(
            key: _scaffoldKey,
            drawer: const AppDrawer(),

            appBar: AppBar(
              backgroundColor: const Color(0xff1f78c8),
              iconTheme:
              const IconThemeData(color: Colors.white),
              title: const Text(
                "Safeguarding",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontInterSemiBold,
                  color: Colors.white,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: color_primary,
                      child: Icon(
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
                  bottom: Radius.circular(34),
                ),
              ),
              bottom:  TabBar(
                controller: chatController.tabController,

                labelColor: Colors.white,                 // selected text
                unselectedLabelColor: Colors.white70,     // unselected text
                indicatorColor: Colors.white,             // underline color
                indicatorWeight: 3,                       // thickness of line

                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: fontInterSemiBold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: fontInterSemiBold,
                ),

                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Conversations"),
                ],
              ),

            ),

            body:  TabBarView(
              controller: chatController.tabController,
              children: [
                PeopleListScreen(),
                ConversationListScreen(),
              ],
            ),
          );
        },
      ),
    ));
  }
}




