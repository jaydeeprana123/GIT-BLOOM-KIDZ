// To parse this JSON data, do
//
//     final groupObservationListResponse = groupObservationListResponseFromJson(jsonString);

import 'dart:convert';

GroupObservationListResponse groupObservationListResponseFromJson(String str) => GroupObservationListResponse.fromJson(json.decode(str));

String groupObservationListResponseToJson(GroupObservationListResponse data) => json.encode(data.toJson());

class GroupObservationListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  GroupObservationListResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory GroupObservationListResponse.fromJson(Map<String, dynamic> json) => GroupObservationListResponse(
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
  List<GroupObservation>? observations;
  Pagination? pagination;

  Data({
    this.observations,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    observations: json["observations"] == null ? [] : List<GroupObservation>.from(json["observations"]!.map((x) => GroupObservation.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "observations": observations == null ? [] : List<dynamic>.from(observations!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GroupObservation {
  int? id;
  String? observations;
  String? childNames;
  IsGroup? isGroup;
  DateTime? createdAt;
  CreatedBy? createdBy;
  List<GroupMedia>? media;

  GroupObservation({
    this.id,
    this.observations,
    this.childNames,
    this.isGroup,
    this.createdAt,
    this.createdBy,
    this.media,
  });

  factory GroupObservation.fromJson(Map<String, dynamic> json) => GroupObservation(
    id: json["id"],
    observations: json["observations"],
    childNames: json["child_names"],
    isGroup: isGroupValues.map[json["is_group"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
    media: json["media"] == null ? [] : List<GroupMedia>.from(json["media"]!.map((x) => GroupMedia.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "observations": observations,
    "child_names": childNames,
    "is_group": isGroupValues.reverse[isGroup],
    "created_at": createdAt?.toIso8601String(),
    "created_by": createdBy?.toJson(),
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
  };
}

class CreatedBy {
  int? id;
  String? name;
  dynamic profile;

  CreatedBy({
    this.id,
    this.name,
    this.profile,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    name: json["name"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile": profile,
  };
}



enum IsGroup {
  N,
  Y
}

final isGroupValues = EnumValues({
  "N": IsGroup.N,
  "Y": IsGroup.Y
});

class GroupMedia {
  int? id;
  String? image;
  String? extension;
  String? size;

  GroupMedia({
    this.id,
    this.image,
    this.extension,
    this.size,
  });

  factory GroupMedia.fromJson(Map<String, dynamic> json) => GroupMedia(
    id: json["id"],
    image: json["image"],
    extension: json["extension"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
