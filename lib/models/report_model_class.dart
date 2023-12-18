class ReportModelClass {
  String? status;
  int? statusCode;
  String? msg;
  ReportData? data;

  ReportModelClass({this.status, this.statusCode, this.msg, this.data});

  ReportModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    data = json['data'] != null ? ReportData.fromJson(json['data']) : null;
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

class ReportData {
  TotalCustomers? totalCustomers;
  TotalCustomers? totalOrders;
  TotalCustomers? activeOrders;
  TotalCustomers? completedOrders;
  TotalCustomers? daysWorked;
  TotalCustomers? earnings;

  ReportData(
      {this.totalCustomers,
      this.totalOrders,
      this.activeOrders,
      this.completedOrders,
      this.earnings,
      this.daysWorked});

  ReportData.fromJson(Map<String, dynamic> json) {
    totalCustomers = json['Total_Customers'] != null
        ? TotalCustomers.fromJson(json['Total_Customers'])
        : null;
    totalOrders = json['Total_Orders'] != null
        ? TotalCustomers.fromJson(json['Total_Orders'])
        : null;
    activeOrders = json['Active_Orders'] != null
        ? TotalCustomers.fromJson(json['Active_Orders'])
        : null;
    completedOrders = json['Completed_Orders'] != null
        ? TotalCustomers.fromJson(json['Completed_Orders'])
        : null;
    daysWorked = json['Days_Worked'] != null
        ? TotalCustomers.fromJson(json['Days_Worked'])
        : null;
    earnings = json['Earnings'] != null
        ? TotalCustomers.fromJson(json['Earnings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totalCustomers != null) {
      data['Total_Customers'] = totalCustomers!.toJson();
    }
    if (totalOrders != null) {
      data['Total_Orders'] = totalOrders!.toJson();
    }
    if (activeOrders != null) {
      data['Active_Orders'] = activeOrders!.toJson();
    }
    if (completedOrders != null) {
      data['Completed_Orders'] = completedOrders!.toJson();
    }
    if (daysWorked != null) {
      data['Days_Worked'] = daysWorked!.toJson();
    }    if (earnings != null) {
      data['Earnings'] = earnings!.toJson();
    }
    return data;
  }
}

class TotalCustomers {
  String? labelEn;
  String? labelAr;
  int? count;
  String? img;

  TotalCustomers({this.labelEn, this.labelAr, this.count, this.img});

  TotalCustomers.fromJson(Map<String, dynamic> json) {
    labelEn = json['label_en'];
    labelAr = json['label_ar'];
    count = json['count'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label_en'] = labelEn;
    data['label_ar'] = labelAr;
    data['count'] = count;
    data['img'] = img;
    return data;
  }
}
