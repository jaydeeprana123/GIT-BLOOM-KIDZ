import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';
import '../../CommonWidgets/common_widget.dart';
import '../../CommonWidgets/full_screen_attachment_viewer.dart';
import '../../CommonWidgets/sanitized_html_content.dart';
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
                  : _attachmentItem(context, mediaList[i]);
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

  String _mediaExtension(Media media, String url) {
    final fromApi = (media.extenstion ?? "").toLowerCase();
    if (fromApi.isNotEmpty) return fromApi;

    final path = url.toLowerCase().split('?').first;
    for (final ext in ['pdf', 'docx', 'doc', 'xlsx', 'xls', 'pptx', 'ppt']) {
      if (path.endsWith('.$ext')) return ext;
    }
    return '';
  }

  bool _isPdfMedia(Media media, String url) =>
      _mediaExtension(media, url) == 'pdf';

  bool _isOfficeMedia(Media media, String url) {
    final ext = _mediaExtension(media, url);
    return ext == 'doc' ||
        ext == 'docx' ||
        ext == 'xls' ||
        ext == 'xlsx' ||
        ext == 'ppt' ||
        ext == 'pptx';
  }

  bool _isInAppViewableMedia(Media media, String url) =>
      _isPdfMedia(media, url) || _isOfficeMedia(media, url);

  Widget _imageItem(
    BuildContext context,
    String url,
    List<Media> mediaList,
    int i,
  ) {
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _attachmentItem(BuildContext context, Media media) {
    final url = media.fullUrl ?? "";
    final name = _fileName(url);
    final isPdf = _isPdfMedia(media, url);
    final isOffice = _isOfficeMedia(media, url);

    if (isPdf) {
      return Stack(
        children: [
          SfPdfViewer.network(
            url,
            canShowScrollHead: false,
            canShowScrollStatus: false,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _openAttachment(context, media),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_in_new_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _openAttachment(context, media),
      child: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffice
                  ? Icons.description_outlined
                  : Icons.attach_file_rounded,
              size: 64,
              color: isOffice ? Colors.blue[700] : color_secondary,
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
            if (isOffice) ...[
              const SizedBox(height: 4),
              Text(
                _mediaExtension(media, url).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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

  void _openAttachment(BuildContext context, Media media) {
    final url = media.fullUrl ?? "";
    if (url.isEmpty) return;

    final ext = _mediaExtension(media, url);
    if (_isInAppViewableMedia(media, url)) {
      Get.to(
        () => FullScreenAttachmentViewer(
          url: url,
          title: _fileName(url),
          extension: ext,
        ),
      );
    } else {
      _launchExternal(context, url);
    }
  }

  void _launchExternal(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
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

  Widget _gridImage(BuildContext context, List<Media> mediaList, int i) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, mediaList, i),
        child: CachedNetworkImage(
          imageUrl: mediaList[i].fullUrl ?? "",
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _description() {
    return SanitizedHtmlContent(html: newsFeed.description ?? "");
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
          _likedUsersAvatarsAndCount(context),
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

  Widget _likedUsersAvatarsAndCount(BuildContext context) {
    final likedUsers = newsFeed.likedUsers ?? [];
    final likesCount = newsFeed.likesCount ?? 0;

    if (likesCount == 0) {
      return BlueMediumRegularText("0");
    }

    // Number of avatar circles to show (real users or placeholders)
    final displayCount = likedUsers.isNotEmpty
        ? likedUsers.length.clamp(1, 3)
        : likesCount.clamp(1, 3);

    return InkWell(
      onTap: () {
        if (likedUsers.isNotEmpty) {
          _showLikedUsersBottomSheet(context, likedUsers);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Always show avatar stack when there are likes
          SizedBox(
            height: 20,
            width: (displayCount * 14.0) + 6.0,
            child: Stack(
              children: List.generate(displayCount, (i) {
                final user = likedUsers.isNotEmpty && i < likedUsers.length
                    ? likedUsers[i]
                    : null;
                return Positioned(
                  left: i * 14.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: color_secondary,
                      backgroundImage:
                          (user?.profile != null && user!.profile!.isNotEmpty)
                          ? NetworkImage(user.profile!)
                          : null,
                      child: (user?.profile == null || (user?.profile ?? "").isEmpty)
                          ? Text(
                              (user?.name ?? "").isNotEmpty
                                  ? user!.name![0].toUpperCase()
                                  : "",
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 4),
          BlueMediumRegularText("$likesCount"),
        ],
      ),
    );
  }

  void _showLikedUsersBottomSheet(BuildContext context, List<User> users) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Liked By",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontInterBold,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, i) {
                    final user = users[i];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            (user.profile != null && user.profile!.isNotEmpty)
                            ? NetworkImage(user.profile!)
                            : null,
                        backgroundColor: color_secondary,
                        child: (user.profile == null || user.profile!.isEmpty)
                            ? Text(
                                (user.name ?? "").isNotEmpty
                                    ? user.name![0].toUpperCase()
                                    : "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        user.name ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Center(child: CircularProgressIndicator()),
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

