import 'package:flutter/material.dart';

import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';

import 'package:flutter/material.dart';

Widget BlueMediumRegularText(
  String text, {
  double? fontSize,
  Color? color,
  String? fontFamily,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      fontSize: fontSize ?? 12, // optional
      color: color ?? color_secondary,
      fontFamily: fontFamily ?? fontInterRegular,
    ),
  );
}
