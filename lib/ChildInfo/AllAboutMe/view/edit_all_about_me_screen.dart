import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
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

class EditAllAboutMeScreen extends StatefulWidget {
  final String childId;

  const EditAllAboutMeScreen({Key? key, required this.childId})
    : super(key: key);

  @override
  State<EditAllAboutMeScreen> createState() => _EditAllAboutMeScreenState();
}

class _EditAllAboutMeScreenState extends State<EditAllAboutMeScreen> {
  ChildInfoController controller = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    final data = controller.allAboutMe.value;

    /// Prefill data
    controller.preferredNameController.value.text = data.preferredName ?? "";

    controller.homeLanguageController.value.text = data.homeLanguage ?? "";

    controller.spokenLanguageController.value.text = data.spokenLanguages ?? "";

    controller.celebrationsController.value.text = data.celebrations ?? "";

    controller.happyThingsController.value.text = data.happyThings ?? "";

    controller.favouriteController.value.text = data.favouriteBooksSongs ?? "";

    controller.dislikesController.value.text = data.dislikes ?? "";

    controller.eatingController.value.text = data.eatingDrinking ?? "";

    controller.foodDislikesController.value.text =
        data.foodDislikes?.toString() ?? "";

    controller.healthController.value.text =
        data.healthConditions?.toString() ?? "";

    controller.allergiesController.value.text =
        data.allergies?.toString() ?? "";

    controller.allergyTreatmentController.value.text =
        data.allergyTreatment?.toString() ?? "";

    controller.daySleepController.value.text = data.daySleep ?? "";

    controller.sleepRoutineController.value.text = data.sleepRoutine ?? "";

    controller.comfortMethodController.value.text = data.comfortMethod ?? "";

    controller.supportBeforeStartController.value.text =
        data.supportBeforeStart?.toString() ?? "";

    controller.primaryCollectorController.value.text =
        data.primaryCollector ?? "";

    controller.alternateCollectorController.value.text =
        data.alternateCollector ?? "";

    controller.additionalNotesController.value.text = parseHtmlString(
      data.additionalNotes?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Edit All About Me",
        showBack: true,
        showMenu: false,
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Card(
              color: Colors.white,
              shadowColor: color_secondary,
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  22,
                ), // change 16 to any radius you like
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Languages
                    _buildField(
                      "My first language at home is",
                      controller.homeLanguageController.value,
                    ),

                    _buildField(
                      "I can speak in",
                      controller.spokenLanguageController.value,
                    ),

                    /// Personal Preferences
                    _buildField(
                      "My Family and I celebrate",
                      controller.celebrationsController.value,
                    ),

                    _buildField(
                      "These are the things that make me happy",
                      controller.happyThingsController.value,
                    ),

                    _buildField(
                      "My favourite book, story and songs are",
                      controller.favouriteController.value,
                    ),

                    _buildField(
                      "Things I do not like or make me sad",
                      controller.dislikesController.value,
                    ),

                    /// Food & Health
                    _buildField(
                      "Eating & Drinking",
                      controller.eatingController.value,
                    ),

                    _buildField(
                      "Things I do not like to eat or drink",
                      controller.foodDislikesController.value,
                    ),

                    _buildField(
                      "These are my relevant health conditions",
                      controller.healthController.value,
                    ),

                    _buildField(
                      "These are the things I am allergic to",
                      controller.allergiesController.value,
                    ),

                    _buildField(
                      "If I have an allergic reaction the treatment is:",
                      controller.allergyTreatmentController.value,
                    ),

                    /// Sleep Routine
                    _buildField(
                      "I do or do not have a sleep during the day",
                      controller.daySleepController.value,
                    ),

                    _buildField(
                      "This is my usual sleeping routine",
                      controller.sleepRoutineController.value,
                    ),

                    _buildField(
                      "This is how you can comfort and calm me down, if I become upset",
                      controller.comfortMethodController.value,
                    ),

                    /// Collection Information
                    _buildField(
                      "Who will collect me from nursery?",
                      controller.primaryCollectorController.value,
                    ),

                    _buildField(
                      "If the above-named person cannot collect me, who will collect me from nursery?",
                      controller.alternateCollectorController.value,
                    ),

                    /// Additional
                    _buildField(
                      "Support Before Start",
                      controller.supportBeforeStartController.value,
                    ),

                    _buildField(
                      "Parents, is there anything else?",
                      controller.additionalNotesController.value,
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: CommonGradientButton(
                        btnTitle: "UPDATE",
                        onPressed: () {
                          controller.callUpdateAllAboutMeAPI(
                            context,
                            widget.childId,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (controller.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueMediumBoldText(label, fontSize: 12),
          const SizedBox(height: 4),

          CommonTextField(hint: label, controller: controller),
        ],
      ),
    );
  }
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = document.body?.text ?? '';
  return parsedString;
}
