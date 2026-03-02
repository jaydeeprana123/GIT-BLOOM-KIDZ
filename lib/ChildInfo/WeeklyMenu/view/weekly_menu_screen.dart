import 'package:bloom_kidz/ChildInfo/Permissions/models/permissions_response.dart';
import 'package:bloom_kidz/CommonWidgets/common_background.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/black_medium_regular_text.dart';
import '../../../CommonWidgets/black_small_regular_text.dart';
import '../../../CommonWidgets/blue_large_bold_text.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/blue_medium_regular_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../View/about_card.dart';
import '../../View/about_tab.dart';
import '../../View/child_.card.dart';

import 'package:flutter/material.dart';

import '../../View/child_options_grid.dart';
import '../../View/child_profile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../controller/child_info_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/weekly_menu_response.dart';

class WeeklyMenuScreen extends StatefulWidget {
  final String childId;

  const WeeklyMenuScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<WeeklyMenuScreen> createState() => _WeeklyMenuScreenState();
}

class _WeeklyMenuScreenState extends State<WeeklyMenuScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      childInfoController.callWeeklyMenu(context, widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Weekly Menu",
        showMenu: false,
        showBack: true,
      ),
      body: Obx(() {
        if (childInfoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = childInfoController.weeklyMenuData.value;

        if (data.weeklyMenu == null || data.weeklyMenu!.isEmpty) {
          return Center(child: BlueLargeBoldText("No Menu Found"));
        }

        return Stack(
          children: [
            Positioned.fill(child: SvgPicture.asset(app_bg, fit: BoxFit.cover)),

            Column(
              children: [
                _weekHeader(data),
                Expanded(child: _weeklyMenuList(data)),
              ],
            ),
          ],
        );
      }),
    );
  }

  /// ------------------ WEEK HEADER ------------------
  Widget _weekHeader(WeeklyMenuData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color_secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: BlueMediumBoldText(
          "${_formatDate(data.weekStart)} - ${_formatDate(data.weekEnd)}",
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  /// ------------------ WEEKLY LIST ------------------
  Widget _weeklyMenuList(WeeklyMenuData data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: data.weeklyMenu!.length,
      itemBuilder: (context, index) {
        final day = data.weeklyMenu![index];
        return _dayCard(day);
      },
    );
  }

  /// ------------------ DAY CARD ------------------
  Widget _dayCard(WeeklyMenu day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: Colors.white,
        shadowColor: color_secondary,
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlueLargeBoldText(day.day ?? "", fontSize: 16),
              const SizedBox(height: 10),

              ...List.generate(
                day.meals?.length ?? 0,
                (index) => _mealItem(day.meals![index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------ MEAL ITEM ------------------
  Widget _mealItem(Meal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueLargeBoldText(meal.mealName ?? ""),
          const SizedBox(height: 6),

          if (meal.items == null || meal.items!.isEmpty)
            BlueMediumRegularText("No items available"),

          ...List.generate(meal.items?.length ?? 0, (index) {
            final item = meal.items![index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(child: BlackMediumRegularText(item.name ?? "")),
                  if (item.diets != null && item.diets!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color_secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlackSmallRegularText(item.diets!.join(", ")),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
