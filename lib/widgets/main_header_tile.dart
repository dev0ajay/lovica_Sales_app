import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/providers/authentication_provider.dart';
import 'package:lovica_sales_app/providers/cart_provider.dart';
import 'package:lovica_sales_app/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import '../common/color_palette.dart';
import '../common/constants.dart';
import '../common/nav_routes.dart';
import '../services/app_data.dart';

class MainHeaderTile extends StatelessWidget {
  final String? title;
  final Function()? onTap;

  const MainHeaderTile({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 27.h,
              width: 37.h,
              child: Image.asset(Assets.iconsMenuIcon),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: Image.asset(Assets.iconsNotifIcon),
                ),
                Consumer<AuthenticationProvider>(builder: (context, model, _) {
                  String count =
                      model.notifCount == null ? '0' : '${model.cartCount}';
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                    ),
                    child: model.notifCount == 0
                        ? const SizedBox()
                        : Material(
                            child: Container(
                                height: 15.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor('#C40000'),
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.80),
                                    child: Text(
                                      count,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: 36.h,
              width: 110.h,
              child: Image.asset(Assets.iconsLovicaAppIconSmall),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: () {
              NavRoutes.navToSearch(context, "");
            },
            child: SizedBox(
              height: 20.h,
              width: 20.h,
              child: Image.asset(Assets.iconsSearchIcon),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: () async {
              String barcodeScanRes;
              try {
                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                print("barcodeScanRes :: ${barcodeScanRes}");
                Future.microtask(
                    () => NavRoutes.navToSearch(context, barcodeScanRes));
              } on PlatformException {
                barcodeScanRes = 'Failed to get platform version.';
              }
              // if (!mounted) return;
            },
            child: SizedBox(
              height: 27.h,
              width: 20.h,
              child: Image.asset(Assets.iconsScannerIcon),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: () {
              Future.microtask(() => NavRoutes.navToCartPage(context));
            },
            child: Stack(
              children: [
                SizedBox(
                  height: 30.h,
                  width: 30.h,
                  child: Image.asset(Assets.iconsCartIcon),
                ),
                Consumer<AuthenticationProvider>(builder: (context, model, _) {
                  String count =
                      model.cartCount == null ? '0' : '${model.cartCount}';
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                    ),
                    child: model.cartCount == 0
                        ? const SizedBox()
                        : Material(
                            child: Container(
                                height: 15.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor('#040707'),
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.80),
                                    child: Text(
                                      count,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MainHeaderTileRevamp extends StatelessWidget {
  final String? title;
  final Function()? onTap;

  const MainHeaderTileRevamp({Key? key, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Center(
            child: Padding(
              padding:  const EdgeInsets.all(0.0),
              child: Container(
                height: 70.h,
                margin:  EdgeInsets.only(bottom: 6.h), //Same as `blurRadius` i guess
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r), ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.r,
                    ),
                  ],
                ),
                child: AppData.appLocale != "ar"
                    ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: InkWell(
                        onTap: onTap,
                        child: Image.asset(
                          Assets.iconsMenuIcon,
                          height: 25.h,
                          width: 25.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () {
                          Future.microtask(
                                  () => NavRoutes.navToNotifications(context));
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.iconsNotifIcon,
                              height: 25.h,
                              width: 25.w,
                              fit: BoxFit.contain,
                            ),
                            Consumer2<AuthenticationProvider,NotificationProvider>(
                                builder: (context, model,nModel, _) {
                                  // String count = model.notifCount == null
                                  //     ? '0'
                                  //     : '${model.cartCount}';
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 14.w,
                                    ),
                                    child: nModel.unreadMessagesFound==false
                                        ? const SizedBox()
                                        : Material(
                                      child: Container(
                                          height: 10.h,
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('#C40000'),
                                          ),
                                          alignment: Alignment.center,
                                          child: const FittedBox(
                                            child: Padding(
                                              padding:
                                              EdgeInsets.all(0.80),
                                              child: Text(
                                                " ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              Assets.iconsLovicaAppIconSmall,
                              width: 110.w,
                              height: 46.h,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                          onTap: () {
                            NavRoutes.navToSearch(context, "");
                          },
                          child: Image.asset(
                            Assets.iconsSearchIcon,
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.contain,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () async {
                          String barcodeScanRes;
                          try {
                            barcodeScanRes =
                            await FlutterBarcodeScanner.scanBarcode(
                                '#ff6666',
                                'Cancel',
                                true,
                                ScanMode.BARCODE);
                            print("barcodeScanRes :: ${barcodeScanRes}");
                            Future.microtask(() =>
                                NavRoutes.navToSearch(context, barcodeScanRes));
                          } on PlatformException {
                            barcodeScanRes = 'Failed to get platform version.';
                          }
                          // if (!mounted) return;
                        },
                        child: Image.asset(
                          Assets.iconsScannerIcon,
                          width: 30.w,
                          height: 25.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () {
                          Future.microtask(
                                  () => NavRoutes.navToCartPage(context));
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.iconsCartIcon,
                              width: 23.w,
                              height: 25.h,
                              fit: BoxFit.contain,
                            ),
                            Consumer<AuthenticationProvider>(
                                builder: (context, model, _) {
                                  String count = model.cartCount == null
                                      ? '0'
                                      : '${model.cartCount}';
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 14.w,
                                    ),
                                    child: model.cartCount == 0
                                        ? const SizedBox()
                                        : Material(
                                      child: Container(
                                          height: 15.h,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('#040707'),
                                          ),
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(0.80),
                                              child: Text(
                                                count,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () {
                          Future.microtask(
                                  () => NavRoutes.navToCartPage(context));
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.iconsCartIcon,
                              width: 23.w,
                              height: 25.h,
                              fit: BoxFit.contain,
                            ),
                            Consumer<AuthenticationProvider>(
                                builder: (context, model, _) {
                                  String count = model.cartCount == null
                                      ? '0'
                                      : '${model.cartCount}';
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 14.w,
                                    ),
                                    child: model.cartCount == 0
                                        ? const SizedBox()
                                        : Material(
                                      child: Container(
                                          height: 15.h,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('#040707'),
                                          ),
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(0.80),
                                              child: Text(
                                                count,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () async {
                          String barcodeScanRes;
                          try {
                            barcodeScanRes =
                            await FlutterBarcodeScanner.scanBarcode(
                                '#ff6666',
                                'Cancel',
                                true,
                                ScanMode.BARCODE);
                            print("barcodeScanRes :: ${barcodeScanRes}");
                            Future.microtask(() =>
                                NavRoutes.navToSearch(context, barcodeScanRes));
                          } on PlatformException {
                            barcodeScanRes = 'Failed to get platform version.';
                          }
                          // if (!mounted) return;
                        },
                        child: Image.asset(
                          Assets.iconsScannerIcon,
                          width: 30.w,
                          height: 25.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                          onTap: () {
                            NavRoutes.navToSearch(context, "");
                          },
                          child: Image.asset(
                            Assets.iconsSearchIcon,
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.contain,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              Assets.iconsLovicaAppIconSmall,
                              width: 110.w,
                              height: 46.h,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () {
                          Future.microtask(
                                  () => NavRoutes.navToNotifications(context));
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.iconsNotifIcon,
                              height: 25.h,
                              width: 25.w,
                              fit: BoxFit.contain,
                            ),
                            Consumer2<AuthenticationProvider,NotificationProvider>(
                                builder: (context, model,nModel, _) {
                                  // String count = model.notifCount == null
                                  //     ? '0'
                                  //     : '${model.cartCount}';
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 14.w,
                                    ),
                                    child: nModel.unreadMessagesFound == false
                                        ? const SizedBox()
                                        : Material(
                                      child: Container(
                                          height: 10.h,
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('#C40000'),
                                          ),
                                          alignment: Alignment.center,
                                          child: const FittedBox(
                                            child: Padding(
                                              padding:
                                              EdgeInsets.all(0.80),
                                              child: Text(
                                                " ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: InkWell(
                        onTap: onTap,
                        child: Image.asset(
                          Assets.iconsMenuIcon,
                          height: 25.h,
                          width: 25.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          // Card(
          //   color: Colors.white,
          //   elevation: 2,
          //   child: Container(
          //     margin: EdgeInsets.only(bottom: 8.h,top: 15.h),
          //     child: ,
          //   ),
          // ),
        ],
      ),
    );
  }
}
