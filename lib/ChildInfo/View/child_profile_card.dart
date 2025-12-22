import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

class ChildProfileCard extends StatelessWidget {
  const ChildProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          const CircleAvatar(
            radius: 38,
            backgroundImage: AssetImage("assets/child1.jpg"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Child Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontInterSemiBold,
                    color: Color(0xff1f78c8),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.school, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Explorers", style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.sick, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Sick", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.beach_access, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Holiday", style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _profileButton(Icons.chat, "Chat"),
                    const SizedBox(width: 8),
                    _profileButton(Icons.location_pin, "Collection Pin"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _profileButton(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff1f78c8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
