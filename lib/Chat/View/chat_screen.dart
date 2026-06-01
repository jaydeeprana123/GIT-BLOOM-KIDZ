import 'dart:io';

import 'package:bloom_kidz/Chat/controller/chat_controller.dart';
import 'package:bloom_kidz/Chat/models/group_chat_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../ChildInfo/View/child_info_screen.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../../CommonWidgets/common_widget.dart';
import '../models/send_message_not_group_request.dart';
import 'chat_bubble.dart';
import 'chat_header.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  SendMessageNotGroupRequest? sendMessageNotGroupRequest;

  ChatScreen({Key? key, required this.groupId, this.sendMessageNotGroupRequest})
    : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = Get.find<ChatController>();
  Message? _editingMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received');

        if (message.notification != null) {
          if (message.notification?.title == "New Message") {
            if (widget.groupId.isNotEmpty) {
              chatController.callGetGroupChatAPI(context, widget.groupId);
            } else if ((chatController
                        .groupChatResponse
                        .value
                        .data
                        ?.group
                        ?.id ??
                    0) !=
                0) {
              chatController.callGetGroupChatAPI(
                context,
                (chatController.groupChatResponse.value.data?.group?.id ?? 0)
                    .toString(),
              );
            }
          }
        }

        // Show custom notification / dialog / snackbar
      });

      chatController.groupChatResponse.value = GroupChatResponse();
      chatController.imagePath.value = "";
      chatController.scrollController = ScrollController();
      chatController.getUserInfo();
      if (widget.groupId.isNotEmpty) {
        chatController.callGetGroupChatAPI(context, widget.groupId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "Chat",
        showMenu: false,
        showBack: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.fill)),

            Card(
              color: Colors.white,
              shadowColor: color_secondary,
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  22,
                ), // change 16 to any radius you like
              ),
              child: Column(
                children: [
                  ChatHeader(
                    sendMessageNotGroupRequest:
                        widget.sendMessageNotGroupRequest,
                  ),
                  const Divider(height: 1),
                  Expanded(child: _chatList()),
                  _replyBox(),
                ],
              ),
            ),

            if (chatController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  /// 🔹 Chat Messages
  Widget _chatList() {
    return ListView.builder(
      controller: chatController.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          (chatController.groupChatResponse.value.data?.messages ?? []).length,
      itemBuilder: (context, index) {
        final messages =
            chatController.groupChatResponse.value.data?.messages ?? [];

        final currentMessage = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;

        /// ✅ WhatsApp-style condition
        final bool showSenderName =
            index == 0 || currentMessage.senderId != previousMessage?.senderId;

        return ChatBubble(
          message:
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .message ??
              "",
          isSender:
              chatController.loginResponse.value.data?.user?.id ==
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .senderId,
          time: getTimeInAmPM(
            chatController
                    .groupChatResponse
                    .value
                    .data
                    ?.messages?[index]
                    .createdAt ??
                DateTime(2026),
          ),
          isGroup: true,
          nameOfUser:
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .senderName ??
              "",
          showSenderName: showSenderName,
          attachments:
              chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index]
                  .attachments ??
              [],

          onDelete: () {
            final messageId = chatController
                .groupChatResponse
                .value
                .data
                ?.messages?[index]
                .id;

            if (messageId != null) {
              chatController.callDeleteMessageAPI(
                context,
                widget.groupId,
                messageId.toString(),
              ); // your API call
            }
          },
          onEdit: () {
            setState(() {
              _editingMessage = chatController
                  .groupChatResponse
                  .value
                  .data
                  ?.messages?[index];
              if (_editingMessage != null) {
                chatController.messageController.value.text =
                    _editingMessage!.message ?? "";
              }
            });
          },
        );
      },
    );
  }

  /// 🔹 Reply Box
  Widget _replyBox() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_editingMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Editing: ${_editingMessage!.message}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _editingMessage = null;
                          chatController.messageController.value.text = "";
                        });
                      },
                      child: const Icon(Icons.close, color: Colors.blue, size: 16),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xff1f78c8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController.messageController.value,
                      decoration: const InputDecoration(
                        hintText: "Write a reply...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),

                  if (chatController.messageController.value.text.isEmpty)
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Color(0xff1f78c8)),
                      onPressed: () async {
                        chatController.imagePath.value = await selectPhoto(
                          context,
                          true,
                        );

                        printData(
                          "chatController.imagePath",
                          chatController.imagePath.value,
                        );

                        showImageDialog(
                          context,
                          chatController.imagePath.value,
                          chatController.groupChatResponse.value.data?.group?.id ??
                              0,
                          chatController
                                  .groupChatResponse
                                  .value
                                  .data
                                  ?.group
                                  ?.name ??
                              "",
                        );
                      },
                    ),

                  if (chatController.messageController.value.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xff1f78c8)),
                      onPressed: () {
                        if (_editingMessage != null) {
                          final editedText = chatController.messageController.value.text;
                          final messageId = _editingMessage!.id.toString();
                          final activeGroupId = widget.groupId.isNotEmpty
                              ? widget.groupId
                              : (chatController.groupChatResponse.value.data?.group?.id ?? 0).toString();

                          chatController.callEditMessageAPI(
                            context,
                            activeGroupId,
                            messageId,
                            editedText,
                          );
                          setState(() {
                            _editingMessage = null;
                            chatController.messageController.value.text = "";
                          });
                        } else if (widget.groupId.isEmpty &&
                            widget.sendMessageNotGroupRequest != null) {
                          widget.sendMessageNotGroupRequest?.message =
                              chatController.messageController.value.text;
                          chatController.callSendMessageNotGroupAPI(
                            context,
                            widget.sendMessageNotGroupRequest!,
                            isFromChatScreen: true,
                          );
                        } else {
                          chatController.callSendMessageInGroupAPI(
                            context,
                            (chatController
                                        .groupChatResponse
                                        .value
                                        .data
                                        ?.group
                                        ?.id ??
                                    0)
                                .toString(),
                            chatController.messageController.value.text,
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImageDialog(
    BuildContext context,
    String imagePath,
    int groupId,
    String groupName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🖼 Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ Submit Button
                CommonGradientButton(
                  btnTitle: "Submit",
                  onPressed: () {
                    Navigator.pop(context);
                    chatController.callSendMessageWithMediaInGroupAPI(
                      context,
                      groupId.toString(),
                      groupName,
                      chatController.messageController.value.text,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
