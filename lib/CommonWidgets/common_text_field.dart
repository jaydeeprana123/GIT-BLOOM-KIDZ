import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  const CommonTextField({
    super.key,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      style: TextStyle(
        fontSize: 14,
        fontFamily: fontInterSemiBold,
        color: text_color,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          fontSize: 13,
          fontFamily: fontInterRegular,
          color: light_text_color,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        /// 🔵 Default Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: color_secondary, width: 1.2),
        ),

        /// 🔵 Focused Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: color_secondary, width: 1.5),
        ),

        /// 🔴 Error Border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),

        /// 👁 Eye Icon (only for password)
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: light_text_color,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
