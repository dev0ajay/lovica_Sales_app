
import 'dart:convert';

PaymentMethodResponse paymentMethodResponseFromJson(String str) => PaymentMethodResponse.fromJson(json.decode(str));

String paymentMethodResponseToJson(PaymentMethodResponse data) => json.encode(data.toJson());

class PaymentMethodResponse {
  final String status;
  final int statusCode;
  final String permit;
  final String message;
  final String messageAr;
  final String parameters;
  final String amount;
  final String codMinAmt;
  final String paymentlinkMinOrder;
  final String btMinOrder;

  PaymentMethodResponse({
    required this.status,
    required this.statusCode,
    required this.permit,
    required this.message,
    required this.messageAr,
    required this.parameters,
    required this.amount,
    required this.codMinAmt,
    required this.paymentlinkMinOrder,
    required this.btMinOrder,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => PaymentMethodResponse(
    status: json["status"],
    statusCode: json["status_code"],
    permit: json["permit"],
    message: json["message"],
    messageAr: json["message_ar"],
    parameters: json["parameters"],
    amount: json["amount"],
    codMinAmt: json["cod_min_amt"],
    paymentlinkMinOrder: json["paymentlink_min_order"],
    btMinOrder: json["\n                  bt_min_order"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "permit": permit,
    "message": message,
    "message_ar": messageAr,
    "parameters": parameters,
    "amount": amount,
    "cod_min_amt": codMinAmt,
    "paymentlink_min_order": paymentlinkMinOrder,
    "\n                  bt_min_order": btMinOrder,
  };
}
