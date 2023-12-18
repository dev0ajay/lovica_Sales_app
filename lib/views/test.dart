import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/providers/authentication_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/main_header_tile.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';

class DashboardScreenTest extends StatefulWidget {
  const DashboardScreenTest({Key? key}) : super(key: key);

  @override
  State<DashboardScreenTest> createState() => _DashboardScreenTestState();
}

class _DashboardScreenTestState extends State<DashboardScreenTest> {
  final ValueNotifier<bool> enableError = ValueNotifier(false);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  void initState() {
    Future.microtask(() => fetchData());
    super.initState();
  }

  Future<void> fetchData() async {}

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          drawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: SizedBox(
              width: 235.w,
              height: double.maxFinite,
              child: ListView(
                children: [Text("data")],
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 100.h,
                left: 0.0,
                child: Column(
                  children: [
                    MainHeaderTile(
                      onTap: () {
                        setState(() {
                          _isDrawerOpen = !_isDrawerOpen;
                        });
                      },
                    )
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                top: 0.0,
                bottom: 0.0,
                left:
                    _isDrawerOpen ? 0.0 : -(MediaQuery.of(context).size.width),
                child: Row(
                  children: [
                    Container(
                      width: 260.w,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30.w,
                                ),
                                onPressed: () =>
                                    setState(() => _isDrawerOpen = false),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 98.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.customers,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.products,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.sales,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.reports,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.tracking,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          Constants.settings,
                                          style: FontPalette.whihte16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
