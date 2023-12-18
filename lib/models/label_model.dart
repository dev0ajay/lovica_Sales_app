class LabelModel {
  String? status;
  int? statusCode;
  String? msg;
  List<Label>? label;

  LabelModel({this.status, this.statusCode, this.msg, this.label});

  LabelModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      label = <Label>[];
      json['data'].forEach((v) {
        label!.add(Label.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (label != null) {
      data['data'] = label!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Label {
  String? idMobileResources;
  String? moduleName;
  String? section;
  String? engLabel;
  String? arLabel;
  String? title;

  Label(
      {this.idMobileResources,
      this.moduleName,
      this.section,
      this.engLabel,
      this.arLabel});

  Label.fromJson(Map<String, dynamic> json) {
    idMobileResources = json['id_mobile_resources'];
    moduleName = json['module_name'];
    section = json['section'];
    engLabel = json['eng_label'];
    arLabel = json['ar_label'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_mobile_resources'] = idMobileResources;
    data['module_name'] = moduleName;
    data['section'] = section;
    data['eng_label'] = engLabel;
    data['ar_label'] = arLabel;
    data['title'] = title;
    return data;
  }
}
