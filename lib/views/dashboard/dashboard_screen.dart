import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/models/category_model.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/views/dashboard/category_card.dart';
import 'package:lovica_sales_app/widgets/main_header_tile.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common_error_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  final ValueNotifier<bool> enableError = ValueNotifier(false);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  ScrollController? scrollController = ScrollController();
  int? mainCategoryCount = 0;

  @override
  void initState() {
    // Future.microtask(() => context
    //     .read<CategoryProvider>()
    //     .getcategoryList(context: context, catId: "0"));

    ///Will be called only once after Build widgets done with rendering.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<CategoryProvider>()
          .getcategoryList(context: context, catId: "0");
    });
    super.initState();
  }

  Future<void> fetchData() async {}

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Consumer2<CategoryProvider, AppLocalizationProvider>(
            builder: (context, value, lp, child) {
          if (value.categories != null &&
              (value.categories?.mainCategoryList?.isNotEmpty ?? true)) {
            mainCategoryCount = value.categories?.mainCategoryList?.length;
          }
          return Stack(
            children: <Widget>[
              NetworkConnectivity(
                inAsyncCall: value.loaderState == LoadState.loading,
                child: value.categories != null &&
                        (value.categories?.mainCategoryList?.isNotEmpty ?? true)
                    ?
                    ///Dashboard body
                buildDashboardBody(value)
                    : value.categories != null &&
                            (value.categories?.mainCategoryList?.isEmpty ??
                                true)
                        ?  Center(
                            child: CommonErrorWidget(
                            types: ErrorTypes.noDataFound,
                              buttonText: Constants.refresh,
                              onTap:(){
                                Future.microtask(() => context
                                    .read<CategoryProvider>()
                                    .getcategoryList(context: context, catId: "0"),
                                );
                              },
                          ))
                        : value.loaderState == LoadState.error
                            ?  Center(
                                child: CommonErrorWidget(
                                  types: ErrorTypes.serverError,
                                    buttonText: Constants.refresh,
                                    onTap:(){
                                      Future.microtask(() => context
                                          .read<CategoryProvider>()
                                          .getcategoryList(context: context, catId: "0"));
                                    }
                                ),
                              )
                            : value.loaderState == LoadState.networkErr
                                ?  Center(
                                    child: CommonErrorWidget(
                                      types: ErrorTypes.networkErr,
                                        buttonText: Constants.refresh,
                                        onTap:(){
                                          Future.microtask(() => context
                                              .read<CategoryProvider>()
                                              .getcategoryList(context: context, catId: "0"));
                                        }
                                    ),
                                  )
                                : SizedBox(height: context.sh(),width:  context.sh(),),
              ),
              ///Custom App Bar
              Positioned(
                top: 0.0,
                left: 0.0,
                child: Column(
                  children: [
                    MainHeaderTileRevamp(
                      onTap: () {
                        setState(() {
                          _isDrawerOpen = !_isDrawerOpen;
                        });
                      },
                    )
                  ],
                ),
              ),
              AppData.appLocale == "ar"
                  ? buildAnimatedPositionedDrawer1(context)
                  : buildAnimatedPositionedDrawer2(context),
            ],
          );
        }),
        // appBar: CommonAppBar(),
      ),
    );
  }

  Column buildDashboardBody(CategoryProvider value) {
    return Column(
                    children: [
                      SizedBox(
                        height: 100.h
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: CupertinoScrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          child: Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: CustomScrollView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              controller: scrollController,
                              slivers: [
                                SliverPadding(
                                    padding: EdgeInsets.only(top: 5.h)),
                                SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      MainCategory? category =
                                          value.categoryList?[index];

                                      if (category == null) {
                                        return const SizedBox();
                                      }
                                      return CategoryCard(
                                        category: category,
                                        colorBackground:
                                            value.selectedCategoryId ==
                                                    category.categoryId
                                                ? Colors.black
                                                : Colors.white,
                                        colorIcon:
                                            value.selectedCategoryId ==
                                                    category.categoryId
                                                ? Colors.white
                                                : Colors.black,
                                        onTap: () {
                                          value.updateSelectedCategory(
                                              category.categoryId);
                                          if (category.isChild != null &&
                                              category.isChild
                                                      .toString()
                                                      .trim()
                                                      .toLowerCase() ==
                                                  "yes") {
                                            setState(() =>
                                                _isDrawerOpen = false);
                                            NavRoutes.navToSubCategory(
                                                context,
                                                catId:
                                                    category.categoryId,
                                                catName: AppData
                                                            .appLocale ==
                                                        "ar"
                                                    ? category
                                                        .categoryNameArabic
                                                    : category
                                                        .categoryName);
                                          } else {
                                            setState(() =>
                                                _isDrawerOpen = false);
                                            NavRoutes.navToProductListing(
                                                context,
                                                catId:
                                                    category.categoryId,
                                                catName: category
                                                    .categoryName);
                                          }
                                        },
                                      );
                                    },
                                    childCount:
                                        value.categoryList!.length,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1 / 2,
                                          crossAxisSpacing: 19.w,
                                          mainAxisSpacing: 5.h,
                                          mainAxisExtent: 125.h,
                                          crossAxisCount: 3),
                                ),
                                SliverPadding(
                                    padding: EdgeInsets.only(top: 5.h)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
  }
///Method for Dashboard Screen Menu Drawer
  //
  AnimatedPositioned buildAnimatedPositionedDrawer2(BuildContext context) {
    return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              top: 0.0,
              // bottom: 0.0,
              left: _isDrawerOpen
                  ? 0.0
                  : -(MediaQuery.of(context).size.width),
              child: InkWell(
                onTap: () {
                  setState(() => _isDrawerOpen = false);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Container(
                          width: 260.w,
                          height:
                          MediaQuery.of(context).size.height *
                              0.6,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.8),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.r)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.black.withOpacity(0.3),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5.h),
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.transparent,
                                        size: 30.w,
                                      ),
                                      onPressed: () => setState(
                                              () => _isDrawerOpen =
                                          false),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                  EdgeInsets.only(top: 35.h),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .iconsCustomersIcon,
                                                        height:
                                                        15.h,
                                                        width: 15.h,
                                                        fit: BoxFit
                                                            .contain,
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Text(
                                                        Constants
                                                            .customers,
                                                        style: FontPalette
                                                            .whihte16RegularHeight0,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color: Colors
                                                        .white,
                                                    size: 15.w,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen =
                                          false);
                                          NavRoutes.navToCustomers(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),

                                      /// commented all pdts
                                      /* InkWell(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              Assets
                                                                  .iconsProductsIcon,
                                                              height: 15.h,
                                                              width: 15.h,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            SizedBox(
                                                              width: 15.w,
                                                            ),
                                                            Text(
                                                              Constants
                                                                  .products,
                                                              style: FontPalette
                                                                  .whihte16RegularHeight0,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white,
                                                          size: 15.w,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  ReusableWidgets.divider(
                                                      color: Colors.white,
                                                      height: 1.h)
                                                ],
                                              ),
                                              onTap: () {
                                                setState(() =>
                                                    _isDrawerOpen = false);
                                                NavRoutes.navToProductListing(
                                                    context,
                                                    catId: "0",
                                                    catName: Constants
                                                        .allProducts);
                                              },
                                            ),
                                            SizedBox(
                                              height: 22.h,
                                            ),*/
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .iconsEarningsIcon,
                                                        height:
                                                        15.h,
                                                        width: 15.h,
                                                        fit: BoxFit
                                                            .contain,
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Text(
                                                        Constants
                                                            .sales,
                                                        style: FontPalette
                                                            .whihte16RegularHeight0,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color: Colors
                                                        .white,
                                                    size: 15.w,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen =
                                          false);
                                          NavRoutes.navToSales(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .iconsReports,
                                                        height:
                                                        15.h,
                                                        width: 15.h,
                                                        fit: BoxFit
                                                            .contain,
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Text(
                                                        Constants
                                                            .reports,
                                                        style: FontPalette
                                                            .whihte16RegularHeight0,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color: Colors
                                                        .white,
                                                    size: 15.w,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen =
                                          false);
                                          NavRoutes.navToReports(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .iconsTrackingIcon,
                                                        height:
                                                        15.h,
                                                        width: 15.h,
                                                        fit: BoxFit
                                                            .contain,
                                                      ),
                                                      SizedBox(
                                                        width: 15.w
                                                      ),
                                                      Text(
                                                        Constants
                                                            .tracking,
                                                        style: FontPalette
                                                            .whihte16RegularHeight0,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color: Colors
                                                        .white,
                                                    size: 15.w,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen =
                                          false);
                                          NavRoutes.navToTracking(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .iconsSettingIcon,
                                                        height:
                                                        15.h,
                                                        width: 15.h,
                                                        fit: BoxFit
                                                            .contain,
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Text(
                                                        Constants
                                                            .settings,
                                                        style: FontPalette
                                                            .whihte16RegularHeight0,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios,
                                                    color: Colors
                                                        .white,
                                                    size: 15.w,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen =
                                          false);
                                          NavRoutes.navToSettings(
                                              context);
                                        },
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }

  AnimatedPositioned buildAnimatedPositionedDrawer1(BuildContext context) {
    return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              top: 0.0,
              // bottom: 0.0,
              right: _isDrawerOpen
                  ? 0.0
                  : -(MediaQuery.of(context).size.width),
              child: InkWell(
                onTap: () {
                  setState(() => _isDrawerOpen = false);
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Container(
                          width: 260.w,
                          height: MediaQuery.of(context).size.height *
                              0.6,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.8),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.r)),
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
                                height: 15.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5.h),
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.transparent,
                                        size: 30.w,
                                      ),
                                      onPressed: () => setState(() =>
                                      _isDrawerOpen = false),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 35.h),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_back_ios_new,
                                                      color: Colors
                                                          .white,
                                                      size: 15.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          Constants
                                                              .customers,
                                                          style: FontPalette
                                                              .whihte16RegularHeight0,
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        SizedBox(
                                                          width: 15.w
                                                        ),
                                                        Image.asset(
                                                          Assets
                                                              .iconsCustomersIcon,
                                                          height:
                                                          15.h,
                                                          width: 15.h,
                                                          fit: BoxFit
                                                              .contain,
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 8.h
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen = false);
                                          NavRoutes.navToCustomers(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),

                                      /// commented all pdts

                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_back_ios_new,
                                                      color: Colors
                                                          .white,
                                                      size: 15.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          Constants
                                                              .sales,
                                                          style: FontPalette
                                                              .whihte16RegularHeight0,
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Image.asset(
                                                          Assets
                                                              .iconsEarningsIcon,
                                                          height:
                                                          15.h,
                                                          width: 15.h,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 8.h
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen = false);
                                          NavRoutes.navToSales(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_back_ios_new,
                                                      color: Colors
                                                          .white,
                                                      size: 15.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          Constants
                                                              .reports,
                                                          style: FontPalette
                                                              .whihte16RegularHeight0,
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        SizedBox(
                                                          width: 15.w
                                                        ),
                                                        Image.asset(
                                                          Assets
                                                              .iconsReports,
                                                          height:
                                                          15.h,
                                                          width: 15.h,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen = false);
                                          NavRoutes.navToReports(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_back_ios_new,
                                                      color: Colors
                                                          .white,
                                                      size: 15.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          Constants
                                                              .tracking,
                                                          style: FontPalette
                                                              .whihte16RegularHeight0,
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Image.asset(
                                                          Assets
                                                              .iconsTrackingIcon,
                                                          height:
                                                          15.h,
                                                          width: 15.h,
                                                          fit: BoxFit
                                                              .contain,
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen = false);
                                          NavRoutes.navToTracking(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  12.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_back_ios_new,
                                                      color: Colors
                                                          .white,
                                                      size: 15.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          Constants
                                                              .settings,
                                                          style: FontPalette
                                                              .whihte16RegularHeight0,
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Image.asset(
                                                          Assets
                                                              .iconsSettingIcon,
                                                          height:
                                                          15.h,
                                                          width: 15.h,
                                                          fit: BoxFit
                                                              .contain,
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            ReusableWidgets.divider(
                                                color: Colors.white,
                                                height: 1.h)
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() =>
                                          _isDrawerOpen = false);
                                          NavRoutes.navToSettings(
                                              context);
                                        },
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }

}
