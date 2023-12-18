import 'package:intl/intl.dart';
import 'package:lovica_sales_app/common/helpers.dart';
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class NotificationList {
  String? status;
  int? statusCode;
  String? msg;
  List<NotificationItem>? data;
  int? totalCount;

  NotificationList({this.totalCount,this.status, this.statusCode, this.msg, this.data});

  NotificationList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    totalCount= Helpers.convertToInt(json['total_count']??"0");
    if (json['data'] != null) {
      data = <NotificationItem>[];
      json['data'].forEach((v) {
        data!.add(NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    data['total_count'] = totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationItem {
  String? id;
  String? type;
  String? title;
  String? message;
  String? date;
  String? dateFormatted;
  int? messageRead;
  String? timeformatted;
  String? messageAr;
  String? titleAr;

  NotificationItem({this.id,this.messageRead, this.type, this.title, this.titleAr,this.message, this.messageAr,this.date, this.dateFormatted, this.timeformatted});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    titleAr = json['title_ar'];
    message = json['message'];
    messageAr = json['message_ar'];
    messageRead = Helpers.convertToInt(json['messageRead']);
    date= json['date']??"";
    dateFormatted= DateFormat.MMMd().format(DateTime.parse(json['date']??""));
    timeformatted= DateFormat('hh:mm a').format(DateTime.parse(json['date']??""));

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['title_ar'] = titleAr;
    data['message'] = message;
    data['message_ar'] = messageAr;
    data['date'] = date;
    data['messageRead'] = messageRead;
    return data;
  }
}
