import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/views/observation_update_screen.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
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

import '../../../CommonWidgets/blue_small_regular_text.dart';
import '../../../NewsFeed/View/comment_list.dart';
import 'observation_comment_list.dart';

class ObservationCard extends StatelessWidget {
  final Observation observation;
  final String childId;
  final ChildInfoController childInfoController;
  final int index;

  const ObservationCard({
    super.key,
    required this.observation,
    required this.childId,
    required this.childInfoController,
    required this.index,
  });

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
          if ((observation.media ?? []).isNotEmpty) _image(),
          _description(),
          _actions(context),
          _replyBox(context, observation.id.toString(), index),
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
              // image: DecorationImage(
              //   image: NetworkImage(observation.createdId?.profile ?? ""),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlackLargeBoldText(observation.createdBy ?? ""),
                SizedBox(height: 2),

                Row(
                  children: [
                    Icon(Icons.timer, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      observation.createdAt != null
                          ? '${observation.createdAt!.hour.toString().padLeft(2, '0')}:'
                                '${observation.createdAt!.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.date_range, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      observation.createdAt != null
                          ? '${observation.createdAt!.day.toString().padLeft(2, '0')}-'
                                '${observation.createdAt!.month.toString().padLeft(2, '0')}-'
                                '${observation.createdAt!.year} • '
                          : '',
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      childInfoController.selectedObservation.value =
                          observation;
                      Get.to(ObservationUpdateScreen(childId: childId));
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 1, child: Text("Edit")),
                  // const PopupMenuItem(
                  //   value: 2,
                  //   child: Text("Delete"),
                  // ),
                ],
              );
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  Widget _titleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: BlueMediumBoldText(observation.title ?? ""),
    );
  }

  Widget _image() {
    return ((observation.media ?? []).length == 1)
        ? (observation.media?[0].extension == "jpeg")
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(observation.media?[0].image ?? ""),
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
        data: observation.observations ?? "",
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

  Widget _actions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              childInfoController.callObservationAddLikeAPI(
                context,
                childId,
                observation.id.toString(),
              );
            },
            child: Icon(Icons.favorite, color: color_secondary, size: 16),
          ),
          SizedBox(width: 4),
          BlueMediumRegularText((observation.likesCount ?? 0).toString()),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              Get.to(
                ObservationCommentListWidget(
                  childId: childId,
                  observation: observation,
                  childInfoController: childInfoController,
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.chat, size: 16, color: color_secondary),
                SizedBox(width: 4),
                BlueMediumRegularText(
                  (observation.commentsCount ?? 0).toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyBox(BuildContext context, String id, int i) {
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
                controller: childInfoController.replyController[i],
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: color_secondary),
              onPressed: () async {
                await childInfoController.callAddCommentAPI(
                  context,
                  childId,
                  id,
                  childInfoController.replyController[i].text,
                );
                childInfoController.replyController[i].text = "";
              },
            ),
          ],
        ),
      ),
    );
  }
}
