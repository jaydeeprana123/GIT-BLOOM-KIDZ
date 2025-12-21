import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'about_tab.dart';
import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'child_options_grid.dart';
import 'child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/child1.jpg"),
            ),
            const SizedBox(height: 8),
            const Text(
              "Oliver",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1f78c8),
              ),
            ),
            const Text(
              "Thompson",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Divider(height: 24),
            _infoRow(Icons.cake, "Date Of Birth", "01-12-2025"),
            _infoRow(Icons.flag, "Nationality", "Lorem Ipsum"),
            _infoRow(Icons.location_on, "Birth Place", "Lorem Ipsum"),
            _infoRow(Icons.home, "Live With", "Lorem Ipsum"),
            _infoRow(Icons.family_restroom, "Parent Responsibility", "Lorem Ipsum"),
            _infoRow(Icons.person, "Key Person", "Lorem Ipsum"),
            _infoRow(Icons.person_outline, "Second Key Person", "Lorem Ipsum"),
            const Divider(height: 24),
            _specialNote(),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xff1f78c8)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$title\n",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(Icons.note, size: 16, color: Color(0xff1f78c8)),
            SizedBox(width: 6),
            Text(
              "Special Note",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}


