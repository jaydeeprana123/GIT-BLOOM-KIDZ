import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
  bool? status;
  String? message;
  int? code;
  NotificationData? data;

  NotificationResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class NotificationData {
  List<NotificationItem>? notifications;
  int? unreadCount;
  NotificationPagination? pagination;

  NotificationData({
    this.notifications,
    this.unreadCount,
    this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    notifications: json["notifications"] == null ? [] : List<NotificationItem>.from(json["notifications"]!.map((x) => NotificationItem.fromJson(x))),
    unreadCount: json["unread_count"],
    pagination: json["pagination"] == null ? null : NotificationPagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "unread_count": unreadCount,
    "pagination": pagination?.toJson(),
  };
}

class NotificationItem {
  int? id;
  String? title;
  String? message;
  String? type;
  dynamic moduleId;
  String? url;
  String? image;
  String? readStatus;
  dynamic readAt;
  String? createdAt;

  NotificationItem({
    this.id,
    this.title,
    this.message,
    this.type,
    this.moduleId,
    this.url,
    this.image,
    this.readStatus,
    this.readAt,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    type: json["type"],
    moduleId: json["module_id"],
    url: json["url"],
    image: json["image"],
    readStatus: json["read_status"],
    readAt: json["read_at"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "type": type,
    "module_id": moduleId,
    "url": url,
    "image": image,
    "read_status": readStatus,
    "read_at": readAt,
    "created_at": createdAt,
  };
}

class NotificationPagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  bool? hasMore;

  NotificationPagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.hasMore,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) => NotificationPagination(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "has_more": hasMore,
  };
}
