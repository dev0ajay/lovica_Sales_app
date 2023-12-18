import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/views/splash.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'common/color_palette.dart';
import 'common/route_generator.dart';
import 'providers/localization_provider.dart';
import 'services/multi_providers_list.dart';

class LovicaApp extends StatelessWidget {

  const LovicaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: OverlaySupport.global(child:
          Consumer<AppLocalizationProvider>(builder: (context, locale, child) {
        return MaterialApp(
          navigatorKey: AppData.navigatorKey,
          home: const SplashScreen(),
          initialRoute: RouteGenerator.routeInitial,
          title: 'Lovica',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
              primarySwatch: ColorPalette.materialPrimary,
              fontFamily: FontPalette.themeFont,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  systemOverlayStyle: Platform.isIOS
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark),
              textSelectionTheme:
                  const TextSelectionThemeData(cursorColor: Colors.black)),
          onGenerateRoute: (settings) =>
              RouteGenerator().generateRoute(settings),
        );
      })),
    );
  }
}
