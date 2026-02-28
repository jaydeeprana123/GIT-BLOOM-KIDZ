import 'package:bloom_kidz/ChildInfo/AllAboutMe/view/edit_all_about_me_screen.dart';
import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/black_medium_regular_text.dart';
import '../../../CommonWidgets/black_small_regular_text.dart';
import '../../../CommonWidgets/blue_large_bold_text.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/blue_medium_regular_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/all_about_me_response.dart';

class AllAboutMeScreen extends StatefulWidget {
  final String childId;

  const AllAboutMeScreen({Key? key, required this.childId})
      : super(key: key);

  @override
  State<AllAboutMeScreen> createState() => _AllAboutMeScreenState();
}

class _AllAboutMeScreenState extends State<AllAboutMeScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.callAllAboutMe(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CommonAppBar(
        title: "All About Me",
        showMenu: false,
        showBack: true,
        showEditButton: true,
        onAddButtonTap: (){
          Get.to(EditAllAboutMeScreen(childId: widget.childId))?.then((value) {
            childInfoController.callAllAboutMe(context, widget.childId);
          });
        }),

      body: Obx(() {
        if (childInfoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = childInfoController.allAboutMe.value;

        if (data.childId == null) {
          return Center(child: BlueLargeBoldText("No Data Found"));
        }

        return Stack(
          children: [

            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionCard("Basic Information", [
                  _infoTile("Name of child", data.childName),
                  _infoTile("I like to be called", data.preferredName),
                  _infoTile("Birth Date", data.birthDate),
                  _infoTile("Start date", data.startDate),
                ]),

                _sectionCard("Languages", [
                  _infoTile("My first language at home is", data.homeLanguage),
                  _infoTile("I can speak in", data.spokenLanguages),
                ]),

                _sectionCard("Personal Preferences", [
                  _infoTile("My Family and I celebrate", data.celebrations),
                  _infoTile("These are the things that make me happy", data.happyThings),
                  _infoTile("My favourite book, story and songs are", data.favouriteBooksSongs),
                  _infoTile("Things I do not like or make me sad ", data.dislikes),
                ]),

                _sectionCard("Food & Health", [
                  _infoTile("Eating & Drinking", data.eatingDrinking),
                  _infoTile("Things I do not like to eat or drink", data.foodDislikes??""),
                  _infoTile("These are my relevant health conditions", data.healthConditions??""),
                  _infoTile("These are the things I am allergic to", data.allergies??""),
                  _infoTile("If I have an allergic reaction the treatment is:", data.allergyTreatment??""),
                ]),

                _sectionCard("Sleep Routine", [
                  _infoTile("I do or do not have a sleep during the day", data.daySleep),
                  _infoTile("This is my usual sleeping routine", data.sleepRoutine),
                  _infoTile("This is how you can comfort and calm me down, if I become upset", data.comfortMethod),
                ]),

                _sectionCard("Collection Information", [
                  _infoTile("Who will collect me from nursery?", data.primaryCollector),
                  _infoTile("If the above-named person cannot collect me, who will collect me from nursery?", data.alternateCollector),
                ]),

                _sectionCard("Additional Notes", [
                  _infoTile("Support Before Start", data.supportBeforeStart??""),
                  _infoTile("Parents, is there anything else?", data.additionalNotes??"NA"),
                ]),
              ],
            ),
          ],
        );
      }),
    );
  }

  /// ---------------- SECTION CARD ----------------
  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Colors.white,
        shadowColor: color_secondary,
        elevation: 6,
        child: Container(

          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlueMediumBoldText(
                title,
                fontSize: 16,
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- INFO TILE ----------------
  Widget _infoTile(String label, String? value) {
    if (value == null || value.trim().isEmpty || value == "null") {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueMediumBoldText(
            label,
          ),
          const SizedBox(height: 2),
          BlackMediumRegularText(
            value,

          ),
        ],
      ),
    );
  }
}
