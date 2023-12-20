import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:provider/provider.dart';
import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../generated/assets.dart';
import '../../models/city_model.dart';
import '../../models/product_model.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/reusable_widgets.dart';
import '../products/product_tile.dart';
import '../products/product_tile_expanded.dart';

class SearchScreen extends StatefulWidget {
  String? searchKey;

  SearchScreen({Key? key, this.searchKey}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  late Timer? _timer;

  void pagination() {
    pageStartCount.value = pageStartCount.value + 20;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        final productProvider = context.read<ProductProvider>();

        print(
            "page tot count : ${productProvider.totPdtCount}, tot pdt count : ${productProvider.totPdtCountAftrPagination}");

        if (productProvider.totPdtCount! >
            productProvider.totPdtCountAftrPagination!) {
          productProvider.getProductList(
              searchString: searchController.text,
              context: context,
              catId: "",
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });

    String searchKey = widget.searchKey ?? "";
    searchController.text = searchKey;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 300), () async {});
    final productProvider = context.read<ProductProvider>();
    pagination();
    productProvider.getProductList(
        searchString: searchController.text,
        context: context,
        catId: "",
        limit: 0,
        start: 1,
        initialLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, pValue, child) {
            return NetworkConnectivity(
              inAsyncCall: pValue.loaderState == LoadState.loading,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Center(
                                child: SizedBox(
                                  width: 110.w,
                                  height: 46.h,
                                  child: Image.asset(
                                      Assets.iconsLovicaAppIconSmall),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.h, right: 8.h),
                                child: AppData.appLocale == "ar"
                                    ? Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Future.microtask(() =>
                                                  NavRoutes.navToCartPage(
                                                      context));
                                            },
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 30.h,
                                                  width: 30.h,
                                                  child: Image.asset(
                                                      Assets.iconsCartIcon),
                                                ),
                                                Consumer<
                                                        AuthenticationProvider>(
                                                    builder:
                                                        (context, model, _) {
                                                  String count = model
                                                              .cartCount ==
                                                          null
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
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: HexColor(
                                                                      '#040707'),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    FittedBox(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        0.80),
                                                                    child: Text(
                                                                      count,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String barcodeScanRes;
                                              try {
                                                barcodeScanRes =
                                                    await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                            '#ff6666',
                                                            'Cancel',
                                                            true,
                                                            ScanMode.BARCODE);
                                                print(barcodeScanRes);
                                                Future.microtask(() =>
                                                    NavRoutes.navToSearch(
                                                        context,
                                                        barcodeScanRes));
                                              } on PlatformException {
                                                barcodeScanRes =
                                                    'Failed to get platform version.';
                                              }
                                              if (!mounted) return;
                                            },
                                            child: SizedBox(
                                                height: 25.h,
                                                width: 25.w,
                                                child: Image.asset(Assets
                                                    .iconsBarcodeScannerIcon)),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Expanded(
                                            child: CustomTextFormField(
                                              suffix: suffixWidget(),
                                              inputAction:
                                                  TextInputAction.search,
                                              onChanged: (val) {
                                                if (val
                                                    .toString()
                                                    .replaceAll(' ', "")
                                                    .isNotEmpty) {
                                                  if (_timer?.isActive ?? false)
                                                    _timer!.cancel();
                                                  _timer = Timer(
                                                      const Duration(
                                                          milliseconds: 1500),
                                                      () async {
                                                    Future.microtask(() =>
                                                        context.read<
                                                            ProductProvider>()
                                                          ..getProductList(
                                                              searchString:
                                                                  searchController
                                                                      .text,
                                                              context: context,
                                                              catId: "",
                                                              start: 0,
                                                              limit: 0,
                                                              initialLoad: true)
                                                          ..addToRecentSearch(
                                                              searchController
                                                                  .text));
                                                  });
                                                } else {
                                                  Future.microtask(() => context
                                                      .read<ProductProvider>()
                                                    ..getProductList(
                                                        searchString: "",
                                                        context: context,
                                                        catId: "",
                                                        start: 0,
                                                        limit: 0,
                                                        initialLoad: true));
                                                }
                                              },
                                              onFieldSubmitted: (val) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                Future.microtask(() => context
                                                    .read<ProductProvider>()
                                                  ..getProductList(
                                                      searchString:
                                                          searchController.text,
                                                      context: context,
                                                      catId: "",
                                                      start: 0,
                                                      limit: 0,
                                                      initialLoad: true)
                                                  ..addToRecentSearch(
                                                      searchController.text));
                                              },
                                              hintText:
                                                  Constants.searchForProducts,
                                              hintFontPalette: FontPalette
                                                  .black12Regular
                                                  .copyWith(
                                                      color:
                                                          HexColor("#7A7A7A")),
                                              labelText:
                                                  Constants.searchForProducts,
                                              controller: searchController,
                                              style: FontPalette.grey12Italic
                                                  .copyWith(
                                                      color:
                                                          HexColor("#7A7A7A")),
                                              // readOnly: true,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child: RotatedBox(
                                                    quarterTurns:
                                                        AppData.appLocale ==
                                                                "ar"
                                                            ? 2
                                                            : 0,
                                                    child: Image.asset(
                                                        Assets.iconsBackIcon))),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child: Image.asset(
                                                    Assets.iconsBackIcon)),
                                          ),
                                          SizedBox(
                                            width: 8.w
                                          ),
                                          Expanded(
                                            child: CustomTextFormField(
                                              suffix: suffixWidget(),
                                              inputAction:
                                                  TextInputAction.search,
                                              onChanged: (val) {
                                                if (val
                                                    .toString()
                                                    .replaceAll(' ', "")
                                                    .isNotEmpty) {
                                                  if (_timer?.isActive ?? false)
                                                    _timer!.cancel();
                                                  _timer = Timer(
                                                      const Duration(
                                                          milliseconds: 1500),
                                                      () async {
                                                    Future.microtask(() =>
                                                        context.read<
                                                            ProductProvider>()
                                                          ..getProductList(
                                                              searchString:
                                                                  searchController
                                                                      .text,
                                                              context: context,
                                                              catId: "",
                                                              start: 0,
                                                              limit: 0,
                                                              initialLoad: true)
                                                          ..addToRecentSearch(
                                                              searchController
                                                                  .text));
                                                  });
                                                } else {
                                                  Future.microtask(() => context
                                                      .read<ProductProvider>()
                                                    ..getProductList(
                                                        searchString: "",
                                                        context: context,
                                                        catId: "",
                                                        start: 0,
                                                        limit: 0,
                                                        initialLoad: true));
                                                }
                                              },
                                              onFieldSubmitted: (val) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                Future.microtask(() => context
                                                    .read<ProductProvider>()
                                                  ..getProductList(
                                                      searchString:
                                                          searchController.text,
                                                      context: context,
                                                      catId: "",
                                                      start: 0,
                                                      limit: 0,
                                                      initialLoad: true)
                                                  ..addToRecentSearch(
                                                      searchController.text));
                                              },
                                              hintText:
                                                  Constants.searchForProducts,
                                              hintFontPalette: FontPalette
                                                  .black12Regular
                                                  .copyWith(
                                                      color:
                                                          HexColor("#7A7A7A")),
                                              labelText:
                                                  Constants.searchForProducts,
                                              controller: searchController,
                                              style: FontPalette.grey12Italic
                                                  .copyWith(
                                                      color:
                                                          HexColor("#7A7A7A")),
                                              // readOnly: true,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String barcodeScanRes;
                                              try {
                                                barcodeScanRes =
                                                    await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                            '#ff6666',
                                                            'Cancel',
                                                            true,
                                                            ScanMode.BARCODE);
                                                print(barcodeScanRes);
                                                Future.microtask(() =>
                                                    NavRoutes.navToSearch(
                                                        context,
                                                        barcodeScanRes));
                                              } on PlatformException {
                                                barcodeScanRes =
                                                    'Failed to get platform version.';
                                              }
                                              if (!mounted) return;
                                            },
                                            child: SizedBox(
                                                height: 25.h,
                                                width: 25.w,
                                                child: Image.asset(Assets
                                                    .iconsBarcodeScannerIcon)),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Future.microtask(() =>
                                                  NavRoutes.navToCartPage(
                                                      context));
                                            },
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 30.h,
                                                  width: 30.h,
                                                  child: Image.asset(
                                                      Assets.iconsCartIcon),
                                                ),
                                                Consumer<
                                                        AuthenticationProvider>(
                                                    builder:
                                                        (context, model, _) {
                                                  String count = model
                                                              .cartCount ==
                                                          null
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
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: HexColor(
                                                                      '#040707'),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    FittedBox(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        0.80),
                                                                    child: Text(
                                                                      count,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: 11.h,
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 9.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: AppData.appLocale == "ar"
                          ? [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "isDetailViewInSearch ${pValue.isDetailViewInSearch}");
                                        pValue.isDetailViewInSearch
                                            ? pValue.updateIsDetailView(false)
                                            : pValue.updateIsDetailView(true);
                                      },
                                      child: SizedBox(
                                        height: 24.h,
                                        width: 28.w,
                                        child: Image.asset(pValue
                                                .isDetailViewInSearch
                                            ? Assets.iconsPdtGridIconSelected
                                            : Assets
                                                .iconsPdtGridIconUnselected),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 36.w, top: 10.h),
                                  child: Text(
                                    pValue.productList!.isNotEmpty &&
                                            searchController.text.isNotEmpty
                                        ? "${searchController.text}    نتائج البحث  "
                                        : "",
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    style: FontPalette.grey10Italic,
                                  ),
                                ),
                              ),
                            ]
                          : [
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 36.w, top: 10.h),
                                  child: Text(
                                    pValue.productList!.isNotEmpty &&
                                            searchController.text.isNotEmpty
                                        ? "Search Results  ${searchController.text}"
                                        : "",
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: FontPalette.grey10Italic,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "isDetailViewInSearch ${pValue.isDetailViewInSearch}");
                                        pValue.isDetailViewInSearch
                                            ? pValue.updateIsDetailView(false)
                                            : pValue.updateIsDetailView(true);
                                      },
                                      child: SizedBox(
                                        height: 24.h,
                                        width: 28.w,
                                        child: Image.asset(pValue
                                                .isDetailViewInSearch
                                            ? Assets.iconsPdtGridIconSelected
                                            : Assets
                                                .iconsPdtGridIconUnselected),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                    ),
                    pValue.recentSearchItems.isNotEmpty
                        ? AppData.appLocale == "ar"
                            ? ListView.builder(
                                itemCount: pValue.recentSearchItems.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(12.w),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Future.microtask(() => context
                                          .read<ProductProvider>()
                                          .getProductList(
                                              searchString:
                                                  searchController.text,
                                              context: context,
                                              catId: "",
                                              start: 0,
                                              limit: 0,
                                              initialLoad: true));
                                    },
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        //takes the row to the top
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: InkWell(
                                              child: Icon(
                                                Icons.close,
                                                color: HexColor("#7A7A7A"),
                                                // size: 12.h,
                                              ),
                                              onTap: () {
                                                Future.microtask(() => context
                                                    .read<ProductProvider>()
                                                    .removeRecentItem(index));
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              pValue.recentSearchItems[index] ??
                                                  "",
                                              textAlign: TextAlign.end,
                                              maxLines: 2,
                                              style:
                                                  FontPalette.blackShade12w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          SizedBox(
                                            child: InkWell(
                                              child: Icon(
                                                Icons.search,
                                                color: HexColor("#7A7A7A"),
                                                // size: 12.h,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                })
                            : ListView.builder(
                                itemCount: pValue.recentSearchItems.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(12.w),
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      //takes the row to the top
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: InkWell(
                                            child: Icon(
                                              Icons.search,
                                              color: HexColor("#7A7A7A"),
                                              // size: 12.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            pValue.recentSearchItems[index] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            style: FontPalette.blackShade12w400,
                                          ),
                                        ),
                                        SizedBox(
                                          child: InkWell(
                                            child: Icon(
                                              Icons.close,
                                              color: HexColor("#7A7A7A"),
                                              // size: 12.h,
                                            ),
                                            onTap: () {
                                              Future.microtask(() => context
                                                  .read<ProductProvider>()
                                                  .removeRecentItem(index));
                                            },
                                          ),
                                        ),
                                      ]);
                                })
                        : SizedBox(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: CustomScrollView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          slivers: [
                            SliverPadding(padding: EdgeInsets.only(top: 5.h)),
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  Product? product = pValue.productList?[index];

                                  if (product == null) {
                                    return const SizedBox();
                                  }

                                  if (pValue.isDetailViewInSearch) {
                                    return ProductCardExpanded(
                                      product: product,
                                      onTap: () {
                                        Future.microtask(() {
                                          context
                                              .read<ProductProvider>()
                                              .getProductDetails(
                                                  context: context,
                                                  productId: product.productId)
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
                                                productId: product.productId)
                                            .then((value) {
                                          if (value) {
                                            Future.microtask(() =>
                                                ReusableWidgets
                                                    .modalBottomSheet(context));
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
                                          pValue.isDetailViewInSearch
                                              ? 20.w
                                              : 46.w,
                                      mainAxisSpacing:
                                          pValue.isDetailViewInSearch
                                              ? 20.h
                                              : 5.h,
                                      mainAxisExtent:
                                          pValue.isDetailViewInSearch
                                              ? 230.h
                                              : 130.h,
                                      crossAxisCount:
                                          pValue.isDetailViewInSearch ? 2 : 3),
                            ),
                            SliverPadding(padding: EdgeInsets.only(top: 5.h)),
                            SliverToBoxAdapter(
                              child: ReusableWidgets.paginationLoader(
                                  pValue.paginationLoader),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // appBar: CommonAppBar(),
    );
  }

  Widget suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: HexColor("#7A7A7A"),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 12.w,
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
