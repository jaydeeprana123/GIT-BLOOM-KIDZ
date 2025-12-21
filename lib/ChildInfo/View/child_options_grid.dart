import 'package:bloom_kidz/ChildInfo/View/document_screen.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_screen.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'family_add_screen.dart';
import 'family_contact_screen.dart';
import 'grid_item.dart';

class ChildOptionsGrid extends StatelessWidget {
  const ChildOptionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      GridItem(Icons.extension, "Activity"),
      InkWell(onTap: (){
        Get.to(AboutScreen());
      },child: GridItem(Icons.info, "About")),
      GridItem(Icons.route, "Journey"),
      GridItem(Icons.shield, "Safeguarding"),
      GridItem(Icons.key, "Child Permission"),
      GridItem(Icons.event, "Booking"),
      InkWell(onTap: (){
        Get.to(DocumentsScreen());
      },child: GridItem(Icons.description, "Documents")),
      InkWell(onTap: (){
        Get.to(FamilyContactsScreen());

      },child: GridItem(Icons.group, "Family & Contacts")),
      GridItem(Icons.add_task, "Book Extra Sessions"),
      GridItem(Icons.calendar_month, "Weekly Plan"),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}

