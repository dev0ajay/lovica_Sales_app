import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/models/category_model.dart';

import '../common/helpers.dart';
import '../services/provider_helper_class.dart';

class CategoryProvider extends ChangeNotifier with ProviderHelperClass {
  CategoryList? categories;
  CategoryList? subCategories;
  CategoryList? subCategoriesForExpansion;

  List<MainCategory>? categoryList = [];
  List<MainCategory>? subCategoryList = [];
  String? selectedCategoryId;
  bool isDetailView = false;
  List<MainCategory>? subCategoryForExpansion = [];
  String? selectedCategoryIdForOutlineButton;

  int? sampleCount = 20;

  Future<void> getcategoryList(
      {required BuildContext context, required String catId}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        if (catId == "0") {
          categoryList = [];
          notifyListeners();
        } else {
          subCategoryList = [];
          notifyListeners();
        }
        dynamic _resp = await serviceConfig.getCategoryList(catId);
        updateLoadState(LoadState.loaded);
        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          if (_resp["data"] != null) {
            if (catId == "0") {
              categories = CategoryList.fromJson(_resp);
              categoryList = categories?.mainCategoryList ?? [];
            } else {
              subCategories = CategoryList.fromJson(_resp);
              subCategoryList!.add(MainCategory(
                  categoryId: "0",
                  categoryName: Constants.allProducts,
                  categoryNameArabic: Constants.allProducts,
                  image: "",
                  isChild: "false",
                  isExpanded: false,
                  subCategory: []));
              subCategoryList!.addAll(subCategories?.mainCategoryList ?? []);
            }
          }
        } else {
          categories=null;
          categoryList=[];
          // Fluttertoast.showToast(msg: _resp["msg"]);
          notifyListeners();
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<void> getSubCategoryListForExpansion(
      {required BuildContext context, required String catId}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        subCategoryForExpansion = [];
        selectedCategoryIdForOutlineButton = "";
        notifyListeners();

        dynamic _resp = await serviceConfig.getCategoryList(catId);
        updateLoadState(LoadState.loaded);
        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          if (_resp["data"] != null) {
            subCategoriesForExpansion = CategoryList.fromJson(_resp);
            subCategoryForExpansion =
                subCategoriesForExpansion?.mainCategoryList ?? [];
          }
        } else {
          // Fluttertoast.showToast(msg: _resp["msg"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  updateSelectedCategory(String? id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  updateIsDetailView(bool val) {
    isDetailView = val;
    notifyListeners();
  }

  clearSubCategory() {
    subCategoryForExpansion = [];
    notifyListeners();
  }

  updateCategoryIdForOutlineButton(String? val) {
    selectedCategoryIdForOutlineButton = val;
    notifyListeners();
  }

  clearSubCat() async {
    subCategoryForExpansion = [];
    notifyListeners();
  }
}
