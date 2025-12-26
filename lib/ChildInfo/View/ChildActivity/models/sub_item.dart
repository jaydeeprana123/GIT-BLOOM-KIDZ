class SubItem {
  final String subTitle;
  final String time;
  final List<String> details;
  final String? statusForNappy;
  final String? icon;

  SubItem({
    required this.subTitle,
    required this.time,
    required this.details,
    this.statusForNappy,
    this.icon,
  });
}
