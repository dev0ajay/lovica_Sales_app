class CustomerModelClass {
  String? status;
  int? statusCode;
  String? msg;
  CustomerData? data;

  CustomerModelClass({this.status, this.statusCode, this.msg, this.data});

  CustomerModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    data = json['data'] != null ? CustomerData.fromJson(json['data']) : null;
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

class CustomerData {
  String? customerId;
  String? customerName;
  String? salesmanId;
  String? customerMobile;
  String? customerCitynameEn;
  String? customerCitynameAr;
  String? customerCountryId;
  String? customerCountryCode;
  String? customerCityid;
  String? customerAddress;
  String? customerCountrynameEn;
  String? customerCountrynameAr;

  CustomerData(
      {this.customerId,
      this.customerName,
      this.salesmanId,
      this.customerMobile,
      this.customerCitynameEn,
      this.customerCountrynameEn,
      this.customerCitynameAr,
      this.customerCountrynameAr,
      this.customerCountryId,
      this.customerCountryCode,
      this.customerCityid,
      this.customerAddress});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    salesmanId = json['salesman_id'];
    customerMobile = json['customer_mobile'];
    customerCitynameEn = json['customer_cityname_en'];
    customerCitynameAr = json['customer_cityname_ar'];
    customerCountrynameEn = json['customer_countryname_en'];
    customerCountrynameAr = json['customer_countryname_ar'];
    customerCountryId = json['customer_country_id'];
    customerCityid = json['customer_cityid'];
    customerAddress = json['customer_address'];
    if (json.containsKey("customer_country_code")) {
      customerCountryCode= json['customer_country_code'];
    }else {
      customerCountryCode="";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['salesman_id'] = salesmanId;
    data['customer_mobile'] = customerMobile;
    data['customer_cityname_en'] = customerCitynameEn;
    data['customer_cityname_ar'] = customerCitynameAr;
    data['customer_country_id'] = customerCountryId;
    data['countryname_en'] = customerCountrynameEn;
    data['countryname_ar'] = customerCountrynameAr;
    data['customer_cityid'] = customerCityid;
    data['customer_address'] = customerAddress;
    return data;
  }
}
