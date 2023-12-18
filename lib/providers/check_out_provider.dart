import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/models/checkout_model.dart';
import 'package:lovica_sales_app/models/city_model.dart';
import 'package:lovica_sales_app/models/order_list_model.dart';
import 'package:lovica_sales_app/models/order_success_model.dart';
import 'package:lovica_sales_app/providers/authentication_provider.dart';
import 'package:lovica_sales_app/providers/cart_provider.dart';
import 'package:lovica_sales_app/providers/customer_provider.dart';
import 'package:lovica_sales_app/services/provider_helper_class.dart';
import 'package:provider/provider.dart';

import '../common/helpers.dart';
import '../common/nav_routes.dart';
import '../common/route_generator.dart';
import '../models/cart_model.dart';
import '../models/checkout_model.dart';
import '../models/customer_model.dart';
import '../models/order_duplicate_model.dart';
import '../models/payment_type_model.dart';
import '../models/profile_model.dart';
import '../services/app_data.dart';
import '../services/service_config.dart';
import '../common/constants.dart';
import '../services/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class CheckOutProvider extends ChangeNotifier with ProviderHelperClass {
  UserData? userData;
  CheckOutModel? checkOutModel;
  List<CartItem>? cartItemsList = [];

  PaymentMethods? selectedPaymentMethod;

  String? selectedInvoice = "with VAT";
  ShippingMethods? selectedShippingInfo;

  List<CartData>? cartData;
  TaxData? taxData;
  List<ShippingMethods>? shippingInfo = [];
  List<PaymentMethods>? paymentMethods = [];
  List<String>? invoice;
  CustomerData? customerData;

  int? cartCount = 0;
  double? shippingCharge = 0;
  double? taxAmount = 0;
  double? grandTotal = 0;

  bool showPopup = false;
  bool showCustomerPopup = false;
  City? selectedCityForCustomer;
  Customer? selectedCustomer;

  OrderListModel? orderListModel;
  OrderDetails? orderDetails;
  List<OrderItem>? ordersList = [];
  List<SalesData>? salesData = [];
  // List<Combination>? combination = [];
  int? totPdtCountAftrPagination = 0;
  int? totPdtCount = 0;
  bool paginationLoader = false;

  ///Order duplicate
  String isDuplicate = "";
  String message_en = "";
  String message_ar = "";
  OrderDuplicateModel? data;

///Payment method
String permit = "";
String paymentMethodMessage = "";
String paymentMethodMessageAr = "";
String amount = "";





  Future<void> masterCheckout({
    required BuildContext context,
    required String customerId,
  }) async {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;

        _resp = await serviceConfig.masterCheckout(customerId: customerId);
        Navigator.of(context, rootNavigator: true)
            .pushNamed(RouteGenerator.routeCheckout);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }
        if (_resp != null && _resp["msg"] != null) {
          updateLoadState(LoadState.loaded);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            checkOutModel = CheckOutModel.fromJson(_resp);
            if (checkOutModel != null && checkOutModel?.checkOutData != null) {
              CheckOutData? checkOutData = checkOutModel?.checkOutData;

              if (selectedCustomer != null) {
                handleCustomerDataPopupVisibility();
              }
              if (checkOutData?.cartData?.isNotEmpty ?? true) {
                cartCount = checkOutData?.cartData?.length;
              }
              if (checkOutData?.paymentMethods?.isNotEmpty ?? true) {
                paymentMethods = checkOutData?.paymentMethods ?? [];
                if (paymentMethods?.isNotEmpty ??
                    true && paymentMethods != null) {
                  updatePaymentMethod(paymentMethods![0]);
                }
              }
              if (checkOutData?.shippingMethods?.isNotEmpty ?? true) {
                shippingInfo = checkOutData?.shippingMethods ?? [];
                if (shippingInfo?.isNotEmpty ?? true && shippingInfo != null) {
                  updateShippingInfo(shippingInfo![0], context);
                }
              }
              if (checkOutData?.billType?.isNotEmpty ?? true) {
                invoice = checkOutData?.billType ?? [];
                if (invoice?.isNotEmpty ?? true && invoice != null) {
                  updateInvoice(invoice![0]);
                }
              }
              if (checkOutData?.taxData != null) {
                taxData = checkOutData?.taxData;
                if (taxData != null) {
                  taxAmount = taxData?.tax ?? 0.0;
                }
              }
              if (checkOutData?.customerData != null) {
                customerData = checkOutData?.customerData;
              }

              Future.microtask(() => updateGrandTotal(context));
              Future.microtask(() => updateCityForCustomer(
                  context.read<AuthenticationProvider>().selectedCity));
            }
            notifyListeners();
          } else {
            // Helpers.showToast(_resp["msg"]);
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
  }

  Future<String> orderConfirmation({
    required BuildContext context,
    required String customerId,
    required String paymentId,
    required String shippingId,
    required String notes,
    required String invoice,
  }) async {
    String orderNum = "";
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.orderConfirmation(
            customerId: customerId,
            paymentId: paymentId,
            shippingId: shippingId,
            notes: notes,
            invoice: invoice);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["msg"] != null) {
          Helpers.showToast(AppData.appLocale == "ar"
              ? _resp["msg_ar"] ?? ""
              : _resp["msg"] ?? "");
          updateLoadState(LoadState.loaded);
          if (_resp["status_code"] == 200) {
            orderNum = _resp["data"]["order_ref_no"] ?? "0";

            Future.microtask(() => triggerRealtimeApiForBackend(
                context: context, orderNum: orderNum));
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return orderNum;
  }

  Future<void> getOrdersList(String searchString,
      {required BuildContext context,
      int? limit,
      int? start,
      bool? initialLoad = false}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    if (initialLoad!) {
      updateLoadState(LoadState.loading);
    } else {
      updatePaginationLoader(true);
    }
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.orderList(
            searchString: searchString, limit: limit, start: start);

        if (initialLoad) {
          updateLoadState(LoadState.loaded);
        } else {
          updatePaginationLoader(false);
        }

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          // Fluttertoast.showToast(msg: _resp["msg"]);
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["data"] != null) {
            orderListModel = OrderListModel.fromJson(_resp);
            totPdtCount = orderListModel?.totalPdtCount ?? 0;

            if (initialLoad ?? true) {
              ordersList = orderListModel?.orderList ?? [];
            } else {
              List<OrderItem>? _orderList = [];
              _orderList = orderListModel?.orderList ?? [];
              if (_orderList.isNotEmpty) {
                ordersList!.addAll(_orderList);
                ordersList = [...?ordersList, ..._orderList];
              } else {
                print("Entered initial load false list empty");
              }
            }
            totPdtCountAftrPagination = ordersList?.length ?? 0;

            notifyListeners();
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
    // }
  }

  Future<void> getOrderDetails(String orderNum,
      {required BuildContext context}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.orderDetails(orderNumber: orderNum ?? "");
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          if (_resp["data"] != null) {
            orderDetails = OrderDetails.fromJson(_resp);
            salesData = orderDetails?.orderDetailData?.salesData ?? [];

          }
        } else {
          Fluttertoast.showToast(
              msg: AppData.appLocale == "ar" ? _resp["msg_ar"] : _resp["msg"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    // }
  }

  Future<void> triggerRealtimeApiForBackend(
      {required BuildContext context, required String orderNum}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.triggerRealtimeApiForBackend();

        Future.microtask(() {
          final authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);
          authProvider.cartCount = 0;
          notifyListeners();
        });
        Future.microtask(
            () => NavRoutes.navToOrderSuccess(context, orderNum: orderNum));
        debugPrint(_resp);
      } catch (_) {}
    } else {}
  }



  void updateInvoice(String invoice) {
    selectedInvoice = invoice;
    notifyListeners();
  }

  void updatePaymentMethod(PaymentMethods method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void updateShippingInfo(ShippingMethods info, BuildContext context) {
    selectedShippingInfo = info;
    shippingCharge = info.charge ?? 0.0;
    updateGrandTotal(context);
    notifyListeners();
  }

  void updateGrandTotal(BuildContext context) {
    double pdtTotalAmt =
        Helpers.convertToDouble(context.read<CartProvider>().sum);
    print("pdt tot:$pdtTotalAmt");
    print("tax:${(taxAmount! * pdtTotalAmt) / 100}");
    print("shipp:$shippingCharge");
    List<double?> totList = [
      pdtTotalAmt,
      (taxAmount! * pdtTotalAmt) / 100,
      shippingCharge
    ];
    totList.isNotEmpty
        ? grandTotal = totList.reduce((a, b) => a! + b!)
        : grandTotal = 0.0;

    notifyListeners();
  }

  void updateCustomer(Customer? customer) {
    print(customer?.customerName ?? "");
    selectedCustomer = customer;
    notifyListeners();
  }

  void updateCityForCustomer(City? city) {
    selectedCityForCustomer = city;
    notifyListeners();
  }

  void handlePopupVisibility() {
    showPopup = !showPopup;
    notifyListeners();
  }

  void handleCustomerDataPopupVisibility() {
    showCustomerPopup = !showCustomerPopup;
    notifyListeners();
  }

  void upateCustomerDataPopupVisibility(bool val) {
    showCustomerPopup = val;
    notifyListeners();
  }

  void handleCustomerDataPopupVisibilityWithValue(bool val) {
    showPopup = val;
    notifyListeners();
  }

  void updateCustomerAfterEditFromCheckOut(BuildContext? context, String? id) {
    List<Customer> customerList =
        context!.read<CustomerProvider>().customerList;
    if (customerList.isNotEmpty) {
      for (int i = 0; i < customerList.length; i++) {
        if (customerList[i].customerId == id) {
          updateCustomer(customerList[i]);
        }
      }
    }
  }

  ///Provider for checking duplicate

  Future<void> orderDuplicate(
      {required BuildContext context,
      required String customerId,
      OrderDuplicateModel? data}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.orderDuplicate(customerId: customerId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          data = OrderDuplicateModel.fromJson(_resp);
          isDuplicate = data.duplicateOrder;
          message_en = data.msgEn;
          message_ar = data.msgAr;
          // notifyListeners();

        } else {
          Fluttertoast.showToast(
              msg: AppData.appLocale == "ar"
                  ? _resp["msg_ar"]
                  : _resp["msg_en"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    // }
  }


  ///Provider for payment method
  Future<void> paymentType(
      {
        required String paymentType,
        required String totalAmount,
        PaymentMethodResponse? data}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
        await serviceConfig.paymentType(payment_type: paymentType,total_amount: totalAmount);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          data = PaymentMethodResponse.fromJson(_resp);
          permit = data.permit;
          paymentMethodMessage = data.message;
          paymentMethodMessageAr = data.messageAr;
          notifyListeners();
          // amount = data.amount;

        } else {
          Fluttertoast.showToast(
              msg: AppData.appLocale == "ar"
                  ? _resp["msg_ar"]
                  : _resp["msg_en"]);
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    // }
  }


  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  void clearOrdersList() {
    ordersList = [];
    notifyListeners();
  }

  void clearOrderDetails() {
    orderDetails = null;
    salesData = [];
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  void initPage() {
    orderListModel = null;
    ordersList = [];
    loaderState = LoadState.initial;
    paginationLoader = false;
    notifyListeners();
  }
}
