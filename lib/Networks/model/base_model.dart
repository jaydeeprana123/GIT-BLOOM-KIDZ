import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  BaseModel({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  bool success;
  int statusCode;
  String message;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
      };
}
