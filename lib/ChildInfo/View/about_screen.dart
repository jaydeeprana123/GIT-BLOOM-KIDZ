import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_large_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
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
import 'package:get/get_core/src/get_main.dart';

import '../../CommonWidgets/common_appbar.dart';
import '../About/models/about_response.dart';
import 'about_card.dart';
import 'about_tab.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  final String childId;

  const AboutScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();


  @override
  void initState() {
    super.initState();

    childInfoController.callGetAboutChildAPI(context, widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "About", showMenu: true, showBack: true,),
      body: Obx(() {
        final basic = childInfoController.aboutChildren.value.basicInfo;
        final health = childInfoController.aboutChildren.value.healthInfo;
        final religion = childInfoController.aboutChildren.value.religionInfo;
        if (childInfoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [

            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Column(
              children: [
                const SizedBox(height: 22),
                _topTabs(),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: (childInfoController.selectedTab.value == 0)
                            ? _mainCard(childInfoController.aboutChildren.value.basicInfo??BasicInfo())
                            :
                        (childInfoController.selectedTab.value == 1)
                            ? _healthCard(health)
                            : (childInfoController.selectedTab.value == 2)
                            ? _sensitiveInfoCard(
                          childInfoController.aboutChildren.value.religionInfo,
                        ):(childInfoController.selectedTab.value == 3)
                            ? _registrationInfoCard(
                          childInfoController.aboutChildren.value.roomMoves,
                        ):SizedBox()))

              ],
            ),

            if(childInfoController.isLoading.value)Center(
              child: CircularProgressIndicator(),)
          ],
        );
      }),

    );
  }

  Widget _topTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [

          SizedBox(width: 16,),

          _tabItem(Icons.info, "Basic", 0),
          const SizedBox(width: 8),
          _tabItem(Icons.favorite, "Health Information", 1),
          const SizedBox(width: 8),
          _tabItem(Icons.lock, "Sensitive Inform", 2),
          const SizedBox(width: 8),
          _tabItem(Icons.lock, "Registration & Room Moves", 3),
        ],
      ),
    );
  }


  Widget _mainCard(BasicInfo basic) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        shadowColor: color_secondary,
        elevation: 6,
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _profileSection(basic),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),
              _twoColumnInfo(
                "Date Of Birth",
                _formatDate(basic.dob),
                Icons.calendar_today,
                "Nationality",
                basic.nationality,
                Icons.public,
              ),
              _twoColumnInfo(
                "Birth Place",
                basic.birthPlace,
                Icons.location_on,
                "Live With",
                basic.liveWith?.join(", "),
                Icons.home,
              ),
              Divider(color: Colors.grey.shade300),
              _singleInfo("Parent Responsibility",
                  basic.parentalResponsibility?.join(", "), Icons.group),
              _singleInfo("Key Person", basic.keyPerson, Icons.person),
              if (basic.secondKeyPerson != null)
                _singleInfo("Second Key Person", basic.secondKeyPerson,
                    Icons.person_outline),
              Divider(color: Colors.grey.shade300),
              _singleInfo("Second Key Person", basic.secondKeyPerson,
                  Icons.person_outline),
              _specialNote(basic.specialNote),
            ],
          ),
        ),
      ),
    );
  }


  Widget _twoColumnInfo(String title1,
      String? value1,
      IconData icon1,
      String title2,
      String? value2,
      IconData icon2,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: _infoWithIcon(title1, value1, icon1)),
          Expanded(child: _infoWithIcon(title2, value2, icon2)),
        ],
      ),
    );
  }

  Widget _singleInfo(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _infoWithIcon(title, value, icon),
    );
  }

  Widget _infoWithIcon(String title, String? value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color_secondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlueMediumBoldText(title, fontFamily: fontInterBold),
              const SizedBox(height: 2),
              BlackMediumBoldText(value ?? "-", color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }


  Widget _specialNote(String? note) {
    if (note == null || note.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.note, size: 18, color: color_secondary),
            SizedBox(width: 6),
            Text(
              "Special Note",
              style: TextStyle(
                color: color_secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(note),
      ],
    );
  }


  Widget _tabItem(IconData icon, String title, int index) {
    final isSelected = childInfoController.selectedTab.value == index;

    return InkWell(
      onTap: () {
        childInfoController.selectedTab.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? color_secondary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color_secondary),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16,
                color: isSelected ? Colors.white : color_secondary),
            const SizedBox(width: 6),
            BlackMediumBoldText(
              title,
              color: isSelected ? Colors.white : color_secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileSection(BasicInfo basic) {
    return Column(
      children: [
        CircleAvatar(
          radius: 65,
          backgroundImage: NetworkImage(basic.profileImage ?? ""),
        ),
        const SizedBox(height: 8),
        BlueLargeBoldText(
            basic.firstName ?? "",
            color: Colors.black,
            fontSize: 18
        ),
        BlackMediumBoldText(
          basic.lastName ?? "",
          color: Colors.black,
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }


  Widget _healthCard(HealthInfo? health) {
    if (health == null) return const SizedBox();

    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        shadowColor: color_secondary,
        elevation: 6,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _healthRow(
                Icons.medical_services,
                "Tolerates Penicillin",
                health.toleratesPenicillin == 1 ? "Yes" : "No",
              ),
              _healthRow(
                Icons.restaurant,
                "Special Dietary Considerations",
                health.specialDietaryConsiderations,
              ),
              _healthRow(
                Icons.vaccines,
                "Vaccines",
                health.vaccines,
              ),
              _healthRow(
                Icons.warning,
                "Allergy",
                health.allergy,
              ),

              const Divider(height: 32),
              _healthRow(
                Icons.note_alt,
                "Special Note",
                health.specialNote,
              ),


              const Divider(height: 32),

              _doctorInfo(),
              const Divider(height: 32),
              _dentistInfo(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _healthRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color_secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlueMediumBoldText(title, fontFamily: fontInterBold),
                const SizedBox(height: 4),
                BlackMediumBoldText(
                  value?.isNotEmpty == true ? value! : "-",
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _sectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _doctorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Doctor Info"),
        const SizedBox(height: 10),
        _infoLine(Icons.person, "Name", "Lorem Ipsum"),
        _infoLine(Icons.phone, "Mobile", "+91 232 1323"),
        _infoLine(
            Icons.location_on, "Address", "Lorem Ipsum is simply dummy text"),
      ],
    );
  }

  Widget _dentistInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Dentist Info"),
        const SizedBox(height: 10),
        _infoLine(Icons.person, "Name", "Lorem Ipsum"),
        _infoLine(Icons.phone, "Mobile", "+91 232 1323"),
        _infoLine(
            Icons.location_on, "Address", "Lorem Ipsum is simply dummy text"),
      ],
    );
  }

  Widget _infoLine(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color_secondary),
          const SizedBox(width: 6),
          BlueLargeBoldText("$title: ", fontFamily: fontInterBold

          ),
          Expanded(child: BlackMediumBoldText(value, color: Colors.black)),
        ],
      ),
    );
  }


  Widget _sensitiveInfoCard(ReligionInfo? sensitive) {
    if (sensitive == null) return const SizedBox();

    return Card(
      color: Colors.white,
      shadowColor: color_secondary,
      elevation: 6,
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sensitiveRow(
              icon: Icons.person_outline,
              title: "Religion",
              value: sensitive.religion,
            ),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: Icons.groups_outlined,
              title: "Ethnicity",
              value: sensitive.ethnicity,
            ),
          ],
        ),
      ),
    );
  }


  Widget _registrationInfoCard(RoomMoves? roomMoves) {
    if (roomMoves == null) return const SizedBox();

    return Card(
      color: Colors.white,
      shadowColor: color_secondary,
      elevation: 6,
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sensitiveRow(
              icon: Icons.room_preferences,
              title: "Rooms",
              value: roomMoves.rooms,
            ),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: Icons.date_range,
              title: "Start Date",
              value: roomMoves.startDate,
            ),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: Icons.date_range,
              title: "End Date",
              value: roomMoves.endDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensitiveRow({
    required IconData icon,
    required String title,
    required String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blue),
            const SizedBox(width: 6),
            BlueMediumBoldText(title, fontFamily: fontInterBold),
          ],
        ),
        const SizedBox(height: 6),
        BlackMediumBoldText(
          value?.isNotEmpty == true ? value! : "-",
          color: Colors.black,
        ),
      ],
    );
  }


}


