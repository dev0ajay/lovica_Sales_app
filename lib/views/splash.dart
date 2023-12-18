import 'dart:async';
import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/providers/authentication_provider.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '../common/color_palette.dart';
import '../common/constants.dart';
import '../common/helpers.dart';
import '../common/nav_routes.dart';
import '../models/push_notif_model.dart';
import '../providers/notification_provider.dart';
import '../services/shared_preference_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<bool> enableError = ValueNotifier(false);
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  late Timer? _timer;
  String? asset = Assets.iconsLovicaAppIconBlack;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationProvider.setContext(context);
    });
    _timer = Timer(const Duration(milliseconds: 1500), () async {
      setState(() {
        asset = Assets.iconsLovicaAppIconLarge;
      });
    });

    registerNotification();
    checkForInitialMessage();
    firebaseInit();
    Future.microtask(() => initialFetch());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    super.dispose();
  }



  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;
    _messaging.subscribeToTopic("messaging");
    FirebaseMessaging fm = FirebaseMessaging.instance;
    fm.getToken().then((token) {
      print("token is $token");
      AppData.fcm = token ?? "";
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'registerNotification A new onMessageOpenedApp event was published!');
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('registerNotification User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'registerNotification Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        if (AppData.navigatorKey.currentContext != null) {
          BuildContext buildContext = AppData.navigatorKey.currentContext!;
          final notificationProvider =
              Provider.of<NotificationProvider>(buildContext, listen: false);
          Future.microtask(() {
            notificationProvider
              ..clearList()
              ..getNotificationList(
                  context: buildContext, limit: 0, start: 0, initialLoad: true);
          });
        }

        _notificationInfo = notification;

        if (_notificationInfo != null) {
          /// For displaying the notification as an overlay
          showOverlayNotification((context) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                    leading: SizedBox.fromSize(
                        size: const Size(40, 40),
                        child: ClipOval(
                            child: Container(
                          color: Colors.grey,
                        ))),
                    title: Text(_notificationInfo!.title!),
                    subtitle: Text(_notificationInfo!.body!),
                    trailing: InkWell(
                      child: const Text(
                        "Dismiss",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        OverlaySupportEntry.of(context)!.dismiss();
                      },
                    ),
                ),
              ),
            );
          }, duration: const Duration(milliseconds: 4000),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }



  void firebaseInit() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      print(
          'firebaseInit onMessageOpenedApp :: Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      // final notificationProvider =
      // Provider.of<NotificationProvider>(context, listen: false);
      // Future.microtask(() {
      //   notificationProvider..clearList()..getNotificationList(
      //       context: context, limit: 0, start: 0, initialLoad: true);
      // });
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    // final notificationProvider =
    // Provider.of<NotificationProvider>(context, listen: false);
    // Future.microtask(() {
    //   notificationProvider..clearList()..getNotificationList(
    //       context: context, limit: 0, start: 0, initialLoad: true);
    // });
    // await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      print(
          'checkForInitialMessage _firebaseMessagingBackgroundHandler :: Message title: ${notification.title}, body: ${notification.body}');

/*      setState(() {
        _notificationInfo = notification;
        textToShow =
            "Notification :- context - InitialMessage, title - ${initialMessage.notification?.title}";
      });*/
    }
  }

  Future<void> initialFetch() async {
    final network = await Helpers.isInternetAvailable(enableToast: false);
    if (network) {
      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Expanded(
              child:
                  Text(Constants.noInternet, style: FontPalette.black10Regular),
            ),
            SizedBox(width: 10.w),
            IconButton(
                onPressed: () async {
                  final network =
                      await Helpers.isInternetAvailable(enableToast: false);
                  if (network) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    fetchData();
                  }
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        duration: const Duration(days: 1),
        backgroundColor: HexColor('#FF5353'),
      ));
    }
  }

  Future<void> fetchData() async {
    final appLocaleProvider =
        Provider.of<AppLocalizationProvider>(context, listen: false);
    Future.microtask(() => appLocaleProvider.getLabels(context: context))
        .then((value) async {
      if (value) {
        String? locale = await Devicelocale.currentLocale;

        if (locale != null) {
          String localeLower = locale.trim().toLowerCase();
          appLocaleProvider
              .updateLanguage(localeLower.contains("ar") ? "ar" : "en")
              // .updateLanguage("ar")
              .then((value) => {
                    appLocaleProvider.updateLabels(context).then((value) => {
                          SharedPreferencesHelper.getHeaderToken()
                              .then((value) async {
                            if (value.isNotEmpty) {
                              AppData.accessToken = value;

                              /// User is logged in
                              SharedPreferencesHelper.getUserDataUpdatedStatus()
                                  .then((value) async {
                                if (value) {
                                  /// data updated
                                  await navToPersonalDetails(context);
                                } else {
                                  Future.microtask(() =>
                                      context.read<AuthenticationProvider>()
                                        ..getProfile(context: context)
                                        ..getCartCount(context: context));
                                  Future.microtask(() => context
                                      .read<NotificationProvider>()
                                      .getNotificationList(
                                          context: context,
                                          start: 0,
                                          limit: 0));
                                  await navToMainPage(context);
                                  // await navToPersonalDetails(context);
                                }
                              });
                            } else {
                              await navToLogIn(context);
                            }
                          })
                        })
                  });
        } else {
          appLocaleProvider.updateLanguage("en").then((value) => {
                appLocaleProvider.updateLabels(context).then((value) => {
                      SharedPreferencesHelper.getHeaderToken()
                          .then((value) async {
                        if (value.isNotEmpty) {
                          AppData.accessToken = value;

                          /// User is logged in
                          SharedPreferencesHelper.getUserDataUpdatedStatus()
                              .then((value) async {
                            if (value) {
                              /// data updated
                              await navToPersonalDetails(context);
                            } else {
                              Future.microtask(
                                  () => context.read<AuthenticationProvider>()
                                    ..getProfile(context: context)
                                    ..getCartCount(context: context));
                              await navToMainPage(context);
                            }
                          });
                        } else {
                          await navToLogIn(context);
                        }
                      })
                    })
              });
        }
      }
    });
  }

  Future<void> navToLogIn(BuildContext context) async {
    NavRoutes.navToLogIn(context);
  }

  Future<void> navToMainPage(BuildContext context) async {
    NavRoutes.navToDashboard(context);
  }

  Future<void> navToPersonalDetails(BuildContext context) async {
    NavRoutes.navToPersonalDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: asset == Assets.iconsLovicaAppIconBlack
                      ? SizedBox(
                          height: 206.h,
                          width: 217.w,
                          child: Image.asset(asset ?? ""))
                      : SizedBox(
                          height: 306.h,
                          width: 432.w,
                          child: Image.asset(asset ?? "")),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.black,
                        statusBarIconBrightness: Platform.isIOS
                            ? Brightness.light
                            : Brightness.light,
                        statusBarBrightness:
                            Platform.isIOS ? Brightness.dark : Brightness.dark,
                        systemNavigationBarIconBrightness:
                            Platform.isIOS ? Brightness.light : Brightness.dark,
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      '_firebaseMessagingBackgroundHandler :: Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

  // Parse the message received
  PushNotification notification = PushNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    dataTitle: message.data['title'],
    dataBody: message.data['body'],
  );
}
