// To parse this JSON data, do
//
//     final newsFeedCalenerResponse = newsFeedCalenerResponseFromJson(jsonString);

import 'dart:convert';

NewsFeedCalenerResponse newsFeedCalenerResponseFromJson(String str) => NewsFeedCalenerResponse.fromJson(json.decode(str));

String newsFeedCalenerResponseToJson(NewsFeedCalenerResponse data) => json.encode(data.toJson());

class NewsFeedCalenerResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  NewsFeedCalenerResponse({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory NewsFeedCalenerResponse.fromJson(Map<String, dynamic> json) => NewsFeedCalenerResponse(
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
  List<NewsEvent>? events;
  int? total;

  Data({
    this.events,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    events: json["events"] == null ? [] : List<NewsEvent>.from(json["events"]!.map((x) => NewsEvent.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
    "total": total,
  };
}

class NewsEvent {
  int? id;
  String? title;
  DateTime? start;
  DateTime? end;
  String? description;
  String? type;
  bool? allDay;

  NewsEvent({
    this.id,
    this.title,
    this.start,
    this.end,
    this.description,
    this.type,
    this.allDay,
  });

  factory NewsEvent.fromJson(Map<String, dynamic> json) => NewsEvent(
    id: json["id"],
    title: json["title"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    description: json["description"],
    type: json["type"],
    allDay: json["allDay"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
    "description": description,
    "type": type,
    "allDay": allDay,
  };
}
