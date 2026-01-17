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

class FamilyUpdateScreen extends StatefulWidget {
  const FamilyUpdateScreen({Key? key}) : super(key: key);

  @override
  State<FamilyUpdateScreen> createState() => _FamilyUpdateScreenState();
}

class _FamilyUpdateScreenState extends State<FamilyUpdateScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();
    childInfoController.clearFamilyFields();
    childInfoController.firstNameController.value.text =
        childInfoController.selectedFamilyContact.value.firstName ?? "";
    childInfoController.lastNameController.value.text =
        childInfoController.selectedFamilyContact.value.lastName ?? "";
    childInfoController.emailController.value.text =
        childInfoController.selectedFamilyContact.value.email ?? "";
    childInfoController.mobileController.value.text =
        childInfoController.selectedFamilyContact.value.mobile ?? "";
    childInfoController.relationController.value.text =
        childInfoController.selectedFamilyContact.value.relation ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Update Family",
        showMenu: false,
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
                                "Update Contact",
                                fontSize: 16,
                                color: color_secondary,
                              ),

                              const SizedBox(height: 16),

                              CommonTextField(
                                hint: "First Name",
                                controller: childInfoController
                                    .firstNameController
                                    .value,
                              ),
                              const SizedBox(height: 12),

                              CommonTextField(
                                hint: "Last Name",
                                controller: childInfoController
                                    .lastNameController
                                    .value,
                              ),
                              const SizedBox(height: 12),

                              CommonTextField(
                                hint: "Relation to Child",
                                controller: childInfoController
                                    .relationController
                                    .value,
                              ),
                              const SizedBox(height: 12),

                              CommonTextField(
                                hint: "Mobile",
                                controller:
                                    childInfoController.mobileController.value,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 12),

                              CommonTextField(
                                hint: "Email",
                                controller:
                                    childInfoController.emailController.value,
                                keyboardType: TextInputType.emailAddress,
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
                                    childInfoController.imagePath.value =
                                        await selectPhoto(context, true);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (childInfoController
                                                    .imagePath
                                                    .value
                                                    .isEmpty &&
                                                (childInfoController
                                                            .selectedFamilyContact
                                                            .value
                                                            .imageUrl ??
                                                        "")
                                                    .isNotEmpty)
                                            ? "Update Profile Image"
                                            : "Profile Image",
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

                              (childInfoController.imagePath.value.isNotEmpty)
                                  ? Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            margin: const EdgeInsets.only(
                                              top: 16,
                                              right: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // ⬅ square with small radius
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.file(
                                                File(
                                                  childInfoController
                                                      .imagePath
                                                      .value,
                                                ),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          /// ❌ Close Button
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () {
                                                childInfoController
                                                        .imagePath
                                                        .value =
                                                    "";
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
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
                                    )
                                  : (childInfoController
                                                .selectedFamilyContact
                                                .value
                                                .imageUrl ??
                                            "")
                                        .isNotEmpty
                                  ? Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(
                                        top: 16,
                                        right: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        // ⬅ square with small radius
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        child: Image.network(
                                          childInfoController
                                              .selectedFamilyContact
                                              .value
                                              .imageUrl ??
                                              "",
                                          height: 200,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    /// ❌ Close Button
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          childInfoController
                                              .selectedFamilyContact
                                              .value
                                              .imageUrl  =
                                          "";

                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
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
                              )
                                  : SizedBox(),

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
                                      childInfoController.callUpdateFamilyAPI(
                                        context,
                                        childInfoController
                                            .selectedFamilyContact
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
