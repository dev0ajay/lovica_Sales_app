import 'package:lovica_sales_app/common/helpers.dart';

import '../common/constants.dart';

class ProductModel {
  String? status;
  int? statusCode;
  int? totalPdtCount;
  String? msg;
  List<Product>? productList;

  ProductModel({this.status, this.statusCode, this.msg, this.productList});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalPdtCount = Helpers.convertToInt(json['total_count'] ?? "0");
    statusCode = json['status_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      productList = <Product>[];
      json['data'].forEach((v) {
        productList!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_count'] = totalPdtCount;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (productList != null) {
      data['data'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ProductModel copyWith({List<Product>? item}) {
    List<Product> _items = item!;
    productList!.addAll(item);
    return ProductModel(
      productList: _items,
    );
  }
}

class Product {
  String? productId;
  String? productName;
  String? productNameArabic;
  String? description;
  String? descriptionArabic;
  String? inclCats;
  String? image;
  String? brandNameEnglish;
  String? brandNameArabic;
  double? unitPrice;
  double? unitSplPrice;
  double? pdtDiscount;
  double? total;

  Product(
      {this.productId,
      this.productName,
      this.productNameArabic,
      this.description,
      this.descriptionArabic,
      this.inclCats,
      this.image,
      this.brandNameArabic,
      this.brandNameEnglish,
      this.total,
      this.unitPrice,
      this.pdtDiscount,
      this.unitSplPrice});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productNameArabic = json['product_name_arabic'];
    description = json['description'];
    descriptionArabic = json['description_arabic'];
    inclCats = json['incl_cats'];
    image = json['image'];
    brandNameEnglish = json['brand_name_en'];
    brandNameArabic = json['brand_name_ar'];
    unitPrice = json.containsKey('unit_price')
        ? Helpers.convertToDouble(json['unit_price'] ?? 0.0)
        : 0.0;
    pdtDiscount = json.containsKey('prd_discount')
        ? Helpers.convertToDouble(json['prd_discount'] ?? 0.0)
        : 0.0;
    unitSplPrice = json.containsKey('unit_spl_price')
        ? Helpers.convertToDouble(json['unit_spl_price'] ?? 0.0)
        : 0.0;
    if (unitSplPrice! > 0) {
      total = unitSplPrice;
    } else {
      total = unitPrice;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_name_arabic'] = productNameArabic;
    data['description'] = description;
    data['description_arabic'] = descriptionArabic;
    data['incl_cats'] = inclCats;
    data['image'] = image;
    data['brand_name_en'] = brandNameEnglish;
    data['brand_name_ar'] = brandNameArabic;
    return data;
  }
}

class ProductDetails {
  String? status;
  int? statusCode;
  String? msg;
  List<DetailData>? detailData;

  ProductDetails({this.status, this.statusCode, this.msg, this.detailData});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      detailData = <DetailData>[];
      json['data'].forEach((v) {
        detailData!.add(DetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (detailData != null) {
      data['data'] = detailData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailData {
  String? productId;
  String? productName;
  String? productNameArabic;
  String? description;
  String? descriptionArabic;
  String? inclCats;
  String? image;
  String? productCode;
  String? productWeight;
  double? unitPrice;
  double? unitSplPrice;
  double? pdtDiscount;
  String? prodType;
  List<AttrDisplay>? attrDisplay;
  String? configAttributes;
  List<Attrbs>? attrbs = [];

  DetailData(
      {this.productId,
      this.productName,
      this.productNameArabic,
      this.description,
      this.descriptionArabic,
      this.inclCats,
      this.image,
      this.productCode,
      this.productWeight,
      this.configAttributes,
      this.prodType,
      this.attrbs,
      this.attrDisplay,
      this.unitPrice,
      this.pdtDiscount,
      this.unitSplPrice});

  DetailData.fromJson(Map<String, dynamic> json) {
    try {
      productId = json['product_id'];
      productName = json['product_name'];
      productNameArabic = json['product_name_arabic'];
      description = json['description'];
      descriptionArabic = json['description_arabic'];
      inclCats = json['incl_cats'];
      image = json['image'];
      productCode = json['product_code'];
      productWeight = json['product_weight'];
      configAttributes = json.containsKey('config_attributes')
          ? json['config_attributes'] ?? ""
          : "";
      prodType = json['prod_type'];

      unitPrice = json.containsKey('unit_price')
          ? Helpers.convertToDouble(json['unit_price'] ?? 0.0)
          : 0.0;
      pdtDiscount = json.containsKey('prd_discount')
          ? Helpers.convertToDouble(json['prd_discount'] ?? 0.0)
          : 0.0;
      unitSplPrice = json.containsKey('unit_spl_price')
          ? Helpers.convertToDouble(json['unit_spl_price'] ?? 0.0)
          : 0.0;

      if (json.containsKey('attrbs')) {
        if (json['attrbs'] != null) {
          attrbs = <Attrbs>[];
          json['attrbs'].forEach((v) {
            attrbs!.add(Attrbs.fromJson(v));
          });
        }
      } else {
        attrbs = [];
      }
      if (json.containsKey('attr_display')) {
        if (json['attr_display'] != null) {
          attrDisplay = <AttrDisplay>[];
          json['attr_display'].forEach((v) {
            attrDisplay!.add(AttrDisplay.fromJson(v));
          });
        }
      } else {
        attrDisplay = [];
      }
    } catch (err) {
      print(err);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_name_arabic'] = productNameArabic;
    data['description'] = description;
    data['description_arabic'] = descriptionArabic;
    data['incl_cats'] = inclCats;
    data['image'] = image;
    data['product_code'] = productCode;
    data['product_weight'] = productWeight;
    data['config_attributes'] = configAttributes;
    data['prod_type'] = prodType;
    data['unit_price'] = unitPrice;
    data['unit_spl_price'] = unitSplPrice;
    if (attrDisplay != null) {
      data['attr_display'] = attrDisplay!.map((v) => v.toJson()).toList();
    }
    if (attrbs != null) {
      data['attrbs'] = attrbs!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Attrbs {
  String? attributeId;
  String? label;
  String? labelArabic;
  String? inputType;
  List<Options>? options;

  Attrbs(
      {this.attributeId,
      this.label,
      this.labelArabic,
      this.inputType,
      this.options});

  Attrbs.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    label = json['label'];
    labelArabic = json['label_arabic'];
    inputType = json['input_type'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['label'] = label;
    data['label_arabic'] = labelArabic;
    data['input_type'] = inputType;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? optionValue;
  String? optionValueAr;
  String? colorCode;
  bool? isSelected = false;

  Options({this.optionValue,this.optionValueAr, this.colorCode, this.isSelected});

  Options.fromJson(Map<String, dynamic> json) {
    optionValue = json['option_value'];
    optionValueAr = json['option_value_ar'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['option_value'] = optionValue;
    data['option_value_ar'] = optionValueAr;
    data['color_code'] = colorCode;
    return data;
  }
}

class AttrDisplay {
  String? attributeId;
  String? inputType;
  String? code;
  String? optionId;
  String? label;
  String? value;

  AttrDisplay(
      {this.attributeId,
      this.inputType,
      this.code,
      this.optionId,
      this.label,
      this.value});

  AttrDisplay.fromJson(Map<String, dynamic> json) {
    attributeId =
        json.containsKey('attribute_id') ? json['attribute_id'] ?? "" : "";
    inputType = json.containsKey('input_type') ? json['input_type'] ?? "" : "";
    code = json.containsKey('code') ? json['code'] ?? "" : "";
    optionId = json.containsKey('option_id') ? json['option_id'] ?? "" : "";
    label = json.containsKey('label') ? json['label'] ?? "" : "";
    value = json.containsKey('value') ? json['value'] ?? "" : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['input_type'] = inputType;
    data['code'] = code;
    data['option_id'] = optionId;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
