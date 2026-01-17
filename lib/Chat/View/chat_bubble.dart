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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String nameOfUser;
  final String time;
  final bool isGroup;
  final bool showSenderName;
  final List<Attachment>? attachments;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.nameOfUser,
    required this.time,
    required this.isGroup,
    required this.showSenderName,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          if (isGroup && showSenderName) BlueMediumBoldText(
              nameOfUser,
              color: color_secondary,
              fontSize: 12
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: BlackSmallRegularText(
                time,
                color: Colors.black

            ),
          ),
          (attachments??[]).isNotEmpty?
          Row(
    mainAxisAlignment: isSender ?MainAxisAlignment.end:MainAxisAlignment.start,children: [

            for(int i = 0; i< (attachments??[]).length; i++)
              InkWell(
                onTap: (){
                  showFullImageDialog(context, attachments?[i].url??"");
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 180,
                  width: 220,
                  padding:  EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(12),
                    // ⬅ square with small radius
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(6),
                    child: Image.network(attachments?[i].url??""),
                  ),
                ),
              ),
          ],)
           :  Container(
            margin: const EdgeInsets.only(top: 3, bottom: 12),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isSender
                  ? color_primary
                  : color_secondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: BlackMediumRegularText(
              message,
             color: Colors.white,
              fontSize: 12
            ),
          ),

        ],
      ),
    );
  }


  void showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          child: Stack(
            children: [

              /// 🔍 Zoomable Image
              InteractiveViewer(
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 80,
                      );
                    },
                  ),
                ),
              ),

              /// ❌ Close Button
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}



