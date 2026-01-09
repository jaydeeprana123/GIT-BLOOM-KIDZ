import 'dart:io';

import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../../CommonWidgets/common_widget.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';

class ObservationUpdateScreen extends StatefulWidget {
  final String childId;

  const ObservationUpdateScreen({Key? key, required this.childId})
    : super(key: key);

  @override
  State<ObservationUpdateScreen> createState() =>
      _ObservationUpdateScreenState();
}

class _ObservationUpdateScreenState extends State<ObservationUpdateScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    childInfoController.observationController.value.text =
        childInfoController.selectedObservation.value.observations ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "New Observation",
        showMenu: true,
        showBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 FULL SCREEN BACKGROUND
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            /// 🔹 FOREGROUND CONTENT
            Obx(
              () => Stack(
                children: [
                  /// Scrollable Content
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Card(
                        color: Colors.white,
                        shadowColor: color_secondary,
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlueMediumBoldText(
                                "Observation For Children Name ",
                                fontSize: 18,
                                color: color_secondary,
                                fontFamily: fontInterBold,
                              ),

                              const SizedBox(height: 16),

                              CommonTextField(
                                hint: "Observation...",
                                controller: childInfoController
                                    .observationController
                                    .value,
                                maxLines: 6,
                              ),

                              const SizedBox(height: 16),

                              /// Profile Image Button
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E73B8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    childInfoController.observationImagePath
                                        .add(await selectPhoto(context, true));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "UPLOAD",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.upload,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if ((childInfoController
                                          .selectedObservation
                                          .value
                                          .media ??
                                      [])
                                  .isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (
                                        int i = 0;
                                        i <
                                            (childInfoController
                                                        .selectedObservation
                                                        .value
                                                        .media ??
                                                    [])
                                                .length;
                                        i++
                                      )
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(58),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(58),
                                                child: Image.network(
                                                  childInfoController
                                                          .selectedObservation
                                                          .value
                                                          .media?[i]
                                                          .image ??
                                                      "",
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

                                            /// ❌ Close Button
                                            Positioned(
                                              top: -6,
                                              right: -6,
                                              child: GestureDetector(
                                                onTap: () {
                                                  childInfoController
                                                      .removedMediaIds
                                                      .add(
                                                        childInfoController
                                                                .selectedObservation
                                                                .value
                                                                .media?[i]
                                                                .id ??
                                                            0,
                                                      );

                                                  /// remove image / clear item
                                                  (childInfoController
                                                              .selectedObservation
                                                              .value
                                                              .media ??
                                                          [])
                                                      .removeAt(i);
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),

                              if (childInfoController
                                  .observationImagePath
                                  .isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (
                                        int i = 0;
                                        i <
                                            childInfoController
                                                .observationImagePath
                                                .length;
                                        i++
                                      )
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          // space between image & border
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              58,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue,
                                              // border color
                                              width: 2, // border width
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              58,
                                            ),
                                            child: Image.file(
                                              File(
                                                childInfoController
                                                    .observationImagePath[i],
                                              ),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 20),

                              /// Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: BlueMediumBoldText("Back"),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: color_secondary,
                                    ),
                                    onPressed: () {
                                      if (childInfoController
                                          .observationController
                                          .value
                                          .text
                                          .toString()
                                          .isEmpty) {
                                        snackBarRapid(
                                          context,
                                          "Please enter observation",
                                        );
                                        return;
                                      }

                                      childInfoController
                                          .callUpdateObservationAPI(
                                            context,
                                            widget.childId,
                                            childInfoController
                                                .selectedObservation
                                                .value
                                                .id
                                                .toString(),
                                          );
                                    },
                                    child: BlueMediumBoldText(
                                      "Save",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// 🔄 Loader
                  if (childInfoController.isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
