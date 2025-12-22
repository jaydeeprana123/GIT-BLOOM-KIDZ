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

import 'document_card.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xff1f78c8),
        elevation: 0,
        title: const Text(
          "Documents",
          style: TextStyle(fontSize: 18, fontFamily: fontInterSemiBold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color(0xff43b8a6),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 7,
        itemBuilder: (context, index) {
          return const DocumentCard();
        },
      ),
    );
  }
}
