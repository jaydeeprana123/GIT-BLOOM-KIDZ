import 'package:flutter/material.dart';
import '../../controller/child_info_controller.dart';
import '../../models/activity_response.dart';
import 'itemline_card.dart';
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
      appBar: AppBar(
        title: const Text("Activity"),
        backgroundColor: const Color(0xFF1E78B7),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: childInfoController.activityList.length,
          itemBuilder: (context, index) {
            final dayData = childInfoController.activityList[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DATE HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    dayData.displayDate ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                /// TIMELINE ITEMS
                ..._buildTimelineItems(dayData),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTimelineItems(ActivityData data) {
    final List<TimelineItem> items = [];

    /// MEALS
    for (final meal in data.meals ?? []) {
      items.add(
        TimelineItem(
          title: meal.mealType ?? "Meal",
          time: meal.mealTime ?? "",
          details:
              meal.foods?.map((f) => "${f.foodName} (${f.amount})").toList() ??
              [],
        ),
      );
    }

    /// NAPPY
    for (final nappy in data.nappy ?? []) {
      items.add(
        TimelineItem(
          title: nappy.type ?? "Nappy",
          time: nappy.time ?? "",
          details: [if (nappy.status != null) nappy.status!],
        ),
      );
    }

    /// ACTIVITIES
    for (final act in data.activities ?? []) {
      items.add(
        TimelineItem(
          title: act.activityName ?? "",
          time: act.time ?? "",
          details: [if (act.temperature != null) "Temp: ${act.temperature}°"],
          icon: act.icon,
        ),
      );
    }

    return List.generate(
      items.length,
      (i) => TimelineCard(item: items[i], isLast: i == items.length - 1),
    );
  }
}
