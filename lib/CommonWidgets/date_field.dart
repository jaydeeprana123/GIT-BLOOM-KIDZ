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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value == null
                  ? "Select date"
                  : "${value!.day.toString().padLeft(2, '0')}-"
                  "${value!.month.toString().padLeft(2, '0')}-"
                  "${value!.year}",
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

