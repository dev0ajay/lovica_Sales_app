import '../common/helpers.dart';

class CartListModel {
  String? status;
  int? statusCode;
  String? msg;
  List<CartItem>? data;
  int? totalPdtCount;

  CartListModel(
      {this.status, this.totalPdtCount, this.statusCode, this.msg, this.data});

  CartListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    totalPdtCount = Helpers.convertToInt(json['totalcount'] ?? "0");
    if (json['data'] != null) {
      data = <CartItem>[];
      json['data'].forEach((v) {
        data!.add(CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    data['totalcount'] = totalPdtCount;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  String? cartId;
  String? productId;
  String? combinationId;
  String? image;
  int? cartQuantity;
  double? unitPrice;
  double? unitSplPrice;
  double? total;
  String? productName;
  String? productNameArabic;
  String? type;
  String configOptionEn="";
  String configOptionAr="";
  List<Configurations>? configurations;


  CartItem({
    this.cartId,
    this.productId,
    this.combinationId,
    this.image,
    this.cartQuantity,
    this.unitPrice,
    this.unitSplPrice,
    this.total = 0.0,
    this.productName,
    this.productNameArabic,
    this.type,
    this.configurations,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    combinationId = json['combination_id'];
    image = json['image'];
    cartQuantity =
        Helpers.convertToDouble(json['cart_quantity'] ?? "0.0").toInt();
    unitPrice = Helpers.convertToDouble(json['unit_price'] ?? "0.0");
    unitSplPrice = Helpers.convertToDouble(json['unit_spl_price'] ?? "0.0");
    productName = json['product_name'];
    productNameArabic = json['product_name_arabic'];
    total = Helpers.updateTotalByQuantity(
        cartQuantity.toString(), unitSplPrice ?? 0.0, unitPrice ?? 0.0);
    type = json['product_type'] ?? "";

    if (json['configurations'] != null) {
      configurations = <Configurations>[];
      json['configurations'].forEach((v) {
        configurations!.add(Configurations.fromJson(v));
      });
    }

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
    data['product_type'] = type;
    if (configurations != null) {
      data['configurations'] = configurations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Configurations {
  String? productType;
  String? optionLabelEng;
  String? optionLabelAr;
  String? optionColorcode;

  Configurations(
      {this.productType,
      this.optionLabelEng,
      this.optionLabelAr,
      this.optionColorcode});

  Configurations.fromJson(Map<String, dynamic> json) {
    productType = json['product_type'];
    optionLabelEng = json['option_label_eng'];
    optionLabelAr = json['option_label_ar'];
    optionColorcode = json['option_colorcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type'] = productType;
    data['option_label_eng'] = optionLabelEng;
    data['option_label_ar'] = optionLabelAr;
    data['option_colorcode'] = optionColorcode;
    return data;
  }
}

class OptionCodes {
  String? optionEn;
  String? optionAr;

  OptionCodes({required this.optionEn,required this.optionAr});
}
