import 'package:lovica_sales_app/common/helpers.dart';

class CheckOutModel {
  String? status;
  int? statusCode;
  String? msg;
  CheckOutData? checkOutData;

  CheckOutModel({this.status, this.statusCode, this.msg, this.checkOutData});

  CheckOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    checkOutData =
        json['data'] != null ? CheckOutData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (checkOutData != null) {
      data['data'] = checkOutData!.toJson();
    }
    return data;
  }
}

class CheckOutData {
  List<CartData>? cartData;
  TaxData? taxData;
  List<ShippingMethods>? shippingMethods;
  List<PaymentMethods>? paymentMethods;
  List<String>? billType;
  CustomerData? customerData;

  CheckOutData(
      {this.cartData,
      this.taxData,
      this.shippingMethods,
      this.paymentMethods,
      this.billType,
      this.customerData});

  CheckOutData.fromJson(Map<String, dynamic> json) {
    if (json['cart_data'] != null) {
      cartData = <CartData>[];
      json['cart_data'].forEach((v) {
        cartData!.add(CartData.fromJson(v));
      });
    }
    taxData =
        json['taxdata'] != null ? TaxData.fromJson(json['taxdata']) : null;
    if (json['shipping_methods'] != null) {
      shippingMethods = <ShippingMethods>[];
      json['shipping_methods'].forEach((v) {
        shippingMethods!.add(ShippingMethods.fromJson(v));
      });
    }
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
    billType = json['bill_type'].cast<String>();
    customerData = json['customer_data'] != null
        ? CustomerData.fromJson(json['customer_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartData != null) {
      data['cart_data'] = cartData!.map((v) => v.toJson()).toList();
    }
    if (taxData != null) {
      data['taxdata'] = taxData!.toJson();
    }
    if (shippingMethods != null) {
      data['shipping_methods'] =
          shippingMethods!.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['bill_type'] = billType;
    if (customerData != null) {
      data['customer_data'] = customerData!.toJson();
    }
    return data;
  }
}

class CartData {
  String? cartId;
  String? productId;
  String? combinationId;
  String? image;
  String? cartQuantity;
  double? unitPrice;
  double? unitSplPrice;
  String? productName;
  String? productNameArabic;
  String? productWeight;

  CartData(
      {this.cartId,
      this.productId,
      this.combinationId,
      this.image,
      this.cartQuantity,
      this.unitPrice,
      this.unitSplPrice,
      this.productName,
      this.productNameArabic,
      this.productWeight});

  CartData.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    combinationId = json['combination_id'];
    image = json['image'];
    cartQuantity = json['cart_quantity'];
    unitPrice = Helpers.convertToDouble(json['unit_price'] ?? 0.0);
    unitSplPrice = Helpers.convertToDouble(json['unit_spl_price'] ?? 0.0);
    productName = json['product_name'];
    productNameArabic = json['product_name_arabic'];
    productWeight = json['product_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['combination_id'] = combinationId;
    data['image'] = image;
    data['cart_quantity'] = cartQuantity;
    data['unit_price'] = unitPrice;
    data['unit_spl_price'] = unitSplPrice;
    data['product_name'] = productName;
    data['product_name_arabic'] = productNameArabic;
    data['product_weight'] = productWeight;
    return data;
  }
}

class TaxData {
  double? tax;

  TaxData({this.tax});

  TaxData.fromJson(Map<String, dynamic> json) {
    tax = Helpers.convertToDouble(json['tax'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tax'] = tax;
    return data;
  }
}

class ShippingMethods {
  String? shippingId;
  String? shippingTitle;
  String? shippingTitleArabic;
  double? charge;

  ShippingMethods(
      {this.shippingId,
      this.shippingTitle,
      this.shippingTitleArabic,
      this.charge});

  ShippingMethods.fromJson(Map<String, dynamic> json) {
    shippingId = json['shipping_id'];
    shippingTitle = json['shipping_title'];
    shippingTitleArabic = json['shipping_title_arabic'];
    charge = Helpers.convertToDouble(json['charge'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipping_id'] = shippingId;
    data['shipping_title'] = shippingTitle;
    data['shipping_title_arabic'] = shippingTitleArabic;
    data['charge'] = charge;
    return data;
  }
}

class PaymentMethods {
  String? paymentId;
  String? paymentTitle;
  String? paymentTitleArabic;
  String? minimumOrder;

  PaymentMethods(
      {this.paymentId,
      this.paymentTitle,
      this.paymentTitleArabic,
      this.minimumOrder});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    paymentTitle = json['payment_title'];
    paymentTitleArabic = json['payment_title_arabic'];
    minimumOrder = json['minimum_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['payment_title'] = paymentTitle;
    data['payment_title_arabic'] = paymentTitleArabic;
    data['minimum_order'] = minimumOrder;
    return data;
  }
}

class CustomerData {
  String? customerId;
  String? customerName;
  String? customerMobile;
  String? customerAddr;
  String? cityName;
  String? cityNameArabic;

  CustomerData(
      {this.customerId,
      this.customerName,
      this.customerMobile,
      this.customerAddr,
      this.cityName,
      this.cityNameArabic});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    customerAddr = json['customer_addr'];
    cityName = json['city_name'];
    cityNameArabic = json['city_name_arabic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_mobile'] = customerMobile;
    data['customer_addr'] = customerAddr;
    data['city_name'] = cityName;
    data['city_name_arabic'] = cityNameArabic;
    return data;
  }
}
