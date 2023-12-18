import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/category_model.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:lovica_sales_app/widgets/main_header_tile.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/helpers.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../generated/assets.dart';
import '../../providers/category_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/common_header_tile.dart';
import '../products/product_tile.dart';
import '../products/product_tile_expanded.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key, this.catId, this.catName});
  final String? catId;
  final String? catName;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final ValueNotifier<bool> enableError = ValueNotifier(false);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool _isDrawerOpen = false;
  int? selected;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<CategoryProvider>()
          .getcategoryList(context: context, catId: widget.catId ?? "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer3<CategoryProvider, ProductProvider,
                AppLocalizationProvider>(
            builder: (context, cValue, pValue, lp, child) {
          return Stack(
            children: [
              buildBody(cValue, pValue, context),
              buildPositionedHeader(),
              AppData.appLocale == "ar"
                  ?
              buildAnimatedPositionedDrawerWidget1(context)
                  : buildAnimatedPositionedDrawerWidget2(context),
            ],
          );
        }),
        // appBar: CommonAppBar(),
      ),
    );
  }
///Body inside scaffold
  NetworkConnectivity buildBody(CategoryProvider cValue, ProductProvider pValue, BuildContext context) {
    return NetworkConnectivity(
              inAsyncCall: cValue.loaderState == LoadState.loading ||
                  pValue.loaderState == LoadState.loading,
              child: cValue.subCategories != null
                  ?
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 90.h,
                  ),
                  HeaderTile(
                    showGridIcon: false,
                    showAppIcon: false,
                    showElevation: false,
                    title: widget.catName,
                    showDetailIcon: cValue.isDetailView,
                    onTapGridDetail: () {
                      cValue.updateIsDetailView(true);
                    },
                    onTapGrid: () {
                      cValue.updateIsDetailView(false);
                    },
                    onTapBack: () => Navigator.pop(context),
                  ),

                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: AppData.appLocale == "ar"
                        ? Row(
                            children: [
                              const Spacer(
                                flex: 1,
                              ),
                              Text(widget.catName ?? "",
                                  style: FontPalette.grey10Italic),
                              Text(widget.catName ?? "",
                                  style: FontPalette.grey10Italic),
                              Text(" / ",
                                  style: FontPalette.grey10Italic),
                              Text(
                                Constants.home,
                                style: FontPalette.grey10Italic,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                Constants.home,
                                style: FontPalette.grey10Italic,
                              ),
                              Text(" / ",
                                  style: FontPalette.grey10Italic),
                              Text(widget.catName ?? "",
                                  style: FontPalette.grey10Italic)
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  cValue.subCategoryList?.isNotEmpty ?? true
                      ? Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Expanded(
                              child: CupertinoScrollbar(
                                thumbVisibility: true,
                                controller: scrollController,
                            child: ListView.builder(
                              controller: scrollController,
                              key: Key(
                                  'builder ${selected.toString()}'),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                MainCategory? category =
                                    cValue.subCategoryList?[index];
                                if (category != null) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.all(0.0),
                                    child: Column(
                                      children: [
                                        ReusableWidgets.divider(
                                            height: 1.h,
                                            color: HexColor(
                                                "#7A7A7A")),
                                        ExpansionTile(
                                          key:
                                              Key(index.toString()),
                                          //attention
                                          initiallyExpanded:
                                              index == selected,
                                          onExpansionChanged:
                                              (value) async {
                                            if (value &&
                                                index != 0) {
                                              setState(() {
                                                selected = index;
                                              });
                                            } else {
                                              setState(() {
                                                selected = -1;
                                              });
                                            }

                                            if (value) {
                                              if (index == 0) {
                                                NavRoutes.navToProductListing(
                                                    context,
                                                    catId: "0",
                                                    catName: Constants
                                                        .allProducts);
                                              } else {
                                                pValue
                                                  ..clearData()
                                                  ..getProductListForSubCategory(
                                                      context:
                                                          context,
                                                      catId: category
                                                          .categoryId,
                                                      initialLoad:
                                                          true,
                                                      // limit: 5,
                                                      start: 0);
                                                cValue
                                                  ..clearSubCategory()
                                                  ..getSubCategoryListForExpansion(
                                                      context:
                                                          context,
                                                      catId: category
                                                              .categoryId ??
                                                          "");
                                              }
                                            }
                                          },
                                          title: Text(
                                              AppData.appLocale == "ar"
                                                  ? category
                                                          .categoryNameArabic ??
                                                      ""
                                                  : category
                                                          .categoryName ??
                                                      "",
                                              style: FontPalette
                                                  .black16Regular),
                                          children: <Widget>[
                                            CustomScrollView(
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              slivers: [
                                                cValue.subCategoryForExpansion
                                                            ?.isNotEmpty ??
                                                        true
                                                    ? SliverGrid(
                                                        delegate:
                                                            SliverChildBuilderDelegate(
                                                          (ctx,
                                                              idx) {
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets.only(bottom: 3.h),
                                                              margin: EdgeInsets.only(
                                                                  left: 12.w,
                                                                  right: 12.w),
                                                              child:
                                                                  OutlinedButton(
                                                                style:
                                                                    OutlinedButton.styleFrom(
                                                                  backgroundColor: cValue.selectedCategoryIdForOutlineButton == cValue.subCategoryForExpansion![idx].categoryId ? Colors.black : Colors.transparent,
                                                                  side: BorderSide(color: idx == 5 ? Colors.white : Colors.black, width: 1), //<-- SEE HERE
                                                                ),
                                                                onPressed:
                                                                    () {
                                                                  if (idx == 5) {
                                                                    NavRoutes.navToViewAllSubCategoryScreen(context, catId: category.categoryId, catName: AppData.appLocale == "ar" ? category.categoryNameArabic : category.categoryName);
                                                                  } else if (cValue.subCategoryForExpansion![idx].categoryId != null) {
                                                                    // NavRoutes.navToProductListing(
                                                                    //   context,
                                                                    //   catId: cValue.subCategoryForExpansion![idx].categoryId ?? "",
                                                                    //   catName: AppData.appLocale == "ar" ? category.categoryNameArabic : category.categoryName,
                                                                    //   subCatChildName: AppData.appLocale == "ar" ? cValue.subCategoryForExpansion![idx].categoryNameArabic : cValue.subCategoryForExpansion![idx].categoryName,
                                                                    // );
                                                                    cValue.updateCategoryIdForOutlineButton(cValue.subCategoryForExpansion![idx].categoryId);
                                                                    pValue
                                                                      ..clearPdtForOutlineButton()
                                                                      ..updateOulineCategory(cValue.subCategoryForExpansion![idx])
                                                                      ..getProductListForOutlineButtonCategory(context: context, catId: cValue.subCategoryForExpansion![idx].categoryId ?? "", initialLoad: true, limit: 6, start: 0);
                                                                  }
                                                                },
                                                                child: idx == 5
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            Constants.seeMore,
                                                                            style: FontPalette.black14Regular,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 8.w,
                                                                          ),
                                                                          const Icon(
                                                                            Icons.arrow_forward_ios,
                                                                            size: 15,
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Padding(
                                                                        padding: EdgeInsets.only(bottom: 5.h),
                                                                        child: Text(
                                                                          AppData.appLocale == "ar" ? cValue.subCategoryForExpansion![idx].categoryNameArabic ?? "" : cValue.subCategoryForExpansion![idx].categoryName ?? "",
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: cValue.selectedCategoryIdForOutlineButton == cValue.subCategoryForExpansion![idx].categoryId ? FontPalette.white12W400 : FontPalette.black12W400,
                                                                        ),
                                                                      ),
                                                              ),
                                                            );
                                                          },
                                                          childCount: (cValue.subCategoryForExpansion!.length > 5 ||
                                                                  cValue.subCategoryForExpansion!.length ==
                                                                      5)
                                                              ? 6
                                                              : cValue
                                                                  .subCategoryForExpansion!
                                                                  .length,
                                                        ),
                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            // childAspectRatio: 1 /2,
                                                            // crossAxisSpacing: 2.w,
                                                            mainAxisSpacing: 10.h,
                                                            mainAxisExtent: 30.h,
                                                            crossAxisCount: 2),
                                                      )
                                                    : const SliverToBoxAdapter(
                                                        child:
                                                            SizedBox(),
                                                      ),

                                                /// ****pdts under outline button

                                                pValue.productListForOutlineButtonCategory
                                                            ?.isNotEmpty ??
                                                        true
                                                    ? SliverPadding(
                                                        padding: EdgeInsets.only(
                                                            left: 12
                                                                .w,
                                                            right: 12
                                                                .w),
                                                        sliver:
                                                            SliverGrid(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (ctx,
                                                                idx) {
                                                              if (idx ==
                                                                  5) {
                                                                return Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed: () {
                                                                          NavRoutes.navToProductListing(context, catId: pValue.selectedCatForOutlineButtonCategory?.categoryId ?? "",
                                                                              catName: AppData.appLocale == "ar" ? pValue.selectedCatForOutlineButtonCategory?.categoryNameArabic ?? "" :
                                                                              pValue.selectedCatForOutlineButtonCategory?.categoryName ?? "");
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              Constants.seeMore,
                                                                              style: FontPalette.black14Regular,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5.w,
                                                                            ),
                                                                            const Icon(
                                                                              Icons.arrow_forward_ios,
                                                                              size: 15,
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ],
                                                                );
                                                              }
                                                              if (cValue
                                                                  .isDetailView) {
                                                                return ProductCardExpanded(
                                                                  product: pValue.productListForOutlineButtonCategory![idx],
                                                                  onTap: () {
                                                                    Future.microtask(() {
                                                                      context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productListForOutlineButtonCategory![idx].productId).then((value) {
                                                                        if (value) {
                                                                          Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
                                                                        }
                                                                      });
                                                                    });
                                                                  },
                                                                  isDetailed: false,
                                                                );
                                                              }

                                                              return ProductCard(
                                                                product:
                                                                    pValue.productListForOutlineButtonCategory![idx],
                                                                onTap:
                                                                    () {
                                                                  Future.microtask(() {
                                                                    context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productListForOutlineButtonCategory![idx].productId).then((value) {
                                                                      if (value) {
                                                                        Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
                                                                      }
                                                                    });
                                                                  });
                                                                },
                                                                isDetailed:
                                                                    false,
                                                              );
                                                            },
                                                            childCount: (pValue.productListForOutlineButtonCategory!.length >
                                                                    5)
                                                                ? 6
                                                                : pValue.productListForOutlineButtonCategory?.length,
                                                          ),
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              // childAspectRatio: 1 /2,
                                                              crossAxisSpacing: cValue.isDetailView ? 15.w : 46.w,
                                                              mainAxisSpacing: cValue.isDetailView ? 15.h : 5.h,
                                                              mainAxisExtent: cValue.isDetailView ? 230.h : 130.h,
                                                              crossAxisCount: cValue.isDetailView ? 2 : 3),
                                                        ),
                                                      )
                                                    : const SliverToBoxAdapter(
                                                        child:
                                                            SizedBox(),
                                                      ),
                                                SliverPadding(
                                                    padding:
                                                        EdgeInsets
                                                            .only(
                                                  top: 5.h,
                                                )),

                                                /// **** pdts under outline button

                                                pValue.productListForSubCategory
                                                            ?.isNotEmpty ??
                                                        true
                                                    ? SliverPadding(
                                                        padding: EdgeInsets.only(
                                                            left: 12
                                                                .w,
                                                            right: 12
                                                                .w),
                                                        sliver:
                                                            SliverGrid(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (ctx,
                                                                idx) {
                                                              if (idx ==
                                                                  5) {
                                                                return Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed: () {
                                                                          NavRoutes.navToProductListing(context, catId: category.categoryId, catName: AppData.appLocale == "ar" ? category.categoryNameArabic : category.categoryName);
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Text(
                                                                                Constants.seeMore,
                                                                                style: FontPalette.black14Regular,
                                                                              ),
                                                                            ),
                                                                            // SizedBox(
                                                                            //   width: 8.w,
                                                                            // ),
                                                                            const Flexible(
                                                                              child: Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 15,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ],
                                                                );
                                                              }
                                                              if (cValue
                                                                  .isDetailView) {
                                                                return ProductCardExpanded(
                                                                  product: pValue.productListForSubCategory![idx],
                                                                  onTap: () {
                                                                    Future.microtask(() {
                                                                      context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productListForSubCategory![idx].productId).then((value) {
                                                                        if (value) {
                                                                          Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
                                                                        }
                                                                      });
                                                                    });
                                                                  },
                                                                  isDetailed: false,
                                                                );
                                                              }

                                                              return ProductCard(
                                                                product:
                                                                    pValue.productListForSubCategory![idx],
                                                                onTap:
                                                                    () {
                                                                  Future.microtask(() {
                                                                    context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productListForSubCategory![idx].productId).then((value) {
                                                                      if (value) {
                                                                        Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
                                                                      }
                                                                    });
                                                                  });
                                                                },
                                                                isDetailed:
                                                                    false,
                                                              );
                                                            },
                                                            childCount: (pValue.productListForSubCategory!.length >
                                                                    5)
                                                                ? 6
                                                                : pValue.productListForSubCategory?.length,
                                                          ),
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              // childAspectRatio: 1 /2,
                                                              crossAxisSpacing: cValue.isDetailView ? 15.w : 46.w,
                                                              mainAxisSpacing: cValue.isDetailView ? 15.h : 5.h,
                                                              mainAxisExtent: cValue.isDetailView ? 230.h : 130.h,
                                                              crossAxisCount: cValue.isDetailView ? 2 : 3),
                                                        ),
                                                      )
                                                    : const SliverToBoxAdapter(
                                                        child:
                                                            SizedBox(),
                                                      ),
                                                SliverPadding(
                                                    padding: EdgeInsets
                                                        .only(
                                                            top: 5
                                                                .h)),
                                              ],
                                            )
                                          ],
                                        ),
                                        index ==
                                                cValue.subCategoryList!
                                                        .length -
                                                    1
                                            ? ReusableWidgets
                                                .divider(
                                                    height: 1.h,
                                                    color: HexColor(
                                                        "#7A7A7A"))
                                            : SizedBox(),
                                      ],
                                    ),
                                  );
                                } else {
                                  return CommonErrorWidget(
                                      types: ErrorTypes.noDataFound,
                                      buttonText:
                                          Constants.backHome,
                                      onTap: () {
                                        NavRoutes.navToDashboard(context);
                                      });
                                }
                              },
                              itemCount:
                                  cValue.subCategoryList?.length,
                            ),
                          )),
                        )
                      : cValue.loaderState == LoadState.loading
                          ? SizedBox()
                          :  CommonErrorWidget(
                              types: ErrorTypes.noDataFound,
                      buttonText:
                      Constants.backHome,
                      onTap: () {
                        NavRoutes.navToDashboard(context);
                      }),
                ],
              )
                  : const SizedBox(),
            );
  }
///Custom App bar
  Positioned buildPositionedHeader() {
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
///Custom Drawer widget1
  AnimatedPositioned buildAnimatedPositionedDrawerWidget2(BuildContext context) {
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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.transparent,
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
                                                              width: 15.w,
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
///Custom Drawer widget2
  AnimatedPositioned buildAnimatedPositionedDrawerWidget1(BuildContext context) {
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
                                height:
                                    MediaQuery.of(context).size.height *
                                        0.6,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.8),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.r)),
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
                                          alignment: Alignment.topLeft,
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
                                                                width:
                                                                    15.w,
                                                              ),
                                                              Image.asset(
                                                                Assets
                                                                    .iconsCustomersIcon,
                                                                height:
                                                                    15.h,
                                                                width:
                                                                    15.h,
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
                                                                width:
                                                                    15.w,
                                                              ),
                                                              Image.asset(
                                                                Assets
                                                                    .iconsEarningsIcon,
                                                                height:
                                                                    15.h,
                                                                width:
                                                                    15.h,
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
                                                                width:
                                                                    15.w,
                                                              ),
                                                              Image.asset(
                                                                Assets
                                                                    .iconsReports,
                                                                height:
                                                                    15.h,
                                                                width:
                                                                    15.h,
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
                                                                width:
                                                                    15.w,
                                                              ),
                                                              Image.asset(
                                                                Assets
                                                                    .iconsTrackingIcon,
                                                                height:
                                                                    15.h,
                                                                width:
                                                                    15.h,
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
                                                                width:
                                                                    15.w,
                                                              ),
                                                              Image.asset(
                                                                Assets
                                                                    .iconsSettingIcon,
                                                                height:
                                                                    15.h,
                                                                width:
                                                                    15.h,
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
}
