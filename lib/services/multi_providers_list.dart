import 'package:lovica_sales_app/providers/category_provider.dart';
import 'package:lovica_sales_app/providers/notification_provider.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/authentication_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/check_out_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/localization_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => AppLocalizationProvider()),
    ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => CustomerProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => CheckOutProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (context) {
      ConnectivityProvider changeNotifier = ConnectivityProvider();
      changeNotifier.initialLoad();
      return changeNotifier;
    }),
  ];
}
