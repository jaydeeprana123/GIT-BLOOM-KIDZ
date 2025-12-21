import 'package:bloom_kidz/ChildInfo/View/family_add_screen.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'child_.card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'contact_card.dart';

class FamilyContactsScreen extends StatelessWidget {
  const FamilyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xff1f78c8),
        elevation: 0,
        title: const Text(
          "Family & Contacts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color(0xff43b8a6),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _addContactButton(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                ContactCard(
                  image: "assets/father.jpg",
                  name: "Lorem Ipsum",
                  relation: "Father",
                ),
                ContactCard(
                  image: "assets/mother.jpg",
                  name: "Lorem Ipsum",
                  relation: "Mother",
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: const Color(0xff1f78c8),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: "News Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: "Child Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Profile",
          ),
        ],
      ),
    );
  }

  /// 🔹 Add Contact Button
  Widget _addContactButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {

            Get.to(FamilyAddScreen());

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1f78c8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Add Contact",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}




