import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/common/helpers.dart';
import 'package:lovica_sales_app/models/checkout_model.dart';
import 'package:lovica_sales_app/models/order_duplicate_model.dart';

import 'http_requests.dart';

class ServiceConfig {
  /// validate status code
  Future<dynamic> validateStatusCode(int statusCode, String? body,
      {String? errorMessage}) async {
    log(body.toString());
    dynamic res;
    switch (statusCode) {
      case 200:
        res = await json.decode(body ?? '');
        break;
      case 400:
        res = await json.decode(body ?? '');
        break;
      case 401:
        res = await json.decode(body ?? '');
        break;
      case 404:
        res = await json.decode(body ?? '');
        break;
      case 500:
        Helpers.showToast('Internal server error, Try again');
        res = {};
        break;
      default:
        {
          if (errorMessage != null) {
            // Fluttertoast.showToast(msg: errorMessage);
          }
        }
    }
    return res ?? {};
  }

  /// login api
  Future<dynamic> login({String? uName, String? password,String? locale}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "username": uName,
        "password": password,
        "locale": locale,
      };
      http.Response? resp = await postRequest("login", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// change pwd api
  Future<dynamic> changePwd({String? password, String? passwordConfirm}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "password_confirm": passwordConfirm,
        "password": password
      };
      http.Response? resp =
          await postRequest("user/password/change", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// get cities list api
  Future<dynamic> getCities(String? country) async {
    dynamic res;
    try {
      String apiEndPoint = "cities/list/$country";
      http.Response? resp = await getRequest(apiEndPoint);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// get cities list api by country
  Future<dynamic> getCitiesForEachCountry(String? country) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"country_id": country};
      String apiEndPoint = "cities/list/show";
      http.Response? resp =
          await postRequest(apiEndPoint, parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// updateUserData api
  Future<dynamic> updateUserData(
      {String? name,
      String? gender,
      String? idNum,
      String? mob,
      String? bankIban,
      String? cityId,
      String? countryId,
      String? address,
      String? emNum,
        String? type,
      }) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "Name": name,
        "Gender": gender,
        "ID_Number": idNum,
        "Bank_IBAN": bankIban,
        "City": cityId,
        "Address": address,
        "Emg_Number": emNum,
        "Mobile_Number": mob,
        "Country": countryId,
        "type": type,
      };
      http.Response? resp =
          await postRequest("userdata/update", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// get category list api
  Future<dynamic> getCategoryList(String catId) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"Category": catId};
      http.Response? resp =
          await postRequest("category", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// get customer list api
  Future<dynamic> getCustomers(
      String city, String search, int limit, int start) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {};
      if (limit == 0 && start == 0) {
        parameters = {"Limit": "$limit", "Start": "$start"};
      } else {
        parameters = {
          "City": city,
          "Search": search,
          "Limit": "$limit",
          "Start": "$start"
        };
      }
      http.Response? resp =
          await postRequest("customer/list", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getProfile() async {
    dynamic res;
    try {
      http.Response? resp = await getRequest("userdata/get");
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> isUserExist(
      {String? email, String? phoneNumber, String? code}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "email": email,
        "phone": phoneNumber,
        "code": code
      };
      http.Response? resp = await postRequest("existing-email-mobile-check",
          parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getProductList(String? searchString,
      {String? catId, int? limit, int? start}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      if (limit == 0) {
        /// search listing
        parameters = {
          "Search": searchString ?? "",
        };
      } else if (catId == "0") {
        /// pdt listing
        parameters = {
          "Limit": "$limit",
          "Start": "$start",
        };
      } else {
        parameters = {
          "Limit": "$limit",
          "Start": "$start",
          "Category": "$catId",
          "Search": searchString ?? "",
        };
      }

      http.Response? resp =
          await postRequest("products", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getProductDetails({String? productId}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"product_id": productId};
      http.Response? resp =
          await postRequest("product/get", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> addToCart(
      {String? productId,
      String? customerId,
      String? combinationId,
      String? quantity,
      String? prodType}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      prodType == Constants.simple
          ? parameters = {
              "product_id": productId,
              "customer_id": customerId,
              "quantity": quantity
            }
          : parameters = {
              "product_id": productId,
              "customer_id": customerId,
              "quantity": quantity,
              "combination_id": combinationId,
            };
      http.Response? resp =
          await postRequest("user/cart/add", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> deleteCartItem(
      {String? productId, String? customerId}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {"cart_id": productId, "customer_id": customerId};
      http.Response? resp =
          await postRequest("user/cart/delete", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> editCartItem(
      {String? cartId, String? customerId, String? quantity}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {
        "cart_id": cartId,
        "customer_id": customerId,
        "quantity": quantity
      };
      http.Response? resp =
          await postRequest("user/cart/edit", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getCartList(
      {String? customerId,String? searchString, int? limit, int? start}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {
        "customer_id": customerId,
        "Limit": "$limit",
        "Start": "$start",
        "Search": "$searchString",
      };
      http.Response? resp =
          await postRequest("user/cart/list", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getConfigurableProductDetails(
      String? productId, String param) async {
    dynamic res;
    Map<String, dynamic> parameters;

    try {
      parameters = {"product_id": productId, "string": param};
      http.Response? resp =
          await postRequest("product/config/string", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());

      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getCartCount() async {
    dynamic res;
    try {
      http.Response? resp = await getRequest("salesman/cart/count");
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> masterCheckout({String? customerId}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {"customer_id": customerId};
      http.Response? resp =
          await postRequest("user/checkout/master", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Api for Checking for duplicate

  Future<dynamic> orderDuplicate({String? customerId}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {"customerid": customerId};
      http.Response resp =
      await postRequest("orders/duplicate/confirm", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      // print("Response: ${res}");
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }


  ///Api for choosing payment type

  Future<dynamic> paymentType({String? payment_type,String? total_amount}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {"payment_type": payment_type,"total_amount": total_amount};
      http.Response resp =
      await postRequest("order/minimum_order/check", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      // print("Response: ${res}");
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

 ///Api for choosing language for notification.
  Future<dynamic> chooseLocale({String? currentLang}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {"current_lang": currentLang};

      http.Response resp =
      await postRequest("salesman/language/change", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      // print("Response: ${res}");
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }



  Future<dynamic> orderConfirmation(
      {String? customerId,
      String? shippingId,
      String? paymentId,
      String? notes,
      String? invoice}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters;
      parameters = {
        "customer_id": customerId,
        "shipping_id": shippingId,
        "payment_id": paymentId,
        "bill_type": invoice,
        "warehouse_note": notes,
      };
      http.Response? resp =
          await postRequest("user/checkout/confirm", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> addCustomer(
      {String? name,
      String? gender,
      String? idNum,
      String? mob,
      String? bankIban,
      String? cityId,
      String? countryId,
      String? address,
      String? emNum}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "Name": name,
        "City": cityId,
        "Mobile_Number": mob,
        "Country": countryId,
        "Address": address,
      };
      http.Response? resp =
          await postRequest("customer/add", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> updateCustomer(
      {String? name,
      String? gender,
      String? idNum,
      String? mob,
      String? bankIban,
      String? cityId,
      String? address,
      String? customerId,
      String? countryId,
      String? emNum}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "Name": name,
        "Id": customerId,
        "City": cityId,
        "Country": countryId,
        "Address": address,
        "Mobile_Number": mob
      };
      http.Response? resp =
          await postRequest("customer/edit", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> orderList(
      {String? searchString, int? limit, int? start}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "Search": searchString,
        "Limit": "$limit",
        "Start": "$start"
      };
      http.Response? resp =
          await postRequest("orders/list", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> orderDetails({String? orderNumber}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "order_number": orderNumber,
      };
      http.Response? resp =
          await postRequest("order/details", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> sendOtp({String? mobile,String? countryCode}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"mobile_no": mobile,"country_code": countryCode};
      http.Response? resp =
          await postRequest("salesman/mobile/otp", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> sendOtpFgtPwd({String? mobile, String? uName}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "mobile_no": mobile,
        "username": uName
      };
      http.Response? resp = await postRequest("salesperson/forget/otp/generate",
          parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> verifyMobile({String? mobile, String? otp}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "mobile_no": mobile,
        "otp": otp,
      };
      http.Response? resp =
          await postRequest("salesman/mobile/verify", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> verifyOtp({String? uName, String? otp}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "username": uName,
        "otp": otp,
      };
      http.Response? resp = await postRequest("salesperson/forget/otp/verify",
          parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// fgt pwd api
  Future<dynamic> fgtPwdChange({String? password, String? uName}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "password": password,
        "username": uName
      };
      http.Response? resp = await postRequest(
          "salesperson/forget/changepassword",
          parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> sendFcmToken({String? fcm, String? device,String? deviceId}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "fcm_token": fcm,
        "device_type": device,
        "device_id": deviceId,
      };
      http.Response? resp =
          await postRequest("fcm/token/register", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> readNotification({String? id}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {
        "notification_id": id,
      };
      http.Response? resp = await postRequest("salesman/notification/markasread",
          parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getLabels() async {
    dynamic res;
    try {
      http.Response? resp = await postRequest("labels");
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getNotificationList({int? limit, int? start}) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"Limit": "$limit", "Start": "$start"};
      http.Response? resp =
          await postRequest("salesman/notification", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getReports() async {
    dynamic res;
    try {
      http.Response? resp = await getRequest("salesman/report");
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getCustomerDetails(String? customerId) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"customer_id": "$customerId"};

      http.Response? resp =
          await postRequest("customer/view", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getCountryList() async {
    dynamic res;
    try {
      http.Response? resp = await getRequest("country/list");
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
  Future<dynamic> triggerRealtimeApiForBackend() async {
    dynamic res;
    try {
      http.Response? resp = await getRequest("realtime/orders/trigger");
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Get terms and conditions
  Future<dynamic> getTermsAndConditions(String? cmsId) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"cms_id": "$cmsId"};

      http.Response? resp =
      await postRequest("cms/mobile", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///Delete User Account
  Future<dynamic> deleteUserAccount(String? confirmation, String? deviceType) async {
    dynamic res;
    try {
      Map<String, dynamic> parameters = {"confirmation": "$confirmation","device_type": "$deviceType"};

      http.Response? resp =
      await postRequest("salesperson/user/account/delete", parameters: parameters);
      res = await validateStatusCode(resp.statusCode, resp.body);
      // log(res.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

}
