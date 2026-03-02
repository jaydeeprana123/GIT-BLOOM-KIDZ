import 'dart:convert';

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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';
import '../../CommonWidgets/common_widget.dart';
import 'comment_list.dart';

class NewsFeedCard extends StatelessWidget {
  final Newsfeed newsFeed;
  final NewsFeedController newsFeedController;
  final int index;

  const NewsFeedCard({
    super.key,
    required this.newsFeed,
    required this.newsFeedController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    newsFeedController.getUserInfo();

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
          if ((newsFeed.media ?? []).isNotEmpty) _image(context),
          _description(),

          if (newsFeed.type == "events")
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      newsFeedController.callAInterestedNotInterestedAPI(
                        context,
                        newsFeed.id.toString(),
                        "1",
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlackMediumRegularText(
                        "Interested",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      newsFeedController.callAInterestedNotInterestedAPI(
                        context,
                        newsFeed.id.toString(),
                        "2",
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlackMediumRegularText(
                        "Not Interested",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          _actions(context, newsFeedController, index, newsFeed.id.toString()),
          _replyBox(context, newsFeed.id.toString(), index),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          /// Avatar
          (newsFeed.createdId?.profile != null &&
                  (newsFeed.createdId?.profile ?? "").isNotEmpty)
              ? Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(newsFeed.createdId?.profile ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color_secondary,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (newsFeed.createdId?.name != null &&
                            (newsFeed.createdId?.name ?? "").isNotEmpty)
                        ? (newsFeed.createdId?.name ?? "")[0].toUpperCase()
                        : "",
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                    // Icon(Icons.timer, color: color_secondary, size: 14),
                    SvgPicture.asset(clockIcon, width: 12),
                    SizedBox(width: 2),
                    BlueSmallRegularText(
                      newsFeed.createdAt != null
                          ? '${newsFeed.createdAt!.hour.toString().padLeft(2, '0')}:'
                                '${newsFeed.createdAt!.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),

                    SizedBox(width: 7),
                    SvgPicture.asset(dobIcon, width: 12),
                    SizedBox(width: 2),
                    BlueSmallRegularText(
                      newsFeed.createdAt != null
                          ? '${newsFeed.createdAt!.day.toString().padLeft(2, '0')}-'
                                '${newsFeed.createdAt!.month.toString().padLeft(2, '0')}-'
                                '${newsFeed.createdAt!.year}'
                          : '',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const Icon(Icons.more_vert),
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

  Widget _image(BuildContext context) {
    final mediaList = newsFeed.media ?? [];

    if (mediaList.isEmpty) {
      return const SizedBox();
    }

    if (mediaList.length == 1) {
      return _singleImage(context, mediaList[0]);
    }

    if (mediaList.length == 2) {
      return _twoImages(context, mediaList);
    }

    return _multiImages(context, mediaList);
  }

  Widget _singleImage(BuildContext context, Media media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, media.file ?? ""),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder: placeholder,
            image: media.file ?? "",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _twoImages(BuildContext context, List<Media> mediaList) {
    return SizedBox(
      height: 200,
      child: Row(
        children: mediaList.map((media) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () => showFullImageDialog(context, media.file ?? ""),
                  child: FadeInImage.assetNetwork(
                    placeholder: placeholder,
                    image: media.file ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _multiImages(BuildContext context, List<Media> mediaList) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          /// Left Big Image
          Expanded(flex: 2, child: _gridImage(context, mediaList[0])),

          const SizedBox(width: 8),

          /// Right Column
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(child: _gridImage(context, mediaList[1])),
                const SizedBox(height: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (mediaList.length > 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllImagesScreenForNewsFeed(
                              mediaList: mediaList,
                            ),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        _gridImage(context, mediaList[2]),

                        if (mediaList.length > 3)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "+${mediaList.length - 3}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridImage(BuildContext context, Media media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, media.file ?? ""),
        child: FadeInImage.assetNetwork(
          placeholder: placeholder,
          image: media.file ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Html(
        data: _sanitizeHtml(newsFeed.description ?? ""),
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
                try {
                  final base64Str = src.split(',').last;
                  final bytes = base64Decode(base64Str);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox();
                      },
                    ),
                  );
                } catch (e) {
                  return const SizedBox();
                }
              }

              if (src.isNotEmpty && !src.startsWith('data:')) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    src,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  String _sanitizeHtml(String html) {
    // Remove problematic inline styles that contain font-feature-settings
    html = html.replaceAllMapped(
      RegExp(r'font-feature-settings:[^;}"]*', caseSensitive: false),
      (match) => '',
    );

    // Remove font-variant-* properties that might cause issues
    html = html.replaceAllMapped(
      RegExp(r'font-variant-[^:]*:[^;}"]*', caseSensitive: false),
      (match) => '',
    );

    // Clean up any double semicolons or style attributes that are now empty
    html = html.replaceAll(';;', ';');
    html = html.replaceAll('style=""', '');
    html = html.replaceAll('style=" "', '');

    return html;
  }

  Widget _actions(
    BuildContext context,
    NewsFeedController controller,
    int index,
    String newsId,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              controller.callAddLikeInNewsFeedAPI(context, newsId, index);
            },
            child: SvgPicture.asset(
              isLikeOrNot() ? icon_like : unlike,
              width: 16,
            ),
          ),
          SizedBox(width: 4),
          BlueMediumRegularText((newsFeed.likesCount ?? 0).toString()),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              Get.to(
                CommentListWidget(
                  newsFeed: newsFeed,
                  newsFeedController: newsFeedController,
                ),
              )?.then((value) {
                controller.callNewsFeedAPI(context);
              });
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  icon_comment,
                  // color: (controller.newsFeedList[index].isLike ?? false)
                  //     ? Colors.red
                  //     : color_secondary,
                  width: 16,
                ),

                // Icon(Icons.chat, size: 16, color: color_secondary),
                SizedBox(width: 4),
                BlueMediumRegularText((newsFeed.commentsCount ?? 0).toString()),
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
                controller: newsFeedController.replyController[i],
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  border: InputBorder.none,
                ),
              ),
            ),

            IconButton(
              icon: SvgPicture.asset(send, width: 22),
              onPressed: () async {
                await newsFeedController.callAddCommentAPI(
                  context,
                  id,
                  newsFeedController.replyController[i].text,
                );
                newsFeedController.replyController[i].text = "";
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isLikeOrNot() {
    bool isLikedByMe =
        newsFeed.likes?.any(
          (like) =>
              like.userId ==
              newsFeedController.loginResponse.value.data?.user?.id,
        ) ??
        false;
    return isLikedByMe;
  }
}

class AllImagesScreenForNewsFeed extends StatelessWidget {
  final List<Media> mediaList;

  const AllImagesScreenForNewsFeed({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Images")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: mediaList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final media = mediaList[index];

          return GestureDetector(
            onTap: () {
              showFullImageDialog(context, mediaList[index].file ?? "");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: placeholder,
                image: media.file ?? "",
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
