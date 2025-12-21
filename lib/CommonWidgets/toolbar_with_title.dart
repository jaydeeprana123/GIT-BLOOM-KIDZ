import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';
import '../Styles/my_icons.dart';


class ToolbarWithTitle extends StatelessWidget {
  final String title;
  ToolbarWithTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.3.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0c041d42),
            spreadRadius: 0,
            blurRadius: 16,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:Container(
                   color: Colors.white,
                  height: 50.h,
                  width: 50.w,
                  padding: EdgeInsets.all(14.r),
                  child: SvgPicture.asset(icon_back_arrow,height: 16.h,width: 10,)),),

          SizedBox(width: 0.w,),
          Expanded(
            flex: 1,
            child: Text((title),style: TextStyle(
              fontSize: 14,
              color: title_black_15181e,
               fontFamily: fontInterSemiBold
            ),),
          )
        ],
      ),
    );
  }
}

