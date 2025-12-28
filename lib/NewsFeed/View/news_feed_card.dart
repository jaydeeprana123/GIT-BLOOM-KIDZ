import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';
import 'comment_list.dart';

class NewsFeedCard extends StatelessWidget {
  final Newsfeed newsFeed;
  final NewsFeedController newsFeedController;
  final int index;

  const NewsFeedCard({super.key, required this.newsFeed, required this.newsFeedController, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: color_primary,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _titleText(),
          if ((newsFeed.media ?? []).isNotEmpty) _image(),
          _description(),
          _actions(),
          _replyBox(context,newsFeed.id.toString(), index),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(newsFeed.createdId?.profile ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlackLargeBoldText(newsFeed.createdId?.name ?? ""),
                SizedBox(height: 2),

                Row(
                  children: [
                    Icon(Icons.timer, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      newsFeed.createdAt != null
                          ? '${newsFeed.createdAt!.hour.toString().padLeft(2, '0')}:'
                                '${newsFeed.createdAt!.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.date_range, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      newsFeed.createdAt != null
                          ? '${newsFeed.createdAt!.day.toString().padLeft(2, '0')}-'
                                '${newsFeed.createdAt!.month.toString().padLeft(2, '0')}-'
                                '${newsFeed.createdAt!.year} • '
                          : '',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  Widget _titleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: BlueMediumBoldText(newsFeed.name ?? ""),
    );
  }

  Widget _image() {
    return ((newsFeed.media ?? []).length == 1)
        ? (newsFeed.media?[0].extenstion == "jpeg")
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(newsFeed.media?[0].file ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox()
        : SizedBox();
  }

  Widget _description() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Html(
        data: newsFeed.description ?? "",
        style: {
          "*": Style(
            fontSize: FontSize(13),
            color: text_color,
            lineHeight: LineHeight(1.4),
          ),
        },
      ),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.favorite, color: color_secondary, size: 16),
          SizedBox(width: 4),
          BlueMediumRegularText((newsFeed.likesCount ?? 0).toString()),
          SizedBox(width: 16),
          InkWell(
            onTap: (){
              Get.to(CommentListWidget(newsFeed: newsFeed,newsFeedController: newsFeedController,));
            },
            child: Row(
              children: [
                Icon(Icons.chat, size: 16, color: color_secondary),
                SizedBox(width: 4),
                BlueMediumRegularText((newsFeed.commentsCount ?? 0).toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyBox(BuildContext context,String id, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color_secondary),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
             Expanded(
              child: TextField(
                controller: newsFeedController.replyController[i],
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: color_secondary),
              onPressed: () async{
               await newsFeedController.callAddCommentAPI(context, id, newsFeedController.replyController[i].text);
               newsFeedController.replyController[i].text = "";
              },
            ),
          ],
        ),
      ),
    );
  }
}
