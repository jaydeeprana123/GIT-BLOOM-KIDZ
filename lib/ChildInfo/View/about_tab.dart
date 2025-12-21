import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AboutTabs extends StatelessWidget {
  const AboutTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _tab("Basic", Icons.info, true),
          const SizedBox(width: 8),
          _tab("Health Information", Icons.favorite, false),
          const SizedBox(width: 8),
          _tab("Sensitive", Icons.lock, false),
          const SizedBox(width: 8),
          _tab("Sensitive", Icons.lock, false),
        ],
      ),
    );
  }

  Widget _tab(String title, IconData icon, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xff1f78c8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff1f78c8)),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 14,
              color: selected ? Colors.white : const Color(0xff1f78c8)),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : const Color(0xff1f78c8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


