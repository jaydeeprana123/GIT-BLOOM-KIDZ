// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../Styles/my_colors.dart';
// import '../Styles/my_font.dart';
// import '../Styles/my_icons.dart';
//
// class InternetRealtimeConnectionChecker extends StatefulWidget {
//   final Widget? layout;
//   final VoidCallback? onTap;
//   final Color? txtColor;
//   final Color? descColor;
//
//   InternetRealtimeConnectionChecker({
//     Key? key,
//     this.layout,
//     this.onTap,
//     this.txtColor,
//     this.descColor,
//   }) : super(key: key);
//
//   @override
//   State<InternetRealtimeConnectionChecker> createState() =>
//       _InternetRealtimeConnectionCheckerState();
// }
//
// class _InternetRealtimeConnectionCheckerState
//     extends State<InternetRealtimeConnectionChecker> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<ConnectivityResult>(
//       stream: Connectivity().onConnectivityChanged,
//       builder: (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
//         if (snapShot.hasData) {
//           var result = snapShot.data!;
//           switch (result) {
//             case ConnectivityResult.none:
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           no_internet,
//                           width: 182.w,
//                           height: 182.w,
//                         ),
//                         SizedBox(height: 15.h),
//                         Text(
//                           "Oops, No Internet Connection!",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontFamily: fontInterBold,
//                             color: widget.txtColor ?? Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 9.h),
//                         Text(
//                           "Make sure wifi or cellular data is turned on\nand then try again.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontFamily: fontInterRegular,
//                             color: widget.descColor ?? Colors.black54,
//                           ),
//                         ),
//                         SizedBox(height: 29.h),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (widget.onTap != null) widget.onTap!();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             textStyle: TextStyle(color: bg_btn_199a8e),
//                             elevation: 0,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 36.5.w,
//                               vertical: 13.h,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.r),
//                             ),
//                           ),
//                           child: Text(
//                             "Try again",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontFamily: fontInterSemiBold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             case ConnectivityResult.mobile:
//             case ConnectivityResult.wifi:
//               return widget.layout ?? SizedBox();
//             default:
//               return widget.layout ?? SizedBox();
//           }
//         } else {
//           return SizedBox(); // or some default widget when data is not available
//         }
//       },
//     );
//   }
// }
