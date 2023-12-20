import 'package:lovica_sales_app/common/helpers.dart';

class OrderListModel {
  String? status;
  int? statusCode;
  int? totalPdtCount;
  String? msg;
  List<OrderItem>? orderList;



  OrderListModel(
      {this.status,
      this.totalPdtCount,
      this.statusCode,
      this.msg,
      this.orderList,
      });

  OrderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    totalPdtCount = Helpers.convertToInt(json['totalcount'] ?? "0");
    if (json['data'] != null) {
      orderList = <OrderItem>[];
      json['data'].forEach((v) {
        orderList!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    data['totalcount'] = totalPdtCount;
    if (orderList != null) {
      data['data'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  String? orderNumber;
  String? status;
  String? statusAr;
  String? subTotal;
  String? discountAmount;
  String? totalSplPrice;
  String? taxAmount;
  String? shippingAmount;
  String? grandTotal;
  String? itemsCount;
  String? paymentMethod;
  String? paymentStatus;
  String? paymentRefno;
  String? shippingMethod;
  String? shippingStatus;
  String? shippingStatusAr;
  String? orderDate;
  String? customerName;
  String? city;
  String? arcity;


  OrderItem({
    this.orderNumber,
    this.status,
    this.statusAr,
    this.subTotal,
    this.discountAmount,
    this.totalSplPrice,
    this.taxAmount,
    this.shippingAmount,
    this.grandTotal,
    this.itemsCount,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentRefno,
    this.shippingMethod,
    this.shippingStatus,
    this.shippingStatusAr,
    this.orderDate,
    this.city,
    this.arcity,
    this.customerName,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    arcity = json['ent_city_ar'];
    city = json['ent_city'];
    status = json['status'];
    if (status != null) {
      if (status!.toLowerCase().replaceAll(' ', '') == "delivered") {
        statusAr = "تم التوصيل";
      } else if (status!.toLowerCase().replaceAll(' ', '') == "intransit") {
        statusAr = "قيد النقل";
      } else if (status!.toLowerCase().replaceAll(' ', '') ==
          "outfordelivery") {
        statusAr = "تحت التوصيل";
      } else if (status!.toLowerCase().replaceAll(' ', '') ==
          "holdatlocation") {
        statusAr = "في الانتظار في الموقع";
      } else if (status!.toLowerCase().replaceAll(' ', '') == "orderplaced") {
        statusAr = "تم تقديم الطلب";
      } else if (status!.toLowerCase().replaceAll(' ', '') ==
          "orderacceptedbywarehouse") {
        statusAr = "تم قبول الطلب من قبل المستودع";
      }
    }
    subTotal = json['sub_total'];

    discountAmount = json['discount_amount'];
    totalSplPrice = json['total_spl_price'];
    taxAmount = json['tax_amount'];
    shippingAmount = json['shipping_amount'];
    grandTotal = json['grand_total'];
    itemsCount = json['items_count'] ?? 0;
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    paymentRefno = json['payment_refno'];
    shippingMethod = json['shipping_method'];
    shippingStatus = json['shipping_status'];
    if (shippingStatus != null) {
      if (shippingStatus!.toLowerCase().replaceAll(' ', '') == "delivered") {
        shippingStatusAr = "تم التوصيل";
      } else if (shippingStatus!.toLowerCase().replaceAll(' ', '') ==
          "intransit") {
        shippingStatusAr = "قيد النقل";
      } else if (shippingStatus!.toLowerCase().replaceAll(' ', '') ==
          "outfordelivery") {
        shippingStatusAr = "تحت التوصيل";
      } else if (shippingStatus!.toLowerCase().replaceAll(' ', '') ==
          "holdatlocation") {
        shippingStatusAr = "في الانتظار في الموقع";
      } else if (shippingStatus!.toLowerCase().replaceAll(' ', '') ==
          "orderplaced") {
        shippingStatusAr = "تم تقديم الطلب";
      } else if (shippingStatus!.toLowerCase().replaceAll(' ', '') ==
          "orderacceptedbywarehouse") {
        shippingStatusAr = "تم قبول الطلب من قبل المستودع";
      }
    } else  {
      if(shippingStatus == null) {
        shippingStatus = "Pending";
        shippingStatusAr = "قيد الانتظار";
      }
    }
    orderDate = json['order_date'];
    customerName = json['customer_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_number'] = orderNumber;
    data['status'] = status;
    data['sub_total'] = subTotal;
    data['discount_amount'] = discountAmount;
    data['total_spl_price'] = totalSplPrice;
    data['tax_amount'] = taxAmount;
    data['shipping_amount'] = shippingAmount;
    data['grand_total'] = grandTotal;
    data['items_count'] = itemsCount;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['payment_refno'] = paymentRefno;
    data['shipping_method'] = shippingMethod;
    data['shipping_status'] = shippingStatus;
    data['order_date'] = orderDate;
    data['customer_name'] = customerName;
    data['ent_city'] = city;
    data['ent_city_ar'] = arcity;
    return data;
  }
}

class OrderDetails {
  String? status;
  int? statusCode;
  String? msg;
  OrderDetailData? orderDetailData;

  OrderDetails({this.status, this.statusCode, this.msg, this.orderDetailData});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    orderDetailData =
        json['data'] != null ? OrderDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (orderDetailData != null) {
      data['data'] = orderDetailData!.toJson();
    }
    return data;
  }
}

class OrderDetailData {
  SalesOrder? salesOrder;
  CustomerDetails? customerData;
  List<SalesData>? salesData;
  SalesmanData? salesmanData;
  MandoobData? mandoobData;
  String? invoiceUrl;
  int? salesDataCount;

  OrderDetailData(
      {this.salesOrder,
      this.customerData,
      this.salesData,
      this.salesmanData,
      this.mandoobData,
      this.invoiceUrl,
        this.salesDataCount,
      });

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    salesOrder = json['sales_order'] != null
        ? SalesOrder.fromJson(json['sales_order'])
        : null;
    customerData = json['customer_data'] != null
        ? CustomerDetails.fromJson(json['customer_data'])
        : null;
    if (json['sales_data'] != null) {
      salesData = <SalesData>[];
      json['sales_data'].forEach((v) {
        salesData!.add(SalesData.fromJson(v));
      });
    }
    salesmanData = json['salesman_data'] != null
        ? SalesmanData.fromJson(json['salesman_data'])
        : null;
    mandoobData = json['mandoob_data'] != null
        ? MandoobData.fromJson(json['mandoob_data'])
        : null;
    invoiceUrl = json['invoice_url'];
    salesDataCount = json['sales_datacount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesOrder != null) {
      data['sales_order'] = salesOrder!.toJson();
    }
    if (customerData != null) {
      data['customer_data'] = customerData!.toJson();
    }
    if (salesData != null) {
      data['sales_data'] = salesData!.map((v) => v.toJson()).toList();
    }
    if (salesmanData != null) {
      data['salesman_data'] = salesmanData!.toJson();
    }
    if (mandoobData != null) {
      data['mandoob_data'] = mandoobData!.toJson();
    }
    data['invoice_url'] = invoiceUrl;
    data['sales_datacount'] = salesDataCount;
    return data;
  }
}

class SalesOrder {
  String? idSalesOrder;
  String? orderIncrementId;
  String? warehouseId;
  String? mandoobId;
  String? invNumber;
  String? status;
  String? customerId;
  String? salesmanId;
  String? subTotal;
  String? discountAmount;
  String? totalSplPrice;
  String? taxAmount;
  String? shippingAmount;
  String? grandTotal;
  String? isTaxbill;
  String? noOfPiece;
  String? paymentMethod;
  String? paymentMethodId;
  String? paymentStatus;
  String? paymentRefno;
  String? paymentAdminAccept;
  String? shippingMethod;
  String? shippingMethodId;
  String? shippingRefSmsa;
  String? shippingStatus;
  String? noteForWarehouse;
  String? orderDate;
  String? orderDatetime;
  String? createdAt;

  SalesOrder(
      {this.idSalesOrder,
      this.orderIncrementId,
      this.warehouseId,
      this.mandoobId,
      this.invNumber,
      this.status,
      this.customerId,
      this.salesmanId,
      this.subTotal,
      this.discountAmount,
      this.totalSplPrice,
      this.taxAmount,
      this.shippingAmount,
      this.grandTotal,
      this.isTaxbill,
      this.noOfPiece,
      this.paymentMethod,
      this.paymentMethodId,
      this.paymentStatus,
      this.paymentRefno,
      this.paymentAdminAccept,
      this.shippingMethod,
      this.shippingMethodId,
      this.shippingRefSmsa,
      this.shippingStatus,
      this.noteForWarehouse,
      this.orderDate,
      this.orderDatetime,
      this.createdAt});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    idSalesOrder = json['id_sales_order'] ?? "";
    orderIncrementId = json['order_increment_id'] ?? "";
    warehouseId = json['warehouse_id'] ?? "";
    mandoobId = json['mandoob_id'] ?? "";
    invNumber = json['inv_number'] ?? "";
    status = json['status'] ?? "";
    customerId = json['customer_id'];
    salesmanId = json['salesman_id'];
    subTotal = json['sub_total'] ?? "";
    discountAmount = json['discount_amount'] ?? "";
    totalSplPrice = json['total_spl_price'] ?? "";
    taxAmount = json['tax_amount'] ?? "";
    shippingAmount = json['shipping_amount'] ?? "";
    grandTotal = json['grand_total'] ?? "";
    isTaxbill = json['is_taxbill'] ?? "";
    noOfPiece = json['no_of_piece'] ?? "";
    paymentMethod = json['payment_method'] ?? "";
    paymentMethodId = json['payment_method_id'];
    paymentStatus = json['payment_status'] ?? "";
    paymentRefno = json['payment_refno'] ?? "";
    paymentAdminAccept = json['payment_admin_accept'] ?? "";
    shippingMethod = json['shipping_method'] ?? "";
    shippingMethodId = json['shipping_method_id'] ?? "";
    shippingRefSmsa = json['shipping_ref_smsa'] ?? "";
    shippingStatus = json['shipping_status'] ?? "";
    noteForWarehouse = json['note_for_warehouse'] ?? "";
    orderDate = json['order_date'] ?? "";
    orderDatetime = json['order_datetime'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_sales_order'] = idSalesOrder;
    data['order_increment_id'] = orderIncrementId;
    data['warehouse_id'] = warehouseId;
    data['mandoob_id'] = mandoobId;
    data['inv_number'] = invNumber;
    data['status'] = status;
    data['customer_id'] = customerId;
    data['salesman_id'] = salesmanId;
    data['sub_total'] = subTotal;
    data['discount_amount'] = discountAmount;
    data['total_spl_price'] = totalSplPrice;
    data['tax_amount'] = taxAmount;
    data['shipping_amount'] = shippingAmount;
    data['grand_total'] = grandTotal;
    data['is_taxbill'] = isTaxbill;
    data['no_of_piece'] = noOfPiece;
    data['payment_method'] = paymentMethod;
    data['payment_method_id'] = paymentMethodId;
    data['payment_status'] = paymentStatus;
    data['payment_refno'] = paymentRefno;
    data['payment_admin_accept'] = paymentAdminAccept;
    data['shipping_method'] = shippingMethod;
    data['shipping_method_id'] = shippingMethodId;
    data['shipping_ref_smsa'] = shippingRefSmsa;
    data['shipping_status'] = shippingStatus;
    data['note_for_warehouse'] = noteForWarehouse;
    data['order_date'] = orderDate;
    data['order_datetime'] = orderDatetime;
    data['created_at'] = createdAt;
    return data;
  }
}

class CustomerDetails {
  String? idEntUser;
  String? entUserName;
  String? salesManId;
  String? entMobile;
  String? entCity;
  String? entAddress;
  String? createdBy;
  String? timeStamp;
  String? cityName_eN;
  String? cityName_aR;

  CustomerDetails(
      {this.idEntUser,
      this.entUserName,
      this.salesManId,
      this.entMobile,
      this.entCity,
      this.entAddress,
      this.createdBy,
      this.timeStamp,
      this.cityName_eN,
      this.cityName_aR});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    idEntUser = json['id_ent_user'] ?? "";
    entUserName = json['ent_user_name'] ?? "";
    salesManId = json['sales_man_id'] ?? "";
    entMobile = json['ent_mobile'] ?? "";
    entCity = json['ent_city'] ?? "";
    entAddress = json['ent_Address'] ?? "";
    createdBy = json['created_by'] ?? "";
    timeStamp = json['time_stamp'] ?? "";
    cityName_eN = json['cityname_en'] ?? "";
    cityName_aR = json['cityname_ar'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_ent_user'] = idEntUser;
    data['ent_user_name'] = entUserName;
    data['sales_man_id'] = salesManId;
    data['ent_mobile'] = entMobile;
    data['ent_city'] = entCity;
    data['ent_Address'] = entAddress;
    data['created_by'] = createdBy;
    data['time_stamp'] = timeStamp;
    data['cityname_en'] = cityName_eN;
    data['cityname_ar'] = cityName_aR;
    return data;
  }
}

class SalesData {
  String? idSalesOrderDetails;
  String? idSalesOrder;
  String? orderIncrementId;
  String? productId;
  String? combinationId;
  String? prdImage;
  String? salesQty;
  String? unitPrice;
  String? unitSplPrice;
  String? productName;
  String? productNameArabic;
  String? totalUnitPrice;
  String? totalSplPrice;
  String? totalDiscount;
  String? type;
  String? optionLabelEn;
  String? optionLabelAr;
  String? optionColorCode;
  // List<Combination>? combination;

  SalesData({
    this.idSalesOrderDetails,
    this.idSalesOrder,
    this.orderIncrementId,
    this.productId,
    this.combinationId,
    this.prdImage,
    this.salesQty,
    this.unitPrice,
    this.unitSplPrice,
    this.productName,
    this.productNameArabic,
    this.totalUnitPrice,
    this.totalSplPrice,
    this.totalDiscount,
    this.type,
    this.optionLabelEn,
    this.optionLabelAr,
    this.optionColorCode,
    // this.combination,
  });

  SalesData.fromJson(Map<String, dynamic> json) {
    idSalesOrderDetails = json['id_sales_order_details'] ?? "";
    idSalesOrder = json['id_sales_order'] ?? "";
    orderIncrementId = json['order_increment_id'] ?? "";
    productId = json['product_id'] ?? "";
    combinationId = json['combination_id'] ?? "";
    prdImage = json['prd_image'] ?? "";
    salesQty = json['sales_qty'].toString();
    unitPrice = json['unit_price'] ?? "";
    unitSplPrice = json['unit_spl_price'] ?? "";
    productName = json['product_name'] ?? "";
    productNameArabic = json['product_name_arabic'] ?? "";
    totalUnitPrice = json['total_unit_price'] ?? "";
    totalSplPrice = json['total_spl_price'] ?? "";
    totalDiscount = json['total_discount'] ?? "";
    type = json['type'] ?? "";
    optionLabelEn = json['option_label_eng'] ?? "";
    optionLabelAr = json['option_label_ar'] ?? "";
    optionColorCode = json['option_colorcode'] ?? "";
    // if (json['combinations'] != null) {
    //   combination = <Combination>[];
    //   json['combinations'].forEach((v) {
    //     combination!.add(Combination.fromJson(v));
    //   });
    // }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_sales_order_details'] = idSalesOrderDetails;
    data['id_sales_order'] = idSalesOrder;
    data['order_increment_id'] = orderIncrementId;
    data['product_id'] = productId;
    data['combination_id'] = combinationId;
    data['prd_image'] = prdImage;
    data['sales_qty'] = salesQty;
    data['unit_price'] = unitPrice;
    data['unit_spl_price'] = unitSplPrice;
    data['product_name'] = productName;
    data['product_name_arabic'] = productNameArabic;
    data['total_unit_price'] = totalUnitPrice;
    data['total_spl_price'] = totalSplPrice;
    data['total_discount'] = totalDiscount;
    data['type'] = type;
    data['option_label_eng'] = optionLabelEn;
    data['option_label_ar'] = optionLabelAr;
    data['option_colorcode'] = optionColorCode;

    // if (combination != null) {
    //   data['combinations'] = combination!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

// class Combination {
//   final String attributeOptionsId;
//   final String productNameEn;
//   final String productNameAr;
//   final String atrId;
//   final String optionLabelEng;
//   final String optionLabelAr;
//   final String optionColorcode;
//   final String atrName;
//
//   Combination(
//       {required this.attributeOptionsId,
//       required this.atrId,
//       required this.optionLabelEng,
//       required this.optionLabelAr,
//       required this.optionColorcode,
//       required this.atrName,
//       required this.productNameEn,
//       required this.productNameAr});
//
//   factory Combination.fromJson(Map<String, dynamic> json) => Combination(
//         attributeOptionsId: json["attribute_options_id"],
//         atrId: json["atr_id"],
//         optionLabelEng: json["option_label_eng"],
//         optionLabelAr: json["option_label_ar"],
//         optionColorcode: json["option_colorcode"],
//         atrName: json["atr_name"],
//         productNameEn: json["productname_en"],
//         productNameAr: json["productname_ar"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "attribute_options_id": attributeOptionsId,
//         "atr_id": atrId,
//         "option_label_eng": optionLabelEng,
//         "option_label_ar": optionLabelAr,
//         "option_colorcode": optionColorcode,
//         "atr_name": atrName,
//         "productname_en": productNameEn,
//         "productname_ar": productNameAr,
//       };
// }

class SalesmanData {
  String? userId;
  String? userForgetPassword;
  String? usersIdno;
  String? userFullname;
  String? userBank;
  String? username;
  String? password;
  String? userGender;
  String? userCity;
  String? userEmergencyContactno;
  String? userEmail;
  String? userMobile;
  String? userAddress;
  String? userType;
  String? userStatus;
  String? forgetOtp;
  String? createdDate;
  String? fcmToken;
  String? deviceType;

  SalesmanData(
      {this.userId,
      this.userForgetPassword,
      this.usersIdno,
      this.userFullname,
      this.userBank,
      this.username,
      this.password,
      this.userGender,
      this.userCity,
      this.userEmergencyContactno,
      this.userEmail,
      this.userMobile,
      this.userAddress,
      this.userType,
      this.userStatus,
      this.forgetOtp,
      this.createdDate,
      this.fcmToken,
      this.deviceType});

  SalesmanData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? "";
    userForgetPassword = json['user_forget_password'] ?? "";
    usersIdno = json['users_idno'] ?? "";
    userFullname = json['user_fullname'] ?? "";
    userBank = json['user_bank'] ?? "";
    username = json['username'] ?? "";
    password = json['password'] ?? "";
    userGender = json['user_gender'] ?? "";
    userCity = json['user_city'] ?? "";
    userEmergencyContactno = json['user_emergency_contactno'] ?? "";
    userEmail = json['user_email'] ?? "";
    userMobile = json['user_mobile'] ?? "";
    userAddress = json['user_address'] ?? "";
    userType = json['user_type'] ?? "";
    userStatus = json['user_status'] ?? "";
    forgetOtp = json['forget_otp'] ?? "";
    createdDate = json['created_date'] ?? "";
    fcmToken = json['fcm_token'] ?? "";
    deviceType = json['device_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_forget_password'] = userForgetPassword;
    data['users_idno'] = usersIdno;
    data['user_fullname'] = userFullname;
    data['user_bank'] = userBank;
    data['username'] = username;
    data['password'] = password;
    data['user_gender'] = userGender;
    data['user_city'] = userCity;
    data['user_emergency_contactno'] = userEmergencyContactno;
    data['user_email'] = userEmail;
    data['user_mobile'] = userMobile;
    data['user_address'] = userAddress;
    data['user_type'] = userType;
    data['user_status'] = userStatus;
    data['forget_otp'] = forgetOtp;
    data['created_date'] = createdDate;
    data['fcm_token'] = fcmToken;
    data['device_type'] = deviceType;
    return data;
  }
}

class MandoobData {
  String? userId;
  String? userForgetPassword;
  String? usersIdno;
  String? userFullname;
  String? userBank;
  String? username;
  String? password;
  String? userGender;
  String? userCity;
  String? userEmergencyContactno;
  String? userEmail;
  String? userMobile;
  String? userAddress;
  String? userType;
  String? userStatus;
  String? forgetOtp;
  String? createdDate;
  String? fcmToken;
  String? deviceType;

  MandoobData(
      {this.userId,
      this.userForgetPassword,
      this.usersIdno,
      this.userFullname,
      this.userBank,
      this.username,
      this.password,
      this.userGender,
      this.userCity,
      this.userEmergencyContactno,
      this.userEmail,
      this.userMobile,
      this.userAddress,
      this.userType,
      this.userStatus,
      this.forgetOtp,
      this.createdDate,
      this.fcmToken,
      this.deviceType});

  MandoobData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? "";
    userForgetPassword = json['user_forget_password'] ?? "";
    usersIdno = json['users_idno'] ?? "";
    userFullname = json['user_fullname'] ?? "";
    userBank = json['user_bank'] ?? "";
    username = json['username'] ?? "";
    password = json['password'] ?? "";
    userGender = json['user_gender'] ?? "";
    userCity = json['user_city'] ?? "";
    userEmergencyContactno = json['user_emergency_contactno'] ?? "";
    userEmail = json['user_email'] ?? "";
    userMobile = json['user_mobile'] ?? "";
    userAddress = json['user_address'] ?? "";
    userType = json['user_type'] ?? "";
    userStatus = json['user_status'] ?? "";
    forgetOtp = json['forget_otp'] ?? "";
    createdDate = json['created_date'] ?? "";
    fcmToken = json['fcm_token'] ?? "";
    deviceType = json['device_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_forget_password'] = userForgetPassword;
    data['users_idno'] = usersIdno;
    data['user_fullname'] = userFullname;
    data['user_bank'] = userBank;
    data['username'] = username;
    data['password'] = password;
    data['user_gender'] = userGender;
    data['user_city'] = userCity;
    data['user_emergency_contactno'] = userEmergencyContactno;
    data['user_email'] = userEmail;
    data['user_mobile'] = userMobile;
    data['user_address'] = userAddress;
    data['user_type'] = userType;
    data['user_status'] = userStatus;
    data['forget_otp'] = forgetOtp;
    data['created_date'] = createdDate;
    data['fcm_token'] = fcmToken;
    data['device_type'] = deviceType;
    return data;
  }
}
