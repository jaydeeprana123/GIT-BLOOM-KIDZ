import 'package:bloom_kidz/CommonWidgets/black_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/black_small_medium_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_large_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_bold_text.dart';
import 'package:bloom_kidz/CommonWidgets/blue_medium_regular_text.dart';
import 'package:bloom_kidz/CommonWidgets/common_green_button.dart';
import 'package:bloom_kidz/CommonWidgets/common_text_field.dart';
import 'package:bloom_kidz/CommonWidgets/common_widget.dart';
import 'package:bloom_kidz/NewsFeed/controller/news_feed_controller.dart';
import 'package:bloom_kidz/NewsFeed/models/news_feed_response.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_font.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CommonWidgets/black_medium_bold_text.dart';
import '../../CommonWidgets/black_medium_regular_text.dart';
import '../../CommonWidgets/blue_small_regular_text.dart';
import '../../CommonWidgets/common_appbar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/news_feed_caleneder_response.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  NewsFeedController newsFeedController = Get.put(NewsFeedController());

  @override
  void initState() {
    super.initState();

    newsFeedController.callNewsFeedCalenderAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar Events"), centerTitle: true),
      body: Obx(
        () => SfCalendar(
          view: CalendarView.month,

          dataSource: AppointmentDataSource(newsFeedController.appointments),

          monthViewSettings: const MonthViewSettings(
            showAgenda: true, // shows event name below calendar
            agendaItemHeight: 70,
          ),

          onTap: (CalendarTapDetails details) {
            if (details.appointments != null &&
                details.appointments!.isNotEmpty) {
              final Appointment appointment =
                  details.appointments!.first as Appointment;

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(appointment.subject),
                  content: Text(
                    "${appointment.startTime} - ${appointment.endTime}",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// REQUIRED by Syncfusion (NOT your model)
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
