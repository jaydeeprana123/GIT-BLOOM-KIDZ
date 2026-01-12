import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/black_medium_regular_text.dart';
import '../../../CommonWidgets/blue_large_bold_text.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/medication_list_response.dart';


class MedicationListScreen extends StatefulWidget {
  final String childId;

  const MedicationListScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.medicineRefreshIndex.value = -1;
      childInfoController.callMedicationListAPI(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(
      //   title: "Safeguarding", showMenu: true, showBack: true,),
      body: Obx(() {
        if (childInfoController.medicationList.isEmpty && !childInfoController.isLoading.value) {
          return const Center(child: Text("No medications found"));
        }




        return Stack(
          children: [

            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: childInfoController.medicationList.length,
                    itemBuilder: (context, index) {
                      final med = childInfoController.medicationList[index];
                      return _MedicationCard(medication: med, childInfoController: childInfoController,childId: widget.childId,index: index,);
                    },
                  ),
                ),
              ],
            ),

        if (childInfoController.isLoading.value)const Center(child: CircularProgressIndicator())

          ],
        );
      }),
    );
  }




}


class _MedicationCard extends StatelessWidget {
  final Medication medication;
  final String childId;
  final int index;
  final ChildInfoController childInfoController;
  const _MedicationCard({required this.medication, required this.childInfoController, required this.childId, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        color: Colors.white,
        shadowColor: color_secondary,
        elevation: 6,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              /// MEDICINE NAME
              _title("Medication"),
              _value(medication.medicine),
          
              const SizedBox(height: 12),
          
              _row(
                "When should this medication be given?",
                medication.reason,
                "Dose (amount)",
                medication.dose,
              ),
          
              _row(
                "Dose (unit)",
                "ml",
                "Frequency",
                medication.frequency,
              ),
          
              const SizedBox(height: 12),
          
              _title("Nursery Acknowledgement"),
              _value(medication.nurseryAck?.name),
          
              const SizedBox(height: 12),
          
              if(medication.parentAck?.status == true)_title("Parent Acknowledgement"),
              medication.parentAck?.status == true
                  ? _value(
                "Acknowledged by ${medication.parentAck?.by} "
                    "on ${_formatDate(medication.parentAck?.date)}",
              )
                  : Obx(
                    () =>_acknowledgeButton(context,childInfoController,medication.id??0, childId, index)),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _row(
      String title1,
      String? value1,
      String title2,
      String? value2,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: _item(title1, value1)),
          const SizedBox(width: 16),
          Expanded(child: _item(title2, value2)),
        ],
      ),
    );
  }

  Widget _item(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(title),
        _value(value),
      ],
    );
  }

  Widget _title(String text) {
    return BlueLargeBoldText(
      text,
     fontFamily: fontInterSemiBold,
      fontSize: 13
    );
  }

  Widget _value(String? text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: BlackMediumRegularText(
        text?.isNotEmpty == true ? text! : "-",
        color: Colors.black,
        fontSize: 12
      ),
    );
  }

  Widget _acknowledgeButton(BuildContext context,ChildInfoController controller, int medicationId, String childId, int index) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: CommonGradientButton(btnTitle: "Acknowledge", onPressed: (){

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.callAddMedicationAcknowledgeAPI(context, medicationId, childId);
        });


      }, isRefresh: childInfoController.medicineRefreshIndex.value == index,),
    );


      Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: call acknowledge API
          },
          child: const Text("Acknowledge"),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}

