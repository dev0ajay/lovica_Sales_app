import '../common/helpers.dart';

class CustomerModel {
  String? status;
  int? statusCode;
  String? msg;
  List<Customer>? customerList;
  int? totalPdtCount;

  CustomerModel({this.status, this.totalPdtCount, this.statusCode, this.msg, this.customerList});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    totalPdtCount = Helpers.convertToInt(json['totalcount'] ?? "0");
    if (json['data'] != null) {
      customerList = <Customer>[];
      json['data'].forEach((v) {
        customerList!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    data['totalcount'] = totalPdtCount;
    if (this.customerList != null) {
      data['data'] = this.customerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? customerId;
  String? customerName;
  String? cityName;
  String? cityNameArabic;
  String? customerNumber;
  String? customerAddress;
  String? croppedName;

  Customer(
      {this.customerId,
        this.customerName,
        this.cityName,
        this.cityNameArabic,
        this.customerNumber,
        this.croppedName,
        this.customerAddress});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    cityName = json['city_name'];
    cityNameArabic = json['city_name_arabic'];
    customerNumber = json['customer_number'];
    customerAddress = json['customer_address'];
    croppedName = json['croppedname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['city_name'] = cityName;
    data['city_name_arabic'] = cityNameArabic;
    data['customer_number'] = customerNumber;
    data['customer_address'] = customerAddress;
    data['croppedname'] = croppedName;
    return data;
  }
}
