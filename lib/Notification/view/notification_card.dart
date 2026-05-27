import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:bloom_kidz/Styles/my_icons.dart';
import 'package:bloom_kidz/Notification/models/notification_response.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = item.readStatus == 'N';
    final DateTime? createdDate = item.createdAt != null ? DateTime.tryParse(item.createdAt!) : null;
    String formattedTime = '';
    if (createdDate != null) {
      formattedTime = DateFormat('hh:mm a  dd-MM-yyyy').format(createdDate);
    } else {
      formattedTime = item.createdAt ?? '';
    }

    return Card(
      elevation: isUnread ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread 
            ? const BorderSide(color: color_primary_transparent, width: 1)
            : BorderSide(color: Colors.grey, width: 0.2),
      ),
      color: isUnread ? Colors.white : const Color(0xfffcfcfc),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isUnread ? color_primary : color_secondary.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isUnread ? color_primary : color_secondary).withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: _getIcon(item.type),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.title ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                    color: isUnread ? title_black_15181e : light_text_color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isUnread) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (item.type != null && item.type!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isUnread 
                                  ? color_primary.withOpacity(0.1) 
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.type!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isUnread ? color_primary : Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.message ?? '',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                        color: isUnread ? Colors.black87 : Colors.black54,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time, 
                              size: 12, 
                              color: isUnread ? color_primary : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 11,
                                color: isUnread ? color_primary : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon(String? type) {
    String? assetPath;
    switch (type?.toLowerCase()) {
      case 'newsfeed':
        assetPath = icon_news_feed;
        break;
      case 'chat':
        assetPath = icon_chat;
        break;
      case 'event':
      case 'events':
      case 'calendar':
        assetPath = icon_event_calender;
        break;
      case 'activity':
        assetPath = icon_activity;
        break;
      case 'document':
      case 'documents':
        assetPath = icon_documents;
        break;
      case 'safeguarding':
        assetPath = icon_Safeguarding;
        break;
    }

    if (assetPath != null) {
      return SvgPicture.asset(
        assetPath,
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    } else {
      return const Icon(
        Icons.notifications_none_outlined,
        color: Colors.white,
        size: 20,
      );
    }
  }
}
