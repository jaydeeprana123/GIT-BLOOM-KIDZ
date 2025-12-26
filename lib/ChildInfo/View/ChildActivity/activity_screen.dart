import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:flutter/material.dart';
import '../../../CommonWidgets/blue_medium_bold_text.dart';
import '../../../CommonWidgets/common_appbar.dart';
import '../../controller/child_info_controller.dart';
import '../../models/activity_response.dart';
import 'itemline_card.dart';
import 'models/sub_item.dart';
import 'models/timeline_item.dart';
import 'package:get/get.dart';

class ActivityScreen extends StatefulWidget {
  final String childId;

  const ActivityScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ChildInfoController childInfoController = Get.find<ChildInfoController>();

  @override
  void initState() {
    super.initState();

    childInfoController.callActivityListAPI(context, widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Activity", showMenu: true, showBack: true,),
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                _dateSelector(),
                Expanded(child: _timeline()),
              ],
            ),


            if(childInfoController.isLoading.value)const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimelineItems(ActivityData data) {
    final List<TimelineItem> items = [];

    /// -------- MEALS --------

    List<SubItem> subItems = [];

    for (int i=0; i< (data.meals??[]).length ; i++) {
      if (data.meals?[i].mealTime == null || (data.meals?[i].mealTime??"").isEmpty) continue;

      List<String> details = [];

      for (int j=0; j< (data.meals?[i].foods??[]).length ; j++) {
        details.add("${data.meals?[i].foods?[j].foodName??""} (${data.meals?[i].foods?[j].amount??""})");
      }

      subItems.add(SubItem(
        subTitle: data.meals?[i].mealType ?? "Meal",
        time: data.meals?[i].mealTime??"",
        details:
        details.isNotEmpty ? details : ["No food recorded"],
      ));
    }

    items.add(
      TimelineItem(
        title: "Meal",
        subItems: subItems,
      ),
    );



    // for (final meal in data.meals ?? []) {
    //   if (meal.mealTime == null || meal.mealTime!.isEmpty) continue;
    //
    //
    //   final foodDetails = (meal.foods ?? [])
    //       .where((f) => f.foodName != null)
    //       .map<String>((f) => "${f.foodName} (${f.amount})")
    //       .toList();
    //
    //   items.add(
    //     TimelineItem(
    //       title: "Meal",
    //       time: meal.mealTime!,
    //       subItems: [
    //         SubItem(
    //           subTitle: meal.mealType ?? "Meal",
    //           details:
    //           foodDetails.isNotEmpty ? foodDetails : ["No food recorded"],
    //         ),
    //       ],
    //     ),
    //   );
    // }

    /// -------- NAPPY --------
    List<SubItem> subItemsNappy = [];
    for (final nappy in data.nappy ?? []) {
      if (nappy.time == null || nappy.time!.isEmpty) continue;

      subItemsNappy.add(SubItem(
        subTitle: nappy.type ?? "Nappy",
        time: nappy.time!,
        details:[],
        statusForNappy: nappy.status??""
      ));
    }


    items.add(
      TimelineItem(
        title: "Nappy",

        subItems: subItemsNappy,
      ),
    );

    /// -------- ACTIVITIES --------
    List<SubItem> subItemsActivity = [];
    for (final act in data.activities ?? []) {
      if (act.time == null || act.time!.isEmpty) continue;

      subItemsActivity.add(SubItem(
          subTitle: act.activityName ?? "",
          time: act.time!,
          details:[],
        icon: act.icon??""
      ));

    }


    items.add(
      TimelineItem(
        title: "Activity",
        subItems: subItemsActivity,
      ),
    );

    /// -------- SORT (SAFE) --------
    // items.sort((a, b) {
    //   final ta = _parseTime(a.time);
    //   final tb = _parseTime(b.time);
    //   return ta.compareTo(tb);
    // });


    printData("Items length", items.length.toString());

    return List.generate(
      items.length,
          (i) => TimelineCard(
        item: items[i],
        isLast: i == items.length - 1,
      ),
    );
  }



  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
  }




  Widget _dateSelector() {
    return Obx(
          () => SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: childInfoController.activityList.length,
          itemBuilder: (context, index) {
            final day = childInfoController.activityList[index];
            final isSelected =
                childInfoController.selectedDateIndex.value == index;

            return GestureDetector(
              onTap: () {
                childInfoController.selectedDateIndex.value = index;
                setState(() {

                });
              },

              child: Container(
                width: 45,
                margin: const EdgeInsets.only(right: 10, top: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color_secondary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1E78B7),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlueMediumBoldText(
                      day.displayDate!.split(',')[0].substring(0, 3),
                        fontSize: 12,
                        color: isSelected ? Colors.white : color_secondary,

                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.displayDate!.split(' ').last,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _timeline() {
    return Obx(() {
      final data = childInfoController.selectedDayData;

      if (data == null) {
        return const SizedBox.shrink();
      }

      final items = _buildTimelineItems(data);

      /// ✅ IF NO CARD AVAILABLE → DO NOT SHOW
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView(
        padding: const EdgeInsets.only(top: 8),
        children: items,
      );
    });
  }




}
