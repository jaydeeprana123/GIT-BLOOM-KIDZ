import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  BaseModel({
    required this.status,
    required this.statusCode,
    required this.message,
  });

  bool status;
  int statusCode;
  String message;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    status: json["status"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "message": message,
  };
}
