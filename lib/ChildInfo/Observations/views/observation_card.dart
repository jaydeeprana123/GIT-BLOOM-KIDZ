import 'dart:convert';

import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/views/observation_update_screen.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
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

    childInfoController.getUserInfo();

    return Card(
      color: Colors.white,
      shadowColor: color_primary,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _titleText(),
          if ((observation.media ?? []).isNotEmpty) _image(),
          _description(),
          _actions(context),
          _replyBox(context, observation.id.toString(), index),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
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
              showUpdateDialog(context, childId, observation.id.toString(), observation, childInfoController);
              printData("update", "val");
              // PopupMenuButton<int>(
              //   icon: const Icon(Icons.more_vert),
              //   onSelected: (value) {
              //     switch (value) {
              //       case 1:
              //         childInfoController.selectedObservation.value =
              //             observation;
              //
              //
              //
              //         Get.to(ObservationUpdateScreen(childId: childId));
              //         break;
              //     }
              //   },
              //   itemBuilder: (context) => [
              //     const PopupMenuItem(value: 1, child: Text("Edit")),
              //     // const PopupMenuItem(
              //     //   value: 2,
              //     //   child: Text("Delete"),
              //     // ),
              //   ],
              // );
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
    if ((observation.media ?? []).isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: observation.media!.length,
        itemBuilder: (context, index) {
          final media = observation.media![index];

          if (media.extension != "jpg" &&
              media.extension != "jpeg" &&
              media.extension != "png") {
            return const SizedBox();
          }

          return Container(
            width: (observation.media??[]).length == 1?double.infinity:280,
            height: 200,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(media.image ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }






  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Html(
        data: observation.observations ?? "",
        style: {
          "*": Style(
            fontSize: FontSize(13),
            color: text_color,
            lineHeight: LineHeight(1.4),
          ),
        },
        extensions: [
          TagExtension(
            tagsToExtend: {"img"},
            builder: (context) {
              final src = context.attributes['src'] ?? '';

              if (src.startsWith('data:image')) {
                final base64Str = src.split(',').last;
                final bytes = base64Decode(base64Str);

                return Image.memory(bytes, fit: BoxFit.contain);
              }

              return const SizedBox();
            },
          ),
        ],
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
                index,
              );
            },
            child: SvgPicture.asset(
              isLikeOrNot()?icon_like:unlike,
              width: 16,
            ),


            // Icon(
            //   (childInfoController.observationList[index].isLike ?? false)
            //       ? Icons.favorite
            //       : Icons.favorite_border,
            //   color:
            //       (childInfoController.observationList[index].isLike ?? false)
            //       ? Colors.red
            //       : color_secondary,
            //   size: 16,
            // ),
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
              )?.then((value) {
                childInfoController.callObservationListAPI(context, childId);
              });
            },
            child: Row(
              children: [

                SvgPicture.asset(
                  icon_comment,
                  width: 16,
                ),

                // Icon(Icons.chat, size: 16, color: color_secondary),
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
              icon: SvgPicture.asset(send, width: 22,),
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


  void showUpdateDialog(
      BuildContext context,
      String childId,
      String id,
      Observation observation,
      ChildInfoController controller
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlueMediumBoldText(
                  "Action",
                  fontSize: 16,
                  color: color_secondary,
                ),

                const SizedBox(height: 16),

                /// ✏️ Update
                ListTile(
                  leading: const Icon(Icons.edit_note, color: color_secondary),
                  title: BlueMediumBoldText("Update"),
                  onTap: () {
                    controller.selectedObservation.value = observation;
                    Navigator.pop(context);
                    Get.to(ObservationUpdateScreen(childId: childId))?.then((value) {
                      controller.callObservationListAPI(context, childId);
                    });
                  },
                ),

                // const Divider(),
                //
                // /// 🗑 Delete
                // ListTile(
                //   leading: const Icon(Icons.delete_forever, color: Colors.red),
                //   title: const Text(
                //     "Delete",
                //     style: TextStyle(
                //       color: Colors.red,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //
                //     showDeleteWarningDialog(
                //       context,
                //       onConfirm: () {
                //         controller.callDeleteExtraBookingsAPI(
                //           context,
                //           childId,
                //           id,
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }


  bool isLikeOrNot(){
    bool isLikedByMe = observation.likes?.any((like) => like.userId == childInfoController.loginResponse.value.data?.user?.id) ?? false;
    return isLikedByMe;
  }

}
