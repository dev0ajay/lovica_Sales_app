
import 'dart:convert';

CurrentLanguageResponse currentLanguageResponseFromJson(String str) => CurrentLanguageResponse.fromJson(json.decode(str));

String currentLanguageResponseToJson(CurrentLanguageResponse data) => json.encode(data.toJson());

class CurrentLanguageResponse {
  final String status;
  final int statusCode;
  final String msg;
  final String currentlang;

  CurrentLanguageResponse({
    required this.status,
    required this.statusCode,
    required this.msg,
    required this.currentlang,
  });

  factory CurrentLanguageResponse.fromJson(Map<String, dynamic> json) => CurrentLanguageResponse(
    status: json["status"],
    statusCode: json["status_code"],
    msg: json["msg"],
    currentlang: json["currentlang"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "msg": msg,
    "currentlang": currentlang,
  };
}
