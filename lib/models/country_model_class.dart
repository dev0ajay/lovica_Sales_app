import 'package:lovica_sales_app/common/helpers.dart';

class CountryModelClass {
  String? status;
  int? statusCode;
  String? msg;
  List<Country>? data;

  CountryModelClass({this.status, this.statusCode, this.msg, this.data});

  CountryModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Country>[];
      json['data'].forEach((v) {
        data!.add(Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  String? countryListId;
  String? countryCode;
  String? countrynameEn;
  String? countrynameAr;
  int? maxLength;
  String? placeholder;

  Country(
      {this.countryListId,
      this.countryCode,
      this.countrynameEn,
      this.countrynameAr,
      this.placeholder,
      this.maxLength});

  Country.fromJson(Map<String, dynamic> json) {
    countryListId = json['country_list_id'];
    countryCode = json['country_code'];
    countrynameEn = json['countryname_en'];
    countrynameAr = json['countryname_ar'];
    if (json.containsKey('number_allowed')) {
      maxLength=Helpers.convertToInt(json['number_allowed']);
    }else{
      maxLength=10;
    }   if (json.containsKey('placeholder')) {
      placeholder=json['placeholder']??"+5xx";
    }else{
      placeholder="+5xx";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_list_id'] = countryListId;
    data['country_code'] = countryCode;
    data['countryname_en'] = countrynameEn;
    data['countryname_ar'] = countrynameAr;
    return data;
  }
}
