import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_medium_regular_text.dart';
import 'package:flutter/material.dart';


import '../Styles/my_colors.dart';
import '../Styles/my_font.dart';
import 'package:get/get.dart';

class DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color_secondary,width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(label,
            //     style: const TextStyle(fontSize: 12, color: Colors.grey)),
            // const SizedBox(height: 6),
            Expanded(
              child: BlackMediumRegularText(
                value == null
                    ? "Select $label"
                    : "${value!.day.toString().padLeft(2, '0')}-"
                    "${value!.month.toString().padLeft(2, '0')}-"
                    "${value!.year}",
                color: value == null?hint_txt_909196:Colors.black,
                fontFamily: value == null?fontInterRegular:fontInterSemiBold
              ),
            ),
            
            Icon(Icons.date_range, color: color_secondary,)
            
          ],
        ),
      ),
    );
  }
}

