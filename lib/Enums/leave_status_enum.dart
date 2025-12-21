enum LeaveStatusEnum {
  pending,

  approve,

  reject


}


extension LeaveStatusEnumExtension on LeaveStatusEnum {
  String get outputVal {
    return ["0", "1", "2"][index];
  }
}