class OrderSuccessModel {
  String? status;
  int? statusCode;
  String? msg;
  OrderData? data;

  OrderSuccessModel({this.status, this.statusCode, this.msg, this.data});

  OrderSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderData {
  String? orderRefNo;
  String? paymentMethod;
  String? shippingMethod;
  int? itemsCount;
  int? grandTotal;

  OrderData(
      {this.orderRefNo,
        this.paymentMethod,
        this.shippingMethod,
        this.itemsCount,
        this.grandTotal});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderRefNo = json['order_ref_no'];
    paymentMethod = json['payment_method'];
    shippingMethod = json['shipping_method'];
    itemsCount = json['items_count'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_ref_no'] = orderRefNo;
    data['payment_method'] = paymentMethod;
    data['shipping_method'] = shippingMethod;
    data['items_count'] = itemsCount;
    data['grand_total'] = grandTotal;
    return data;
  }
}
