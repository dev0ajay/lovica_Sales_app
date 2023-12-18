import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovica_sales_app/views/orders/order_confirmation.dart';
import 'package:lovica_sales_app/views/search/search_screen.dart';
import 'package:lovica_sales_app/views/settings_sub_pages/change_password.dart';
import 'package:lovica_sales_app/views/auth_screens/login.dart';
import 'package:lovica_sales_app/views/auth_screens/personal_details_screen.dart';
import 'package:lovica_sales_app/views/settings_sub_pages/profile_screen.dart';
import 'package:lovica_sales_app/views/menu/report_screen.dart';
import 'package:lovica_sales_app/views/orders/order_details.dart';
import 'package:lovica_sales_app/views/products/product_listing.dart';
import 'package:lovica_sales_app/views/settings_sub_pages/terms_and_conditions_screen.dart';

import '../models/route_arguments.dart';
import '../views/auth_screens/forget_pwd.dart';
import '../views/auth_screens/forget_pwd_change.dart';
import '../views/auth_screens/forget_pwd_otp.dart';
import '../views/cart/cart_screen.dart';
import '../views/checkout/check_out_screen.dart';
import '../views/customer/add_customer.dart';
import '../views/customer/edit_customer.dart';
import '../views/customer/view_customer.dart';
import '../views/dashboard/view_all_sub_category.dart';
import '../views/notification/notification_screen.dart';
import '../views/products/product_listing_screen.dart';
import '../views/settings_sub_pages/change_pwd_otp_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/dashboard/sub_category_screen.dart';
import '../views/menu/customers_screen.dart';
import '../views/menu/sales_screen.dart';
import '../views/menu/settings_screen.dart';
import '../views/menu/tracking_screen.dart';
import '../views/settings_sub_pages/my_account.dart';
import '../views/settings_sub_pages/otp_screen.dart';
import '../views/splash.dart';

class RouteGenerator {
  static const String routeMain = "/main";
  static const String routeInitial = "/";
  static const String routeLogin = "/login";
  static const String routeOTP = "/otp";
  static const String routeError = "/error";
  static const String routePersonalDetails = "/routePersonalDetails";
  static const String routeDashboard = "/routeDashboard";
  static const String routeSubCategory = "/routeSubCategory";
  static const String routeProductListing = "/routeProductListing";
  static const String routeChangePwd = "/routeChangePwd";
  static const String routeChangePwdOtp = "/routeChangePwdOtp";
  static const String routeProfileEdit = "/routeProfileEdit";
  static const String routeTracking = "/routeTracking";
  static const String routeSales = "/routeSales";
  static const String routeReports = "/routeReports";
  static const String routeSettings = "/routeSettings";
  static const String routeOrderDetails = "/routeOrderDetails";
  static const String routeCustomers = "/routeCustomers";
  static const String routeMyAccount = "/routeMyAccount";
  static const String routeCartPage = "/routeCartPage";
  static const String routeCheckout = "/routeCheckout";
  static const String routeAddCustomer = "/routeAddCustomer";
  static const String routeOrderSuccess = "/routeOrderSuccess";
  static const String routeSearch = "/routeSearch";
  static const String routefgtPwd = "/routefgtPwd";
  static const String routefgtPwdOtp = "/routefgtPwdOtp";
  static const String routefgtPwdChange = "/routefgtPwdChange";
  static const String routeNotification = "/routeNotification";
  static const String routeViewAllSubCategory = "/routeViewAllSubCategory";
  static const String routeCustomerEdit = "/routeCustomerEdit";
  static const String routeCustomerView = "/routeCustomerView";
  static const String routeTermsAndCondition = "/routeTermsAndCondition";

  Route generateRoute(RouteSettings settings, {var routeBuilders}) {
    var args = settings.arguments;
    // RouteArguments? _routeArguments;
    switch (settings.name) {
      case routeInitial:
        return _buildRoute(routeInitial, const SplashScreen());
      case routeOTP:
        RouteArguments routeArguments = args as RouteArguments;

        return _buildRoute(
            routeOTP,
            OTPScreen(
              mobile: routeArguments.mobile,countryCode: routeArguments.countryID,
            ));
      case routeLogin:
        return _buildRoute(routeLogin, const LogInScreen());
      case routePersonalDetails:
        return _buildRoute(routePersonalDetails, const PersonalDetailsScreen());
      case routeChangePwd:
        return _buildRoute(routeChangePwd, const ChangePwdScreen());
      case routeChangePwdOtp:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeChangePwdOtp,
            ChangePwdOTPScreen(
              uName: routeArguments.uName ?? "",
            ));
      case routefgtPwd:
        return _buildRoute(routefgtPwd, const ForgetPwdScreen());
      case routefgtPwdOtp:
        return _buildRoute(routefgtPwdOtp, ForgetPwdOtpScreen());
      case routefgtPwdChange:
        return _buildRoute(routefgtPwdChange, const ForgetPwdChangeScreen());
      case routeDashboard:
        return _buildRoute(routePersonalDetails, const DashboardScreen());
      case routeProfileEdit:
        return _buildRoute(routeProfileEdit, const ProfileScreen());
      case routeTracking:
        return _buildRoute(routeTracking, const TrackingScreen());
      case routeSales:
        return _buildRoute(routeSales, const SalesScreen());
      case routeReports:
        return _buildRoute(routeReports, const ReportsScreen());
      case routeSettings:
        return _buildRoute(routeSettings, const SettingsScreen());
      case routeOrderDetails:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeSearch,
            OrderDetailsScreen(
              orderItem: routeArguments.orderItem,
            ));
      case routeCustomers:
        return _buildRoute(routeCustomers, const CustomerScreen());
      case routeMyAccount:
        return _buildRoute(routeMyAccount, const MyAccount());
      case routeCartPage:
        return _buildRoute(routeCartPage, const CartScreen());
      case routeCheckout:
        return _buildRoute(routeCheckout, const CheckoutPage());
      case routeAddCustomer:
        return _buildRoute(routeAddCustomer, const AddCustomerScreen());
      case routeSearch:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeSearch,
            SearchScreen(
              searchKey: routeArguments.searchKey,
            ));
      case routeSubCategory:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeSubCategory,
            SubCategoryScreen(
              catId: routeArguments.catId,
              catName: routeArguments.catName,
            ));
      case routeOrderSuccess:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeOrderSuccess,
            OrderConfirmation(
              orderNumber: routeArguments.orderNum,
            ));
      case routeProductListing:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeProductListing,
            ProductListing(
              catId: routeArguments.catId,
              catName: routeArguments.catName,
            ));
      case routeViewAllSubCategory:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeViewAllSubCategory,
            ViewAllSubCategoryScreen(
              catId: routeArguments.catId,
              catName: routeArguments.catName,
            ));
      case routeNotification:
        return _buildRoute(routeNotification, const NotificationScreen());
      case routeCustomerEdit:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(routeCustomerEdit,
            CustomerEditScreen(custId: routeArguments.customerID));
      case routeCustomerView:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(routeCustomerView,
            CustomerViewScreen(custId: routeArguments.customerID));
      // case routeTermsAndCondition:
      //   return _buildRoute(routeTermsAndCondition, const TermsAndConditionScreen(from: '',));
      default:
        return _buildRoute(routeError, const ErrorView());
    }
  }

  Route _buildRoute(String route, Widget widget,
      {bool enableFullScreen = false}) {
    return CupertinoPageRoute(
        fullscreenDialog: enableFullScreen,
        settings: RouteSettings(name: route),
        builder: (_) => widget);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Error View")),
        body: const Center(child: Text('Page not found')));
  }
}
