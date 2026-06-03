import 'package:bloom_kidz/ChildInfo/controller/child_info_controller.dart';
import 'package:bloom_kidz/ChildInfo/View/edit_doctor_dentist_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.callGetAboutChildAPI(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Obx(
          () => CommonAppBar(
            title: "About",
            showMenu: false,
            showBack: true,
          ),
        ),
      ),
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
                    padding: const EdgeInsets.all(16.0),
                    child: (childInfoController.selectedTab.value == 0)
                        ? _mainCard(
                            childInfoController.aboutChildren.value.basicInfo ??
                                BasicInfo(),
                          )
                        : (childInfoController.selectedTab.value == 1)
                        ? _healthCard(health)
                        : (childInfoController.selectedTab.value == 2)
                        ? _sensitiveInfoCard(
                            childInfoController
                                .aboutChildren
                                .value
                                .religionInfo,
                          )
                        : (childInfoController.selectedTab.value == 3)
                        ? _registrationInfoCard(
                            childInfoController.aboutChildren.value.roomMoves,
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),

            if (childInfoController.isLoading.value)
              Center(child: CircularProgressIndicator()),
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
          SizedBox(width: 16),

          _tabItem(basicIcon, "Basic", 0),
          const SizedBox(width: 8),
          _tabItem(HealthInformation, "Health Information", 1),
          const SizedBox(width: 8),
          _tabItem(SensitiveInformation, "Sensitive Inform", 2),
          const SizedBox(width: 8),
          _tabItem(Rooms, "Registration & Room Moves", 3),
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
                basic.dob,
                // _formatDate(basic.dob),
                dob,
                "Nationality",
                basic.nationality,
                nationalityIcon,
              ),
              _twoColumnInfo(
                "Birth Place",
                basic.birthPlace,
                birthPlaceIcon,
                "Live With",
                basic.liveWith?.join(", "),
                liveWithIcon,
              ),
              Divider(color: Colors.grey.shade300),
              _singleInfo(
                "Parent Responsibility",
                basic.parentalResponsibility?.join(", "),
                parentResponsibilityIcon,
              ),
              _singleInfo("Key Person", basic.keyPerson, keyPersonIcon),
              if (basic.secondKeyPerson != null)
                _singleInfo(
                  "Second Key Person",
                  basic.secondKeyPerson,
                  keyPersonIcon,
                ),
              Divider(color: Colors.grey.shade300),
              _specialNote(basic.specialNote),
            ],
          ),
        ),
      ),
    );
  }

  Widget _twoColumnInfo(
    String title1,
    String? value1,
    String icon1,
    String title2,
    String? value2,
    String icon2,
  ) {
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

  Widget _singleInfo(String title, String? value, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _infoWithIcon(title, value, icon),
    );
  }

  Widget _infoWithIcon(String title, String? value, String icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, width: 16, color: color_secondary),
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

  Widget _tabItem(String icon, String title, int index) {
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
            SvgPicture.asset(
              icon,
              width: 16,
              color: isSelected ? Colors.white : color_secondary,
            ),
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

        (basic.profileImage != null &&
            (basic.profileImage ?? "").isNotEmpty)
            ? CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(basic.profileImage ?? ""),
            )
            : Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color_secondary,
          ),
          alignment: Alignment.center,
          child: Text(
            (basic.firstName != null &&
                (basic.firstName ?? "").isNotEmpty)
                ? (basic.firstName ?? "")[0].toUpperCase()
                : "",
            style: const TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),


        // CircleAvatar(
        //   radius: 65,
        //   backgroundImage: NetworkImage(basic.profileImage ?? ""),
        // ),
        const SizedBox(height: 8),
        BlueLargeBoldText(
          "${basic.firstName ?? ""} ${basic.lastName ?? ""} (${basic.gender ?? ""})",
          color: Colors.black,
          fontSize: 18,
        ),
        // BlackMediumBoldText(basic.lastName ?? "", color: Colors.black),
      ],
    );
  }

  // String _formatDate(DateTime? date) {
  //   if (date == null) return "-";
  //   return "${date.day.toString().padLeft(2, '0')}-"
  //       "${date.month.toString().padLeft(2, '0')}-"
  //       "${date.year}";
  // }

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
                ToleratesPenicilln,
                "Tolerates Penicillin",
                health.toleratesPenicillin == 0
                    ? "Yes"
                    : health.toleratesPenicillin == 1
                    ? "No"
                    : "Unknown",
              ),
              _healthRow(
                SpecialDietaryConsiderations,
                "Special Dietary Considerations",
                health.specialDietaryConsiderations,
              ),
              _healthRow(Vaccines, "Vaccines", health.vaccines),
              _healthRow(Allergy, "Allergy", health.allergy),

              const Divider(height: 32),
              _healthRow(specailnote, "Special Note", health.specialNote),

              // const Divider(height: 32),
              _doctorInfo(health),
              // const Divider(height: 32),
              _dentistInfo(health),
            ],
          ),
        ),
      ),
    );
  }

  Widget _healthRow(String icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width: 18),
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
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _doctorInfo(HealthInfo health) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Doctor Info"),
            InkWell(
              onTap: () {
                Get.to(() => EditDoctorDentistScreen(childId: widget.childId));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color_secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _infoLine(keyPersonIcon, "Name", health.doctor?.name ?? "-"),
        _infoLine(icon_call_video, "Mobile", health.doctor?.mobile ?? "-"),
        _infoLine(icon_home, "Address", buildAddress(health.doctor)),
      ],
    );
  }

  Widget _dentistInfo(HealthInfo health) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Dentist Info"),
            InkWell(
              onTap: () {
                Get.to(() => EditDoctorDentistScreen(childId: widget.childId));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color_secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _infoLine(keyPersonIcon, "Name", health.dentist?.name ?? "-"),
        _infoLine(icon_call_video, "Mobile", health.dentist?.mobile ?? "-"),
        _infoLine(icon_home, "Address", buildAddress(health.dentist)),
      ],
    );
  }

  Widget _infoLine(String icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width: 16, color: color_secondary),
          const SizedBox(width: 6),
          BlueLargeBoldText("$title: ", fontFamily: fontInterBold),
          Expanded(child: BlackMediumBoldText(value, color: Colors.black)),
        ],
      ),
    );
  }

  String buildAddress(Dentist? doctor) {
    final parts = [
      doctor?.city,
      doctor?.country,
    ].where((e) => e != null && e.toString().trim().isNotEmpty).toList();

    final address = parts.join(", ");

    if (doctor?.postcode != null &&
        doctor!.postcode.toString().trim().isNotEmpty) {
      return address.isNotEmpty
          ? "$address - ${doctor.postcode}"
          : doctor.postcode.toString();
    }

    return address;
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
              icon: Religion,
              title: "Religion",
              value: sensitive.religion,
            ),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: ethnicityIcon,
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
            _sensitiveRow(icon: Rooms, title: "Rooms", value: roomMoves.rooms),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: dateIcon,
              title: "Start Date",
              value: roomMoves.startDate,
            ),

            const SizedBox(height: 16),

            _sensitiveRow(
              icon: dateIcon,
              title: "End Date",
              value: roomMoves.endDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensitiveRow({
    required String icon,
    required String title,
    required String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon, width: 18, color: Colors.blue),
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
