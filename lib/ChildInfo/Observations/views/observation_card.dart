import 'dart:convert';

import 'package:bloom_kidz/ChildInfo/Observations/models/observation_list_response.dart';
import 'package:bloom_kidz/ChildInfo/Observations/views/observation_update_screen.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../CommonWidgets/blue_small_regular_text.dart';
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

          if (observation.isGroupObs == "Y")
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              color: color_secondary,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: BlackMediumBoldText(
                observation.isGroupLabel ?? "",
                color: Colors.white,
              ),
            ),

          if (observation.isGroupObs == "N")
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              color: color_secondary,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: BlackMediumBoldText(
                observation.isGroupLabel ?? "",
                color: Colors.white,
              ),
            ),



          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            color: color_secondary,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: BlackMediumBoldText(
              observation.obsTypeLabel ?? "",
              color: Colors.white,
            ),
          ),

          _titleText(),
          if ((observation.media ?? []).isNotEmpty) _image(context),
          _description(),

          // ── Type-specific fields ──────────────────────────────────────────
          _typeSpecificFields(),

          _whatsNext(),

          if ((observation.domain ?? []).isNotEmpty)
            Wrap(
              spacing: 6,
              children: observation.domain!.map((d) {
                final color = hexToColor(d.color ?? "#000000");

                return Container(
                  margin: EdgeInsets.only(left: 16, bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    d.name ?? "",
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),

          _actions(context),
          _replyBox(context, observation.id.toString(), index),
        ],
      ),
    );
  }

  // ── Type-specific field builder ───────────────────────────────────────────

  Widget _typeSpecificFields() {
    final obsType = observation.obsType ?? "";
    final typeData = observation.typeData;
    if (typeData == null) return const SizedBox();

    switch (obsType) {
      case "O": // Observation – nothing extra beyond description + whatsNext
        return const SizedBox();

      case "A": // Assessment
        return _assessmentFields(typeData);

      case "TYPC": // Two years progress check
        return _twoYearCheckFields(typeData);

      case "SI": // Settling in
        return _settlingInFields(typeData);

      case "BA": // Baseline Assessment
        return _baselineAssessmentFields(typeData);

      default:
        return const SizedBox();
    }
  }

  // ── Assessment (A) ────────────────────────────────────────────────────────

  Widget _assessmentFields(TypeData typeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _areaSection("Communication and Language", typeData.areas?.communicationLanguage),
        _areaSection("Personal, Social and Emotional Development", typeData.areas?.psed),
        _areaSection("Physical Development", typeData.areas?.physicalDevelopment),
        _areaSection("Literacy", typeData.areas?.literacy),
        _areaSection("Mathematics", typeData.areas?.mathematics),
        _areaSection("Understanding the World", typeData.areas?.understandingWorld),
        _areaSection("Expressive Arts and Design", typeData.areas?.ead),
      ],
    );
  }

  // ── Two Years Progress Check (TYPC) ───────────────────────────────────────

  Widget _twoYearCheckFields(TypeData typeData) {
    final tabs = typeData.tabs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _areaSection("Communication and Language", typeData.areas?.communicationLanguage),
        _areaSection("Personal, Social and Emotional Development", typeData.areas?.psed),
        _areaSection("Physical Development", typeData.areas?.physicalDevelopment),
        _areaSection("Literacy", typeData.areas?.literacy),
        _areaSection("Mathematics", typeData.areas?.mathematics),
        _areaSection("Understanding the World", typeData.areas?.understandingWorld),
        _areaSection("Expressive Arts and Design", typeData.areas?.ead),
        if (tabs != null) ...[
          _tabField("Playing & Exploring", tabs["playing_exploring"]),
          _tabField("Active Learning", tabs["active_learning"]),
          _tabField("Creating & Thinking Critically", tabs["creating_thinking"]),
          _tabField("Child's Strengths & Interests", tabs["strengths"]),
          _tabField("Activities & Strategies", tabs["activities_development"]),
          _tabField("Info from Other Agencies", tabs["agencies_info"]),
          _tabField("Parent/Carer Comments", tabs["parent_comments"]),
        ],
      ],
    );
  }

  // ── Settling In (SI) ──────────────────────────────────────────────────────

  Widget _settlingInFields(TypeData typeData) {
    final tabs = typeData.tabs;
    if (tabs == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabField("Playing & Exploring", tabs["playing_exploring"]),
        _tabField("Active Learning", tabs["active_learning"]),
        _tabField("Creating & Thinking Critically", tabs["creating_thinking"]),
        _tabField("Context", tabs["context"]),
      ],
    );
  }

  // ── Baseline Assessment (BA) ──────────────────────────────────────────────

  Widget _baselineAssessmentFields(TypeData typeData) {
    final tabs = typeData.tabs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _areaSection("Communication and Language", typeData.areas?.communicationLanguage),
        _areaSection("Personal, Social and Emotional Development", typeData.areas?.psed),
        _areaSection("Physical Development", typeData.areas?.physicalDevelopment),
        _areaSection("Literacy", typeData.areas?.literacy),
        _areaSection("Mathematics", typeData.areas?.mathematics),
        _areaSection("Understanding the World", typeData.areas?.understandingWorld),
        _areaSection("Expressive Arts and Design", typeData.areas?.ead),
        if (tabs != null) ...[
          _tabField("Playing & Exploring", tabs["playing_exploring"]),
          _tabField("Active Learning", tabs["active_learning"]),
          _tabField("Creating & Thinking Critically", tabs["creating_thinking"]),
        ],
      ],
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  /// Renders a development area block (assessment_type + age_band + text).
  Widget _areaSection(String title, CommunicationLanguage? area) {
    if (area == null) return const SizedBox();
    final hasText = (area.text ?? "").trim().isNotEmpty;
    final hasAssessment = (area.assessmentType ?? "").trim().isNotEmpty;
    final hasAgeBand = (area.ageBandLabel ?? "").trim().isNotEmpty;
    if (!hasText && !hasAssessment && !hasAgeBand) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color_secondary,
            ),
          ),
          const SizedBox(height: 6),

          // Assessment type row
          if (hasAssessment) ...[
            _labelValue("Assessment", area.assessmentType ?? ""),
            const SizedBox(height: 4),
          ],

          // Age band row
          if (hasAgeBand) ...[
            _labelValue("Age Band", area.ageBandLabel ?? ""),
            const SizedBox(height: 4),
          ],

          // Reflections / text
          if (hasText) ...[
            Text(
              "Reflections",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              area.text ?? "",
              style: const TextStyle(fontSize: 13, color: text_color),
            ),
          ],
        ],
      ),
    );
  }

  /// Renders a tab field (e.g. Playing & Exploring).
  Widget _tabField(String label, dynamic value) {
    final text = (value ?? "").toString().trim();
    if (text.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color_secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: text_color),
          ),
        ],
      ),
    );
  }

  /// Inline label + value row.
  Widget _labelValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: text_color),
          ),
        ),
      ],
    );
  }

  // ── Existing widget methods (unchanged) ───────────────────────────────────

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
          if (observation.createdBy?.id ==
              childInfoController.loginResponse.value.data?.user?.id)
            InkWell(
              onTap: () {
                showUpdateDialog(
                  context,
                  childId,
                  observation.id.toString(),
                  observation,
                  childInfoController,
                );
                printData("update", "val");
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

  Widget _image(BuildContext context) {
    final mediaList = observation.media ?? [];
    if (mediaList.isEmpty) return const SizedBox();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: mediaList.length,
            onPageChanged: (page) {
              childInfoController.updateImagePage(index, page);
            },
            itemBuilder: (context, i) {
              final url = mediaList[i].image ?? "";
              return _isImageUrl(url)
                  ? _imageItem(context, mediaList, i)
                  : _attachmentItem(context, mediaList[i]);
            },
          ),
        ),

        if (mediaList.length > 1)
          Obx(() {
            final currentPage = childInfoController.imagePageMap[index] ?? 0;
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

  bool _isImageUrl(String url) {
    final lower = url.toLowerCase().split('?').first;
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

  Widget _imageItem(BuildContext context, List<ObservationMedia> mediaList, int i) {
    return GestureDetector(
      onTap: () => showFullImageDialogForObservation(context, mediaList, i),
      child: Image.network(
        mediaList[i].image??"",
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

  Widget _attachmentItem(BuildContext context, ObservationMedia media) {
    final url = media.image ?? "";
    final name = _fileName(url);
    final isPdf = (media.extension ?? "").toLowerCase() == "pdf" ||
        url.toLowerCase().split('?').first.endsWith('.pdf');

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
                      errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
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
                    errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(),
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

  Widget _whatsNext() {
    if ((observation.typeData?.whatsNext ?? "").isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            "What's Next?",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color_secondary,
            ),
          ),
          const SizedBox(height: 2),
          Html(
            data: _sanitizeHtml(observation.typeData?.whatsNext ?? ""),
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
                          errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
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
                        errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _sanitizeHtml(String html) {
    html = html.replaceAllMapped(
      RegExp(r'font-feature-settings:[^;}"]*', caseSensitive: false),
          (match) => '',
    );
    html = html.replaceAllMapped(
      RegExp(r'font-variant-[^:]*:[^;}"]*', caseSensitive: false),
          (match) => '',
    );
    html = html.replaceAll(';;', ';');
    html = html.replaceAll('style=""', '');
    html = html.replaceAll('style=" "', '');
    return html;
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
              isLikeOrNot() ? icon_like : unlike,
              width: 16,
            ),
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
                childInfoController.pageNumberObservation = 1;
                childInfoController.callObservationListAPI(context, childId);
              });
            },
            child: Row(
              children: [
                SvgPicture.asset(icon_comment, width: 16),
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
              icon: SvgPicture.asset(send, width: 22),
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
      ChildInfoController controller,
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
                ListTile(
                  leading: const Icon(Icons.edit_note, color: color_secondary),
                  title: BlueMediumBoldText("Update"),
                  onTap: () {
                    controller.selectedObservation.value = observation;
                    Navigator.pop(context);
                    Get.to(ObservationUpdateScreen(childId: childId))?.then((
                        value,
                        ) {
                      childInfoController.pageNumberObservation = 1;
                      controller.callObservationListAPI(context, childId);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLikeOrNot() {
    bool isLikedByMe =
        observation.likes?.any(
              (like) =>
          like.userId ==
              childInfoController.loginResponse.value.data?.user?.id,
        ) ??
            false;
    return isLikedByMe;
  }
}

class AllImagesScreenForObservation extends StatelessWidget {
  final List<ObservationMedia> mediaList;

  const AllImagesScreenForObservation({super.key, required this.mediaList});

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
              showFullImageDialogForObservation(context, mediaList, index);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: media.image ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) =>  Center(
  child: CircularProgressIndicator(),
),
                errorWidget: (context, url, error) =>  Center(
  child: CircularProgressIndicator(),
),
              ),
            ),
          );
        },
      ),
    );
  }
}

Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xff')));
}