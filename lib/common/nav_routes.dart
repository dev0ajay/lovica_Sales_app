import 'package:flutter/material.dart';
import 'package:lovica_sales_app/models/order_list_model.dart';
import 'package:lovica_sales_app/models/route_arguments.dart';
import 'package:lovica_sales_app/providers/category_provider.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:lovica_sales_app/views/auth_screens/login.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/check_out_provider.dart';
import '../providers/customer_provider.dart';
import 'constants.dart';
import 'route_generator.dart';

class NavRoutes {
  static Future<dynamic> navToLoginRemoveUntil(BuildContext context,
      {String navFrom = RouteGenerator.routeMain}) async {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LogInScreen()),
        (route) => false);
  }

  static void navToLogIn(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeLogin);
  }

  static void navToPgtPwd(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routefgtPwd);
  }

  static void navToFgtPwdOtp(BuildContext context, String? uName) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routefgtPwdOtp,
        arguments: RouteArguments(uName: uName));
  }

  static void navToFgtPwdChange(BuildContext context, String? uName) {
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
        RouteGenerator.routefgtPwdChange,
            arguments: RouteArguments(uName: uName),
    );

  }

  static void navToPersonalDetails(BuildContext context, {String? email}) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routePersonalDetails, arguments: email);
  }

  static void navToChangePwd(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeChangePwd);
  }

  static void navToChangePwdOtp(BuildContext context, String? uName) {
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
        RouteGenerator.routeChangePwdOtp,
        arguments: RouteArguments(uName: uName));
  }

  static void navToProfileEdit(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeProfileEdit);
  }

  static void navToTracking(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeTracking);
  }

  static void navToSales(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeSales);
  }

  static void navToReports(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeReports);
  }

  static void navToSettings(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeSettings);
  }

  static void navToOrderDetails(BuildContext context, OrderItem? item) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeOrderDetails,
        arguments: RouteArguments(orderItem: item));
  }

  static void navToCustomers(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeCustomers);
  }

  static void navToMyAccount(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeMyAccount);
  }

  static void navToCartPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeCartPage);
  }

  static void navToCheckout(BuildContext context) {
    // String cityId = context.read<AuthenticationProvider>().userData?.city ?? "";
    Future.microtask(() => context.read<CustomerProvider>().getCustomers("", "",
        initialLoad: true, start: 0, limit: 0, context: context)).then((value) {
      Future.microtask(() => context
          .read<CheckOutProvider>()
          .masterCheckout(context: context, customerId: "0"));
    });
  }


  static void navToSearch(BuildContext context, String? searchKey) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeSearch,
        arguments: RouteArguments(searchKey: searchKey));
  }

  static void navToAddCustomer(BuildContext context, {String? from}) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeAddCustomer,
        arguments: RouteArguments(from: from));
  }

  static void navToOrderSuccess(BuildContext context, {String? orderNum}) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeOrderSuccess,
        arguments: RouteArguments(orderNum: orderNum));
  }

  static void navToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteGenerator.routeDashboard,
      (route) => false,
    );
  }

  static void navToSubCategory(BuildContext context,
      {String? catId, String? catName}) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeSubCategory,
        arguments: RouteArguments(catId: catId, catName: catName));
  }

  static void navToProductListing(BuildContext context,
      {String? catId, String? catName, String? subCatChildName}) {
    context.read<ProductProvider>().clearData();

    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeProductListing,
            arguments: RouteArguments(
                catId: catId,
                catName: catName,
                subCatChildName: subCatChildName))
        .then((value) => {
              if (catName == Constants
                  .allProducts)
                {
                  Future.microtask(
                      () => context.read<CategoryProvider>()..clearSubCat()),
                  Future.microtask(() => context.read<ProductProvider>()
                    ..clearData()
                    ..clearPdtForOutlineButton()
                    ..clearSubProducts())
                }
            });
  }

  static void navToViewAllSubCategoryScreen(BuildContext context,
      {String? catId, String? catName}) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeViewAllSubCategory,
        arguments: RouteArguments(catId: catId, catName: catName));
  }

  static void navToNotifications(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(RouteGenerator.routeNotification);
  }

  static void navToCustomerEdit(BuildContext context, String? customerID) {
    Navigator.of(context, rootNavigator: true).pushNamed(
        RouteGenerator.routeCustomerEdit,
        arguments: RouteArguments(customerID: customerID));
  }
}
