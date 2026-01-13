import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';
import '../../CommonWidgets/common_appbar.dart';

class CommentListWidget extends StatelessWidget {
  Newsfeed newsFeed;
  NewsFeedController newsFeedController;
  CommentListWidget({
    super.key,
    required this.newsFeed,
    required this.newsFeedController,
  });

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < (newsFeed.comments ?? []).length; i++) {
      newsFeedController.isLikeList.add(false);
    }


    newsFeedController.getUserInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Comments", showMenu: true, showBack: true),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            ((newsFeed.comments ?? []).isEmpty)
                ? Center(child: BlueLargeBoldText("No comments found"))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    itemCount: (newsFeed.comments ?? []).length,
                    itemBuilder: (context, index) {
                      final comment = newsFeed.comments?[index];

                      return Card(
                        color: Colors.white,
                        shadowColor: color_secondary,
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 👤 Profile Image
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(
                                  comment?.user?.profile ?? "",
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 💬 Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Name + Date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlueMediumBoldText(
                                          comment?.user?.name ?? "",
                                          fontSize: 14,
                                        ),
                                        BlackSmallMediumText(
                                          getDateOnlyInIndianFormat(
                                            comment?.date ?? DateTime(2025),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    /// Comment Text
                                    BlackMediumRegularText(
                                      comment?.content ?? "",
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),

                                    const SizedBox(height: 8),

                                    /// Likes
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            newsFeedController
                                                .callAddLikeInCommentAPI(
                                                  context,
                                                  newsFeed.id.toString(),
                                                  (comment?.id ?? 0).toString(),
                                                  index,
                                                );
                                          },
                                          child: Icon(
                                            newsFeedController
                                                        .isLikeList[index] ==
                                                    true
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_alt_outlined,
                                            size: 16,
                                            color:
                                                newsFeedController
                                                        .isLikeList[index] ==
                                                    true
                                                ? color_secondary
                                                : text_color,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        BlackMediumBoldText(
                                          (comment?.likes ?? 0).toString(),
                                        ),

                                        SizedBox(width: 16,),

                                        if(comment?.user?.id == newsFeedController.loginResponse?.value.data?.user?.id)InkWell(onTap: (){

                                          showDeleteWarningDialog(context, onConfirm: (){
                                            newsFeedController.callNewsDeleteCommentAPI(context, newsFeed.id.toString(), (comment?.id??0).toString());

                                          });

                                        },child: Row(
                                          children: [
                                            Icon(Icons.delete_forever, color: Colors.red,size: 16,),

                                            BlackSmallMediumText(
                                                "Delete",
                                                color: Colors.red,
                                                fontSize: 11

                                            )
                                          ],
                                        ))

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            if (newsFeedController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }


  void showDeleteWarningDialog(
      BuildContext context, {
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ⚠️ Icon
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 50,
                ),

                const SizedBox(height: 12),

                /// Title
                BlueMediumBoldText(
                  "Delete Comment",
                  fontSize: 16,
                  color: Colors.red,
                ),

                const SizedBox(height: 8),

                /// Message
                const Text(
                  "Are you sure you want to delete this comment?\nThis action cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
