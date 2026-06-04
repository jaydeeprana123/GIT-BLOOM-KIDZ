// To parse this JSON data, do
//
//     final observationListResponse = observationListResponseFromJson(jsonString);

import 'dart:convert';

ObservationListResponse observationListResponseFromJson(String str) =>
    ObservationListResponse.fromJson(json.decode(str));

String observationListResponseToJson(ObservationListResponse data) =>
    json.encode(data.toJson());

class ObservationListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ObservationListResponse({this.status, this.message, this.code, this.data});

  factory ObservationListResponse.fromJson(Map<String, dynamic> json) =>
      ObservationListResponse(
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

  Data({this.observations, this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    observations: json["observations"] == null
        ? []
        : List<Observation>.from(
            json["observations"]!.map((x) => Observation.fromJson(x)),
          ),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "observations": observations == null
        ? []
        : List<dynamic>.from(observations!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Observation {
  int? id;
  String? date;
  dynamic title;
  dynamic description;
  String? observations;
  List<int>? childrenIds;
  String? childNames;
  String? isGroupObs;
  String? isGroupLabel;
  List<int>? domainIds;
  List<Domain>? domain;
  List<int>? specificAreaIds;
  List<SpecificArea>? specificAreas;
  String? obsType;
  String? obsTypeLabel;
  TypeData? typeData;
  String? addedBy;
  DateTime? createdAt;
  CreatedBy? createdBy;
  List<ObservationMedia>? media;
  List<Like>? likes;
  int? likesCount;
  List<Comment>? comments;
  int? commentsCount;
  List<User>? likedUsers;

  Observation({
    this.id,
    this.date,
    this.title,
    this.description,
    this.observations,
    this.childrenIds,
    this.childNames,
    this.isGroupObs,
    this.isGroupLabel,
    this.domainIds,
    this.domain,
    this.specificAreaIds,
    this.specificAreas,
    this.obsType,
    this.obsTypeLabel,
    this.typeData,
    this.addedBy,
    this.createdAt,
    this.createdBy,
    this.media,
    this.likes,
    this.likesCount,
    this.comments,
    this.commentsCount,
    this.likedUsers,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    final parsedLikes = json["likes"] == null
        ? <Like>[]
        : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x)));

    List<User> usersList = [];
    if (json["liked_users"] != null) {
      usersList = List<User>.from(json["liked_users"]!.map((x) => User.fromJson(x)));
    } else if (json["likedUsers"] != null) {
      usersList = List<User>.from(json["likedUsers"]!.map((x) => User.fromJson(x)));
    } else {
      // Build from likes array: use nested user object if present,
      // otherwise create a minimal User from user_id so avatars are never lost.
      usersList = parsedLikes.map((l) {
        if (l.user != null) return l.user!;
        if (l.userId != null) return User(id: l.userId);
        return null;
      }).whereType<User>().toList();
    }

    return Observation(
      id: json["id"],
      date: json["date"],
      title: json["title"],
      description: json["description"],
      observations: json["observations"],
      childrenIds: json["children_ids"] == null
          ? []
          : List<int>.from(json["children_ids"]!.map((x) => x)),
      childNames: json["child_names"],
      isGroupObs: json["is_group_obs"],
      isGroupLabel: json["is_group_label"],
      domainIds: json["domain_ids"] == null
          ? []
          : List<int>.from(json["domain_ids"]!.map((x) => x)),
      domain: json["domain"] == null
          ? []
          : List<Domain>.from(json["domain"]!.map((x) => Domain.fromJson(x))),
      specificAreaIds: json["specific_area_ids"] == null
          ? []
          : List<int>.from(json["specific_area_ids"]!.map((x) => x)),
      specificAreas: json["specific_areas"] == null
          ? []
          : List<SpecificArea>.from(
              json["specific_areas"]!.map((x) => SpecificArea.fromJson(x)),
            ),
      obsType: json["obs_type"],
      obsTypeLabel: json["obs_type_label"],
      typeData: json["type_data"] == null
          ? null
          : TypeData.fromJson(json["type_data"]),
      addedBy: json["added_by"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      createdBy: json["created_by"] == null
          ? null
          : CreatedBy.fromJson(json["created_by"]),
      media: json["media"] == null
          ? []
          : List<ObservationMedia>.from(json["media"]!.map((x) => ObservationMedia.fromJson(x))),
      likes: parsedLikes,
      likesCount: json["likes_count"],
      comments: json["comments"] == null
          ? []
          : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
      commentsCount: json["comments_count"],
      likedUsers: usersList,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "title": title,
    "description": description,
    "observations": observations,
    "children_ids": childrenIds == null
        ? []
        : List<dynamic>.from(childrenIds!.map((x) => x)),
    "child_names": childNames,
    "is_group_obs": isGroupObs,
    "is_group_label": isGroupLabel,
    "domain_ids": domainIds == null
        ? []
        : List<dynamic>.from(domainIds!.map((x) => x)),
    "domain": domain == null
        ? []
        : List<dynamic>.from(domain!.map((x) => x.toJson())),
    "specific_area_ids": specificAreaIds == null
        ? []
        : List<dynamic>.from(specificAreaIds!.map((x) => x)),
    "specific_areas": specificAreas == null
        ? []
        : List<dynamic>.from(specificAreas!.map((x) => x.toJson())),
    "obs_type": obsType,
    "obs_type_label": obsTypeLabel,
    "type_data": typeData?.toJson(),
    "added_by": addedBy,
    "created_at": createdAt?.toIso8601String(),
    "created_by": createdBy?.toJson(),
    "media": media == null
        ? []
        : List<dynamic>.from(media!.map((x) => x.toJson())),
    "likes": likes == null
        ? []
        : List<dynamic>.from(likes!.map((x) => x.toJson())),
    "likes_count": likesCount,
    "comments": comments == null
        ? []
        : List<Comment>.from(comments!.map((x) => x)),
    "comments_count": commentsCount,
    "liked_users": likedUsers == null
        ? []
        : List<dynamic>.from(likedUsers!.map((x) => x.toJson())),
  };
}

class CreatedBy {
  int? id;
  String? name;
  dynamic profile;

  CreatedBy({this.id, this.name, this.profile});

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      CreatedBy(id: json["id"], name: json["name"], profile: json["profile"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "profile": profile};
}

class Domain {
  int? id;
  String? name;
  String? color;
  String? status;
  int? createdId;
  DateTime? createdAt;
  int? updatedId;
  DateTime? updatedAt;
  dynamic deletedBy;
  dynamic deletedAt;
  String? deletedStatus;

  Domain({
    this.id,
    this.name,
    this.color,
    this.status,
    this.createdId,
    this.createdAt,
    this.updatedId,
    this.updatedAt,
    this.deletedBy,
    this.deletedAt,
    this.deletedStatus,
  });

  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    status: json["status"],
    createdId: json["created_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedId: json["updated_id"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedBy: json["deleted_by"],
    deletedAt: json["deleted_at"],
    deletedStatus: json["deleted_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color,
    "status": status,
    "created_id": createdId,
    "created_at": createdAt?.toIso8601String(),
    "updated_id": updatedId,
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_by": deletedBy,
    "deleted_at": deletedAt,
    "deleted_status": deletedStatus,
  };
}

class Like {
  int? id;
  int? masterId;
  int? userId;
  dynamic date;
  User? user;

  Like({this.id, this.masterId, this.userId, this.date, this.user});

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["id"],
    masterId: json["master_id"],
    userId: json["user_id"],
    date: json["date"],
    user: json["user"] == null
        ? (json["user_details"] == null
            ? (json["liked_by"] == null ? null : User.fromJson(json["liked_by"]))
            : User.fromJson(json["user_details"]))
        : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "master_id": masterId,
    "user_id": userId,
    "date": date,
    "user": user?.toJson(),
  };
}

class ObservationMedia {
  int? id;
  int? masterId;
  String? image;
  String? extension;
  String? size;

  ObservationMedia({this.id, this.masterId, this.image, this.extension, this.size});

  factory ObservationMedia.fromJson(Map<String, dynamic> json) => ObservationMedia(
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

class SpecificArea {
  int? id;
  String? name;

  SpecificArea({this.id, this.name});

  factory SpecificArea.fromJson(Map<String, dynamic> json) =>
      SpecificArea(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

// ── TypeData ──────────────────────────────────────────────────────────────────
// The `tabs` field is a dynamic map in JSON (keys vary by obs_type).
// We store it as Map<String, String?> for easy lookup by key.

class TypeData {
  String? observations;
  String? whatsNext;
  String? assessmentType;
  dynamic assessmentTypeLabel;
  Areas? areas;

  /// Holds tab values keyed by their JSON field name, e.g.:
  ///   "playing_exploring", "active_learning", "creating_thinking",
  ///   "context", "strengths", "activities_development",
  ///   "agencies_info", "parent_comments"
  Map<String, String?>? tabs;

  TypeData({
    this.observations,
    this.whatsNext,
    this.assessmentType,
    this.assessmentTypeLabel,
    this.areas,
    this.tabs,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) {
    // Parse tabs map if present
    Map<String, String?>? tabsMap;
    if (json["tabs"] != null && json["tabs"] is Map) {
      tabsMap = (json["tabs"] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v?.toString()),
      );
    }

    return TypeData(
      observations: json["observations"],
      whatsNext: json["whats_next"],
      assessmentType: json["assessment_type"],
      assessmentTypeLabel: json["assessment_type_label"],
      areas: json["areas"] == null ? null : Areas.fromJson(json["areas"]),
      tabs: tabsMap,
    );
  }

  Map<String, dynamic> toJson() => {
    "observations": observations,
    "whats_next": whatsNext,
    "assessment_type": assessmentType,
    "assessment_type_label": assessmentTypeLabel,
    "areas": areas?.toJson(),
    "tabs": tabs,
  };
}

class Areas {
  CommunicationLanguage? communicationLanguage;
  CommunicationLanguage? psed;
  CommunicationLanguage? physicalDevelopment;
  CommunicationLanguage? literacy;
  CommunicationLanguage? mathematics;
  CommunicationLanguage? understandingWorld;
  CommunicationLanguage? ead;

  Areas({
    this.communicationLanguage,
    this.psed,
    this.physicalDevelopment,
    this.literacy,
    this.mathematics,
    this.understandingWorld,
    this.ead,
  });

  factory Areas.fromJson(Map<String, dynamic> json) => Areas(
    communicationLanguage: json["communication_language"] == null
        ? null
        : CommunicationLanguage.fromJson(json["communication_language"]),
    psed: json["psed"] == null
        ? null
        : CommunicationLanguage.fromJson(json["psed"]),
    physicalDevelopment: json["physical_development"] == null
        ? null
        : CommunicationLanguage.fromJson(json["physical_development"]),
    literacy: json["literacy"] == null
        ? null
        : CommunicationLanguage.fromJson(json["literacy"]),
    mathematics: json["mathematics"] == null
        ? null
        : CommunicationLanguage.fromJson(json["mathematics"]),
    understandingWorld: json["understanding_world"] == null
        ? null
        : CommunicationLanguage.fromJson(json["understanding_world"]),
    ead: json["ead"] == null
        ? null
        : CommunicationLanguage.fromJson(json["ead"]),
  );

  Map<String, dynamic> toJson() => {
    "communication_language": communicationLanguage?.toJson(),
    "psed": psed?.toJson(),
    "physical_development": physicalDevelopment?.toJson(),
    "literacy": literacy?.toJson(),
    "mathematics": mathematics?.toJson(),
    "understanding_world": understandingWorld?.toJson(),
    "ead": ead?.toJson(),
  };
}

class CommunicationLanguage {
  String? text;
  String? assessmentType;
  String? ageBand;
  String? ageBandLabel;

  CommunicationLanguage({
    this.text,
    this.assessmentType,
    this.ageBand,
    this.ageBandLabel,
  });

  factory CommunicationLanguage.fromJson(Map<String, dynamic> json) =>
      CommunicationLanguage(
        text: json["text"],
        assessmentType: json["assessment_type"],
        ageBand: json["age_band"],
        ageBandLabel: json["age_band_label"],
      );

  Map<String, dynamic> toJson() => {
    "text": text,
    "assessment_type": assessmentType,
    "age_band": ageBand,
    "age_band_label": ageBandLabel,
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

class Comment {
  int? id;
  String? content;
  DateTime? date;
  int? likes;
  User? user;
  List<User>? likedUsers;

  Comment({this.id, this.content, this.date, this.likes, this.user, this.likedUsers});

  factory Comment.fromJson(Map<String, dynamic> json) {
    final dynamic likesRaw = json["likes"];
    List<Like> parsedLikes = [];
    int likesCount = 0;

    if (likesRaw is List) {
      parsedLikes = List<Like>.from(
        likesRaw.map((x) => Like.fromJson(x as Map<String, dynamic>)),
      );
      likesCount = json["likes_count"] as int? ?? parsedLikes.length;
    } else if (likesRaw is int) {
      likesCount = likesRaw;
    } else {
      likesCount = json["likes_count"] as int? ?? 0;
    }

    List<User> usersList = [];
    if (json["liked_users"] != null) {
      usersList = List<User>.from(
        json["liked_users"]!.map((x) => User.fromJson(x)),
      );
    } else if (json["likedUsers"] != null) {
      usersList = List<User>.from(
        json["likedUsers"]!.map((x) => User.fromJson(x)),
      );
    } else if (parsedLikes.isNotEmpty) {
      usersList = parsedLikes.map((l) {
        if (l.user != null) return l.user!;
        if (l.userId != null) return User(id: l.userId);
        return null;
      }).whereType<User>().toList();
    }

    final dynamic userRaw =
        json["user"] ?? json["user_details"] ?? json["created_by"];

    return Comment(
      id: json["id"],
      content: json["content"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      likes: likesCount,
      user: userRaw == null
          ? null
          : User.fromJson(userRaw as Map<String, dynamic>),
      likedUsers: usersList,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "date": date?.toIso8601String(),
    "likes": likes,
    "user": user?.toJson(),
    "liked_users": likedUsers == null
        ? []
        : List<dynamic>.from(likedUsers!.map((x) => x.toJson())),
  };
}

class User {
  int? id;
  String? name;
  String? profile;

  User({this.id, this.name, this.profile});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    profile: json["profile"] ?? json["profile_image"] ?? json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile": profile,
  };
}
