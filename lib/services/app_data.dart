import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/city_model.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  static String baseUrl = "https://lovicasales.demoatcrayotech.com/api/";
  static String appLocale = 'en';
  static String fcm = '';
  static String accessToken = "";
  static bool isUserDataRequired = false;
  static List<City> cityListFromAppData = [];
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  static CartItem? itemForActionDone;
  static int? indexForActionDone;
  static bool? isVisibleKeyboard=false;
}