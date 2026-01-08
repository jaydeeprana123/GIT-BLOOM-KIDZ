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


class ObservationAddScreen extends StatefulWidget {
  final String childId;

  const ObservationAddScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<ObservationAddScreen> createState() => _ObservationAddScreenState();
}

class _ObservationAddScreenState extends State<ObservationAddScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

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
            Positioned.fill(
              child: SvgPicture.asset(
                app_bg,
                fit: BoxFit.cover,
              ),
            ),

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
                                fontFamily: fontInterBold
                              ),

                              const SizedBox(height: 16),

                              CommonTextField(
                                hint: "Observation...",
                                controller: childInfoController
                                    .firstNameController.value,
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
                                    childInfoController.observationImagePath.add(await selectPhoto(context, true));
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
                                      Icon(Icons.upload,
                                          color: Colors.white, size: 18),
                                    ],
                                  ),
                                ),
                              ),

                              if (childInfoController.observationImagePath.value.isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [

                                      for(int i=0; i<childInfoController.observationImagePath.length ;i++)Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(58),
                                            child: Image.file(
                                              File(
                                                  childInfoController.observationImagePath[i]),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                )
                                ,

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
                                      childInfoController
                                          .callAddFamilyAPI(context);
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




