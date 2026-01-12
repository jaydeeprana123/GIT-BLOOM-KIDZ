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



class BodyMapView extends StatelessWidget {
  final String imagePath;
  final List<Front>? frontPoints; // front / head etc
  final List<Front>? backPoints;
  final List<Front>? sidePoints;
  final List<Front>? headPoints;

  const BodyMapView({
    super.key,
    required this.imagePath,
    required this.frontPoints,
    required this.backPoints,
    required this.sidePoints,
    required this.headPoints,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 6, // body image ratio
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Body image
              Image.asset(
                imagePath,
                width: width,
                height: height,
                fit: BoxFit.fitHeight,
              ),

              // Red dots
             if(frontPoints != null) ...frontPoints!.map((p) {
                final left = (p.x ?? 0) / 100 * width;
                final top = (p.y ?? 0) / 100 * height;

                return Positioned(
                  left: left - 5,
                  top: top - 5,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),


              if(backPoints != null) ...backPoints!.map((p) {
                final left = (p.x ?? 0) / 100 * width;
                final top = (p.y ?? 0) / 100 * height;

                return Positioned(
                  left: left - 5,
                  top: top - 5,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),


              if(sidePoints != null) ...sidePoints!.map((p) {
                final left = (p.x ?? 0) / 100 * width;
                final top = (p.y ?? 0) / 100 * height;

                return Positioned(
                  left: left - 5,
                  top: top - 5,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),


              if(headPoints != null) ...headPoints!.map((p) {
                final left = (p.x ?? 0) / 100 * width;
                final top = (p.y ?? 0) / 100 * height;

                return Positioned(
                  left: left - 5,
                  top: top - 5,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}



