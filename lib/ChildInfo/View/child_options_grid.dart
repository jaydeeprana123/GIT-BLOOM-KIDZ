import 'package:bloom_kidz/ChildInfo/GroupObservation/view/group_observation_list_screen.dart';
import 'package:bloom_kidz/ChildInfo/Permissions/View/child_permissions_screen.dart';
import 'package:bloom_kidz/ChildInfo/SafeGuarding/views/accident_list_screen.dart';
import 'package:bloom_kidz/ChildInfo/View/ChildActivity/child_activity_screen.dart';
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
import '../ExtraBookings/views/extra_booking_screen.dart';
import '../Observations/views/observation_list_screen.dart';
import '../SafeGuarding/views/medications_list_screen.dart';
import '../SafeGuarding/views/safeguarding_screen.dart';
import 'about_screen.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import '../FamilyContact/view/family_add_screen.dart';
import '../FamilyContact/view/family_contact_screen.dart';
import 'grid_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ChildOptionsGrid extends StatelessWidget {
  final String childId;

  const ChildOptionsGrid({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    final items = [
      _gridItem(
        onTap: () => Get.to(ChildActivityScreen(childId: childId)),
        icon: icon_activity,
        title: "Activity",
      ),
      _gridItem(
        onTap: () => Get.to(AboutScreen(childId: childId)),
        icon: icon_about,
        title: "About",
      ),
      _gridItem(
        onTap: () => Get.to(ObservationListScreen(childId: childId)),
        icon: icon_Journey,
        title: "Journey",
      ),
      _gridItem(
        onTap: () => Get.to(SafeguardingScreen(childId: childId)),
        icon: icon_Safeguarding,
        title: "Safeguarding",
      ),
      _gridItem(
        onTap: () => Get.to(ChildrenPermissionScreen(childId: childId)),
        icon: icon_ChildPermission,
        title: "Child Permission",
      ),
      _gridItem(
        onTap: () => Get.to(BookingScreen(childId: childId)),
        icon: icon_booking,
        title: "Booking",
      ),
      _gridItem(
        onTap: () => Get.to(DocumentsScreen(childId: childId)),
        icon: icon_documents,
        title: "Documents",
      ),
      _gridItem(
        onTap: () => Get.to(FamilyContactsScreen()),
        icon: icon_FamilyContacts,
        title: "Family & Contacts",
      ),
      _gridItem(
        onTap: () => Get.to(ExtraBookingScreen(childId: childId)),
        icon: icon_Book_Extra_Sessions,
        title: "Book Extra Sessions",
      ),


      _gridItem(
        onTap: () => Get.to(GroupObservationListScreen(childId: childId)),
        icon: icon_Journey,
        title: "Group Observation",
      ),
    ];

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  Widget _gridItem({
    required VoidCallback onTap,
    required String icon,
    required String title,
  }) {
    return InkWell(
      onTap: onTap,
      child: GridItem(icon, title),
    );
  }
}

