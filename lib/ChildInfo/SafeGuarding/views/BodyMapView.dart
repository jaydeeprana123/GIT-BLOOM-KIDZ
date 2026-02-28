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



import 'package:flutter/material.dart';

class BodyMapView extends StatelessWidget {
  final String imagePath;
  final List<Front>? frontPoints;
  final List<Front>? backPoints;
  final List<Front>? sidePoints;
  final List<Front>? headPoints;

  // front__1_.jpg is 1063x1063 — square
  static const double imageAspectRatio = 1063 / 1063; // = 1.0

  const BodyMapView({
    super.key,
    required this.imagePath,
    required this.frontPoints,
    required this.backPoints,
    required this.sidePoints,
    required this.headPoints,
  });

  List<Widget> _buildDots(
      List<Front>? points,
      double imgLeft,
      double imgTop,
      double imgWidth,
      double imgHeight,
      ) {
    if (points == null) return [];
    return points.map((p) {
      final left = imgLeft + (p.x ?? 0) / 100 * imgWidth;
      final top = imgTop + (p.y ?? 0) / 100 * imgHeight;
      return Positioned(
        left: left - 7.5,
        top: top - 7.5,
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widgetWidth = constraints.maxWidth;
          final widgetHeight = constraints.maxHeight;

          // Square image inside a tall widget — contain will
          // make width fill, with top/bottom padding
          final imgWidth = widgetWidth;
          final imgHeight = widgetWidth * imageAspectRatio; // = widgetWidth
          final imgLeft = 0.0;
          final imgTop = (widgetHeight - imgHeight) / 2;

          return Stack(
            children: [
              Image.asset(
                imagePath,
                width: widgetWidth,
                height: widgetHeight,
                fit: BoxFit.contain, // ← changed from fitHeight
              ),
              ..._buildDots(frontPoints, imgLeft, imgTop, imgWidth, imgHeight),
              ..._buildDots(backPoints, imgLeft, imgTop, imgWidth, imgHeight),
              ..._buildDots(sidePoints, imgLeft, imgTop, imgWidth, imgHeight),
              ..._buildDots(headPoints, imgLeft, imgTop, imgWidth, imgHeight),
            ],
          );
        },
      ),
    );
  }
}



