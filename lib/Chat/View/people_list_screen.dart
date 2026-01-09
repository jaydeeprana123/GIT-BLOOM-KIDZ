import 'package:bloom_kidz/Chat/View/chat_screen.dart';
import 'package:bloom_kidz/Chat/controller/chat_controller.dart';
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
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import 'chat_bubble.dart';
import 'chat_header.dart';

import 'package:flutter/material.dart';

class PeopleListScreen extends StatefulWidget {
  const PeopleListScreen({Key? key}) : super(key: key);

  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();

    chatController.callPeopleListAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "Chat", showMenu: true, showBack: true,),
      body: Obx(
              () =>Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),

              /// 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  alignment: Alignment.center,
                  // height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: color_secondary, // 🔵 Blue border
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search Here....",
                          border: InputBorder.none, // important
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontFamily: fontInterRegular,
                            color: light_text_color,
                          ),
                          // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: color_secondary),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 16),

              /// 👥 Employee List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return  ChatUserTile(chatPerson: chatController.peopleList[index],);
                    },
                  ),
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


class ChatUserTile extends StatelessWidget {

  final ChatPerson chatPerson;

  const ChatUserTile({super.key, required this.chatPerson});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ChatScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            /// Avatar
             CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                chatPerson.profileImage??"",
              ),
            ),

            const SizedBox(width: 12),

            /// Name & Designation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                BlueLargeBoldText(
                  chatPerson.name??"",
                  fontFamily: fontInterBold
                ),
                SizedBox(height: 3),
                BlackMediumRegularText(
                  chatPerson.userType??"",
                  fontSize: 12,
                  color: Colors.black
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



