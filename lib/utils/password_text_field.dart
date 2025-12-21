import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';
import '../Styles/my_icons.dart';
import '../Styles/my_strings.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  String? Function(dynamic value) validator;

  PasswordTextField({this.controller, required this.validator});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  // Initially password is obscure
  bool _passwordVisible = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: !_passwordVisible,

      style: TextStyle(
          color: text_color,
          fontFamily: fontInterMedium,
          fontSize: 16),
      decoration: InputDecoration(
        hintText:
        (str_password),
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
              _passwordVisible ? icon_open_eye : icon_close_eye, height: 20, width: 20,),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        isDense: true,
        // contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        border: InputBorder.none,

        labelStyle: TextStyle(
          fontSize: 16,
          color: hint_txt_909196,
          fontFamily: fontInterMedium,),

        filled: true,
        fillColor: Colors.white70,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.7)),
          borderSide: BorderSide(color: grey_f0f0f0, width: 1),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.7)),
          borderSide: BorderSide(color: bg_btn_199a8e),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.7)),
          borderSide: BorderSide(color: grey_f0f0f0, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.7)),
          borderSide: BorderSide(color: grey_f0f0f0, width: 1),
        ),
      ),
      keyboardType: TextInputType.text,
      cursorColor: bg_btn_199a8e,
      textInputAction: TextInputAction.done,
    );
  }
}
