import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/nav_routes.dart';

class OrderConfirmation extends StatefulWidget {
  String? orderNumber;

  OrderConfirmation({super.key, this.orderNumber});

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:
      Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                  child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Center(
                    child: SizedBox(
                      width: 110.w,
                      height: 46.h,
                      child: Image.asset(Assets.iconsLovicaAppIconSmall),
                    ),
                  ),
                ],
              )),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.orderConfirmed,
                      style: FontPalette.black36w600,
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    Text(
                      "${Constants.orderNumber} ${widget.orderNumber ?? ""}",
                      style: FontPalette.black16Italicw600,
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        // background (button) color
                        foregroundColor:
                            Colors.white, // foreground (text) color
                      ),
                      onPressed: () => NavRoutes.navToDashboard(context),
                      child: Text(
                        Constants.home,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
