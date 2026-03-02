import 'dart:convert';

import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/views/observation_update_screen.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart' hide Media;
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../CommonWidgets/blue_small_regular_text.dart';
import '../../../NewsFeed/View/comment_list.dart';
import '../model/group_observation_list_response.dart';

class GroupObservationCard extends StatelessWidget {
  final GroupObservation observation;
  final String childId;
  final ChildInfoController childInfoController;
  final int index;

  const GroupObservationCard({
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
          if ((observation.media ?? []).isNotEmpty) _image(context),
          _description(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          /// Avatar
          (observation.createdBy?.profile != null &&
                  (observation.createdBy?.profile ?? "").isNotEmpty)
              ? Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(observation.createdBy?.profile ?? ""),
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
                    (observation.createdBy != null &&
                            (observation.createdBy?.name ?? "").isNotEmpty)
                        ? (observation.createdBy?.name ?? "")[0].toUpperCase()
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
                BlackLargeBoldText(observation.createdBy?.name ?? ""),
                SizedBox(height: 2),

                BlackMediumRegularText(
                  "made an Observation for ${observation.childNames ?? ""}",
                  fontSize: 12,
                ),
                SizedBox(height: 2),

                Row(
                  children: [
                    Icon(Icons.timer, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      observation.createdAt != null
                          ? '${observation.createdAt?.hour.toString().padLeft(2, '0')}:'
                                '${observation.createdAt?.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.date_range, color: color_secondary, size: 14),

                    BlueSmallRegularText(
                      observation.createdAt != null
                          ? '${observation.createdAt?.day.toString().padLeft(2, '0')}-'
                                '${observation.createdAt?.month.toString().padLeft(2, '0')}-'
                                '${observation.createdAt?.year} • '
                          : '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    final mediaList = observation.media ?? [];

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

  Widget _singleImage(BuildContext context, GroupMedia media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, media.image ?? ""),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder: placeholder,
            image: media.image ?? "",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _twoImages(BuildContext context, List<GroupMedia> mediaList) {
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
                  onTap: () => showFullImageDialog(context, media.image ?? ""),
                  child: FadeInImage.assetNetwork(
                    placeholder: placeholder,
                    image: media.image ?? "",
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

  Widget _multiImages(BuildContext context, List<GroupMedia> mediaList) {
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
                            builder: (_) =>
                                AllImagesScreen(mediaList: mediaList),
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

  Widget _gridImage(BuildContext context, GroupMedia media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => showFullImageDialog(context, media.image ?? ""),
        child: FadeInImage.assetNetwork(
          placeholder: placeholder,
          image: media.image ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _description() {
    if ((observation.observations ?? "").isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Html(
        data: _sanitizeHtml(observation.observations ?? ""),
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
}

class AllImagesScreen extends StatelessWidget {
  final List<GroupMedia> mediaList;

  const AllImagesScreen({super.key, required this.mediaList});

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
              showFullImageDialog(context, mediaList[index].image ?? "");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: placeholder,
                image: media.image ?? "",
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
