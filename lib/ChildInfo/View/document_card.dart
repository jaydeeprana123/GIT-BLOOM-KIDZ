import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'about_card.dart';
import 'about_tab.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _pdfIcon(),
          const SizedBox(width: 12),
          _docInfo(),
          _actions(),
        ],
      ),
    );
  }

  Widget _pdfIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          "PDF",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _docInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Heading Will be Here...",
            style: TextStyle(
              fontSize: 13,
              fontFamily: fontInterSemiBold,
              color: Color(0xff1f78c8),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "09-10-2025 | 08:30:55",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Size: 1.2MB",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _iconButton(Icons.cloud_download),
            const SizedBox(width: 6),
            _iconButton(Icons.remove_red_eye),
          ],
        )
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff1f78c8)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: const Color(0xff1f78c8)),
    );
  }
}



