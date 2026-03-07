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
  dynamic title;
  dynamic description;
  String? observations;
  String? childNames;
  String? isGroupObs;
  String? isGroupLabel;
  String? whatsNext;
  String? context;
  List<Domain>? domain;
  List<SpecificArea>? specificAreas;
  String? clAssessmentType;
  String? pwAssessmentType;
  String? pdAssessmentType;
  String? literacyAssessmentType;
  String? mathematicsAssessmentType;
  String? uwAssessmentType;
  String? eadAssessmentType;
  String? clAssessmentAgeBand;
  String? pwAssessmentAgeBand;
  String? pdAssessmentTypeAgeBand;
  String? literacyAssessmentAgeBand;
  String? mathematicsAssessmentAgeBand;
  String? uwAssessmentAgeBand;
  String? eadAssessmentAgeBand;
  String? addedBy;
  DateTime? createdAt;
  CreatedBy? createdBy;
  List<Media>? media;
  List<Like>? likes;
  int? likesCount;
  List<dynamic>? comments;
  int? commentsCount;

  Observation({
    this.id,
    this.title,
    this.description,
    this.observations,
    this.childNames,
    this.isGroupObs,
    this.isGroupLabel,
    this.whatsNext,
    this.context,
    this.domain,
    this.specificAreas,
    this.clAssessmentType,
    this.pwAssessmentType,
    this.pdAssessmentType,
    this.literacyAssessmentType,
    this.mathematicsAssessmentType,
    this.uwAssessmentType,
    this.eadAssessmentType,
    this.clAssessmentAgeBand,
    this.pwAssessmentAgeBand,
    this.pdAssessmentTypeAgeBand,
    this.literacyAssessmentAgeBand,
    this.mathematicsAssessmentAgeBand,
    this.uwAssessmentAgeBand,
    this.eadAssessmentAgeBand,
    this.addedBy,
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
    isGroupObs: json["is_group_obs"],
    isGroupLabel: json["is_group_label"],
    whatsNext: json["whats_next"],
    context: json["context"],
    domain: json["domain"] == null
        ? []
        : List<Domain>.from(json["domain"]!.map((x) => Domain.fromJson(x))),
    specificAreas: json["specific_areas"] == null
        ? []
        : List<SpecificArea>.from(
            json["specific_areas"]!.map((x) => SpecificArea.fromJson(x)),
          ),
    clAssessmentType: json["cl_assessment_type"],
    pwAssessmentType: json["pw_assessment_type"],
    pdAssessmentType: json["pd_assessment_type"],
    literacyAssessmentType: json["literacy_assessment_type"],
    mathematicsAssessmentType: json["mathematics_assessment_type"],
    uwAssessmentType: json["uw_assessment_type"],
    eadAssessmentType: json["ead_assessment_type"],
    clAssessmentAgeBand: json["cl_assessment_age_band"],
    pwAssessmentAgeBand: json["pw_assessment_age_band"],
    pdAssessmentTypeAgeBand: json["pd_assessment_type_age_band"],
    literacyAssessmentAgeBand: json["literacy_assessment_age_band"],
    mathematicsAssessmentAgeBand: json["mathematics_assessment_age_band"],
    uwAssessmentAgeBand: json["uw_assessment_age_band"],
    eadAssessmentAgeBand: json["ead_assessment_age_band"],
    addedBy: json["added_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    createdBy: json["created_by"] == null
        ? null
        : CreatedBy.fromJson(json["created_by"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    likes: json["likes"] == null
        ? []
        : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
    likesCount: json["likes_count"],
    comments: json["comments"] == null
        ? []
        : List<dynamic>.from(json["comments"]!.map((x) => x)),
    commentsCount: json["comments_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "observations": observations,
    "child_names": childNames,
    "is_group_obs": isGroupObs,
    "is_group_label": isGroupLabel,
    "whats_next": whatsNext,
    "context": context,
    "domain": domain == null
        ? []
        : List<dynamic>.from(domain!.map((x) => x.toJson())),
    "specific_areas": specificAreas == null
        ? []
        : List<dynamic>.from(specificAreas!.map((x) => x.toJson())),
    "cl_assessment_type": clAssessmentType,
    "pw_assessment_type": pwAssessmentType,
    "pd_assessment_type": pdAssessmentType,
    "literacy_assessment_type": literacyAssessmentType,
    "mathematics_assessment_type": mathematicsAssessmentType,
    "uw_assessment_type": uwAssessmentType,
    "ead_assessment_type": eadAssessmentType,
    "cl_assessment_age_band": clAssessmentAgeBand,
    "pw_assessment_age_band": pwAssessmentAgeBand,
    "pd_assessment_type_age_band": pdAssessmentTypeAgeBand,
    "literacy_assessment_age_band": literacyAssessmentAgeBand,
    "mathematics_assessment_age_band": mathematicsAssessmentAgeBand,
    "uw_assessment_age_band": uwAssessmentAgeBand,
    "ead_assessment_age_band": eadAssessmentAgeBand,
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
        : List<dynamic>.from(comments!.map((x) => x)),
    "comments_count": commentsCount,
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
  String? image;
  String? extension;
  String? size;

  Media({this.id, this.masterId, this.image, this.extension, this.size});

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

class SpecificArea {
  int? id;
  String? name;

  SpecificArea({this.id, this.name});

  factory SpecificArea.fromJson(Map<String, dynamic> json) =>
      SpecificArea(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
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
