import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/models/city_model.dart';
import 'package:lovica_sales_app/providers/authentication_provider.dart';
import 'package:lovica_sales_app/services/provider_helper_class.dart';
import 'package:provider/provider.dart';

import '../common/helpers.dart';
import '../common/nav_routes.dart';
import '../models/cart_model.dart';
import '../models/profile_model.dart';
import '../services/app_data.dart';
import '../services/service_config.dart';
import '../common/constants.dart';
import '../services/shared_preference_helper.dart';

class CartProvider extends ChangeNotifier with ProviderHelperClass {
  UserData? userData;
  CartListModel? cartListModel;
  List<CartItem>? cartItemsList = [];
  List<double>? totList = [];
  List<String>? colorCodeList = [];
  List<OptionCodes>? optionCodeList = [];

  var sum = 0.0;
  int? totPdtCountAftrPagination = 0;
  int? totPdtCount = 0;
  bool paginationLoader = false;

  Future<bool> addToCart({
    required BuildContext context,
    required String productId,
    required String productType,
    required String combinationId,
    required String quantity,
    required String customerId,
  }) async {
    bool isAdded = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;

        _resp = await serviceConfig.addToCart(
            productId: productId,
            prodType: productType,
            customerId: "0",
            quantity: quantity,
            combinationId: combinationId);

        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        if (_resp != null && _resp["msg"] != null) {
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            Helpers.showToast(AppData.appLocale == "ar"
                ? _resp["msg_ar"] ?? ""
                : _resp["msg"] ?? "");

            Future.microtask(() => context
                .read<AuthenticationProvider>()
                .getCartCount(context: context));
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isAdded;
  }

  Future<bool> deleteCartItem({
    required BuildContext context,
    required String productId,
    required String customerId,
  }) async {
    bool isDeleted = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;

        _resp = await serviceConfig.deleteCartItem(
            productId: productId, customerId: "0");

        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        if (_resp != null && _resp["msg"] != null) {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");

          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            isDeleted = true;
            notifyListeners();
            Future.microtask(() => context
                .read<AuthenticationProvider>()
                .getCartCount(context: context));
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isDeleted;
  }

  Future<bool> editCartItem({
    required BuildContext context,
    required String productId,
    required String customerId,
    required String quantity,
  }) async {
    bool isUpdated = false;
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;

        _resp = await serviceConfig.editCartItem(
            cartId: productId, customerId: "0", quantity: quantity);

        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        if (_resp != null && _resp["msg"] != null) {
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            isUpdated = true;
            updateQuantity(productId, quantity);
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return isUpdated;
  }

  Future<void> getCartList(
      {required BuildContext context,
      required String customerId,
      required String searchString,
      required int? limit,
      required int? start,
      bool? initialLoad = false}) async {
    if (initialLoad!) {
      updateLoadState(LoadState.loading);
    } else {
      updatePaginationLoader(true);
    }
    notifyListeners();
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;
        _resp = await serviceConfig.getCartList(
            customerId: "0",
            limit: limit,
            start: start,
            searchString: searchString ?? "");
        if (initialLoad!) {
          updateLoadState(LoadState.loaded);
        } else {
          updatePaginationLoader(false);
        }
        if (_resp != null && _resp["msg"] != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            cartListModel = CartListModel.fromJson(_resp);
            if (cartListModel != null && cartListModel?.data != null) {
              totPdtCount = cartListModel?.totalPdtCount ?? 0;
              if (initialLoad ?? true) {
                cartItemsList = cartListModel?.data ?? [];
                updateAmountList();
                updateConfigurations();
              } else {
                List<CartItem>? _cartItemsList = [];
                _cartItemsList = cartListModel?.data ?? [];
                if (_cartItemsList.isNotEmpty) {
                  cartItemsList!.addAll(_cartItemsList);
                  cartItemsList = [...?cartItemsList, ..._cartItemsList];
                  updateAmountList();
                  updateConfigurations();
                } else {
                  print("Entered initial load false list empty");
                }
              }
              totPdtCountAftrPagination = cartItemsList?.length ?? 0;

              notifyListeners();
            }
          } else if (_resp["status_code"] == 204 && _resp["data"] == null) {
            cartItemsList = [];
            updateAmountList();
            notifyListeners();
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  void updateQuantity(String productId, String qnty) {
    if (cartItemsList?.isNotEmpty ?? true) {
      for (int i = 0; i < cartItemsList!.length; i++) {
        if (productId == cartItemsList![i].cartId) {
          cartItemsList![i].cartQuantity = int.tryParse(qnty);
          notifyListeners();
        }
      }
    }
  }

  updateGrandTotal() {
    totList!.isNotEmpty ? sum = totList!.reduce((a, b) => a + b) : sum = 0.0;
    notifyListeners();
  }

  updateAmountList() {
    totList = [];
    if (cartItemsList?.isNotEmpty ?? true) {
      for (int i = 0; i < cartItemsList!.length; i++) {
        totList?.add(cartItemsList![i].total ?? 0.0);
      }
    }
    notifyListeners();
    updateGrandTotal();
  }

  updateConfigurations() {
    optionCodeList = [];
    colorCodeList = [];
    notifyListeners();
    if (cartItemsList?.isNotEmpty ?? true) {
      for (int i = 0; i < cartItemsList!.length; i++) {
        if (cartItemsList![i].configurations?.isNotEmpty ?? true) {
          for (var item in cartItemsList![i].configurations!) {
            if (item.optionColorcode == null) {
              cartItemsList![i].configOptionEn =
                  "${cartItemsList![i].configOptionEn}${item.optionLabelEng!},";
              cartItemsList![i].configOptionAr =
              "${cartItemsList![i].configOptionAr}${item.optionLabelAr!},";
              print(cartItemsList![i].configOptionEn??"");
            }

          }
        }
      }
    }

    notifyListeners();
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  clearList() {
    cartListModel = null;
    cartItemsList = [];
    notifyListeners();
  }
}
