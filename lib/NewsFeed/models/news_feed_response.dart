// To parse this JSON data, do
//
//     final newsFeedResponse = newsFeedResponseFromJson(jsonString);

import 'dart:convert';

NewsFeedResponse newsFeedResponseFromJson(String str) =>
    NewsFeedResponse.fromJson(json.decode(str));

String newsFeedResponseToJson(NewsFeedResponse data) =>
    json.encode(data.toJson());

class NewsFeedResponse {
  bool? status;
  String? message;
  int? code;
  NewsFeedData? data;

  NewsFeedResponse({this.status, this.message, this.code, this.data});

  factory NewsFeedResponse.fromJson(Map<String, dynamic> json) =>
      NewsFeedResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? null : NewsFeedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class NewsFeedData {
  List<Newsfeed>? newsfeeds;
  Pagination? pagination;

  NewsFeedData({this.newsfeeds, this.pagination});

  factory NewsFeedData.fromJson(Map<String, dynamic> json) => NewsFeedData(
    newsfeeds: json["newsfeeds"] == null
        ? []
        : List<Newsfeed>.from(
            json["newsfeeds"]!.map((x) => Newsfeed.fromJson(x)),
          ),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "newsfeeds": newsfeeds == null
        ? []
        : List<dynamic>.from(newsfeeds!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Newsfeed {
  int? id;
  String? name;
  String? description;
  String? descriptionOld;
  ShowType? showType;
  DateTime? startDate;
  String? startTime;
  String? endTime;
  int? nurseryId;
  Type? type;
  String? status;
  DateTime? createdAt;
  CreatedId? createdId;
  List<Media>? media;
  List<Like>? likes;
  int? likesCount;
  List<Comment>? comments;
  int? commentsCount;

  Newsfeed({
    this.id,
    this.name,
    this.description,
    this.descriptionOld,
    this.showType,
    this.startDate,
    this.startTime,
    this.endTime,
    this.nurseryId,
    this.type,
    this.status,
    this.createdAt,
    this.createdId,
    this.media,
    this.likes,
    this.likesCount,
    this.comments,
    this.commentsCount,
  });

  factory Newsfeed.fromJson(Map<String, dynamic> json) => Newsfeed(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    descriptionOld: json["description_old"],
    showType: showTypeValues.map[json["show_type"]]!,
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    nurseryId: json["nursery_id"],
    type: typeValues.map[json["type"]]!,
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    createdId: json["created_id"] == null
        ? null
        : CreatedId.fromJson(json["created_id"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    likes: json["likes"] == null
        ? []
        : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
    likesCount: json["likes_count"],
    comments: json["comments"] == null
        ? []
        : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
    commentsCount: json["comments_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "description_old": descriptionOld,
    "show_type": showTypeValues.reverse[showType],
    "start_date":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "nursery_id": nurseryId,
    "type": typeValues.reverse[type],
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "created_id": createdId?.toJson(),
    "media": media == null
        ? []
        : List<dynamic>.from(media!.map((x) => x.toJson())),
    "likes": likes == null
        ? []
        : List<dynamic>.from(likes!.map((x) => x.toJson())),
    "likes_count": likesCount,
    "comments": comments == null
        ? []
        : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "comments_count": commentsCount,
  };
}

class Comment {
  int? id;
  String? content;
  DateTime? date;
  int? likes;
  User? user;

  Comment({this.id, this.content, this.date, this.likes, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    content: json["content"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    likes: json["likes"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "date": date?.toIso8601String(),
    "likes": likes,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? profile;
  String? userType;

  User({this.id, this.name, this.profile, this.userType});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    profile: json["profile"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile": profile,
    "user_type": userType,
  };
}

class CreatedId {
  int? id;
  String? name;
  String? email;
  Phone? phone;
  String? profile;
  UserType? userType;
  String? roleId;
  String? status;

  CreatedId({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.userType,
    this.roleId,
    this.status,
  });

  factory CreatedId.fromJson(Map<String, dynamic> json) => CreatedId(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: phoneValues.map[json["phone"]]!,
    profile: json["profile"],
    userType: userTypeValues.map[json["user_type"]]!,
    roleId: json["role_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "email": emailValues.reverse[email],
    "phone": phoneValues.reverse[phone],
    "profile": profile,
    "user_type": userTypeValues.reverse[userType],
    "role_id": roleId,
    "status": status,
  };
}

enum Email {
  ACCOUNTSADMIN_VDNURSERIES_CO_UK,
  LAURA_FAHMY_LITTLEINVENTORSMONTESSORI_CO_UK,
}

final emailValues = EnumValues({
  "accountsadmin@vdnurseries.co.uk": Email.ACCOUNTSADMIN_VDNURSERIES_CO_UK,
  "laura.fahmy@littleinventorsmontessori.co.uk":
      Email.LAURA_FAHMY_LITTLEINVENTORSMONTESSORI_CO_UK,
});

enum Name { LAURA_FAHMY, SESSIE_LEITAO }

final nameValues = EnumValues({
  "Laura Fahmy": Name.LAURA_FAHMY,
  "Sessie Leitao": Name.SESSIE_LEITAO,
});

enum Phone { EMPTY, THE_07533622275 }

final phoneValues = EnumValues({
  "": Phone.EMPTY,
  "07533622275": Phone.THE_07533622275,
});

enum UserType { ADMIN, EMPLOYEE }

final userTypeValues = EnumValues({
  "Admin": UserType.ADMIN,
  "Employee": UserType.EMPLOYEE,
});

class Like {
  int? id;
  int? masterId;
  int? userId;
  dynamic date;

  Like({this.id, this.masterId, this.userId, this.date});

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["id"],
    masterId: json["master_id"],
    userId: json["user_id"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "master_id": masterId,
    "user_id": userId,
    "date": date,
  };
}

class Media {
  int? id;
  int? masterId;
  String? file;
  String? extenstion;

  Media({this.id, this.masterId, this.file, this.extenstion});

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    masterId: json["master_id"],
    file: json["file"],
    extenstion: json["extenstion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "master_id": masterId,
    "file": file,
    "extenstion": extenstion,
  };
}

enum ShowType { EVERYONE, PARENTS }

final showTypeValues = EnumValues({
  "everyone": ShowType.EVERYONE,
  "parents": ShowType.PARENTS,
});

enum Type { ANNOUNCEMENT, EVENTS, FEED }

final typeValues = EnumValues({
  "announcement": Type.ANNOUNCEMENT,
  "events": Type.EVENTS,
  "feed": Type.FEED,
});

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
