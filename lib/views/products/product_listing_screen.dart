// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lovica_sales_app/common/font_palette.dart';
// import 'package:lovica_sales_app/models/category_model.dart';
// import 'package:lovica_sales_app/providers/product_provider.dart';
// import 'package:lovica_sales_app/widgets/main_header_tile.dart';
// import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
// import 'package:provider/provider.dart';
//
// import '../../common/color_palette.dart';
// import '../../common/constants.dart';
// import '../../common/helpers.dart';
// import '../../common/nav_routes.dart';
// import '../../common/network_connectivity.dart';
// import '../../models/product_model.dart';
// import '../../providers/category_provider.dart';
// import '../../widgets/common_error_widget.dart';
// import '../../widgets/common_header_tile.dart';
// import '../products/product_tile.dart';
// import '../products/product_tile_expanded.dart';
//
// class ProductListingScreen extends StatefulWidget {
//   const ProductListingScreen(
//       {Key? key, this.catId, this.catName, this.isDetailView = false})
//       : super(key: key);
//   final String? catId;
//   final String? catName;
//   final bool isDetailView;
//
//   @override
//   State<ProductListingScreen> createState() => _ProductListingScreenState();
// }
//
// class _ProductListingScreenState extends State<ProductListingScreen> {
//   ScrollController scrollController = ScrollController();
//   bool _isDrawerOpen = false;
//
//   @override
//   void initState() {
//     // Future.microtask(() => context
//     //     .read<ProductProvider>()
//     //     .getProductList(context: context, catId: widget.catId ?? "",searchString: "",initialLoad: true));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double textScale =
//         Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
//     return SizedBox();
//     //   Scaffold(
//     //   backgroundColor: Colors.white,
//     //   body: Consumer2<CategoryProvider, ProductProvider>(
//     //       builder: (context, value, pValue, child) {
//     //     return Stack(
//     //       children: [
//     //         NetworkConnectivity(
//     //           inAsyncCall: value.loaderState == LoadState.loading,
//     //           child: value.subCategories != null
//     //               ? Stack(
//     //                   children: [
//     //                     Column(
//     //                       mainAxisAlignment: MainAxisAlignment.start,
//     //                       crossAxisAlignment: CrossAxisAlignment.start,
//     //                       children: [
//     //                         SizedBox(
//     //                           height: 170.h
//     //                         ),
//     //                         Padding(
//     //                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//     //                           child: HeaderTile(
//     //                             showGridIcon: true,
//     //                             showAppIcon: false,
//     //                             title: widget.catName,
//     //                             showDetailIcon: value.isDetailView,
//     //                             onTapGridDetail: () {
//     //                               value.updateIsDetailView(true);
//     //                             },
//     //                             onTapGrid: () {
//     //                               value.updateIsDetailView(false);
//     //                             },
//     //                             onTapBack: () => Navigator.pop(context),
//     //                           ),
//     //                         ),
//     //                         SizedBox(
//     //                           height: 10.h,
//     //                         ),
//     //                         Padding(
//     //                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//     //                           child: Wrap(
//     //                             children: [
//     //                               Text(
//     //                                 Constants.home,
//     //                                 style: FontPalette.grey10Italic,
//     //                               ),
//     //                               Text(" / ", style: FontPalette.grey10Italic),
//     //                               Text(widget.catName ?? "",
//     //                                   style: FontPalette.grey10Italic)
//     //                             ],
//     //                           ),
//     //                         ),
//     //                         value.subCategoryList?.isNotEmpty ?? true
//     //                             ? Expanded(
//     //                                 child: ListView.builder(
//     //                                 scrollDirection: Axis.vertical,
//     //                                 shrinkWrap: true,
//     //                                 itemBuilder:
//     //                                     (BuildContext context, int index) {
//     //                                   MainCategory? category =
//     //                                       value.subCategoryList?[index];
//     //                                   if (category != null) {
//     //                                     return Padding(
//     //                                       padding: const EdgeInsets.all(8.0),
//     //                                       child: Column(
//     //                                         children: [
//     //                                           ReusableWidgets.divider(
//     //                                               height: 1.h,
//     //                                               color: HexColor("#7A7A7A")),
//     //                                           ExpansionTile(
//     //                                             onExpansionChanged:
//     //                                                 (value) async {
//     //                                               if (value) {
//     //                                                 pValue
//     //                                                   ..clearData()
//     //                                                   ..getProductList(
//     //                                                       context: context,
//     //                                                       catId: category
//     //                                                           .categoryId,
//     //                                                       limit: 5,
//     //                                                       start: 0);
//     //                                               }
//     //                                             },
//     //                                             title: Text(
//     //                                                 category.categoryName ?? "",
//     //                                                 style: FontPalette
//     //                                                     .black16Regular),
//     //                                             children: <Widget>[
//     //                                               pValue.loaderState ==
//     //                                                       LoadState.loading
//     //                                                   ? Padding(
//     //                                                       padding:
//     //                                                           EdgeInsets.all(
//     //                                                               10.h),
//     //                                                       child: ReusableWidgets
//     //                                                           .circularLoader(),
//     //                                                     )
//     //                                                   : pValue.productList
//     //                                                               ?.isNotEmpty ??
//     //                                                           true
//     //                                                       ? CustomScrollView(
//     //                                                           shrinkWrap: true,
//     //                                                           physics:
//     //                                                               const BouncingScrollPhysics(),
//     //                                                           slivers: [
//     //                                                             SliverPadding(
//     //                                                                 padding: EdgeInsets
//     //                                                                     .only(
//     //                                                                         top:
//     //                                                                             5.h)),
//     //                                                             SliverGrid(
//     //                                                               delegate:
//     //                                                                   SliverChildBuilderDelegate(
//     //                                                                 (context,
//     //                                                                     index) {
//     //                                                                   if (index ==
//     //                                                                       4) {
//     //                                                                     return Column(
//     //                                                                       crossAxisAlignment:
//     //                                                                           CrossAxisAlignment.center,
//     //                                                                       mainAxisAlignment:
//     //                                                                           MainAxisAlignment.center,
//     //                                                                       children: [
//     //                                                                         TextButton(
//     //                                                                             onPressed: () {
//     //                                                                               NavRoutes.navToProductListing(context, catId: category.categoryId, catName: category.categoryName);
//     //                                                                             },
//     //                                                                             child: Row(
//     //                                                                               children: [
//     //                                                                                 Text(
//     //                                                                                   Constants.seeMore,
//     //                                                                                   style: FontPalette.black14Regular,
//     //                                                                                 ),
//     //                                                                                 SizedBox(
//     //                                                                                   width: 8.w,
//     //                                                                                 ),
//     //                                                                                 const Icon(
//     //                                                                                   Icons.arrow_forward_ios,
//     //                                                                                   size: 15,
//     //                                                                                 )
//     //                                                                               ],
//     //                                                                             )),
//     //                                                                       ],
//     //                                                                     );
//     //                                                                   }
//     //                                                                   if (value
//     //                                                                       .isDetailView) {
//     //                                                                     return ProductCardExpanded(
//     //                                                                       product:
//     //                                                                           pValue.productList![index],
//     //                                                                       onTap:
//     //                                                                           () {
//     //                                                                         Future.microtask(() {
//     //                                                                           context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productList![index].productId).then((value) {
//     //                                                                             if (value) {
//     //                                                                               Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
//     //                                                                             }
//     //                                                                           });
//     //                                                                         });
//     //                                                                       },
//     //                                                                       isDetailed:
//     //                                                                           false,
//     //                                                                     );
//     //                                                                   }
//     //
//     //                                                                   return ProductCard(
//     //                                                                     product:
//     //                                                                         pValue.productList![index],
//     //                                                                     onTap:
//     //                                                                         () {
//     //                                                                       Future.microtask(
//     //                                                                           () {
//     //                                                                         context.read<ProductProvider>().getProductDetails(context: context, productId: pValue.productList![index].productId).then((value) {
//     //                                                                           if (value) {
//     //                                                                             Future.microtask(() => ReusableWidgets.modalBottomSheet(context));
//     //                                                                           }
//     //                                                                         });
//     //                                                                       });
//     //                                                                     },
//     //                                                                     isDetailed:
//     //                                                                         false,
//     //                                                                   );
//     //                                                                 },
//     //                                                                 childCount: pValue
//     //                                                                     .productList
//     //                                                                     ?.length,
//     //                                                               ),
//     //                                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     //                                                                   // childAspectRatio: 1 /2,
//     //                                                                   crossAxisSpacing: value.isDetailView ? 25.w : 46.w,
//     //                                                                   mainAxisSpacing: 5.h,
//     //                                                                   mainAxisExtent: value.isDetailView ? 230.h : 130.h,
//     //                                                                   crossAxisCount: 3),
//     //                                                             ),
//     //                                                             SliverPadding(
//     //                                                                 padding: EdgeInsets
//     //                                                                     .only(
//     //                                                                         top:
//     //                                                                             5.h)),
//     //                                                           ],
//     //                                                         )
//     //                                                       : Padding(
//     //                                                           padding:
//     //                                                               EdgeInsets
//     //                                                                   .all(
//     //                                                                       10.h),
//     //                                                           child:
//     //                                                                Center(
//     //                                                             child: Text(
//     //                                                                 Constants
//     //                                                                     .noData),
//     //                                                           ),
//     //                                                         )
//     //                                             ],
//     //                                           ),
//     //                                           ReusableWidgets.divider(
//     //                                               height: 1.h,
//     //                                               color: HexColor("#7A7A7A")),
//     //                                         ],
//     //                                       ),
//     //                                     );
//     //                                   } else {
//     //                                     return const CommonErrorWidget(
//     //                                         types: ErrorTypes.noDataFound);
//     //                                   }
//     //                                 },
//     //                                 itemCount: value.subCategoryList?.length,
//     //                               ))
//     //                             : const CommonErrorWidget(
//     //                                 types: ErrorTypes.noDataFound),
//     //                       ],
//     //                     ),
//     //                   ],
//     //                 )
//     //               : SizedBox(),
//     //         ),
//     //         Positioned(
//     //           top: 40.h,
//     //           left: 0.0,
//     //           child: Column(
//     //             children: [
//     //               MainHeaderTileRevamp(
//     //                 onTap: () {
//     //                   setState(() {
//     //                     _isDrawerOpen = !_isDrawerOpen;
//     //                   });
//     //                 },
//     //               )
//     //             ],
//     //           ),
//     //         ),
//     //         AnimatedPositioned(
//     //           duration: const Duration(milliseconds: 300),
//     //           curve: Curves.easeIn,
//     //           top: 0.0,
//     //           bottom: 0.0,
//     //           left: _isDrawerOpen ? 0.0 : -(MediaQuery.of(context).size.width),
//     //           child: Row(
//     //             children: [
//     //               Container(
//     //                 width: 260.w,
//     //                 height: double.infinity,
//     //                 decoration: BoxDecoration(
//     //                   color: Colors.black.withOpacity(.8),
//     //                   boxShadow: [
//     //                     BoxShadow(
//     //                       color: Colors.black.withOpacity(0.3),
//     //                       blurRadius: 5.0,
//     //                     ),
//     //                   ],
//     //                 ),
//     //                 child: Column(
//     //                   children: <Widget>[
//     //                     SizedBox(
//     //                       height: 30.h,
//     //                     ),
//     //                     Padding(
//     //                       padding: EdgeInsets.all(8.h),
//     //                       child: Align(
//     //                         alignment: Alignment.topRight,
//     //                         child: IconButton(
//     //                           icon: Icon(
//     //                             Icons.close,
//     //                             color: Colors.white,
//     //                             size: 30.w,
//     //                           ),
//     //                           onPressed: () =>
//     //                               setState(() => _isDrawerOpen = false),
//     //                         ),
//     //                       ),
//     //                     ),
//     //                     Container(
//     //                         margin: EdgeInsets.only(top: 98.h, left: 10.w),
//     //                         child: Column(
//     //                           children: [
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.customers,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToCustomers(context);
//     //                               },
//     //                             ),
//     //                             SizedBox(
//     //                               height: 40.h
//     //                             ),
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.products,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToProductListing(context,
//     //                                     catId: "0", catName: Constants.allProducts);
//     //                               },
//     //                             ),
//     //                             SizedBox(
//     //                               height: 40.h,
//     //                             ),
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.sales,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToSales(context);
//     //                               },
//     //                             ),
//     //                             SizedBox(
//     //                               height: 40.h,
//     //                             ),
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.reports,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToReports(context);
//     //                               },
//     //                             ),
//     //                             SizedBox(
//     //                               height: 40.h,
//     //                             ),
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.tracking,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToTracking(context);
//     //                               },
//     //                             ),
//     //                             SizedBox(
//     //                               height: 40.h,
//     //                             ),
//     //                             InkWell(
//     //                               child: Padding(
//     //                                 padding:
//     //                                     EdgeInsets.symmetric(horizontal: 12.w),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Text(
//     //                                       Constants.settings,
//     //                                       style: FontPalette.whihte16Regular,
//     //                                       textAlign: TextAlign.left,
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               onTap: () {
//     //                                 NavRoutes.navToSettings(context);
//     //                               },
//     //                             ),
//     //                           ],
//     //                         ))
//     //                   ],
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ),
//     //       ],
//     //     );
//     //   }),
//     //   // appBar: CommonAppBar(),
//     // );
//   }
// }
