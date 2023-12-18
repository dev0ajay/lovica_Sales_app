class CategoryList {
  String? status;
  int? statusCode;
  String? msg;
  List<MainCategory>? mainCategoryList;

  CategoryList({this.status, this.statusCode, this.msg, this.mainCategoryList});

  CategoryList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      mainCategoryList = <MainCategory>[];
      json['data'].forEach((v) {
        mainCategoryList!.add(MainCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['msg'] = msg;
    if (this.mainCategoryList != null) {
      data['data'] = this.mainCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainCategory {
  String? categoryId;
  String? categoryName;
  String? categoryNameArabic;
  String? image;
  String? isChild;
  List<SubCategory>? subCategory;
  bool? isExpanded;

  MainCategory(
      {this.categoryId,
      this.categoryName,
      this.categoryNameArabic,
      this.image,
      this.isChild,
      this.isExpanded=false,
      this.subCategory});

  MainCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryNameArabic = json['category_name_arabic'];
    image = json['image'];
    isChild = json['is_child'];
    isExpanded=false;
    if (json['child_data'] != null) {
      subCategory = <SubCategory>[];
      json['child_data'].forEach((v) {
        subCategory!.add(SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_name_arabic'] = categoryNameArabic;
    data['image'] = image;
    data['is_child'] = isChild;
    if (subCategory != null) {
      data['child_data'] = subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  String? subCategoryId;
  String? subCategoryName;
  String? subCategoryNameArabic;
  String? image;

  SubCategory(
      {this.subCategoryId,
      this.subCategoryName,
      this.subCategoryNameArabic,
      this.image});

  SubCategory.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['category_id'];
    subCategoryName = json['category_name'];
    subCategoryNameArabic = json['category_name_arabic'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = subCategoryId;
    data['category_name'] = subCategoryName;
    data['category_name_arabic'] = subCategoryNameArabic;
    data['image'] = image;
    return data;
  }
}
