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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _titleText(),
          if ((newsFeed.media ?? []).isNotEmpty) _image(context),
          _description(),


          if (newsFeed.type == "events")
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
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
    if (mediaList.isEmpty) return const SizedBox();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: mediaList.length,
            onPageChanged: (page) {
              newsFeedController.updateImagePage(index, page);
            },
            itemBuilder: (context, i) {
              final url = mediaList[i].fullUrl ?? "";
              return _isImageUrl(url)
                  ? _imageItem(context, url, mediaList, i)
                  : _attachmentItem(context, url);
            },
          ),
        ),

        if (mediaList.length > 1)
          Obx(() {
            final currentPage = newsFeedController.imagePageMap[index] ?? 0;
            return Container(
              color: half_transparent,
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(mediaList.length, (dotIndex) {
                  final isActive = dotIndex == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? color_primary
                          : Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            );
          }),
      ],
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────────

  bool _isImageUrl(String url) {
    final lower = url.toLowerCase().split('?').first; // strip query params
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  String _fileName(String url) {
    try {
      return Uri.parse(url).pathSegments.last;
    } catch (_) {
      return "Attachment";
    }
  }

  Widget _imageItem(BuildContext context, String url, List<Media> mediaList, int i, ) {
    return GestureDetector(
      onTap: () => showFullImageDialog(context, mediaList, i),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        cacheWidth: 1080,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image_outlined,
            color: Colors.grey,
            size: 40,
          ),
        ),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return  Center(
  child: CircularProgressIndicator(),
);
        },
      ),
    );
  }

  Widget _attachmentItem(BuildContext context, String url) {
    final name = _fileName(url);
    final isPdf = url.toLowerCase().split('?').first.endsWith('.pdf');

    return GestureDetector(
      onTap: () => _openAttachment(context, url),
      child: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.attach_file_rounded,
              size: 64,
              color: isPdf ? Colors.red[400] : color_secondary,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: color_primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Open",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAttachment(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open attachment")),
        );
      }
    }
  }

  Widget _multiImages(BuildContext context, List<Media> mediaList) {
    // Show first row: left big + right column of 2
    // Then all remaining images below in a grid

    return Column(
      children: [
        // --- Row 1: first 3 images in the original layout ---
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(flex: 2, child: _gridImage(context, mediaList, 0)),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(child: _gridImage(context, mediaList, 1)),
                    const SizedBox(height: 8),
                    Expanded(child: _gridImage(context, mediaList, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- Remaining images (index 3 onwards) in a grid ---
        if (mediaList.length > 3) ...[
          const SizedBox(height: 8),
          _remainingImagesGrid(context, mediaList.sublist(3)),
        ],
      ],
    );
  }

  Widget _remainingImagesGrid(BuildContext context, List<Media> remaining) {
    return GridView.builder(
      shrinkWrap: true,
      // IMPORTANT: disable GridView's own scrolling so it doesn't
      // conflict with the parent SingleChildScrollView / ListView
      physics: const NeverScrollableScrollPhysics(),
      itemCount: remaining.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return _gridImage(context, remaining, index);
      },
    );
  }

//   Widget _singleImage(BuildContext context, Media media) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: GestureDetector(
//         onTap: () => showFullImageDialog(context, media.file ?? ""),
//         child: SizedBox(
//           height: 200,
//           width: double.infinity,
//           child: CachedNetworkImage(
//             imageUrl: media.file ?? "",
//             fit: BoxFit.cover,
//             height: 200,
//             width: double.infinity,
//             placeholder: (context, url) =>  Center(
//   child: CircularProgressIndicator(),
// ),
//             errorWidget: (context, url, error) =>  Center(
//   child: CircularProgressIndicator(),
// ),
//           )
//
//
//
//           // FadeInImage.assetNetwork(
//           //   placeholder: placeholder,
//           //   image: media.file ?? "",
//           //   fit: BoxFit.cover,
//           //   height: 200,
//           //   width: double.infinity,
//           // ),
//         ),
//       ),
//     );
//   }

  Widget _gridImage(BuildContext context, List<Media> mediaList, int i, ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, mediaList, i),
        child: CachedNetworkImage(
          imageUrl: mediaList[i].fullUrl ?? "",
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) =>  Center(
  child: CircularProgressIndicator(),
),
          errorWidget: (context, url, error) =>  Center(
  child: CircularProgressIndicator(),
),
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
            margin: Margins.zero,      // 👈 Add this
            padding: HtmlPaddings.zero, // 👈 Add this
          ),
          "body": Style(
            margin: Margins.zero,       // 👈 Add this
            padding: HtmlPaddings.zero, // 👈 Add this
          ),
        },
        // ... extensions
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

        // FIX 1: addRepaintBoundaries + addAutomaticKeepAlives = false
        // prevents Flutter from keeping all decoded images in memory at once
        addRepaintBoundaries: true,
        addAutomaticKeepAlives: false,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final media = mediaList[index];
          final url = media.fullUrl ?? "";

          if (url.isEmpty) return const SizedBox();

          return GestureDetector(
            onTap: () => showFullImageDialog(context, mediaList, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: CachedNetworkImage(
                imageUrl: media.fullUrl ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) =>  Center(
  child: CircularProgressIndicator(),
),
                errorWidget: (context, url, error) =>  Center(
  child: CircularProgressIndicator(),
),

              ),

              // FadeInImage.assetNetwork(
              //   placeholder: placeholder,
              //   image: media.file ?? "",
              //   fit: BoxFit.cover,
              // ),
            ),
          );
        },
      ),
    );
  }
}
