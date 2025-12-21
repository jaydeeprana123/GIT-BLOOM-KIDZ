enum UserTypeEnum {
  employee,

  member,



}


extension UserTypeEnumExtension on UserTypeEnum {
  String get outputVal {
    return ["1", "2"][index];
  }
}