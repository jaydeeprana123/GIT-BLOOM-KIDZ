enum AttendanceTypeEnum {
  all,

  lateMark,

  overTime,

  absent


}


extension AttendanceTypeEnumExtension on AttendanceTypeEnum {
  String get outputVal {
    return ["0", "1", "2", "3"][index];
  }
}