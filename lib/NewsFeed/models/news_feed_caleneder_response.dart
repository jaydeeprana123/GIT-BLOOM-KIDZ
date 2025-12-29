// To parse this JSON data, do
//
//     final newsFeedCalenerResponse = newsFeedCalenerResponseFromJson(jsonString);

import 'dart:convert';

NewsFeedCalenerResponse newsFeedCalenerResponseFromJson(String str) =>
    NewsFeedCalenerResponse.fromJson(json.decode(str));

String newsFeedCalenerResponseToJson(NewsFeedCalenerResponse data) =>
    json.encode(data.toJson());

class NewsFeedCalenerResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  NewsFeedCalenerResponse({this.status, this.message, this.code, this.data});

  factory NewsFeedCalenerResponse.fromJson(Map<String, dynamic> json) =>
      NewsFeedCalenerResponse(
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
  List<CalenderNewsEvent>? events;
  int? total;

  Data({this.events, this.total});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    events: json["events"] == null
        ? []
        : List<CalenderNewsEvent>.from(
            json["events"]!.map((x) => CalenderNewsEvent.fromJson(x)),
          ),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "events": events == null
        ? []
        : List<dynamic>.from(events!.map((x) => x.toJson())),
    "total": total,
  };
}

class CalenderNewsEvent {
  int? id;
  String? title;
  DateTime? start;
  DateTime? end;
  String? description;
  String? type;
  bool? allDay;

  CalenderNewsEvent({
    this.id,
    this.title,
    this.start,
    this.end,
    this.description,
    this.type,
    this.allDay,
  });

  factory CalenderNewsEvent.fromJson(Map<String, dynamic> json) =>
      CalenderNewsEvent(
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
