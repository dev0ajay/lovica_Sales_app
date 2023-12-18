class ProfileModel {
  String? status;
  int? statusCode;
  String? msg;
  UserData? userData;

  ProfileModel({this.status, this.statusCode, this.msg, this.userData});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? name;
  String? gender;
  String? mobileNumber;
  String? emergencyContactNumber;
  String? iDNumber;
  String? bankIBAN;
  String? cityNameEn;
  String? cityId;
  String? cityNameAr;
  String? address;
  String? countryId;
  String? countryNameEn;
  String? countryNameAr;

  UserData(
      {this.name,
      this.gender,
      this.mobileNumber,
      this.emergencyContactNumber,
      this.iDNumber,
      this.bankIBAN,
      this.cityNameEn,
      this.countryId,
      this.countryNameEn,
      this.countryNameAr,
      this.cityId,
      this.cityNameAr,
      this.address});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    gender = json['Gender'];
    mobileNumber = json['Mobile_Number'];
    emergencyContactNumber = json['Emergency_Contact_Number'];
    iDNumber = json['ID_Number'];
    bankIBAN = json['Bank_IBAN'];
    cityNameEn = json['City'];
    cityNameAr = json['City_ar'];
    address = json['Address'];
    countryId = json['CountryID'];
    countryNameEn = json['Countryname_en'];
    countryNameAr = json['Countryname_ar'];
    cityId = json['City_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Gender'] = gender;
    data['Mobile_Number'] = mobileNumber;
    data['Emergency_Contact_Number'] = emergencyContactNumber;
    data['ID_Number'] = iDNumber;
    data['Bank_IBAN'] = bankIBAN;
    data['City'] = cityNameEn;
    data['Address'] = address;
    data['CountryID'] = countryId;
    data['Countryname_en'] = countryNameEn;
    data['Countryname_ar'] = countryNameAr;
    data['City_id'] = cityId;
    data['City_ar'] = cityNameAr;
    return data;
  }
}

