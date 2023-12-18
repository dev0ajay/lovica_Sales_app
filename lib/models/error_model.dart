class ErrorModel {
  String? error;
  String? message;
  Extensions? extensions;

  ErrorModel({this.error, this.message, this.extensions});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    error = json['status'];
    message = json['message'];
    extensions = json['extensions'] != null
        ? Extensions.fromJson(json['extensions'])
        : null;
  }
}

class Extensions {
  String? category;

  Extensions({this.category});

  Extensions.fromJson(Map<String, dynamic> json) {
    category = json['category'];
  }
}
