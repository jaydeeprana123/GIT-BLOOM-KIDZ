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
import '../../../CommonWidgets/black_small_regular_text.dart';
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

import '../models/accident_list_response.dart';
import '../models/medication_list_response.dart';
import 'BodyMapView.dart';



class AccidentListScreen extends StatefulWidget {
  final String childId;

  const AccidentListScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<AccidentListScreen> createState() => _AccidentListScreenState();
}

class _AccidentListScreenState extends State<AccidentListScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.medicineRefreshIndex.value = -1;
      childInfoController.callAccidentListAPI(context, widget.childId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(
      //   title: "Accident / Incident", showMenu: true, showBack: true,),
      body: Obx(() {
        if (childInfoController.accidentList.isEmpty && !childInfoController.isLoading.value) {
          return const Center(child: Text("No records found"));
        }

        return Obx(
                () =>Stack(
          children: [
            !childInfoController.isLoading.value?childInfoController.accidentList.isNotEmpty?  ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: childInfoController.accidentList.length,
              itemBuilder: (context, index) {
                return _AccidentCard(accident: childInfoController.accidentList[index], childInfoController: childInfoController,childId: widget.childId,index: index);
              },
            ):Expanded(child: Center(child: BlueLargeBoldText("No Data Found", ),)):SizedBox(),

            if (childInfoController.isLoading.value)const Center(child: CircularProgressIndicator())
          ],
        ));
      }),
    );
  }
}


class _AccidentCard extends StatelessWidget {
  final Accident accident;
  final String childId;
  final int index;
  final ChildInfoController childInfoController;
  const _AccidentCard({required this.accident, required this.childInfoController, required this.childId, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: color_secondary,
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [
                const Icon(Icons.report, size: 18, color: color_secondary,),
                const SizedBox(width: 8),
                BlueLargeBoldText(
                  accident.kind?.toUpperCase() ?? "ACCIDENT",
                fontFamily: fontInterBold
                ),
                const Spacer(),
                BlackSmallRegularText(
                  accident.dateTime ?? "",
                  fontSize: 11
                ),
              ],
            ),

            const Divider(height: 24),

            _item("Child", accident.child?.name),
            _item("Location", accident.location),
            _item("Nature", accident.nature),
            _item("First aid administered", accident.firstAid),
            _item("When and how were parents notified", accident.parentsNotified),
            _item("Witness", accident.witness?.name),
            _item("Approved and sent by", "${accident.approvedBy?.name??""} | ${accident.dateTime??""}"),

            // const SizedBox(height: 12),

            /// ACKNOWLEDGEMENT
            _acknowledgementSection(context, childId, childInfoController, index),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 12),

                BlueMediumBoldText(
                  "Body map",
                    fontFamily: fontInterSemiBold,
                    fontSize: 13
                ),


                if (accident.bodyMap?.front != null && accident.bodyMap!.front!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: BodyMapView(
                      imagePath: body_front,
                      frontPoints: accident.bodyMap?.front,
                      backPoints: accident.bodyMap?.back,
                      headPoints: accident.bodyMap?.head,
                      sidePoints: accident.bodyMap?.sideface,
                    ),
                  ),

                if (accident.bodyMap?.head != null && accident.bodyMap!.head!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: BodyMapView(
                      imagePath: body_head,
                      frontPoints: accident.bodyMap?.front,
                      backPoints: accident.bodyMap?.back,
                      headPoints: accident.bodyMap?.head,
                      sidePoints: accident.bodyMap?.sideface,
                    ),
                  ),

                if (accident.bodyMap?.back != null && accident.bodyMap!.back!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: BodyMapView(
                      imagePath: body_back,
                      frontPoints: accident.bodyMap?.front,
                      backPoints: accident.bodyMap?.back,
                      headPoints: accident.bodyMap?.head,
                      sidePoints: accident.bodyMap?.sideface,
                    ),
                  ),


                if (accident.bodyMap?.sideface != null && accident.bodyMap!.sideface!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: BodyMapView(
                      imagePath: body_side_face,
                      frontPoints: accident.bodyMap?.front,
                      backPoints: accident.bodyMap?.back,
                      headPoints: accident.bodyMap?.head,
                      sidePoints: accident.bodyMap?.sideface,
                    ),
                  ),


              ],
            )


      ],
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueMediumBoldText(
            title,
            fontFamily: fontInterSemiBold,
              fontSize: 13
          ),
          const SizedBox(height: 2),
          BlackMediumRegularText(
            value?.isNotEmpty == true ? value! : "-",
            color: Colors.black,
            fontSize: 12
          ),
        ],
      ),
    );
  }

  Widget _acknowledgementSection(BuildContext context, String childId, ChildInfoController controller, int index) {
    final ack = accident.acknowledgement;

    if (ack?.status == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           BlueMediumBoldText(
            "Parent Acknowledgement",
             fontFamily: fontInterSemiBold,
             fontSize: 13
          ),
          const SizedBox(height: 2),
          BlackMediumRegularText(
            "Acknowledged on ${_formatDate(ack?.date)}",
           color: Colors.black,
            fontSize: 12
          ),
        ],
      );
    }

    return _acknowledgeButton(context, controller,accident.id??0, childId, index);
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


