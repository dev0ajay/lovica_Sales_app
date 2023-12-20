
import 'dart:convert';

DeleteUserAccountResponse deleteUserAccountResponseFromJson(String str) => DeleteUserAccountResponse.fromJson(json.decode(str));

String deleteUserAccountResponseToJson(DeleteUserAccountResponse data) => json.encode(data.toJson());

class DeleteUserAccountResponse {
  final String status;
  final int statusCode;
  final String msg;
  final String msgAr;

  DeleteUserAccountResponse({
    required this.status,
    required this.statusCode,
    required this.msg,
    required this.msgAr,
  });

  factory DeleteUserAccountResponse.fromJson(Map<String, dynamic> json) => DeleteUserAccountResponse(
    status: json["status"],
    statusCode: json["status_code"],
    msg: json["msg"],
    msgAr: json["msg_ar"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "msg": msg,
    "msg_ar": msgAr,
  };
}
