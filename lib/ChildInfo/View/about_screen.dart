import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../About/models/about_response.dart';
import 'about_card.dart';
import 'about_tab.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  final String childId;

  const AboutScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();


  @override
  void initState() {
    super.initState();

    childInfoController.callGetAboutChildAPI(context,widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Obx(() {
        final basic = childInfoController.aboutChildren.value.basicInfo;

        if (basic == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _profileSection(basic),
              const SizedBox(height: 16),
              _infoCard(basic),
              const SizedBox(height: 16),
              _specialNote(basic.specialNote),
            ],
          ),
        );
      }),
    );
  }


  Widget _profileSection(BasicInfo basic) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(basic.profileImage ?? ""),
        ),
        const SizedBox(height: 8),
        BlackLargeBoldText(
          basic.firstName ?? "",
          color: Colors.black,
          fontSize: 18
        ),
        BlackLargeRegularText(
          basic.lastName ?? "",
          color: Colors.black,
        ),
      ],
    );
  }


  Widget _infoCard(BasicInfo basic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          _infoRow("Date Of Birth", _formatDate(basic.dob)),
          _infoRow("Nationality", basic.nationality),
          _infoRow("Birth Place", basic.birthPlace),
          _infoRow("Live With", basic.liveWith?.join(", ")),
          _infoRow("Parent Responsibility", basic.parentalResponsibility?.join(", ")),
          _infoRow("Key Person", basic.keyPerson),
          if (basic.secondKeyPerson != null)
            _infoRow("Second Key Person", basic.secondKeyPerson),
        ],
      ),
    );
  }


  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: BlueMediumBoldText(
              title,
            ),
          ),
          Expanded(
            flex: 6,
            child: BlackMediumRegularText(value ?? "-", color: Colors.black),
          ),
        ],
      ),
    );
  }


  Widget _specialNote(String? note) {
    if (note == null || note.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Special Note",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(note),
        ],
      ),
    );
  }


  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }


}


