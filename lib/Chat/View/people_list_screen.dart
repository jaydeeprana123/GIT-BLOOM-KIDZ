import 'package:bloom_kidz/Chat/View/chat_screen.dart';
import 'package:bloom_kidz/Chat/controller/chat_controller.dart';
import 'package:bloom_kidz/Chat/models/conversation_list_response.dart';
import 'package:bloom_kidz/Chat/models/people_list_response.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../../Drawer/app_drawer.dart';
import '../models/send_message_not_group_request.dart';
import 'chat_bubble.dart';
import 'chat_header.dart';

import 'package:flutter/material.dart';

class PeopleListScreen extends StatefulWidget {
  const PeopleListScreen({Key? key}) : super(key: key);

  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  ChatController chatController = Get.find<ChatController>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.callPeopleListAPI(context);
      chatController.callConversationListAPI(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // 👈 Navigation Drawer
      body: Obx(
              () =>
              Stack(
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
                                controller: chatController.searchController.value,
                                onChanged: (value){
                                  chatController.filterPeople(value);
                                },
                                decoration: InputDecoration(
                                  hintText: "Search Here....",
                                  border: InputBorder.none,
                                  // important
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: fontInterRegular,
                                    color: light_text_color,
                                  ),
                                  // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                        Icons.search, color: color_secondary),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 👥 Employee List
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ListView.separated(
                            itemCount: chatController.peopleList.length,
                            separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                            itemBuilder: (context, index) {
                              return ChatUserTile(chatPerson: chatController
                                  .peopleList[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),


                  if(chatController.isLoading.value)Center(
                    child: CircularProgressIndicator(),)
                ],
              )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedPersons.isEmpty) {
            snackBarRapid(context, "Select person first");
          } else if (selectedPersons.length == 1) {
            List<ConversationData> conversationList =  getGroupForSingle(selectedPersons[0].id??0);

            if(conversationList.length == 1){
              printData("get conversationList", "1");
              Get.to(ChatScreen(groupId: (conversationList[0].groupId??0).toString(),))?.then((value) {
                chatController.callConversationListAPI(context);
              });
            }else if(conversationList.length > 1){

              printData("get conversationList", "more than 1");
              chatController.tabController.animateTo(1); // ✅ SWITCH TAB
            }else{

              printData("get conversationList", "not available");

              chatController.callConversationListAPI(context,selectedPersons: selectedPersons);
            }

          }else{

            List<ConversationData> conversationList =  getExactGroupConversation(selectedPersons);
            printData("conversationList length", conversationList.length.toString());
            if(conversationList.length == 1){

              Get.to(ChatScreen(groupId: (conversationList[0].groupId??0).toString(),))?.then((value) {
                chatController.callConversationListAPI(context);
              });
            }else if(conversationList.length > 1){
              chatController.tabController.animateTo(1); // ✅ SWITCH TAB
            }else{

              chatController.callConversationListAPI(context, selectedPersons: selectedPersons);
            }
          }
        },
        child: Icon(Icons.arrow_forward, color: Colors.white,),
        backgroundColor: color_secondary,),
    );
  }

  /// ✅ Get selected persons
  List<ChatPerson> get selectedPersons {
    return chatController.peopleList
        .where((person) => person.isSelected == true)
        .toList();
  }

  List<ConversationData> getGroupForSingle(int userId) {
    return chatController.conversationList
        .where((conversation) =>
    conversation.isGroup == "single" &&
        (conversation.members?.any(
              (member) => member.id == userId,
        ) ??
            false))
        .toList();
  }


  List<ConversationData> getExactGroupConversation(
      List<ChatPerson> users,
      ) {

    List<ConversationData> availableConversations = [];


    // convert selected users to ID set
    final Set<int> userIdSet = users
        .map((u) => u.id)
        .whereType<int>()
        .toSet();


    userIdSet.add(chatController.loginResponse.value.data?.user?.id??0);

    printData("userIdSet length", userIdSet.length.toString());

    return chatController.conversationList.where((conversation) {
      if (conversation.isGroup != "group") return false;

      final members = conversation.members;

      printData("members", (members?.length??0).toString());

      if (members == null) return false;

      final Set<int> memberIdSet = members
          .map((m) => m.id)
          .whereType<int>()
          .toSet();


      printData("memberIdSet", (memberIdSet.length??0).toString());

      if(memberIdSet.containsAll(userIdSet) && memberIdSet.length == userIdSet.length){
        availableConversations.add(conversation);

        printData("memberIdSet", "trueeeee");
      }

      // EXACT MATCH: count + same IDs
      return memberIdSet.length == userIdSet.length &&
          memberIdSet.containsAll(userIdSet);
    }).toList();
  }




}

class ChatUserTile extends StatefulWidget {
  final ChatPerson chatPerson;
  const ChatUserTile({Key? key, required this.chatPerson}) : super(key: key);

  @override
  State<ChatUserTile> createState() => _ChatUserTileState();
}

class _ChatUserTileState extends State<ChatUserTile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.chatPerson.isSelected = !(widget.chatPerson.isSelected??false);
        setState(() {

        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [

            Checkbox(value: widget.chatPerson.isSelected??false, onChanged: (value){

setState(() {
  widget.chatPerson.isSelected = value;
});

            }),


            /// Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: (widget.chatPerson.profileImage != null &&
                widget.chatPerson.profileImage!.isNotEmpty)
                ? NetworkImage(widget.chatPerson.profileImage!)
                : null,
            child: (widget.chatPerson.profileImage == null ||
                widget.chatPerson.profileImage!.isEmpty)
                ? Text(
              (widget.chatPerson.name != null &&
                  widget.chatPerson.name!.isNotEmpty)
                  ? widget.chatPerson.name![0].toUpperCase()
                  : "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
                : null,
          ),


            const SizedBox(width: 12),

            /// Name & Designation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                BlueLargeBoldText(
                    widget.chatPerson.name??"",
                  fontFamily: fontInterSemiBold
                ),
                SizedBox(height: 3),
                BlackMediumRegularText(
                    widget.chatPerson.userType??"",
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



