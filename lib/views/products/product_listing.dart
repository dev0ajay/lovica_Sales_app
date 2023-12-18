import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/providers/cart_provider.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:lovica_sales_app/widgets/main_header_tile.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../generated/assets.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../providers/category_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/common_header_tile.dart';
import '../dashboard/category_card.dart';
import '../products/product_tile.dart';
import 'product_tile_expanded.dart';

class ProductListing extends StatefulWidget {
  const ProductListing(
      {super.key,
      this.catId,
      this.catName,
      this.isDetailView = false,
      this.subCatChildName = ""});

  final String? catId;
  final String? catName;
  final String? subCatChildName;
  final bool isDetailView;

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<int> pageNo = ValueNotifier<int>(1);
  int? totalLength;
  bool _isDrawerOpen = false;
  final TextEditingController searchController = TextEditingController();
  int? mainCategoryCount = 0;
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);

  void _scollListen(ProductProvider productProvider) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (productProvider.totPdtCount! >
            productProvider.totPdtCountAftrPagination!) {
          pageStartCount.value = pageStartCount.value + 20;
          productProvider.getProductList(
              searchString: "",
              context: context,
              catId: "0",
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });
  }

  @override
  void initState() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _scollListen(productProvider);
    Future.microtask(() {
      productProvider
        ..initPage()
        ..getProductList(
            searchString: "",
            context: context,
            catId: widget.catId ?? "0",
            start: 0,
            initialLoad: true);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Consumer4<CategoryProvider, ProductProvider, CartProvider,
                  AppLocalizationProvider>(
              builder: (context, value, pValue, cValue, lP, child) {
            return Stack(
              children: [
                buildBody(pValue, cValue, value, context),
                buildPositionedCustomAppBar(),
                AppData.appLocale == "ar"
                    ? buildAnimatedPositionedDrawer1(context)
                    : buildAnimatedPositionedDrawer2(context),
              ],
            );
          }),
        ),

        // appBar: CommonAppBar(),
      ),
    );
  }

  ///Method for scaffold body
  NetworkConnectivity buildBody(ProductProvider pValue, CartProvider cValue,
      CategoryProvider value, BuildContext context) {
    return NetworkConnectivity(
      inAsyncCall: pValue.loaderState == LoadState.loading ||
          cValue.loaderState == LoadState.loading && !pValue.paginationLoader,
      child: pValue.productModel != null &&
              (pValue.productList?.isNotEmpty ?? true)
          ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.h,
                    ),
                    HeaderTile(
                      showGridIcon: true,
                      showAppIcon: false,
                      showElevation: false,
                      title: widget.catName,
                      showDetailIcon: value.isDetailView,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                      onTapGridDetail: () {
                        value.updateIsDetailView(true);
                      },
                      onTapGrid: () {
                        value.updateIsDetailView(false);
                      },
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            children: [
                              Text(
                                Constants.home,
                                style: FontPalette.grey10Italic,
                              ),
                              Text(" / ", style: FontPalette.grey10Italic),
                              Text(widget.catName ?? "",
                                  style: FontPalette.grey10Italic),
                              Text(
                                widget.subCatChildName!.isNotEmpty
                                    ? " / ${widget.subCatChildName}"
                                    : "",
                                style: FontPalette.grey10Italic,
                              ),
                              // const Spacer(
                              //   flex: 1,
                              // ),
                            ],
                          ),
                      ),
                    ),
                    /*Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15.w),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            Constants.home,
                                            style: FontPalette.grey10Italic,
                                          ),
                                          Text(" / ",
                                              style: FontPalette.grey10Italic),
                                          Text(widget.catName ?? "",
                                              style: FontPalette.grey10Italic),
                                          Text(
                                              widget.subCatChildName!.isNotEmpty
                                                  ? " / ${widget.subCatChildName}"
                                                  : "",
                                              style: FontPalette.grey10Italic)
                                        ],
                                      ),
                                    ),*/

                    SizedBox(
                      height: 21.h,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: CupertinoScrollbar(
                            thickness: 3,
                            thumbVisibility: false,
                            controller: scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, bottom: 10),
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
                                        Product? product =
                                            pValue.productList?[index];

                                        if (product == null) {
                                          return const SizedBox();
                                        }

                                        if (value.isDetailView) {
                                          return ProductCardExpanded(
                                            product: product,
                                            onTap: () {
                                              Future.microtask(() {
                                                context
                                                    .read<ProductProvider>()
                                                    .getProductDetails(
                                                        context: context,
                                                        productId:
                                                            product.productId)
                                                    .then((value) {
                                                  if (value) {
                                                    Future.microtask(() =>
                                                        ReusableWidgets
                                                            .modalBottomSheet(
                                                                context));
                                                  }
                                                });
                                              });
                                            },
                                            isDetailed: false,
                                          );
                                        }

                                        return ProductCard(
                                          product: product,
                                          onTap: () {
                                            Future.microtask(() {
                                              context
                                                  .read<ProductProvider>()
                                                  .getProductDetails(
                                                      context: context,
                                                      productId:
                                                          product.productId)
                                                  .then((value) {
                                                if (value) {
                                                  Future.microtask(() =>
                                                      ReusableWidgets
                                                          .modalBottomSheet(
                                                              context));
                                                }
                                              });
                                            });
                                          },
                                          isDetailed: false,
                                        );
                                      },
                                      childCount: pValue.productList?.length,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            // childAspectRatio: 1 /2,
                                            crossAxisSpacing:
                                                value.isDetailView ? 20.w : 26.w,
                                            mainAxisSpacing:
                                                value.isDetailView ? 20.h : 9.h,
                                            mainAxisExtent: value.isDetailView
                                                ? 230.h
                                                : 130.h,
                                            crossAxisCount:
                                                value.isDetailView ? 2 : 3),
                                  ),
                                  SliverPadding(
                                      padding: EdgeInsets.only(
                                          top: 5.h, left: 20.w, right: 20.w)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : pValue.productModel != null && (pValue.productList?.isEmpty ?? true)
              ? Center(
                  child: CommonErrorWidget(
                      types: ErrorTypes.noDataFound,
                      buttonText: Constants.backHome,
                      onTap: () {
                        NavRoutes.navToDashboard(context);
                      }))
              : pValue.loaderState == LoadState.error
                  ? Center(
                      child: CommonErrorWidget(
                          types: ErrorTypes.serverError,
                          buttonText: Constants.backHome,
                          onTap: () {
                            NavRoutes.navToDashboard(context);
                          }),
                    )
                  : pValue.loaderState == LoadState.networkErr
                      ? Center(
                          child: CommonErrorWidget(
                              types: ErrorTypes.networkErr,
                              buttonText: Constants.backHome,
                              onTap: () {
                                NavRoutes.navToDashboard(context);
                              }),
                        )
                      : SizedBox(),
    );
  }

  ///method for creating positioned AppBar
  Positioned buildPositionedCustomAppBar() {
    return Positioned(
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
    );
  }

  ///Method for Drawer
  AnimatedPositioned buildAnimatedPositionedDrawer2(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      top: 0.0,
      // bottom: 0.0,
      left: _isDrawerOpen ? 0.0 : -(MediaQuery.of(context).size.width),
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.8),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10.r)),
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
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.transparent,
                                size: 30.w,
                              ),
                              onPressed: () =>
                                  setState(() => _isDrawerOpen = false),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                Assets.iconsCustomersIcon,
                                                height: 15.h,
                                                width: 15.h,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                Constants.customers,
                                                style: FontPalette
                                                    .whihte16RegularHeight0,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
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
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToCustomers(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                Assets.iconsEarningsIcon,
                                                height: 15.h,
                                                width: 15.h,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                Constants.sales,
                                                style: FontPalette
                                                    .whihte16RegularHeight0,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
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
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToSales(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                Assets.iconsReports,
                                                height: 15.h,
                                                width: 15.h,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                Constants.reports,
                                                style: FontPalette
                                                    .whihte16RegularHeight0,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
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
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToReports(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                Assets.iconsTrackingIcon,
                                                height: 15.h,
                                                width: 15.h,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                Constants.tracking,
                                                style: FontPalette
                                                    .whihte16RegularHeight0,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
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
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToTracking(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                Assets.iconsSettingIcon,
                                                height: 15.h,
                                                width: 15.h,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                Constants.settings,
                                                style: FontPalette
                                                    .whihte16RegularHeight0,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
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
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToSettings(context);
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

  ///Method for drawer
  AnimatedPositioned buildAnimatedPositionedDrawer1(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      top: 0.0,
      // bottom: 0.0,
      right: _isDrawerOpen ? 0.0 : -(MediaQuery.of(context).size.width),
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.8),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10.r)),
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
                              onPressed: () =>
                                  setState(() => _isDrawerOpen = false),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Constants.customers,
                                                  style: FontPalette
                                                      .whihte16RegularHeight0,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(width: 15.w),
                                                Image.asset(
                                                  Assets.iconsCustomersIcon,
                                                  height: 15.h,
                                                  width: 15.h,
                                                  fit: BoxFit.contain,
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    ReusableWidgets.divider(
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToCustomers(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),

                              /// commented all pdts

                              /*   InkWell(
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
                                                          Icon(
                                                            Icons
                                                                .arrow_back_ios_new,
                                                            color: Colors.white,
                                                            size: 15.w,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                Constants
                                                                    .products,
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
                                                                    .iconsProductsIcon,
                                                                height: 15.h,
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
                                                NavRoutes.navToProductListing(
                                                    context,
                                                    catId: "0",
                                                    catName:
                                                        Constants.allProducts);
                                              },
                                            ),
                                            SizedBox(
                                              height: 22.h,
                                            ),*/
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Constants.sales,
                                                  style: FontPalette
                                                      .whihte16RegularHeight0,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Image.asset(
                                                  Assets.iconsEarningsIcon,
                                                  height: 15.h,
                                                  width: 15.h,
                                                  fit: BoxFit.contain,
                                                )
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    ReusableWidgets.divider(
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToSales(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Constants.reports,
                                                  style: FontPalette
                                                      .whihte16RegularHeight0,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Image.asset(
                                                  Assets.iconsReports,
                                                  height: 15.h,
                                                  width: 15.h,
                                                  fit: BoxFit.contain,
                                                )
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    ReusableWidgets.divider(
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToReports(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Constants.tracking,
                                                  style: FontPalette
                                                      .whihte16RegularHeight0,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Image.asset(
                                                  Assets.iconsTrackingIcon,
                                                  height: 15.h,
                                                  width: 15.h,
                                                  fit: BoxFit.contain,
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    ReusableWidgets.divider(
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToTracking(context);
                                },
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Colors.white,
                                              size: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  Constants.settings,
                                                  style: FontPalette
                                                      .whihte16RegularHeight0,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Image.asset(
                                                  Assets.iconsSettingIcon,
                                                  height: 15.h,
                                                  width: 15.h,
                                                  fit: BoxFit.contain,
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    ReusableWidgets.divider(
                                        color: Colors.white, height: 1.h)
                                  ],
                                ),
                                onTap: () {
                                  setState(() => _isDrawerOpen = false);
                                  NavRoutes.navToSettings(context);
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
