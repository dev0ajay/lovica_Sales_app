import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/helpers.dart';
import 'package:lovica_sales_app/models/product_model.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:html/parser.dart';

import '../common/color_palette.dart';
import '../common/constants.dart';
import '../common/font_palette.dart';
import '../providers/cart_provider.dart';
import '../providers/connectivity_provider.dart';
import 'custom_common_button.dart';

class ReusableWidgets {
  static Widget divider(
      {double? height, Color? color, double? marginWidth, EdgeInsets? margin}) {
    return Container(
      height: height ?? 5.h,
      color: color ?? Colors.black,
      margin: margin ?? EdgeInsets.symmetric(horizontal: marginWidth ?? 0),
    );
  }

  static void customCircularLoader(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierDismissible: false,
      barrierLabel: "Loader",
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return WillPopScope(
          child: SizedBox.expand(
            // makes widget fullscreen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
                )
              ],
            ),
          ),
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
        );
      },
    );
  }

  static Widget verticalDivider(
      {double? height, double? width, Color? color, EdgeInsets? margin}) {
    return Container(
      height: height ?? 13.h,
      width: width ?? 1.w,
      color: color ?? Colors.black,
      margin: margin,
    );
  }

  static Widget circularLoader({double? height, double? width}) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: const CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }

  static Widget paginationLoader(bool async) {
    return AnimatedSwitcher(
      duration: const Duration(microseconds: 300),
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: async
          ? Padding(
              padding: EdgeInsets.all(20.0.r),
              child: CupertinoActivityIndicator(
                color: Colors.black,
                radius: 15.r,
              ),
            )
          : const SizedBox(),
    );
  }

  static modalBottomSheet(BuildContext ctx) {
    final TextEditingController qntyController = TextEditingController();
    final FocusNode qntyFocusNode = FocusNode();
    final ScrollController scrollController = ScrollController();
    final ScrollController scrollControllerDummy = ScrollController();
    qntyController.text = "1";
    var key2 = GlobalKey();

    final outlinedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.r),
        borderRadius: BorderRadius.circular(2.r));
    final outlinedErrorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.r),
        borderRadius: BorderRadius.circular(2.r));
    final outlinedFocusedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.r),
        borderRadius: BorderRadius.circular(2.r));

    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // You can wrap this Column with Padding of 8.0 for better design
          child: Platform.isIOS
              ? KeyboardActions(
                  config: KeyboardActionsConfig(
                    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                    keyboardBarColor: Colors.grey[200],
                    nextFocus: false,
                    actions: [
                      KeyboardActionsItem(
                        focusNode: qntyFocusNode,
                        toolbarButtons: [
                          //button 1
                          (node) {
                            return InkWell(
                              onTap: () => node.unfocus(),
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
                            );
                          },
                          //button 2
                          (node) {
                            return InkWell(
                              onTap: () {
                                node.unfocus();
                                String qty = qntyController.text.trim();
                                if (qty.isNotEmpty) {
                                  Future.microtask(() => context
                                      .read<ProductProvider>()
                                      .updateTotalByQuantity(qty));
                                } else {
                                  Helpers.showToast(Constants.cantProceedPrice);
                                }
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
                            );
                          }
                        ],
                      ),
                    ],
                  ),
                  autoScroll: false,
                  child: Consumer3<ProductProvider, CartProvider,
                          ConnectivityProvider>(
                      builder: (context, pValue, cValue, conProvider, child) {
                    return Stack(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          controller: scrollControllerDummy,
                          padding: EdgeInsets.all(11.h),
                          children: [
                            Icon(
                              Icons.remove,
                              color: Colors.grey[600],
                              size: 45,
                            ),

                            /// Name
                            Directionality(
                                textDirection: AppData.appLocale == "ar"
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppData.appLocale == "ar"
                                              ? pValue.detailData
                                                      ?.productNameArabic ??
                                                  ""
                                              : pValue.detailData
                                                      ?.productName ??
                                                  "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: FontPalette.black20W500,
                                        ),
                                      ),
                                    ])),
                            SizedBox(
                              height: 12.h
                            ),

                            /// List of variants
                            /// ios number keypad ISSUE RESOLVED

                            SizedBox(
                              child: pValue.detailData?.prodType
                                          ?.toString()
                                          .toLowerCase() ==
                                      Constants.simple
                                  ? const SizedBox()
                                  : pValue.detailData!.attrbs!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: pValue.attrLength,
                                          shrinkWrap: true,
                                          // physics: const BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Attrbs? attributes = pValue
                                                .detailData?.attrbs?[index];

                                            List<Options>? options =
                                                attributes?.options ?? [];
                                            return attributes != null
                                                ? Column(
                                                    crossAxisAlignment: AppData
                                                                .appLocale ==
                                                            "ar"
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment: AppData
                                                                .appLocale ==
                                                            "ar"
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                          crossAxisAlignment: AppData
                                                                      .appLocale ==
                                                                  "ar"
                                                              ? CrossAxisAlignment
                                                                  .end
                                                              : CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment: AppData
                                                                      .appLocale ==
                                                                  "ar"
                                                              ? MainAxisAlignment
                                                                  .end
                                                              : MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              AppData.appLocale ==
                                                                      "ar"
                                                                  ? attributes
                                                                          .labelArabic ??
                                                                      ""
                                                                  : attributes
                                                                          .label ??
                                                                      "",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 1,
                                                              // textDirection: TextDirection.rtl,
                                                              style: FontPalette
                                                                  .black12w600,
                                                            ),
                                                          ]),
                                                      SizedBox(
                                                        height: 7.h
                                                      ),
                                                      options.isNotEmpty
                                                          ? SizedBox(
                                                              height: 24.h,
                                                              child: ListView
                                                                  .builder(
                                                                      reverse: AppData.appLocale ==
                                                                              "ar"
                                                                          ? true
                                                                          : false,
                                                                      shrinkWrap:
                                                                          false,
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount:
                                                                          options
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext ctx,
                                                                              int _index) {
                                                                        Options?
                                                                            option =
                                                                            attributes.options![_index];
                                                                        return option.colorCode !=
                                                                                null
                                                                            ? Column(
                                                                                crossAxisAlignment: AppData.appLocale == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                                mainAxisAlignment: AppData.appLocale == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      context.read<ProductProvider>().updateVariantSelection(option, attributes.label ?? "");
                                                                                      qntyController.text = "1";
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 23.h,
                                                                                      width: 23.w,
                                                                                      margin: EdgeInsets.only(right: 4.w),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(2.r),
                                                                                        border: Border.all(color: option.isSelected ?? true ? Colors.black : Colors.transparent),
                                                                                      ),
                                                                                      child: Container(
                                                                                        // height: 20.h,
                                                                                        // width: 20.w,
                                                                                        color: HexColor("#${option.colorCode ?? ""}"),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : InkWell(
                                                                                child: Row(
                                                                                  crossAxisAlignment: AppData.appLocale == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: AppData.appLocale == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 22,
                                                                                      // width: 35.w,
                                                                                      decoration: BoxDecoration(
                                                                                        color: option.isSelected ?? true ? Colors.black : Colors.white,
                                                                                        borderRadius: BorderRadius.circular(2.r),
                                                                                        border: Border.all(color: Colors.black),
                                                                                      ),
                                                                                      margin: EdgeInsets.only(right: 4.w),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(3.h),
                                                                                        child: Directionality(
                                                                                          textDirection:  AppData.appLocale=="ar"? TextDirection.rtl : TextDirection.ltr,
                                                                                          child: Text(
                                                                                            AppData.appLocale=="ar"? option.optionValueAr ?? "":option.optionValue??"",
                                                                                            style: TextStyle(
                                                                                                color: option.isSelected ?? true ? Colors.white : HexColor("#121515"), fontSize: 12.sp),
                                                                                            textAlign: TextAlign.center,
                                                                                            textDirection: AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                onTap: () {
                                                                                  context.read<ProductProvider>().updateVariantSelection(option, attributes.label ?? "");
                                                                                  qntyController.text = "1";
                                                                                },
                                                                              );
                                                                      }),
                                                            )
                                                          : const SizedBox(),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox();
                                          })
                                      : const SizedBox(),
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ReadMoreText(
                                      parse(AppData.appLocale == "ar"
                                              ? pValue.detailData
                                                      ?.descriptionArabic ??
                                                  ""
                                              : pValue.detailData
                                                      ?.description ??
                                                  "")
                                          .body!
                                          .text,
                                      textAlign: AppData.appLocale == "ar"
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      textDirection: AppData.appLocale == "ar"
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      trimLines: 1,
                                      preDataText: "",
                                      preDataTextStyle: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      colorClickableText: Colors.black,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...${Constants.more}',
                                      trimExpandedText:
                                          ' ...${Constants.showLess}',
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 16.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 64.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            Constants.price,
                                            style: FontPalette.black16W500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24.w,
                                      )
                                    ],
                                  ),
                                  Flexible(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.r)),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        )),
                                    height: 30.h,
                                    width: 84.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            // "SAR ${pValue.unitPrice!.toStringAsFixed(2)}",
                                            pValue.unitPrice!
                                                        .toStringAsFixed(2)
                                                        .length >
                                                    5
                                                ? 'SAR ${pValue.unitPrice!.toStringAsFixed(2).substring(0, 5)}...'
                                                : "SAR ${pValue.unitPrice!.toStringAsFixed(2)}",
                                            style: FontPalette.black12w500,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  SizedBox(
                                    width: 32.w,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 64.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            Constants.discount,
                                            style: FontPalette.black16W500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Flexible(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.r)),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        )),
                                    height: 30.h,
                                    width: 84.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            pValue.unitSplPrice! > 0
                                                ? "${pValue.discountPercentage?.toStringAsFixed(2)}%"
                                                : "0%",
                                            style: FontPalette.black12w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),

                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 64.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            Constants.cutPrice,
                                            style: FontPalette.black16W500,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24.w,
                                      )
                                    ],
                                  ),
                                  Flexible(
                                      child: Container(
                                    height: 30.h,
                                    width: 84.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.r)),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            "SAR ${pValue.cutPrice!.toStringAsFixed(2)}",
                                            style: FontPalette.black12w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  SizedBox(
                                    width: 32.w,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 64.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(0.h),
                                          child: Text(
                                            Constants.quantity,
                                            style: FontPalette.black16W500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                    width: 84.w,
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      onTap: () => qntyController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset: qntyController
                                                  .value.text.length),
                                      controller: qntyController,
                                      focusNode: qntyFocusNode,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5.h),
                                        border: outlinedBorder,
                                        enabledBorder: outlinedBorder,
                                        counterText: "",
                                        focusedBorder: outlinedFocusedBorder,
                                        focusedErrorBorder: outlinedErrorBorder,
                                      ),
                                      onChanged: (value) {
                                        // String qty = qntyController.text.trim();
                                        // if (qty.isNotEmpty) {
                                        //   pValue.updateTotalByQuantity(qty);
                                        // }
                                      },
                                      onEditingComplete: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');

                                        String qty = qntyController.text.trim();
                                        if (qty.isNotEmpty) {
                                          pValue.updateTotalByQuantity(qty);
                                        } else {
                                          Helpers.showToast(
                                              Constants.cantProceedPrice);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    Constants.total,
                                    style: FontPalette.black16W500,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    "SAR ${pValue.total!.toStringAsFixed(2)}",
                                    style: FontPalette.black24W700,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 19.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 24.w, right: 24.w),
                              child: CustomCommonButton(
                                buttonText: Constants.addToCart,
                                onTap: () async {
                                  Navigator.pop(context);
                                  if (pValue.detailData != null) {
                                    DetailData? detailData = pValue.detailData;
                                    if (detailData?.unitPrice == 0 &&
                                        detailData?.unitSplPrice == 0) {
                                      detailData?.prodType == Constants.simple
                                          ? Helpers.showToast(
                                              Constants.cantProceedPrice)
                                          : Helpers.showToast(
                                              Constants.selectAvailablePdt);
                                    } else {
                                      if (qntyController.text
                                          .trim()
                                          .isNotEmpty) {
                                        cValue.addToCart(
                                            context: ctx,
                                            productId:
                                                pValue.detailData?.productId ??
                                                    "",
                                            productType:
                                                pValue.detailData?.prodType ??
                                                    "",
                                            combinationId:
                                                pValue.combinationId ?? "0",
                                            quantity:
                                                qntyController.text.trim(),
                                            customerId: "0");
                                      } else {
                                        Helpers.showToast(
                                            Constants.cantProceedQty);
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 27.h,
                            ),
                          ],
                        ),
                        pValue.loaderState == LoadState.loading ||
                                cValue.loaderState == LoadState.loading
                            ? Positioned(
                                bottom: 200.h,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ReusableWidgets.circularLoader(),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  }),
                )
              : Consumer3<ProductProvider, CartProvider, ConnectivityProvider>(
                  builder: (context, pValue, cValue, conProvider, child) {
                  return Stack(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        controller: scrollControllerDummy,
                        padding: EdgeInsets.all(11.h),
                        children: [
                          Icon(
                            Icons.remove,
                            color: Colors.grey[600],
                            size: 45,
                          ),

                          /// Name
                          Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppData.appLocale == "ar"
                                            ? pValue.detailData
                                                    ?.productNameArabic ??
                                                ""
                                            : pValue.detailData?.productName ??
                                                "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: FontPalette.black20W500,
                                      ),
                                    ),
                                  ])),
                          SizedBox(
                            height: 12.h,
                          ),

                          /// List of variants
                          /// ios number keypad ISSUE RESOLVED

                          SizedBox(
                            child: pValue.detailData?.prodType
                                        ?.toString()
                                        .toLowerCase() ==
                                    Constants.simple
                                ? const SizedBox()
                                : pValue.detailData!.attrbs!.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: pValue.attrLength,
                                        shrinkWrap: true,
                                        // physics: const BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Attrbs? attributes =
                                              pValue.detailData?.attrbs?[index];

                                          List<Options>? options =
                                              attributes?.options ?? [];
                                          return attributes != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      AppData.appLocale == "ar"
                                                          ? CrossAxisAlignment
                                                              .end
                                                          : CrossAxisAlignment
                                                              .start,
                                                  mainAxisAlignment: AppData
                                                              .appLocale ==
                                                          "ar"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        crossAxisAlignment: AppData
                                                                    .appLocale ==
                                                                "ar"
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment: AppData
                                                                    .appLocale ==
                                                                "ar"
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            AppData.appLocale ==
                                                                    "ar"
                                                                ? attributes
                                                                        .labelArabic ??
                                                                    ""
                                                                : attributes
                                                                        .label ??
                                                                    "",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            style: FontPalette
                                                                .black12w600,
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                      height: 7.h,
                                                    ),
                                                    options.length > 0
                                                        ? SizedBox(
                                                            height: 24.h,
                                                            // width:MediaQuery.of(context).size.width/1.2,
                                                            child: ListView
                                                                .builder(
                                                                    reverse: AppData
                                                                                .appLocale ==
                                                                            "ar"
                                                                        ? true
                                                                        : false,
                                                                    shrinkWrap:
                                                                        false,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        options
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                ctx,
                                                                            int _index) {
                                                                      Options?
                                                                          option =
                                                                          attributes
                                                                              .options![_index];
                                                                      return option.colorCode !=
                                                                              null
                                                                          ? Column(
                                                                              crossAxisAlignment: AppData.appLocale == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                              mainAxisAlignment: AppData.appLocale == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    context.read<ProductProvider>().updateVariantSelection(option, attributes.label ?? "");
                                                                                    qntyController.text = "1";
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 23.h,
                                                                                    width: 23.w,
                                                                                    margin: EdgeInsets.only(right: 4.w),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(2.r),
                                                                                      border: Border.all(color: option.isSelected ?? true ? Colors.black : Colors.transparent),
                                                                                    ),
                                                                                    child: Container(
                                                                                      // height: 20.h,
                                                                                      // width: 20.w,
                                                                                      color: HexColor("#${option.colorCode ?? ""}"),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : Directionality(
                                                                        textDirection: AppData.appLocale=="ar"? TextDirection.rtl : TextDirection.ltr,
                                                                            child: InkWell(
                                                                                child: Row(
                                                                                  crossAxisAlignment: AppData.appLocale == "ar" ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: AppData.appLocale == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 22,
                                                                                      // width: 35.w,
                                                                                      decoration: BoxDecoration(
                                                                                        color: option.isSelected ?? true ? Colors.black : Colors.white,
                                                                                        borderRadius: BorderRadius.circular(2.r),
                                                                                        border: Border.all(color: Colors.black),
                                                                                      ),
                                                                                      margin: EdgeInsets.only(right: 4.w),
                                                                                      child: Padding(
                                                                                        padding:   EdgeInsets.only(bottom: AppData.appLocale=="ar"? 3 : 3.h,left: 3.h,right: 3.h,top: 3.h),
                                                                                        child: Text(
                                                                                         AppData.appLocale=="ar"? option.optionValueAr ?? "":option.optionValue??"",
                                                                                          style: TextStyle(color: option.isSelected ?? true ? Colors.white : HexColor("#121515"), fontSize: 12.sp),
                                                                                          textAlign: TextAlign.center,
                                                                                          textDirection:  AppData.appLocale=="ar"? TextDirection.rtl : TextDirection.ltr,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                onTap: () {
                                                                                  context.read<ProductProvider>().updateVariantSelection(option, attributes.label ?? "");
                                                                                  qntyController.text = "1";
                                                                                },
                                                                              ),
                                                                          );
                                                                    }),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      height: 7.h,
                                                    ),
                                                  ],
                                                )
                                              : SizedBox();
                                        })
                                    : const SizedBox(),
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ReadMoreText(
                                    parse(AppData.appLocale == "ar"
                                            ? pValue.detailData
                                                    ?.descriptionArabic ??
                                                ""
                                            : pValue.detailData?.description ??
                                                "")
                                        .body!
                                        .text,
                                    textAlign: AppData.appLocale == "ar"
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    textDirection: AppData.appLocale == "ar"
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    trimLines: 1,
                                    preDataText: "",
                                    preDataTextStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    style: const TextStyle(color: Colors.black),
                                    colorClickableText: Colors.black,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: '...${Constants.more}',
                                    trimExpandedText:
                                        ' ...${Constants.showLess}',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16.h,
                          ),
                          Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 64.w,
                                      child: Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.price,
                                          style: FontPalette.black16W500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24.w,
                                    )
                                  ],
                                ),
                                Flexible(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.r)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )),
                                  height: 30.h,
                                  width: 84.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          // "SAR ${pValue.unitPrice!.toStringAsFixed(2)}",
                                          pValue.unitPrice!
                                                      .toStringAsFixed(2)
                                                      .length >
                                                  5
                                              ? 'SAR ${pValue.unitPrice!.toStringAsFixed(2).substring(0, 5)}...'
                                              : "SAR ${pValue.unitPrice!.toStringAsFixed(2)}",
                                          style: FontPalette.black12w500,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                  width: 32.w,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 64.w,
                                      child: Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.discount,
                                          style: FontPalette.black16W500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Flexible(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.r)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )),
                                  height: 30.h,
                                  width: 84.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          pValue.unitSplPrice! > 0
                                              ? "${pValue.discountPercentage?.toStringAsFixed(2)}%"
                                              : "0%",
                                          style: FontPalette.black12w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 64.w,
                                      child: Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.cutPrice,
                                          style: FontPalette.black16W500,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24.w,
                                    )
                                  ],
                                ),
                                Flexible(
                                    child: Container(
                                  height: 30.h,
                                  width: 84.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.r)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          "SAR ${pValue.cutPrice!.toStringAsFixed(2)}",
                                          style: FontPalette.black12w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                  width: 32.w,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 64.w,
                                      child: Padding(
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.quantity,
                                          style: FontPalette.black16W500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                SizedBox(
                                  height: 30.h,
                                  width: 84.w,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    onTap: () => qntyController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: qntyController
                                                .value.text.length),
                                    controller: qntyController,
                                    focusNode: qntyFocusNode,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5.h),
                                      border: outlinedBorder,
                                      enabledBorder: outlinedBorder,
                                      counterText: "",
                                      focusedBorder: outlinedFocusedBorder,
                                      focusedErrorBorder: outlinedErrorBorder,
                                    ),
                                    onChanged: (value) {
                                      // String qty = qntyController.text.trim();
                                      // if (qty.isNotEmpty) {
                                      //   pValue.updateTotalByQuantity(qty);
                                      // }
                                    },
                                    onEditingComplete: () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');

                                      String qty = qntyController.text.trim();
                                      if (qty.isNotEmpty) {
                                        pValue.updateTotalByQuantity(qty);
                                      } else {
                                        Helpers.showToast(
                                            Constants.cantProceedPrice);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  Constants.total,
                                  style: FontPalette.black16W500,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "SAR ${pValue.total!.toStringAsFixed(2)}",
                                  style: FontPalette.black24W700,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 19.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            child: CustomCommonButton(
                              buttonText: Constants.addToCart,
                              onTap: () async {
                                Navigator.pop(context);
                                if (pValue.detailData != null) {
                                  DetailData? detailData = pValue.detailData;
                                  if (detailData?.unitPrice == 0 &&
                                      detailData?.unitSplPrice == 0) {
                                    detailData?.prodType == Constants.simple
                                        ? Helpers.showToast(
                                            Constants.cantProceedPrice)
                                        : Helpers.showToast(
                                            Constants.selectAvailablePdt);
                                  } else {
                                    if (qntyController.text.trim().isNotEmpty) {
                                      cValue.addToCart(
                                          context: ctx,
                                          productId:
                                              pValue.detailData?.productId ??
                                                  "",
                                          productType:
                                              pValue.detailData?.prodType ?? "",
                                          combinationId:
                                              pValue.combinationId ?? "0",
                                          quantity: qntyController.text.trim(),
                                          customerId: "0");
                                    } else {
                                      Helpers.showToast(
                                          Constants.cantProceedQty);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 27.h,
                          ),
                        ],
                      ),
                      pValue.loaderState == LoadState.loading ||
                              cValue.loaderState == LoadState.loading
                          ? Positioned(
                              bottom: 200.h,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: ReusableWidgets.circularLoader(),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                }),
        );
      },
    );
  }

  static Widget showOverlayNotification(BuildContext context) {
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
            title: Text("hfdjf"),
            subtitle: Text("hguhguh"),
            trailing: InkWell(
              child: const Text(
                "Dismiss",
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                OverlaySupportEntry.of(context)!.dismiss();
              },
            )),
      ),
    );
  }
}
