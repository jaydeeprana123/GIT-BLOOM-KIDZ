import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../CommonWidgets/common_widget.dart';
import '../Enums/select_date_enum.dart';
import '../Styles/my_colors.dart';
class Helper {


  /// Get difference between current time and added time
  /// dateTime - Date and time which will be add when user will do comment
  getTimeDifference(DateTime dateTime) {
    DateTime dt1 = dateTime;
    DateTime dt2 = DateTime.now();

    Duration diff = dt2.difference(dt1);

    var difference = "";

    if (diff.inDays > 0) {
      difference = "${diff.inDays} Days";
    } else if (diff.inHours > 0) {
      difference = "${diff.inHours} Hours";
    } else if (diff.inMinutes > 0) {
      difference = "${diff.inMinutes} Minutes";
    } else if (diff.inSeconds > 0) {
      difference = "${diff.inSeconds} Seconds";
    } else {
      difference = "${diff.inSeconds} Seconds";
    }

    return difference;
  }


  /// Convert 24 hours time into 12 hours
  String convert24To12HoursFormat(DateTime? dateTime) {
    String timeIn12Hours = "";
    if (dateTime != null) {
      final dateFormat = DateFormat('h:mm a');
      timeIn12Hours = dateFormat.format(dateTime);
    }

    return timeIn12Hours;
  }




  Future<String> selectDate(BuildContext context,int selectDateFor) async {

    String dateFromDatePicker = "";

    DateTime? newDate = await showDatePicker(
      locale:  const Locale('en','IN'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      helpText: "Select Date",
      cancelText: "CANCEL",
      confirmText: "GO",
      fieldHintText: 'dd/mm/yyyy',
      initialDatePickerMode: DatePickerMode.day,
      selectableDayPredicate: selectDateFor == SelectDateEnum.Past.outputVal?_decideWhichDayToEnable:null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bg_btn_199a8e, // <-- SEE HERE
              onPrimary: circle_gray_cfd0d1, // <-- SEE HERE
              onSurface: title_black_15181e, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
               textStyle: TextStyle(color: orange_df6129) // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {

        dateFromDatePicker = DateFormat('dd/MM/yyyy').format(value);

      }
      return null;
    });


    return dateFromDatePicker;
  }

  Future<DateTime?> selectDateInYYYYMMDD(BuildContext context,int selectDateFor) async {

    DateTime? dateFromDatePicker;

    DateTime? newDate = await showDatePicker(
       locale:  const Locale('en','IN'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      helpText: "Select Date",
      cancelText: "CANCEL",
      confirmText: "GO",
       fieldHintText: 'dd/mm/yyyy',
      initialDatePickerMode: DatePickerMode.day,
      selectableDayPredicate: selectDateFor == SelectDateEnum.Past.outputVal?_decideWhichDayToEnable:null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bg_btn_199a8e, // <-- SEE HERE
              onPrimary: circle_gray_cfd0d1, // <-- SEE HERE
              onSurface: title_black_15181e, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  textStyle: TextStyle(color: orange_df6129) // button text color
              ),
            ),


          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        dateFromDatePicker = value;
       // dateFromDatePicker = DateFormat('dd/mm/yyyy').format(value) as DateTime?;

      }
      return null;
    });


    return dateFromDatePicker;
  }
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 36500))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  bool _futureToEnable(DateTime day) {
    if ((day.isBefore(DateTime.now().subtract(const Duration(days: 36500))) &&
        day.isAfter(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }


  convertDatedIndMMMyyyy(DateTime originalDate) {
    String result;
    result = DateFormat("d MMM yyyy").format(originalDate);
    return result;
  }


  String convert24To12Hour(String time24) {
    // Parse the 24-hour time string into a DateTime object
    DateFormat inputFormat = DateFormat("HH:mm"); // or "HH:mm:ss" if seconds are included
    DateTime dateTime = inputFormat.parse(time24);

    // Format the DateTime object into 12-hour format with AM/PM
    DateFormat outputFormat = DateFormat("hh:mm a");
    String time12 = outputFormat.format(dateTime);

    return time12;
  }
}
