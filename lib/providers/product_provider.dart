import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/models/category_model.dart';
import 'package:lovica_sales_app/models/product_model.dart';
import 'package:lovica_sales_app/services/shared_preference_helper.dart';

import '../common/helpers.dart';
import '../services/provider_helper_class.dart';
import '../widgets/reusable_widgets.dart';

class ProductProvider extends ChangeNotifier with ProviderHelperClass {
  ProductModel? productModel;
  ProductModel? productModelForOutlineButtonCategory;
  ProductModel? productModelForSubCategory;
  List<Product>? productList = [];
  List<Product>? productListForOutlineButtonCategory = [];
  List<Product>? productListForSubCategory = [];
  MainCategory? selectedCatForOutlineButtonCategory;

  List<Product>? tempList = [];
  bool firstLoad = true;
  bool isListEmpty = false;
  DetailData? detailData;
  Options? selectedOption;
  List<Attrbs>? attrbs = [];
  List<Options>? options = [];
  int optLength = 0;
  double? discountPercentage = 0.0;
  double? discount = 0.0;
  double? unitPrice = 0.0;
  double? unitSplPrice = 0.0;
  double? cutPrice = 0.0;
  double? total = 0.0;
  int? attrLength = 0;
  int? limitCount = 20;
  int? totPdtCount = 0;
  int? totPdtCountForOutlineButtonCategory = 0;
  int? totPdtCountForSubCategory = 0;
  int? totPdtCountAftrPagination = 0;

  bool paginationLoader = false;
  bool isDetailViewInSearch = false;
  bool showHistory = false;

  Map<String, String> parametersForConfigurable = <String, String>{};
  Map<String, String> parametersForConfigurableTemp = <String, String>{};
  final mergedMap = <String, String>{};

  String? combinationId = "0";
  String? barCode = "unKnown";
  List<String>? configValues = [];
  String configValueAsString = "";

  List<String> recentSearchItems = [];

  Future<void> getProductList(
      {BuildContext? context,
      String? catId,
      int? limit,
      int? start,
      String? searchString,
      bool? initialLoad = false}) async {
    final network = await Helpers.isInternetAvailable();
    print(network);
    updatePaginationLoader(false);

    if (network) {
      try {
        handleHistoryView(false);
        // if (start! > 1) {
        //   updatePaginationLoader(true);
        // }
        updateLoadState(LoadState.loading);
        var _resp = await serviceConfig.getProductList(searchString,
            catId: catId, limit: limit ?? limitCount, start: start);
        if (_resp != null) {
          updateLoadState(LoadState.loaded);
          productModel = ProductModel.fromJson(_resp);
          totPdtCount = productModel?.totalPdtCount ?? 0;
          if (initialLoad ?? true) {
            productList = productModel?.productList ?? [];
            print(productList?.length);
          } else {
            List<Product>? _productList = [];
            _productList = productModel?.productList ?? [];
            if (_productList.isNotEmpty) {
              productList!.addAll(_productList);
              productList = [...?productList, ..._productList];
            }
          }
          totPdtCountAftrPagination = productList?.length ?? 0;

          notifyListeners();
          updatePaginationLoader(false);
        } else {
          updateLoadState(LoadState.error);
          updatePaginationLoader(false);
        }
      } catch (onError) {
        print(onError);
        updatePaginationLoader(false);
        updateLoadState(LoadState.error);
        print(onError.toString());
      }
    }
  }

  Future<bool> getProductDetails(
      {required BuildContext context, required String? productId}) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    bool status = false;
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.getProductDetails(productId: productId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            ProductDetails model = ProductDetails.fromJson(_resp);
            detailData = model.detailData?.first;

            if (detailData != null) {
              updatePriceValues();
              updateTotalByQuantity("1");

              if (detailData?.prodType != Constants.simple) {
                if (detailData?.attrbs?.isNotEmpty ?? true) {
                  attrbs = detailData?.attrbs ?? [];
                  if (attrbs?.isNotEmpty ?? true) {
                    attrLength = attrbs?.length ?? 0;
                    updateVariantSelectionInitially();
                  } else {
                    attrLength = 0;
                    notifyListeners();
                  }
                }
              }

              notifyListeners();
            } else {
              combinationId = "0";
              attrbs = [];
              options = [];
              optLength = 0;
              attrLength = 0;
              notifyListeners();
            }
            status = true;
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
    return status;
  }

  clearData() async {
    productList = [];
    notifyListeners();
  }

  clearPdtForOutlineButton() async {
    productListForOutlineButtonCategory = [];
    notifyListeners();
  }

  clearSubProducts() async {
    productListForSubCategory = [];
    notifyListeners();
  }



  Future<bool> updatePriceValuesIfConfigurable() async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    bool status = false;
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getConfigurableProductDetails(
            detailData?.productId ?? "", configValueAsString);
        updateLoadState(LoadState.loaded);
        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 204) {
          unitPrice = 0.0;
          unitSplPrice = 0.0;
          discount = 0;
          discountPercentage = 0;
          notifyListeners();
        }

        if (_resp != null && _resp["status_code"] == 200) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            detailData?.unitPrice =
                Helpers.convertToDouble(_resp["data"]['unit_price'] ?? 0.0);
            detailData?.unitSplPrice =
                Helpers.convertToDouble(_resp["data"]['unit_spl_price'] ?? 0.0);
            detailData?.pdtDiscount =
                Helpers.convertToDouble(_resp["data"]['prd_discount'] ?? 0.0);
            combinationId = _resp["data"]['combination_id'];
            notifyListeners();

            updatePriceValues();
            updateTotalByQuantity("1");
            status = true;
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
    return status;
  }

  void updateVariantSelection(Options option, String? attLabel) {
    parametersForConfigurableTemp = parametersForConfigurable;
    for (int i = 0; i < attrLength!; i++) {
      if (attrbs![i].options?.isNotEmpty ?? true) {
        int opLength = attrbs![i].options!.length;
        for (int j = 0; j < opLength; j++) {
          Options options = attrbs![i].options![j];
          if (options != null) {
            /// removed already selected with same key
            parametersForConfigurable
                .removeWhere((key, value) => key == attLabel);
            if (option.optionValue != null) {
              /// make selected true for same key

              if (attrbs![i].label == attLabel &&
                  options.optionValue == option.optionValue) {
                options.isSelected = true;
              }

              /// make selected false for others with same key

              if (attrbs![i].label == attLabel &&
                  options.optionValue != option.optionValue) {
                options.isSelected = false;
              }
            } else if (option.colorCode != null) {
              /// make selected true for same key

              if (attrbs![i].label == attLabel &&
                  options.colorCode == option.colorCode) {
                options.isSelected = true;
              }

              /// make selected false for others with same key

              if (attrbs![i].label == attLabel &&
                  options.colorCode != option.colorCode) {
                options.isSelected = false;
              }
            }

            notifyListeners();
          }
        }
      }
    }

    if (option.optionValue != null) {
      Map<String, String> tempData = <String, String>{};
      tempData["$attLabel"] = "${option.optionValue}";
      parametersForConfigurable.addAll(tempData);
    } else if (option.colorCode != null) {
      Map<String, String> tempData = <String, String>{};
      tempData["$attLabel"] = "${option.colorCode}";
      parametersForConfigurable.addAll(tempData);
    }

    updatePriceValuesIfConfigurable();
    notifyListeners();
    log("Variants after selection : ${JsonEncoder().convert(parametersForConfigurable)}");
    configValues = [];
    configValueAsString = "";
    parametersForConfigurable.values.forEach((value) {
      configValues!.add(value);
      configValueAsString = configValues!.join(',');
    });

    log("Variants after selection config: ${configValueAsString}");
  }

  void updateVariantSelectionInitially() {
    parametersForConfigurable = <String, String>{};

    for (int i = 0; i < attrLength!; i++) {
      if (attrbs![i].options?.isNotEmpty ?? true) {
        List<Options>? options = attrbs![i].options ?? [];
        if (options.isNotEmpty) {
          options.first.isSelected = true;
          notifyListeners();
          parametersForConfigurable["${attrbs![i].label}"] =
              options.first.optionValue ?? '';
        }
      }
    }
    updatePriceValuesIfConfigurable();
    notifyListeners();
    configValues = [];
    configValueAsString = "";
    parametersForConfigurable.values.forEach((value) {
      configValues!.add(value);
      configValueAsString = configValues!.join(',');
    });
    log("Variants initially : ${configValueAsString}");
  }

  void updateTotalByQuantity(String qty) {
    if (unitSplPrice! > 0) {
      total = unitSplPrice! * Helpers.convertToDouble(qty);
    } else {
      total = unitPrice! * Helpers.convertToDouble(qty);
    }
    notifyListeners();
  }

  void updatePriceValues() {
    unitPrice = detailData?.unitPrice ?? 0.0;
    unitSplPrice = detailData?.unitSplPrice ?? 0.0;
    cutPrice = detailData?.pdtDiscount ?? 0.0;
    discountPercentage = (cutPrice! / unitPrice!) * 100;


    print("unitPrice $unitPrice");
    print("unitSplPrice $unitSplPrice");
    print("cutPrice $cutPrice");
    print("discountPercentage $discountPercentage");
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  void handleHistoryView(bool val) {
    showHistory = val;
    notifyListeners();
  }

  void updateBarcode(String val) {
    barCode = val;
    notifyListeners();
  }

  void initPage() {
    productModel = null;
    productList = [];
    loaderState = LoadState.initial;
    paginationLoader = false;
    detailData = null;
    notifyListeners();
  }

  Future<void> addToRecentSearch(String val) async {
    List<String> _recentList = recentSearchItems;
    if (_recentList.contains(val)) return;
    if (_recentList.length == 3 && val.isNotEmpty) {
      _recentList.removeAt(0);
      _recentList.add(val);
    } else {
      _recentList.add(val);
    }
    await SharedPreferencesHelper.saveRecentSearchList(_recentList);
    recentSearchItems = _recentList;
    notifyListeners();
  }

  Future<void> getRecentSearch() async {
    recentSearchItems =
        await SharedPreferencesHelper.getRecentSearchList() ?? [];
    notifyListeners();
  }

  Future<void> removeRecentItem(int? index) async {
    List<String> _recentList = recentSearchItems;
    _recentList.removeAt(0);
    notifyListeners();
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  updateIsDetailView(bool val) {
    isDetailViewInSearch = val;
    notifyListeners();
  }

  updateOulineCategory(MainCategory? val) {
    selectedCatForOutlineButtonCategory = val;
    notifyListeners();
  }

  Future<void> getProductListForOutlineButtonCategory(
      {BuildContext? context,
      String? catId,
      String? catName,
      int? limit,
      int? start,
      String? searchString,
      bool? initialLoad = false}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoadState.loading);
        notifyListeners();
        var _resp = await serviceConfig.getProductList(searchString,
            catId: catId, limit: limit, start: start);
        if (_resp != null) {
          updateLoadState(LoadState.loaded);
          productModelForOutlineButtonCategory = ProductModel.fromJson(_resp);
          totPdtCountForOutlineButtonCategory =
              productModel?.totalPdtCount ?? 0;

          productListForOutlineButtonCategory =
              productModelForOutlineButtonCategory?.productList ?? [];

          notifyListeners();
          updatePaginationLoader(false);
        } else {
          updateLoadState(LoadState.error);
          updatePaginationLoader(false);
        }
      } catch (onError) {
        print(onError);
        updatePaginationLoader(false);
        updateLoadState(LoadState.error);
        print(onError.toString());
      }
    }
  }

  Future<void> getProductListForSubCategory(
      {BuildContext? context,
      String? catId,
      String? catName,
      int? limit,
      int? start,
      String? searchString,
      bool? initialLoad = false}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoadState.loading);
        notifyListeners();
        var _resp = await serviceConfig.getProductList(searchString,
            catId: catId, limit: limit, start: start);
        if (_resp != null) {
          updateLoadState(LoadState.loaded);
          productModelForSubCategory = ProductModel.fromJson(_resp);
          totPdtCountForSubCategory = productModel?.totalPdtCount ?? 0;

          productListForSubCategory =
              productModelForSubCategory?.productList ?? [];

          notifyListeners();
          updatePaginationLoader(false);
        } else {
          updateLoadState(LoadState.error);
          updatePaginationLoader(false);
        }
      } catch (onError) {
        print(onError);
        updatePaginationLoader(false);
        updateLoadState(LoadState.error);
        print(onError.toString());
      }
    }
  }
}
