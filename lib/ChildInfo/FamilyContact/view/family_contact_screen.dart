import 'package:bloom_kidz/ChildInfo/FamilyContact/view/family_add_screen.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
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

import '../../../CommonWidgets/common_appbar.dart';
import '../../controller/child_info_controller.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'contact_card.dart';

class FamilyContactsScreen extends StatefulWidget {
  const FamilyContactsScreen({Key? key}) : super(key: key);

  @override
  State<FamilyContactsScreen> createState() => _FamilyContactsScreenState();
}

class _FamilyContactsScreenState extends State<FamilyContactsScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    childInfoController.callGetFamilyContactsAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Family & Contacts",
        showMenu: true,
        showBack: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Column(
              children: [
                _addContactButton(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: childInfoController.familyContactList.length,
                    itemBuilder: (context, index) {
                      final contact =
                          childInfoController.familyContactList[index];

                      return ContactCard(
                        familyContact: contact,
                        childInfoController: childInfoController,
                      );
                    },
                  ),
                ),
              ],
            ),

            if (childInfoController.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  /// 🔹 Add Contact Button
  Widget _addContactButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            Get.to(FamilyAddScreen())?.then((value) {
              childInfoController.callGetFamilyContactsAPI(context);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color_secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: BlackMediumBoldText("Add Contact", color: Colors.white),
        ),
      ),
    );
  }
}
