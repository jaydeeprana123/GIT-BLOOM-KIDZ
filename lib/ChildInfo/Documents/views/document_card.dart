import 'dart:io';

import 'package:bloom_kidz/ChildInfo/Documents/models/documents_response.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final DocumentData documentData;
  final String childId;
  final ChildInfoController controller;
  const DocumentCard({
    super.key,
    required this.documentData,
    required this.childId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: color_secondary,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            _pdfIcon(),
            const SizedBox(width: 12),
            _docInfo(),
            _actions(controller),
          ],
        ),
      ),
    );
  }

  Widget _pdfIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          (documentData.extension ?? "").toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _docInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueLargeBoldText(documentData.name ?? ""),
          SizedBox(height: 4),
          BlackSmallRegularText(
            documentData.uploadedAt ?? "",
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _actions(ChildInfoController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Size: ${documentData.size ?? "0 MB"}",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            InkWell(
              onTap: () {
                downloadAndOpenPdf(documentData.url ?? "", controller);
              },
              child: _iconButton(icon_cirlce_download),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: () async {
                Uri launchUri = Uri.parse(documentData.url ?? "");
                await launchUrl(
                  launchUri,
                  mode: LaunchMode.externalApplication,
                );
              },
              child: _iconButton(eyeIcon),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(icon, width: 14, color: Colors.white),
    );
  }

  Future<void> downloadAndOpenPdf(String url, ChildInfoController controller) async {


    controller.isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/document.pdf');

        await file.writeAsBytes(response.bodyBytes);
        controller.isLoading.value = false;
        /// Open PDF
        await OpenFilex.open(file.path);
      } else {
        controller.isLoading.value = false;
        throw Exception("Failed to download PDF");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }
}
