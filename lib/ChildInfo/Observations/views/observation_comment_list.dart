import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart'
    hide Comment, User;
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../CommonWidgets/black_medium_bold_text.dart';
import '../../../CommonWidgets/black_medium_regular_text.dart';
import '../../../CommonWidgets/common_appbar.dart';

class ObservationCommentListWidget extends StatelessWidget {
  Observation observation;
  String childId;
  ChildInfoController childInfoController;
  ObservationCommentListWidget({
    super.key,
    required this.childId,
    required this.observation,
    required this.childInfoController,
  });

  @override
  Widget build(BuildContext context) {
    final myUserId =
        childInfoController.loginResponse.value.data?.user?.id;
    childInfoController.isLikeList.assignAll(
      (observation.comments ?? []).map(
        (comment) =>
            comment.likedUsers?.any((user) => user.id == myUserId) ?? false,
      ),
    );

    childInfoController.getUserInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Comments", showMenu: false, showBack: true),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            ((observation.comments ?? []).isEmpty)
                ? Center(child: BlueLargeBoldText("No comments found"))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    itemCount: (observation.comments ?? []).length,
                    itemBuilder: (context, index) {
                      final comment = observation.comments?[index];

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
                        child: Column(
                          children: [
                            if (comment?.user?.id ==
                                childInfoController
                                    .loginResponse
                                    .value
                                    .data
                                    ?.user
                                    ?.id)
                              InkWell(
                                onTap: () {
                                  showDeleteWarningDialog(
                                    context,
                                    onConfirm: () {
                                      childInfoController
                                          .callObservationDeleteCommentAPI(
                                            context,
                                            childId,
                                            observation.id.toString(),
                                            (comment?.id ?? 0).toString(),
                                          );
                                    },
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      showDeleteWarningDialog(
                                        context,
                                        onConfirm: () {
                                          childInfoController
                                              .callObservationDeleteCommentAPI(
                                                context,
                                                childId,
                                                observation.id.toString(),
                                                (comment?.id ?? 0).toString(),
                                              );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 8,
                                        bottom: 4,
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            Container(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCommentUserAvatar(comment?.user),

                                  const SizedBox(width: 10),

                                  /// 💬 Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                childInfoController
                                                    .callAddLikeCommentAPI(
                                                      context,
                                                      childId,
                                                      observation.id.toString(),
                                                      (comment?.id ?? 0)
                                                          .toString(),
                                                      index,
                                                      comment,
                                                    );
                                              },
                                              child: Icon(
                                                _isCommentLiked(
                                                      index,
                                                      comment,
                                                    )
                                                    ? Icons.thumb_up
                                                    : Icons
                                                          .thumb_up_alt_outlined,
                                                size: 16,
                                                color: _isCommentLiked(
                                                      index,
                                                      comment,
                                                    )
                                                    ? color_secondary
                                                    : text_color,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            _likedUsersAvatarsAndCount(
                                              context,
                                              comment,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            if (childInfoController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentUserAvatar(User? user) {
    final profile = user?.profile ?? "";
    final name = user?.name ?? "";

    if (profile.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(profile),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: color_secondary,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  bool _isCommentLiked(int index, Comment? comment) {
    final myUserId =
        childInfoController.loginResponse.value.data?.user?.id;
    if (index < childInfoController.isLikeList.length &&
        childInfoController.isLikeList[index]) {
      return true;
    }
    return comment?.likedUsers?.any((user) => user.id == myUserId) ?? false;
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

  Widget _likedUsersAvatarsAndCount(BuildContext context, Comment? comment) {
    final likedUsers = comment?.likedUsers ?? [];
    final likesCount = comment?.likes ?? 0;

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
