import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  BaseModel({
     this.status,
     this.statusCode,
     this.code,
     this.message,
  });

  bool? status;
  int? statusCode;
  int? code;
  String? message;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    status: json["status"],
    statusCode: json["status_code"],
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "message": message,
  };
}
