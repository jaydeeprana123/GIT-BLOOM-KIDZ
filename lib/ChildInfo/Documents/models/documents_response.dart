// To parse this JSON data, do
//
//     final documentsResponse = documentsResponseFromJson(jsonString);

import 'dart:convert';

DocumentsResponse documentsResponseFromJson(String str) => DocumentsResponse.fromJson(json.decode(str));

String documentsResponseToJson(DocumentsResponse data) => json.encode(data.toJson());

class DocumentsResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  DocumentsResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) => DocumentsResponse(
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
  List<DocumentData>? document;

  Data({
    this.document,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    document: json["document"] == null ? [] : List<DocumentData>.from(json["document"]!.map((x) => DocumentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "document": document == null ? [] : List<dynamic>.from(document!.map((x) => x.toJson())),
  };
}

class DocumentData {
  int? id;
  String? name;
  String? size;
  String? extension;
  String? iconType;
  String? uploadedAt;
  String? url;

  DocumentData({
    this.id,
    this.name,
    this.size,
    this.extension,
    this.iconType,
    this.uploadedAt,
    this.url,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) => DocumentData(
    id: json["id"],
    name: json["name"],
    size: json["size"],
    extension: json["extension"],
    iconType: json["icon_type"],
    uploadedAt: json["uploaded_at"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "size": size,
    "extension": extension,
    "icon_type": iconType,
    "uploaded_at": uploadedAt,
    "url": url,
  };
}
