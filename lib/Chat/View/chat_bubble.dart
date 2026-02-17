import 'package:bloom_kidz/Chat/models/group_chat_response.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
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

import '../../CommonWidgets/common_widget.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isSender;
  final String nameOfUser;
  final String time;
  final bool isGroup;
  final bool showSenderName;
  final List<Attachment>? attachments;
  final VoidCallback? onDelete;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.nameOfUser,
    required this.time,
    required this.isGroup,
    required this.showSenderName,
    this.attachments,
    this.onDelete,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: widget.isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (widget.isGroup && widget.showSenderName)
            BlueMediumBoldText(
              widget.nameOfUser,
              color: color_secondary,
              fontSize: 12,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: BlackSmallRegularText(widget.time, color: Colors.black),
          ),

          // Delete button
          if (_showDelete && widget.isSender)
            GestureDetector(
              onTap: () {
                setState(() => _showDelete = false);
                widget.onDelete?.call();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

          // Message / Attachments
          GestureDetector(
            onLongPress: () {
              if (widget.isSender) {
                setState(() => _showDelete = !_showDelete);
              }
            },
            child: (widget.attachments ?? []).isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: widget.isSender
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        for (
                          int i = 0;
                          i < (widget.attachments ?? []).length;
                          i++
                        )
                          InkWell(
                            onTap: () {
                              showFullImageDialog(
                                context,
                                widget.attachments?[i].url ?? "",
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                right: 12,
                              ),
                              height: 180,
                              width: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 0.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  widget.attachments?[i].url ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 3, bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: widget.isSender ? color_primary : color_secondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: BlackMediumRegularText(
                      widget.message,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
