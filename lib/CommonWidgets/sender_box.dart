import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Styles/my_colors.dart';

final SenderBox = BoxDecoration(
    color: bg_btn_199a8e,
    boxShadow:  [
      BoxShadow(
        color: shadow_0x0f041d42.withOpacity(0.01),
        offset: Offset(
          3.0,
          5.0,
        ),
        blurRadius: 7.0,
        spreadRadius: 5.0,
      )
    ],
    borderRadius: BorderRadius.all(Radius.circular(8.r)));
