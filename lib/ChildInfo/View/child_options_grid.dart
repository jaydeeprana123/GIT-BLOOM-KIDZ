import 'package:bloom_kidz/ChildInfo/Permissions/View/child_permissions_screen.dart';
import 'package:bloom_kidz/ChildInfo/View/ChildActivity/activity_screen.dart';
import 'package:bloom_kidz/ChildInfo/Documents/views/document_screen.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Bookings/views/booking_screen.dart';
import '../Observations/views/observation_list_screen.dart';
import 'about_screen.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import '../FamilyContact/view/family_add_screen.dart';
import '../FamilyContact/view/family_contact_screen.dart';
import 'grid_item.dart';

class ChildOptionsGrid extends StatelessWidget {
  final String childId;

  const ChildOptionsGrid({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    final items = [
      InkWell(
        onTap: () {
          Get.to(ActivityScreen(childId: childId));
        },
        child: GridItem(icon_activity, "Activity"),
      ),
      InkWell(
        onTap: () {
          Get.to(AboutScreen());
        },
        child: GridItem(icon_about, "About"),
      ),
      InkWell(onTap: (){
        Get.to(ObservationListScreen(childId: childId,));
      },child: GridItem(icon_Journey, "Journey")),
      GridItem(icon_Safeguarding, "Safeguarding"),
      InkWell(onTap: (){
        Get.to(ChildrenPermissionScreen(childId: childId,));
      },child: GridItem(icon_ChildPermission, "Child Permission")),
      InkWell(onTap: (){
        Get.to(BookingScreen(childId: childId,));
      },child: GridItem(icon_booking, "Booking")),
      InkWell(
        onTap: () {
          Get.to(DocumentsScreen(childId: childId,));
        },
        child: GridItem(icon_documents, "Documents"),
      ),
      InkWell(
        onTap: () {
          Get.to(FamilyContactsScreen());
        },
        child: GridItem(icon_FamilyContacts, "Family & Contacts"),
      ),
      GridItem(icon_Book_Extra_Sessions, "Book Extra Sessions"),
      GridItem(icon_WeeklyPlan, "Weekly Plan"),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
