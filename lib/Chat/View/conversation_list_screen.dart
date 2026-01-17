import 'package:bloom_kidz/Chat/View/chat_screen.dart';
import 'package:bloom_kidz/Chat/controller/chat_controller.dart';
import 'package:bloom_kidz/Chat/models/conversation_list_response.dart';
import 'package:bloom_kidz/Chat/models/people_list_response.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../../Drawer/app_drawer.dart';
import 'chat_bubble.dart';
import 'chat_header.dart';

import 'package:flutter/material.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  ChatController chatController = Get.find<ChatController>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.callConversationListAPI(context);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white, // 👈 Navigation Drawer
      body: Obx(
              () =>Stack(
        children: [

          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

          Column(
            children: [
              const SizedBox(height: 16),

              /// 👥 Employee List
              Expanded(
                child: ListView.separated(
                  itemCount: chatController.conversationList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return  ConversationTile(conversationData: chatController.conversationList[index],chatController: chatController,);
                  },
                ),
              ),
            ],
          ),

          if(chatController.isLoading.value)Center(child: CircularProgressIndicator(),)
        ],
      )),
    );
  }
}


class ConversationTile extends StatelessWidget {

  final ConversationData conversationData;
  final ChatController chatController;

  const ConversationTile({super.key, required this.conversationData, required this.chatController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ChatScreen(groupId: (conversationData.groupId??0).toString(),))?.then((value) {
          chatController.callConversationListAPI(context);
        });
      },
      child: Card(
        color: Colors.white,
        shadowColor: color_primary,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [

              Icon(Icons.groups, color: color_secondary,),

              const SizedBox(width: 12),

              /// Name & Designation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    BlueLargeBoldText(
                        getMembersName(conversationData.members??[]),
                      fontFamily: fontInterSemiBold
                    ),
                    SizedBox(height: 3),
                    BlackMediumRegularText(
                        conversationData.lastMessage??"",
                      fontSize: 12,
                      color: Colors.black
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 String getMembersName(List<Member> members){
    String membersNameString = members
        ?.where((m) => m.name != null && m.name!.isNotEmpty && m.id != chatController.loginResponse.value.data?.user?.id)
        .map((m) => m.name!)
        .join(', ')
        ?? '';

    return membersNameString;

  }
}



