import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Styles/my_icons.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;

  const CommonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),
          child,
        ],
      ),
    );
  }
}
