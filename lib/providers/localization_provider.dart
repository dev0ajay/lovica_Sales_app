import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/models/current_lang_response.dart';
import 'package:lovica_sales_app/models/label_model.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/views/auth_screens/login.dart';
import 'package:lovica_sales_app/views/settings_sub_pages/privacy_policy_screen.dart';
import 'package:provider/provider.dart';

import '../common/helpers.dart';
import '../models/delete_user_account_model.dart';
import '../models/terms_and_condition_response_model.dart';
import '../services/provider_helper_class.dart';
import '../views/settings_sub_pages/terms_and_conditions_screen.dart';
import 'authentication_provider.dart';

class AppLocalizationProvider extends ChangeNotifier with ProviderHelperClass {
  Locale? locale;
  String language = '';
  String? selectedLanguage = "en";
  bool showPopup = false;
  LabelModel? labelModel;
  List<Label>? labelsList = [];
  String? cmsManagementId;
  String? headingEn;
  String? headingAr;
  String? contentEn;
  String? contentAr;
  String deleteAccountMsgEn = "";
  String deleteAccountMsgAr = "";

  Future<void> getLocalLocale() async {
    language = window.locale.languageCode;
    locale = Locale(language);
    notifyListeners();
  }

  @override
  void updateLoadState(LoadState state) {
    loaderState = state;
    notifyListeners();
  }

  Future<void> updateLanguage(String lan) async {
    selectedLanguage = lan;
    AppData.appLocale = lan;
    debugPrint("App data ::Language locale : ${AppData.appLocale}");
    notifyListeners();
  }

  void handlePopupVisibility() {
    showPopup = !showPopup;
    notifyListeners();
  }

  Future<void> updateLabels(BuildContext context) async {
    updateLoadState(LoadState.loading);
    for (var label in labelsList!) {
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.userName.toLowerCase().replaceAll(' ', '')) {
        Constants.userName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.userName
            : label.arLabel ?? ConstantsDefault.userName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.password.toLowerCase().replaceAll(' ', '')) {
        Constants.password = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.password
            : label.arLabel ?? ConstantsDefault.password;
      }
      if (label.title?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.fgtPwd.toLowerCase().replaceAll(' ', '')) {
        Constants.fgtPwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.fgtPwd
            : label.arLabel ?? ConstantsDefault.fgtPwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterName.toLowerCase().replaceAll(' ', '')) {
        Constants.enterName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterName
            : label.arLabel ?? ConstantsDefault.enterName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterUname.toLowerCase().replaceAll(' ', '')) {
        Constants.enterUname = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterUname
            : label.arLabel ?? ConstantsDefault.enterUname;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.signIn.toLowerCase().replaceAll(' ', '')) {
        Constants.signIn = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.signIn
            : label.arLabel ?? ConstantsDefault.signIn;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterPwd.toLowerCase().replaceAll(' ', '')) {
        Constants.enterPwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterPwd
            : label.arLabel ?? ConstantsDefault.enterPwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.login.toLowerCase().replaceAll(' ', '')) {
        Constants.login = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.login
            : label.arLabel ?? ConstantsDefault.login;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.changePwd.toLowerCase().replaceAll(' ', '')) {
        Constants.changePwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.changePwd
            : label.arLabel ?? ConstantsDefault.changePwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.changePwdTitle.toLowerCase().replaceAll(' ', '')) {
        Constants.changePwdTitle = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.changePwdTitle
            : label.arLabel ?? ConstantsDefault.changePwdTitle;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.emptyString.toLowerCase().replaceAll(' ', '')) {
        Constants.emptyString = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.emptyString
            : label.arLabel ?? ConstantsDefault.emptyString;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterValidUName.toLowerCase().replaceAll(' ', '')) {
        Constants.enterValidUName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterValidUName
            : label.arLabel ?? ConstantsDefault.enterValidUName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.personalDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.personalDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.personalDetails
            : label.arLabel ?? ConstantsDefault.personalDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.required.toLowerCase().replaceAll(' ', '')) {
        Constants.required = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.required
            : label.arLabel ?? ConstantsDefault.required;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.submitted.toLowerCase().replaceAll(' ', '')) {
        Constants.submitted = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.submitted
            : label.arLabel ?? ConstantsDefault.submitted;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.seeMore.toLowerCase().replaceAll(' ', '')) {
        Constants.seeMore = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.seeMore
            : label.arLabel ?? ConstantsDefault.seeMore;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.logout.toLowerCase().replaceAll(' ', '')) {
        Constants.logout = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.logout
            : label.arLabel ?? ConstantsDefault.logout;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.submit.toLowerCase().replaceAll(' ', '')) {
        Constants.submit = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.submit
            : label.arLabel ?? ConstantsDefault.submit;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.name.toLowerCase().replaceAll(' ', '')) {
        Constants.name = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.name
            : label.arLabel ?? ConstantsDefault.name;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterName.toLowerCase().replaceAll(' ', '')) {
        Constants.enterName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterName
            : label.arLabel ?? ConstantsDefault.enterName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.gender.toLowerCase().replaceAll(' ', '')) {
        Constants.gender = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.gender
            : label.arLabel ?? ConstantsDefault.gender;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.mobileNumber.toLowerCase().replaceAll(' ', '')) {
        Constants.mobileNumber = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.mobileNumber
            : label.arLabel ?? ConstantsDefault.mobileNumber;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.emContactNum.toLowerCase().replaceAll(' ', '')) {
        Constants.emContactNum = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.emContactNum
            : label.arLabel ?? ConstantsDefault.emContactNum;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.idNumber.toLowerCase().replaceAll(' ', '')) {
        Constants.idNumber = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.idNumber
            : label.arLabel ?? ConstantsDefault.idNumber;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterIdNumber.toLowerCase().replaceAll(' ', '')) {
        Constants.enterIdNumber = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterIdNumber
            : label.arLabel ?? ConstantsDefault.enterIdNumber;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.bankIban.toLowerCase().replaceAll(' ', '')) {
        Constants.bankIban = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.bankIban
            : label.arLabel ?? ConstantsDefault.bankIban;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterBankIban.toLowerCase().replaceAll(' ', '')) {
        Constants.enterBankIban = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterBankIban
            : label.arLabel ?? ConstantsDefault.enterBankIban;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterCity.toLowerCase().replaceAll(' ', '')) {
        Constants.enterCity = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterCity
            : label.arLabel ?? ConstantsDefault.enterCity;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterMob.toLowerCase().replaceAll(' ', '')) {
        Constants.enterMob = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterMob
            : label.arLabel ?? ConstantsDefault.enterMob;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.city.toLowerCase().replaceAll(' ', '')) {
        Constants.city = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.city
            : label.arLabel ?? ConstantsDefault.city;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.address.toLowerCase().replaceAll(' ', '')) {
        Constants.address = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.address
            : label.arLabel ?? ConstantsDefault.address;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.male.toLowerCase().replaceAll(' ', '')) {
        Constants.male = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.male
            : label.arLabel ?? ConstantsDefault.male;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.female.toLowerCase().replaceAll(' ', '')) {
        Constants.female = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.female
            : label.arLabel ?? ConstantsDefault.female;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.home.toLowerCase().replaceAll(' ', '')) {
        Constants.home = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.home
            : label.arLabel ?? ConstantsDefault.home;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterName.toLowerCase().replaceAll(' ', '')) {
        Constants.enterName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterName
            : label.arLabel ?? ConstantsDefault.enterName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.customers.toLowerCase().replaceAll(' ', '')) {
        Constants.customers = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.customers
            : label.arLabel ?? ConstantsDefault.customers;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.products.toLowerCase().replaceAll(' ', '')) {
        Constants.products = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.products
            : label.arLabel ?? ConstantsDefault.products;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.sales.toLowerCase().replaceAll(' ', '')) {
        Constants.sales = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.sales
            : label.arLabel ?? ConstantsDefault.sales;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.reports.toLowerCase().replaceAll(' ', '')) {
        Constants.reports = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.reports
            : label.arLabel ?? ConstantsDefault.reports;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.tracking.toLowerCase().replaceAll(' ', '')) {
        Constants.tracking = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.tracking
            : label.arLabel ?? ConstantsDefault.tracking;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.settings.toLowerCase().replaceAll(' ', '')) {
        Constants.settings = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.settings
            : label.arLabel ?? ConstantsDefault.settings;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.sendOtp.toLowerCase().replaceAll(' ', '')) {
        Constants.sendOtp = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.sendOtp
            : label.arLabel ?? ConstantsDefault.sendOtp;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterNewPwd.toLowerCase().replaceAll(' ', '')) {
        Constants.enterNewPwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterNewPwd
            : label.arLabel ?? ConstantsDefault.enterNewPwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.confirmNewPwd.toLowerCase().replaceAll(' ', '')) {
        Constants.confirmNewPwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.confirmNewPwd
            : label.arLabel ?? ConstantsDefault.confirmNewPwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterOtp.toLowerCase().replaceAll(' ', '')) {
        Constants.enterOtp = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterOtp
            : label.arLabel ?? ConstantsDefault.enterOtp;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.verify.toLowerCase().replaceAll(' ', '')) {
        Constants.verify = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.verify
            : label.arLabel ?? ConstantsDefault.verify;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.show.toLowerCase().replaceAll(' ', '')) {
        Constants.show = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.show
            : label.arLabel ?? ConstantsDefault.show;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.editProfile.toLowerCase().replaceAll(' ', '')) {
        Constants.editProfile = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.editProfile
            : label.arLabel ?? ConstantsDefault.editProfile;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.searchForOrderId.toLowerCase().replaceAll(' ', '')) {
        Constants.searchForOrderId = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.searchForOrderId
            : label.arLabel ?? ConstantsDefault.searchForOrderId;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.orderNo.toLowerCase().replaceAll(' ', '')) {
        Constants.orderNo = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.orderNo
            : label.arLabel ?? ConstantsDefault.orderNo;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.custName.toLowerCase().replaceAll(' ', '')) {
        Constants.custName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.custName
            : label.arLabel ?? ConstantsDefault.custName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.notification.toLowerCase().replaceAll(' ', '')) {
        Constants.notification = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.notification
            : label.arLabel ?? ConstantsDefault.notification;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.myAccount.toLowerCase().replaceAll(' ', '')) {
        Constants.myAccount = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.myAccount
            : label.arLabel ?? ConstantsDefault.myAccount;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.changeLang.toLowerCase().replaceAll(' ', '')) {
        Constants.changeLang = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.changeLang
            : label.arLabel ?? ConstantsDefault.changeLang;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.customerList.toLowerCase().replaceAll(' ', '')) {
        Constants.customerList = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.customerList
            : label.arLabel ?? ConstantsDefault.customerList;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterCustOrShopName
              .toLowerCase()
              .replaceAll(' ', '')) {
        Constants.enterCustOrShopName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterCustOrShopName
            : label.arLabel ?? ConstantsDefault.enterCustOrShopName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.custID.toLowerCase().replaceAll(' ', '')) {
        Constants.custID = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.custID
            : label.arLabel ?? ConstantsDefault.custID;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.mobnumdot.toLowerCase().replaceAll(' ', '')) {
        Constants.mobnumdot = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.mobnumdot
            : label.arLabel ?? ConstantsDefault.mobnumdot;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.custNameDot.toLowerCase().replaceAll(' ', '')) {
        Constants.custNameDot = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.custNameDot
            : label.arLabel ?? ConstantsDefault.custNameDot;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.addNewCustWithIcon
              .toLowerCase()
              .replaceAll(' ', '')) {
        Constants.addNewCustWithIcon = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.addNewCustWithIcon
            : label.arLabel ?? ConstantsDefault.addNewCustWithIcon;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.employeeId.toLowerCase().replaceAll(' ', '')) {
        Constants.employeeId = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.employeeId
            : label.arLabel ?? ConstantsDefault.employeeId;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.price.toLowerCase().replaceAll(' ', '')) {
        Constants.price = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.price
            : label.arLabel ?? ConstantsDefault.price;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.discount.toLowerCase().replaceAll(' ', '')) {
        Constants.discount = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.discount
            : label.arLabel ?? ConstantsDefault.discount;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.fillAllFields.toLowerCase().replaceAll(' ', '')) {
        Constants.fillAllFields = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.fillAllFields
            : label.arLabel ?? ConstantsDefault.fillAllFields;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.total.toLowerCase().replaceAll(' ', '')) {
        Constants.total = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.total
            : label.arLabel ?? ConstantsDefault.total;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.cutPrice.toLowerCase().replaceAll(' ', '')) {
        Constants.cutPrice = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.cutPrice
            : label.arLabel ?? ConstantsDefault.cutPrice;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.quantity.toLowerCase().replaceAll(' ', '')) {
        Constants.quantity = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.quantity
            : label.arLabel ?? ConstantsDefault.quantity;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.addToCart.toLowerCase().replaceAll(' ', '')) {
        Constants.addToCart = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.addToCart
            : label.arLabel ?? ConstantsDefault.addToCart;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.shoppingCart.toLowerCase().replaceAll(' ', '')) {
        Constants.shoppingCart = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.shoppingCart
            : label.arLabel ?? ConstantsDefault.shoppingCart;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.simple.toLowerCase().replaceAll(' ', '')) {
        Constants.simple = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.simple
            : label.arLabel ?? ConstantsDefault.simple;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.searchForProducts
              .toLowerCase()
              .replaceAll(' ', '')) {
        Constants.searchForProducts = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.searchForProducts
            : label.arLabel ?? ConstantsDefault.searchForProducts;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.orderNumber.toLowerCase().replaceAll(' ', '')) {
        Constants.orderNumber = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.orderNumber
            : label.arLabel ?? ConstantsDefault.orderNumber;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.orderConfirmed.toLowerCase().replaceAll(' ', '')) {
        Constants.orderConfirmed = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.orderConfirmed
            : label.arLabel ?? ConstantsDefault.orderConfirmed;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.checkoutPage.toLowerCase().replaceAll(' ', '')) {
        Constants.checkoutPage = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.checkoutPage
            : label.arLabel ?? ConstantsDefault.checkoutPage;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.checkout.toLowerCase().replaceAll(' ', '')) {
        Constants.checkout = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.checkout
            : label.arLabel ?? ConstantsDefault.checkout;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.checkoutTitle.toLowerCase().replaceAll(' ', '')) {
        Constants.checkoutTitle = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.checkoutTitle
            : label.arLabel ?? ConstantsDefault.checkoutTitle;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.customerDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.customerDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.customerDetails
            : label.arLabel ?? ConstantsDefault.customerDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.addNewCustomer.toLowerCase().replaceAll(' ', '')) {
        Constants.addNewCustomer = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.addNewCustomer
            : label.arLabel ?? ConstantsDefault.addNewCustomer;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.addCust.toLowerCase().replaceAll(' ', '')) {
        Constants.addCust = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.addCust
            : label.arLabel ?? ConstantsDefault.addCust;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.shippingInfo.toLowerCase().replaceAll(' ', '')) {
        Constants.shippingInfo = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.shippingInfo
            : label.arLabel ?? ConstantsDefault.shippingInfo;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noteToWareHouse.toLowerCase().replaceAll(' ', '')) {
        Constants.noteToWareHouse = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noteToWareHouse
            : label.arLabel ?? ConstantsDefault.noteToWareHouse;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.paymentDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.paymentDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.paymentDetails
            : label.arLabel ?? ConstantsDefault.paymentDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.invoice.toLowerCase().replaceAll(' ', '')) {
        Constants.invoice = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.invoice
            : label.arLabel ?? ConstantsDefault.invoice;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.totPrice.toLowerCase().replaceAll(' ', '')) {
        Constants.totPrice = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.totPrice
            : label.arLabel ?? ConstantsDefault.totPrice;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.totItems.toLowerCase().replaceAll(' ', '')) {
        Constants.totItems = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.totItems
            : label.arLabel ?? ConstantsDefault.totItems;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.items.toLowerCase().replaceAll(' ', '')) {
        Constants.items = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.items
            : label.arLabel ?? ConstantsDefault.items;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterPerOrCompany
              .toLowerCase()
              .replaceAll(' ', '')) {
        Constants.enterPerOrCompany = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterPerOrCompany
            : label.arLabel ?? ConstantsDefault.enterPerOrCompany;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.selectCustomer.toLowerCase().replaceAll(' ', '')) {
        Constants.selectCustomer = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.selectCustomer
            : label.arLabel ?? ConstantsDefault.selectCustomer;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.amtPaid.toLowerCase().replaceAll(' ', '')) {
        Constants.amtPaid = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.amtPaid
            : label.arLabel ?? ConstantsDefault.amtPaid;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.date.toLowerCase().replaceAll(' ', '')) {
        Constants.date = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.date
            : label.arLabel ?? ConstantsDefault.date;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.order.toLowerCase().replaceAll(' ', '')) {
        Constants.order = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.order
            : label.arLabel ?? ConstantsDefault.order;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.viewDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.viewDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.viewDetails
            : label.arLabel ?? ConstantsDefault.viewDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.verification.toLowerCase().replaceAll(' ', '')) {
        Constants.verification = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.verification
            : label.arLabel ?? ConstantsDefault.verification;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.verified.toLowerCase().replaceAll(' ', '')) {
        Constants.verified = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.verified
            : label.arLabel ?? ConstantsDefault.verified;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.fgtPwd.toLowerCase().replaceAll(' ', '')) {
        Constants.fgtPwd = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.fgtPwd
            : label.arLabel ?? ConstantsDefault.fgtPwd;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.pwdChanged.toLowerCase().replaceAll(' ', '')) {
        Constants.pwdChanged = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.pwdChanged
            : label.arLabel ?? ConstantsDefault.pwdChanged;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.enterAddress.toLowerCase().replaceAll(' ', '')) {
        Constants.enterAddress = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.enterAddress
            : label.arLabel ?? ConstantsDefault.enterAddress;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noInternet.toLowerCase().replaceAll(' ', '')) {
        Constants.noInternet = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noInternet
            : label.arLabel ?? ConstantsDefault.noInternet;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.pressAgainToExit.toLowerCase().replaceAll(' ', '')) {
        Constants.pressAgainToExit = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.pressAgainToExit
            : label.arLabel ?? ConstantsDefault.pressAgainToExit;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noNetwork.toLowerCase().replaceAll(' ', '')) {
        Constants.noNetwork = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noNetwork
            : label.arLabel ?? ConstantsDefault.noNetwork;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noNetworkDesc.toLowerCase().replaceAll(' ', '')) {
        Constants.noNetworkDesc = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noNetworkDesc
            : label.arLabel ?? ConstantsDefault.noNetworkDesc;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noData.toLowerCase().replaceAll(' ', '')) {
        Constants.noData = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noData
            : label.arLabel ?? ConstantsDefault.noData;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.confirm.toLowerCase().replaceAll(' ', '')) {
        Constants.confirm = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.confirm
            : label.arLabel ?? ConstantsDefault.confirm;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.allProducts.toLowerCase().replaceAll(' ', '')) {
        Constants.allProducts = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.allProducts
            : label.arLabel ?? ConstantsDefault.allProducts;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.orderDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.orderDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.orderDetails
            : label.arLabel ?? ConstantsDefault.orderDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.productDetails.toLowerCase().replaceAll(' ', '')) {
        Constants.productDetails = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.productDetails
            : label.arLabel ?? ConstantsDefault.productDetails;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.general.toLowerCase().replaceAll(' ', '')) {
        Constants.general = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.general
            : label.arLabel ?? ConstantsDefault.general;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.personal.toLowerCase().replaceAll(' ', '')) {
        Constants.personal = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.personal
            : label.arLabel ?? ConstantsDefault.personal;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.transactions.toLowerCase().replaceAll(' ', '')) {
        Constants.transactions = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.transactions
            : label.arLabel ?? ConstantsDefault.transactions;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.old.toLowerCase().replaceAll(' ', '')) {
        Constants.old = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.old
            : label.arLabel ?? ConstantsDefault.old;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.today.toLowerCase().replaceAll(' ', '')) {
        Constants.today = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.today
            : label.arLabel ?? ConstantsDefault.today;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.addNewCust.toLowerCase().replaceAll(' ', '')) {
        Constants.addNewCust = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.addNewCust
            : label.arLabel ?? ConstantsDefault.addNewCust;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.more.toLowerCase().replaceAll(' ', '')) {
        Constants.more = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.more
            : label.arLabel ?? ConstantsDefault.more;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.showLess.toLowerCase().replaceAll(' ', '')) {
        Constants.showLess = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.showLess
            : label.arLabel ?? ConstantsDefault.showLess;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noData.toLowerCase().replaceAll(' ', '')) {
        Constants.noData = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noData
            : label.arLabel ?? ConstantsDefault.noData;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.noDataFound.toLowerCase().replaceAll(' ', '')) {
        Constants.noDataFound = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.noDataFound
            : label.arLabel ?? ConstantsDefault.noDataFound;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.emptyString.toLowerCase().replaceAll(' ', '')) {
        Constants.fieldCannotBeEmpty = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.emptyString
            : label.arLabel ?? ConstantsDefault.emptyString;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.qty.toLowerCase().replaceAll(' ', '')) {
        Constants.qty = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.qty
            : label.arLabel ?? ConstantsDefault.qty;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.orderStatus.toLowerCase().replaceAll(' ', '')) {
        Constants.orderStatus = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.orderStatus
            : label.arLabel ?? ConstantsDefault.orderStatus;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.country.toLowerCase().replaceAll(' ', '')) {
        Constants.country = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.country
            : label.arLabel ?? ConstantsDefault.country;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.editCustomer.toLowerCase().replaceAll(' ', '')) {
        Constants.editCustomer = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.editCustomer
            : label.arLabel ?? ConstantsDefault.editCustomer;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.action.toLowerCase().replaceAll(' ', '')) {
        Constants.action = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.action
            : label.arLabel ?? ConstantsDefault.action;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.backHome.toLowerCase().replaceAll(' ', '')) {
        Constants.backHome = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.backHome
            : label.arLabel ?? ConstantsDefault.backHome;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.minQty.toLowerCase().replaceAll(' ', '')) {
        Constants.minQty = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.minQty
            : label.arLabel ?? ConstantsDefault.minQty;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.cantProceedPrice.toLowerCase().replaceAll(' ', '')) {
        Constants.cantProceedPrice = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.cantProceedPrice
            : label.arLabel ?? ConstantsDefault.cantProceedPrice;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.cantProceedQty.toLowerCase().replaceAll(' ', '')) {
        Constants.cantProceedQty = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.cantProceedQty
            : label.arLabel ?? ConstantsDefault.cantProceedQty;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.mobShouldContain.toLowerCase().replaceAll(' ', '')) {
        Constants.mobShouldContain = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.mobShouldContain
            : label.arLabel ?? ConstantsDefault.mobShouldContain;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.numbers.toLowerCase().replaceAll(' ', '')) {
        Constants.numbers = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.numbers
            : label.arLabel ?? ConstantsDefault.numbers;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.selectAvailablePdt
              .toLowerCase()
              .replaceAll(' ', '')) {
        Constants.selectAvailablePdt = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.selectAvailablePdt
            : label.arLabel ?? ConstantsDefault.selectAvailablePdt;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.selectCountry.toLowerCase().replaceAll(' ', '')) {
        Constants.selectCountry = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.selectCountry
            : label.arLabel ?? ConstantsDefault.selectCountry;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.selectCity.toLowerCase().replaceAll(' ', '')) {
        Constants.selectCity = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.selectCity
            : label.arLabel ?? ConstantsDefault.selectCity;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.arabic.toLowerCase().replaceAll(' ', '')) {
        Constants.arabic = label.arLabel ?? ConstantsDefault.arabic;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.deleteMsg.toLowerCase().replaceAll(' ', '')) {
        Constants.deleteMsg = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.deleteMsg
            : label.arLabel ?? ConstantsDefault.deleteMsg;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.delete.toLowerCase().replaceAll(' ', '')) {
        Constants.delete = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.delete
            : label.arLabel ?? ConstantsDefault.delete;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.warning.toLowerCase().replaceAll(' ', '')) {
        Constants.warning = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.warning
            : label.arLabel ?? ConstantsDefault.warning;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.cancel.toLowerCase().replaceAll(' ', '')) {
        Constants.cancel = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.cancel
            : label.arLabel ?? ConstantsDefault.cancel;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.close.toLowerCase().replaceAll(' ', '')) {
        Constants.close = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.close
            : label.arLabel ?? ConstantsDefault.close;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.done.toLowerCase().replaceAll(' ', '')) {
        Constants.done = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.done
            : label.arLabel ?? ConstantsDefault.done;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.colorAr.toLowerCase().replaceAll(' ', '')) {
        Constants.colorAr = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.colorAr
            : label.arLabel ?? ConstantsDefault.colorAr;
      }

      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.optionAr.toLowerCase().replaceAll(' ', '')) {
        Constants.optionAr = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.optionAr
            : label.arLabel ?? ConstantsDefault.optionAr;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.color.toLowerCase().replaceAll(' ', '')) {
        Constants.color = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.color
            : label.arLabel ?? ConstantsDefault.color;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.itemName.toLowerCase().replaceAll(' ', '')) {
        Constants.itemName = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.itemName
            : label.arLabel ?? ConstantsDefault.itemName;
      }
      if (label.engLabel?.toLowerCase().replaceAll(' ', '') ==
          ConstantsDefault.amount.toLowerCase().replaceAll(' ', '')) {
        Constants.amount = AppData.appLocale == "en"
            ? label.engLabel ?? ConstantsDefault.amount
            : label.arLabel ?? ConstantsDefault.amount;
      }
      notifyListeners();
    }
    updateLoadState(LoadState.loaded);

    NavRoutes.navToDashboard(context);
  }

  Future<bool> getLabels({required BuildContext context}) async {
    bool status = false;
    updateLoadState(LoadState.loading);
    // cartItemsList = [];
    notifyListeners();
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp;
        _resp = await serviceConfig.getLabels();
        updateLoadState(LoadState.loaded);
        if (_resp != null && _resp["msg"] != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_resp["status_code"] == 200) {
            labelModel = LabelModel.fromJson(_resp);

            if (labelModel != null && labelModel?.label != null) {
              labelsList = labelModel?.label ?? [];
            }

            status = true;
          }
        }
      } catch (_) {
        updateLoadState(LoadState.error);
      }
    } else {
      updateLoadState(LoadState.networkErr);
    }
    return status;
  }

  ///Choose language for notification
  Future<void> chooseLocale(
      {required String currentLang, CurrentLanguageResponse? data}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.chooseLocale(currentLang: currentLang);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          data = CurrentLanguageResponse.fromJson(_resp);
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

  ///Terms And Conditions

  Future<void> getTermsAndConditions(
      {required String cmsId,
      required BuildContext context,
      TermsAndConditionResponse? data}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getTermsAndConditions(cmsId);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["cms_management_id"] == "1") {
          data = TermsAndConditionResponse.fromJson(_resp);
          cmsManagementId = data.cmsManagementId;
          headingEn = data.headingEn;
          headingAr = data.headingAr;
          contentAr = data.contentAr;
          contentEn = data.contentEn;
          notifyListeners();
          Future.microtask(() async {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsAndConditionScreen(),
              ),
            );
          });
          // amount = data.amount;
        } else if (_resp != null && _resp["cms_management_id"] == "4") {
          data = TermsAndConditionResponse.fromJson(_resp);
          cmsManagementId = data.cmsManagementId;
          headingEn = data.headingEn;
          headingAr = data.headingAr;
          contentAr = data.contentAr;
          contentEn = data.contentEn;
          notifyListeners();
          Future.microtask(() async {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              ),
            );
          });
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

  ///User Account deletion
  Future<void> deleteUserAccount(
      {required String confirmation,
      required String deviceType,
      required BuildContext context,
      DeleteUserAccountResponse? data}) async {
    // if (AppData.cityListFromAppData.isEmpty) {
    updateLoadState(LoadState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.deleteUserAccount(confirmation, deviceType);
        updateLoadState(LoadState.loaded);

        if (_resp.isEmpty) {
          updateLoadState(LoadState.loaded);
        }

        if (_resp != null && _resp["status_code"] == 200) {
          data = DeleteUserAccountResponse.fromJson(_resp);
          deleteAccountMsgAr = data.msgAr;
          deleteAccountMsgEn = data.msg;
          Fluttertoast.showToast(
              msg: AppData.appLocale == "ar"
                  ? deleteAccountMsgAr
                  : deleteAccountMsgEn,
          );
          notifyListeners();
          Future.microtask(() async {
           await context
                .read<AuthenticationProvider>()
                .logOut(context);
             // ignore: use_build_context_synchronously
             Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogInScreen(),
                ),
                (Route<dynamic> route) => false);
          });
          // amount = data.amount;
        } else {
          Fluttertoast.showToast(
              msg: AppData.appLocale == "ar"
                  ? _resp["msg"]
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
}
