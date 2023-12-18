import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/models/cart_model.dart';
import 'package:lovica_sales_app/providers/cart_provider.dart';
import 'package:lovica_sales_app/providers/connectivity_provider.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:provider/provider.dart';

import '../../../common/color_palette.dart';
import '../../../common/constants.dart';
import '../../../common/network_connectivity.dart';
import '../../../common/validator.dart';
import '../../../models/city_model.dart';
import '../../../providers/authentication_provider.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../common/helpers.dart';
import '../../providers/check_out_provider.dart';
import '../../providers/customer_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/reusable_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController qntyController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final outlinedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.r),
      borderRadius: BorderRadius.circular(2.r));
  final outlinedErrorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.r),
      borderRadius: BorderRadius.circular(2.r));
  final outlinedFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.r),
      borderRadius: BorderRadius.circular(2.r));
  List<TextEditingController>? controllers = [];
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  late Timer? _timer;

  void _scollListen(CartProvider cartProvider) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (cartProvider.totPdtCount! >
            cartProvider.totPdtCountAftrPagination!) {
          pageStartCount.value = pageStartCount.value + 20;
          cartProvider.getCartList(
              context: context,
              limit: 20,
              start: pageStartCount.value,
              customerId: "0",
              searchString: "",
              initialLoad: false);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 300), () async {});

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    _scollListen(cartProvider);
    Future.microtask(() {
      cartProvider
        ..clearList()
        ..updateAmountList()
        ..getCartList(
            context: context,
            customerId: "0",
            searchString: "",
            initialLoad: true,
            start: 0,
            limit: 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 19.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            child: CustomCommonButton(
              buttonText: Constants.checkoutTitle,
              onTap: () async {
                if (context.read<CartProvider>().cartItemsList?.isNotEmpty ??
                    true) {
                  NavRoutes.navToCheckout(context);
                }
              },
            ),
          ),
          SizedBox(height: 27.h),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Consumer4<CartProvider, AuthenticationProvider,
              CheckOutProvider, CustomerProvider>(
            builder: (context, cartProvider, lp, cP, custPro, child) {
              return NetworkConnectivity(
                inAsyncCall: cartProvider.loaderState == LoadState.loading ||
                    cP.loaderState == LoadState.loading ||
                    custPro.loaderState == LoadState.loading,
                child: Column(
                  crossAxisAlignment: AppData.appLocale == "ar"
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: AppData.appLocale == "ar"
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.shoppingCart,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              inputType: TextInputType.text,
                              suffix: suffixWidget(),
                              hintText: Constants.searchForProducts,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.searchForProducts,
                              controller: searchController,
                              style: FontPalette.grey12Italic
                                  .copyWith(color: HexColor("#7A7A7A")),

                              onChanged: (val) {
                                if (val
                                    .toString()
                                    .replaceAll(' ', "")
                                    .isNotEmpty) {
                                  if (_timer?.isActive ?? false)
                                    _timer!.cancel();
                                  _timer =
                                      Timer(const Duration(milliseconds: 1500),
                                          () async {
                                    Future.microtask(() {
                                      cartProvider
                                        ..clearList()
                                        ..updateAmountList()
                                        ..getCartList(
                                            searchString: searchController.text,
                                            context: context,
                                            customerId: "0",
                                            initialLoad: true,
                                            start: 0,
                                            limit: 0,
                                        );
                                    });
                                  });
                                } else {
                                  Future.microtask(() {
                                    cartProvider
                                      ..clearList()
                                      ..updateAmountList()
                                      ..getCartList(
                                          searchString: "",
                                          context: context,
                                          customerId: "0",
                                          initialLoad: true,
                                          start: 0,
                                          limit: 20);
                                  });
                                }
                              },
                              onFieldSubmitted: (val) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              validator: (val) {
                                return Validator.validateEMptyField(val);
                              },
                              // readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    const CartSubHeader(),
                    SizedBox(height: 12.h),
                    cartProvider.cartItemsList?.isNotEmpty ?? true
                        ? buildExpandedCartItemListView(cartProvider)
                        : const Expanded(
                            child: SizedBox(),
                          ),
                    SizedBox(height: 23.h),
                    Center(
                        child: ReusableWidgets.paginationLoader(
                            cartProvider.paginationLoader)),
                    buildCartTotalPriceRow(cartProvider),

                    /// ios number keypad ISSUE RESOLVED

                    Platform.isIOS
                        ? Consumer<ConnectivityProvider>(
                            builder: (context, provider, child) {
                            return KeyboardVisibility(
                                // it will notify
                                onChanged: (bool visible) {
                                  provider.updateVisibilityOfKeyboard(
                                      visible, 0.0);
                                },
                                child: provider.isVisibleKeyboard
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                            },
                                            child: SizedBox(
                                              height: 50.h,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: Text(
                                                  Constants.close,
                                                  textAlign: TextAlign.end,
                                                  style: FontPalette.blue15W500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                              actionDone();
                                            },
                                            child: SizedBox(
                                              height: 50.h,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: Text(
                                                  Constants.done,
                                                  textAlign: TextAlign.end,
                                                  style: FontPalette.blue15W500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : const SizedBox());
                          })
                        : const SizedBox()
                  ],
                ),
              );
            },
          ),
        ),
      ),
      // appBar: CommonAppBar(),
    );
  }

  ///Method for total price of cart
  Row buildCartTotalPriceRow(CartProvider cartProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: AppData.appLocale == "ar"
          ? [
              Text(
                "SAR ${cartProvider.sum.toStringAsFixed(2)}",
                style: FontPalette.black24W700,
              ),
              SizedBox(width: 8.w),
              Text(
                Constants.total,
                style: FontPalette.black16W500,
              ),
            ]
          : [
              Text(
                Constants.total,
                style: FontPalette.black16W500,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "SAR ${cartProvider.sum.toStringAsFixed(2)}",
                style: FontPalette.black24W700,
              )
            ],
    );
  }

  ///Method for Cart item List view
  Expanded buildExpandedCartItemListView(CartProvider cartProvider) {
    return Expanded(
      child: CupertinoScrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 5, right: 5, left: 5),
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            CartItem? cartItem = cartProvider.cartItemsList?[index];
            controllers!.add(TextEditingController());
            controllers![index].text =
                cartItem != null ? cartItem.cartQuantity.toString() : "0";
            return cartItem != null
                ? InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 1.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              1.0, // Move to right 10  horizontally
                              1.0, // Move to bottom 10 Vertically
                            ),
                          ),
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 1.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              -1.0, // Move to right 10  horizontally
                              -1.0, // Move to bottom 10 Vertically
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.w),
                        ),
                      ),
                      margin: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        bottom: 16.h,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(11.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: AppData.appLocale == "ar"
                              ?
                              //Arabic
                              [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Text(
                                        "SAR ${cartItem.total!.toStringAsFixed(2)}",
                                        style: FontPalette.black16W500,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showAlertDialogForDeleteCartItem(
                                                context,
                                                cartProvider,
                                                cartItem);
                                          },
                                          child: Image.asset(
                                            Assets.iconsCartDeleteIcon,
                                            height: 20.h,
                                            width: 20.w,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 23.w,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Constants.qty,
                                        style: FontPalette.black16W500,
                                      ),
                                      SizedBox(height: 7.h),
                                      Container(
                                        color: Colors.white,
                                        height: 20.h,
                                        width: 56.w,
                                        child: TextFormField(
                                            controller: controllers![index],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              AppData.itemForActionDone =
                                                  cartItem;
                                              AppData.indexForActionDone =
                                                  index;
                                              controllers![index].selection =
                                                  TextSelection(
                                                      baseOffset: 0,
                                                      extentOffset:
                                                          controllers![index]
                                                              .value
                                                              .text
                                                              .length);
                                            },
                                            onChanged: (val) {
                                              // if (controllers![index]
                                              //     .text
                                              //     .trim()
                                              //     .isNotEmpty) {
                                              //   Helpers.convertToInt(controllers![index].text.trim()) != 0
                                              //       ? cartProvider.editCartItem(context: context, productId: cartItem.cartId ?? "", customerId: "0", quantity: controllers![index].text).then((value) => cartProvider.getCartList(context: context, customerId: "0", start: 0, limit: 20, initialLoad: true))
                                              //       : Helpers.showToast("Minimum quantity is 1");
                                              // }
                                            },
                                            onEditingComplete: () {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');

                                              cartProvider.updateQuantity(
                                                  cartItem.cartId ?? "",
                                                  controllers![index].text);
                                              if (controllers![index]
                                                  .text
                                                  .trim()
                                                  .isNotEmpty) {
                                                Helpers.convertToInt(controllers![
                                                                index]
                                                            .text
                                                            .trim()) !=
                                                        0
                                                    ? cartProvider
                                                        .editCartItem(
                                                            context: context,
                                                            productId: cartItem
                                                                    .cartId ??
                                                                "",
                                                            customerId: "0",
                                                            quantity:
                                                                controllers![
                                                                        index]
                                                                    .text)
                                                        .then((value) =>
                                                            cartProvider
                                                                .getCartList(
                                                                    context:
                                                                        context,
                                                                    customerId:
                                                                        "0",
                                                                    start: 0,
                                                                    limit: 20,
                                                                    searchString:
                                                                        "",
                                                                    initialLoad:
                                                                        true))
                                                    : Helpers.showToast(
                                                        Constants.minQty);
                                              }
                                            },
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsets.all(5.h),
                                              border: outlinedBorder,
                                              enabledBorder: outlinedBorder,
                                              counterText: "",
                                              focusedBorder:
                                                  outlinedFocusedBorder,
                                              focusedErrorBorder:
                                                  outlinedErrorBorder,
                                            )),
                                      ),
                                    ],
                                  ),
                                  // cartItem.configurations!.length == 1 ?

                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppData.appLocale == 'en'
                                              ? cartItem.productName ?? ""
                                              : cartItem.productNameArabic ??
                                                  "",
                                          maxLines: 3,
                                          style: FontPalette.black12w500,
                                          textAlign: TextAlign.right,
                                        ),
                                        cartItem.configurations?.isNotEmpty ??
                                                true
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 15.h,
                                                    width: 50.w,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: cartItem
                                                                .configurations
                                                                ?.length ??
                                                            0,
                                                        itemBuilder:
                                                            (BuildContext ctx,
                                                                int _index) {
                                                          Configurations?
                                                              configData =
                                                              cartItem.configurations?[
                                                                  _index];

                                                          return configData ==
                                                                  null
                                                              ? const SizedBox()
                                                              : configData.optionColorcode !=
                                                                      null
                                                                  ? Container(
                                                                      width:
                                                                          15.w,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              28.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.r),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.transparent),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        color: HexColor(configData.optionColorcode ??
                                                                            ""),
                                                                      ),
                                                                    )
                                                                  : const SizedBox();
                                                        }),
                                                  ),
                                                  Text(
                                                    "        ${Constants.colorAr}",
                                                    maxLines: 3,
                                                    style:
                                                        FontPalette.black10w600,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        const SizedBox(height: 4),
                                        cartItem.configurations?.isNotEmpty ??
                                                true
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Text(
                                                        //"${AppData.appLocale=="ar"?cartItem.configOptionAr ?? "": cartItem.configOptionEn ?? ""}",
                                                        cartItem.configOptionAr ??
                                                            "",
                                                        // "ssssssssssssssssssssssssssssss",
                                                        style: FontPalette
                                                            .black10Regular,
                                                        maxLines: 3,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "  ${Constants.optionAr}",
                                                    maxLines: 1,
                                                    style:
                                                        FontPalette.black10w600,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ]
                              : [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Text(
                                            AppData.appLocale == 'en'
                                                ? cartItem.productName ?? ""
                                                : cartItem.productNameArabic ??
                                                    "",
                                            maxLines: 3,
                                            style: FontPalette.black12w500,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        cartItem.configurations?.isNotEmpty ??
                                                true
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "${Constants.color}     ",
                                                    maxLines: 1,
                                                    style:
                                                        FontPalette.black10w600,
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                    width: 50.w,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: cartItem
                                                                .configurations
                                                                ?.length ??
                                                            0,
                                                        itemBuilder:
                                                            (BuildContext ctx,
                                                                int _index) {
                                                          Configurations?
                                                              configData =
                                                              cartItem.configurations?[
                                                                  _index];

                                                          return configData ==
                                                                  null
                                                              ? const SizedBox()
                                                              : configData.optionColorcode !=
                                                                      null
                                                                  ? Container(
                                                                      width:
                                                                          15.w,
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              4.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.r),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.transparent),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        color: HexColor(configData.optionColorcode ??
                                                                            ""),
                                                                      ),
                                                                    )
                                                                  : const SizedBox();
                                                        }),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        // const SizedBox(
                                        //     height:
                                        //         4),
                                        cartItem.configurations?.isNotEmpty ??
                                                true
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "${Constants.option}   ",
                                                    maxLines: 1,
                                                    style:
                                                        FontPalette.black10w600,
                                                  ),
                                                  Expanded(
                                                      // flex: 3,
                                                      child:
                                                          AppData.appLocale ==
                                                                  'en'
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  child: Text(
                                                                    cartItem.configOptionEn ??
                                                                        "",
                                                                    style: FontPalette
                                                                        .black10Regular,
                                                                    maxLines: 3,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  cartItem.configOptionAr ??
                                                                      "",
                                                                  style: FontPalette
                                                                      .black10Regular,
                                                                  maxLines: 3,
                                                                ))

                                                  // Expanded(
                                                  //   child: SizedBox(
                                                  //     height: 30.h,
                                                  //     // width: 50.w,
                                                  //     child: ListView.builder(
                                                  //         shrinkWrap: true,
                                                  //         physics: const BouncingScrollPhysics(),
                                                  //         scrollDirection: Axis.horizontal,
                                                  //         itemCount: cartItem.configurations?.length ?? 0,
                                                  //         itemBuilder: (BuildContext ctx, int _index) {
                                                  //           Configurations? configData = cartItem.configurations?[_index];
                                                  //
                                                  //           return configData == null
                                                  //               ? const SizedBox()
                                                  //               : configData.optionColorcode != null
                                                  //                   ? SizedBox()
                                                  //                   : Center(child: Text( configData.optionLabelEng!=null?"${configData.optionLabelEng},":"",style: FontPalette.black10Regular,maxLines: 2,));
                                                  //         }),
                                                  //   ),
                                                  // ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Constants.qty,
                                        style: FontPalette.black16W500,
                                      ),
                                      SizedBox(height: 7.h),
                                      Container(
                                        color: Colors.white,
                                        height: 20.h,
                                        width: 56.w,
                                        child: TextFormField(
                                            controller: controllers![index],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              AppData.itemForActionDone =
                                                  cartItem;
                                              AppData.indexForActionDone =
                                                  index;
                                              controllers![index].selection =
                                                  TextSelection(
                                                      baseOffset: 0,
                                                      extentOffset:
                                                          controllers![index]
                                                              .value
                                                              .text
                                                              .length);
                                            },
                                            onChanged: (val) {
                                              // cartProvider.updateCartItemForDoneAction(cartItem, index);

                                              // if (controllers![index]
                                              //     .text
                                              //     .trim()
                                              //     .isNotEmpty) {
                                              //   Helpers.convertToInt(controllers![index].text.trim()) != 0
                                              //       ? cartProvider.editCartItem(context: context, productId: cartItem.cartId ?? "", customerId: "0", quantity: controllers![index].text).then((value) => cartProvider.getCartList(context: context, customerId: "0", start: 0, limit: 20, initialLoad: true))
                                              //       : Helpers.showToast("Minimum quantity is 1");
                                              // }
                                            },
                                            onEditingComplete: () {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');

                                              cartProvider.updateQuantity(
                                                  cartItem.cartId ?? "",
                                                  controllers![index].text);
                                              if (controllers![index]
                                                  .text
                                                  .trim()
                                                  .isNotEmpty) {
                                                Helpers.convertToInt(controllers![
                                                                index]
                                                            .text
                                                            .trim()) !=
                                                        0
                                                    ? cartProvider
                                                        .editCartItem(
                                                            context: context,
                                                            productId: cartItem
                                                                    .cartId ??
                                                                "",
                                                            customerId: "0",
                                                            quantity:
                                                                controllers![
                                                                        index]
                                                                    .text)
                                                        .then((value) =>
                                                            cartProvider
                                                                .getCartList(
                                                                    context:
                                                                        context,
                                                                    searchString:
                                                                        "",
                                                                    customerId:
                                                                        "0",
                                                                    start: 0,
                                                                    limit: 20,
                                                                    initialLoad:
                                                                        true))
                                                    : Helpers.showToast(
                                                        Constants.minQty);
                                              }
                                            },
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsets.all(5.h),
                                              border: outlinedBorder,
                                              enabledBorder: outlinedBorder,
                                              counterText: "",
                                              focusedBorder:
                                                  outlinedFocusedBorder,
                                              focusedErrorBorder:
                                                  outlinedErrorBorder,
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 23.w,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Text(
                                        "SAR ${cartItem.total!.toStringAsFixed(2)}",
                                        style: FontPalette.black16W500,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showAlertDialogForDeleteCartItem(
                                                context,
                                                cartProvider,
                                                cartItem);
                                          },
                                          child: Image.asset(
                                            Assets.iconsCartDeleteIcon,
                                            height: 20.h,
                                            width: 20.w,
                                          ))
                                    ],
                                  ),
                                ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
          itemCount: cartProvider.cartItemsList?.length,
        ),
      ),
    );
  }

  ///Method for Cart search bar icon
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
        SizedBox(width: 12.w)
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    qntyController.dispose();
    for (final TextEditingController controller in controllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  actionDone() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    cartProvider.updateQuantity(AppData.itemForActionDone?.cartId ?? "",
        controllers![AppData.indexForActionDone ?? 0].text);
    if (controllers![AppData.indexForActionDone ?? 0].text.trim().isNotEmpty) {
      Helpers.convertToInt(
                  controllers![AppData.indexForActionDone ?? 0].text.trim()) !=
              0
          ? cartProvider
              .editCartItem(
                  context: context,
                  productId: AppData.itemForActionDone?.cartId ?? "",
                  customerId: "0",
                  quantity: controllers![AppData.indexForActionDone ?? 0].text)
              .then((value) => cartProvider.getCartList(
                  context: context,
                  customerId: "0",
                  searchString: "",
                  start: 0,
                  limit: 20,
                  initialLoad: true))
          : Helpers.showToast(Constants.minQty);
    }
  }

  showAlertDialogForDeleteCartItem(
    BuildContext context,
    CartProvider cartProvider,
    CartItem cartItem,
  ) {
    // set up the buttons
    Widget cancelButton = Directionality(
      textDirection:
          AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
      child: TextButton(
        child: Text(Constants.cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    Widget continueButton = Directionality(
      textDirection:
          AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
      child: TextButton(
        child: Text(Constants.delete),
        onPressed: () {
          Navigator.pop(context);

          cartProvider
              .deleteCartItem(
                  context: context,
                  productId: cartItem.cartId ?? "",
                  customerId: "0")
              .then((value) => cartProvider.getCartList(
                  context: context,
                  searchString: "",
                  customerId: "0",
                  start: 0,
                  limit: 20,
                  initialLoad: true));
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Directionality(
          textDirection:
              AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: Text(Constants.warning)),
      content: Directionality(
          textDirection:
              AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: Text(Constants.deleteMsg)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CartSubHeader extends StatelessWidget {
  const CartSubHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Wrap(
        children: [
          Text(
            Constants.home,
            style: FontPalette.grey10Italic,
          ),
          Text(" / ", style: FontPalette.grey10Italic),
          Text(Constants.shoppingCart, style: FontPalette.grey10Italic)
        ],
      ),
    );
  }
}
