
import 'dart:convert';
//
// OrderDuplicateModel orderDuplicateModelFromJson(String str) => OrderDuplicateModel.fromJson(json.decode(str));
//
// String orderDuplicateModelToJson(OrderDuplicateModel data) => json.encode(data.toJson());

class OrderDuplicateModel {
  final String status;
  final int statusCode;
  final String duplicateOrder;
  final String msgEn;
  final String msgAr;

  OrderDuplicateModel({
    required this.status,
    required this.statusCode,
    required this.duplicateOrder,
    required this.msgEn,
    required this.msgAr,
  });
  //
  factory OrderDuplicateModel.fromJson(Map<String, dynamic> json) => OrderDuplicateModel(
    status: json["status"],
    statusCode: json["status_code"],
    duplicateOrder: json["duplicate_order"],
    msgEn: json["msg_en"],
    msgAr: json["msg_ar"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "duplicate_order": duplicateOrder,
    "msg_en": msgEn,
    "msg_ar": msgAr,
  };
}
