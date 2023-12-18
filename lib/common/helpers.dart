import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

class Helpers {
  static Future<bool> isInternetAvailable({bool enableToast = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        if (enableToast) showToast(Constants.noInternet);
        return false;
      }
    } on SocketException catch (_) {
      // if (enableToast) showToast("");
      return false;
    }
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
    );
  }

  static double validateScale(double val) {
    double _val = 1.0;
    if (val <= 1.0) {
      _val = 1.0;
    } else if (val >= 1.3) {
      _val = val - 0.2;
    } else if (val >= 1.1) {
      _val = val - 0.1;
    }
    return _val;
  }

  static double convertToDouble(var val) {
    double _val = 0.0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case int:
        return val.toDouble();

      case String:
        return double.tryParse(val) ?? _val;

      default:
        return val;
    }
  }

  static int convertToInt(var val) {
    int? _val = 0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case double:
        return val.toInt();

      case String:

        _val=int.tryParse(val);
        return _val??0;

      default:
        return val;
    }
  }

  static double updateTotalByQuantity(
      String qty, double unitSplPrice, double unitPrice) {
    if (unitPrice == 0.0 && unitSplPrice == 0.0) {
      return 0.0;
    }

    double? total = 0.0;
    if (unitSplPrice > 0) {
      total = unitSplPrice * Helpers.convertToDouble(qty);
    } else {
      total = unitPrice * Helpers.convertToDouble(qty);
    }
    return total;
  }
}
