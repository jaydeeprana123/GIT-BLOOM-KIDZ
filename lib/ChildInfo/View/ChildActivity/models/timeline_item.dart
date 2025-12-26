class TimelineItem {
  final String title;
  final String time;
  final List<String> details;
  final String? icon;

  TimelineItem({
    required this.title,
    required this.time,
    required this.details,
    this.icon,
  });
}
