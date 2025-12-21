import 'package:flutter/material.dart';

import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';

class CommonGradientButton extends StatelessWidget {
  final String btnTitle;
  final VoidCallback onPressed;


  const CommonGradientButton({
    super.key,
    required this.btnTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [
            color_primary,
            color_secondary,
        ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          btnTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: fontInterSemiBold,
          ),
        ),
      ),
    );
  }
}

