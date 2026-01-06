// To parse this JSON data, do
//
//     final observationListResponse = observationListResponseFromJson(jsonString);

import 'dart:convert';

ObservationListResponse observationListResponseFromJson(String str) => ObservationListResponse.fromJson(json.decode(str));

String observationListResponseToJson(ObservationListResponse data) => json.encode(data.toJson());

class ObservationListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ObservationListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory ObservationListResponse.fromJson(Map<String, dynamic> json) => ObservationListResponse(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  List<Observation>? observations;
  Pagination? pagination;

  Data({
    this.observations,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    observations: json["observations"] == null ? [] : List<Observation>.from(json["observations"]!.map((x) => Observation.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "observations": observations == null ? [] : List<dynamic>.from(observations!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Observation {
  int? id;
  dynamic title;
  dynamic description;
  String? observations;
  String? childNames;
  DateTime? createdAt;
  String? createdBy;
  List<Media>? media;
  List<Like>? likes;
  int? likesCount;
  List<Comment>? comments;
  int? commentsCount;

  Observation({
    this.id,
    this.title,
    this.description,
    this.observations,
    this.childNames,
    this.createdAt,
    this.createdBy,
    this.media,
    this.likes,
    this.likesCount,
    this.comments,
    this.commentsCount,
  });

  factory Observation.fromJson(Map<String, dynamic> json) => Observation(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    observations: json["observations"],
    childNames: json["child_names"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
    likesCount: json["likes_count"],
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
    commentsCount: json["comments_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "observations": observations,
    "child_names": childNames,
    "created_at": createdAt?.toIso8601String(),
    "created_by": createdBy,
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
    "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
    "likes_count": likesCount,
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "comments_count": commentsCount,
  };
}


class Comment {
  int? id;
  String? content;
  DateTime? date;
  int? likes;
  User? user;

  Comment({
    this.id,
    this.content,
    this.date,
    this.likes,
    this.user,
  });

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

  User({
    this.id,
    this.name,
    this.profile,
    this.userType,
  });

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


class Like {
  int? id;
  int? masterId;
  int? userId;
  dynamic date;

  Like({
    this.id,
    this.masterId,
    this.userId,
    this.date,
  });

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
  String? image;
  String? extension;
  String? size;

  Media({
    this.id,
    this.masterId,
    this.image,
    this.extension,
    this.size,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    masterId: json["master_id"],
    image: json["image"],
    extension: json["extension"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "master_id": masterId,
    "image": image,
    "extension": extension,
    "size": size,
  };
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
