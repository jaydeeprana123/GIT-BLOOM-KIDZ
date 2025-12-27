import 'package:bloom_kidz/ChildInfo/FamilyContact/view/family_update_screen.dart';
import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/ChildInfo/models/family_contact_list_response.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final FamilyContact familyContact;
  ChildInfoController childInfoController;

   ContactCard({
    super.key,
     required this.familyContact,
    required this.childInfoController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: color_secondary,
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          22,
        ), // change 16 to any radius you like
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(familyContact.imageUrl??""),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlueLargeBoldText(
                    "${familyContact.firstName ??""} ${familyContact.lastName ??""}",
                  ),
                  const SizedBox(height: 2),
                  BlackMediumRegularText(
                      familyContact.relation ??"",
                    fontSize: 12
                  ),
                ],
              ),
            ),
             InkWell(onTap: (){
               showUpdateDeleteDialog(context, familyContact.id.toString());
             },child: Icon(Icons.more_vert, color: color_secondary)),
          ],
        ),
      ),
    );
  }


  void showUpdateDeleteDialog(BuildContext context, String id) {
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

                /// ✏️ Update
                ListTile(
                  leading: const Icon(Icons.edit_note, color: color_secondary),
                  title: BlueMediumBoldText("Update"),
                  onTap: () {
                    Navigator.pop(context);

                    childInfoController.selectedFamilyContact.value = familyContact;
                    Get.to(FamilyUpdateScreen());

                  },
                ),

                const Divider(),

                /// 🗑 Delete
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    showDeleteWarningDialog(context, onConfirm: (){

                      childInfoController.callDeleteContactAPI(context,id);
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


  void showDeleteWarningDialog(
      BuildContext context, {
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ⚠️ Icon
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 50,
                ),

                const SizedBox(height: 12),

                /// Title
                BlueMediumBoldText(
                  "Delete Contact",
                  fontSize: 16,
                  color: Colors.red,
                ),

                const SizedBox(height: 8),

                /// Message
                const Text(
                  "Are you sure you want to delete this contact?\nThis action cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}





