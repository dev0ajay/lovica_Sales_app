import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/order_list_model.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../providers/check_out_provider.dart';
import 'components/positioned_amount_paid_widget.dart';


class OrderDetailsScreen extends StatefulWidget {
  OrderItem? orderItem;

  OrderDetailsScreen({super.key, this.orderItem});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int listIndex = 0;
  List combData = [];
  @override
  void initState() {
    Future.microtask(() => context.read<CheckOutProvider>()
      ..clearOrderDetails()
      ..getOrderDetails(widget.orderItem?.orderNumber ?? "", context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<CheckOutProvider, AppLocalizationProvider>(
          builder: (context, cProvider, aProvider, child) {
            return NetworkConnectivity(
              inAsyncCall: cProvider.loaderState == LoadState.loading,
              child: Stack(
                children: [
                  buildStackedColumnWidgetMethod(context, cProvider),
                  PositionedAmountPaidWidget(widget: widget),
                ],
              ),
            );
          },
        ),
      ),
      // appBar: CommonAppBar(),
    );
  }

  Column buildStackedColumnWidgetMethod(BuildContext context, CheckOutProvider cProvider) {
    return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.orderDetails,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20.h
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Row(
                          children: [
                            Text(
                              Constants.home,
                              style: FontPalette.grey10Italic,
                            ),
                            Text(" / ", style: FontPalette.grey10Italic),
                            Text(Constants.sales,
                                style: FontPalette.grey10Italic),
                            Text(" / ", style: FontPalette.grey10Italic),
                            Text(" #${widget.orderItem?.orderNumber ?? ""} ",
                                style: FontPalette.grey10Italic),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Text(Constants.orderNumber,
                                style: FontPalette.black24Regular),
                            Text(" : ${widget.orderItem?.orderNumber ?? ""} ",
                                style: FontPalette.black24Regular),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Text(
                                AppData.appLocale == "ar"
                                    ? widget.orderItem?.statusAr ?? ""
                                    : widget.orderItem?.status ?? "",
                                style: FontPalette.black16W500),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  SizedBox(
                                    width: context.sw() * 0.15,
                                    child: Text(
                                      Constants.date,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      style: FontPalette.black12w500,
                                    ),
                                  ),
                                  Text(
                                    ":  ${widget.orderItem?.orderDate ?? ""}",
                                    maxLines: 1,
                                    style: FontPalette.black12w500,
                                  ),
                                ],
                              ),
                              Text(
                                "${Constants.totItems} : ${widget.orderItem?.itemsCount ?? ""} ${Constants.items}",
                                maxLines: 1,
                                style: FontPalette.black12w500,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: AppData.appLocale == "ar"
                          ? EdgeInsets.only(left: 100.w, right: 10.h)
                          : EdgeInsets.only(left: 10.w, right: 100.h),
                      child: Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: context.sw() * 0.15,
                              child: Text(
                                Constants.name,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: FontPalette.black12w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ":  ${widget.orderItem?.customerName ?? ""}",
                                maxLines: 5,
                                style: FontPalette.black12w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: AppData.appLocale == "ar"
                          ? EdgeInsets.only(left: 100.w, right: 10.h)
                          : EdgeInsets.only(left: 10.w, right: 100.h),
                      child: Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: context.sw() * 0.15,
                              child: Text(
                                Constants.city,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: FontPalette.black12w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ":  ${AppData.appLocale == "ar" ? cProvider.orderDetails?.orderDetailData?.customerData?.cityName_aR ?? "" : cProvider.orderDetails?.orderDetailData?.customerData?.cityName_eN ?? ""}",
                                maxLines: 5,
                                style: FontPalette.black12w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: AppData.appLocale == "ar"
                          ? EdgeInsets.only(left: 100.w, right: 10.h)
                          : EdgeInsets.only(left: 10.w, right: 100.h),
                      child: Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: context.sw() * 0.15,
                              child: Text(
                                Constants.address,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: FontPalette.black12w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ":  ${cProvider.orderDetails?.orderDetailData?.customerData?.entAddress ?? ""}",
                                maxLines: 5,
                                style: FontPalette.black12w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Constants.productDetails,
                              maxLines: 1,
                              style: FontPalette.black20W500,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h
                    ),
                    cProvider.salesData!.isNotEmpty
                        ? Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              color: const Color(0xFFF5F5F5),
                              margin: EdgeInsets.only(
                                  left: 12.w, right: 12.w, bottom: 16.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 7.h),
                                child: SizedBox(
                                  height: 25.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        Constants.itemName,
                                        maxLines: 1,
                                        style: FontPalette.black16W500,
                                      ),
                                      Text(
                                        Constants.qty,
                                        maxLines: 1,
                                        style: FontPalette.black16W500,
                                      ),
                                      Text(
                                        Constants.amount,
                                        maxLines: 1,
                                        style: FontPalette.black16W500,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    cProvider.salesData!.isNotEmpty
                        ? Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child:
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  SalesData data = cProvider.salesData![index];

                                  // Combination combinationData = cProvider.combination![index];
                                // combData.add(combinationData.optionColorcode);
                                  return data != null
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 12.w,
                                              right: 12.w,
                                              bottom: 16.h,
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            color: const Color(0xFFF5F5F5),
                                            child: Padding(
                                              padding: EdgeInsets.all(11.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: context.sw() * 0.25,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          AppData.appLocale ==
                                                                  "ar"
                                                              ? data.productNameArabic ??
                                                                  ""
                                                              : data.productName ??
                                                                  "",
                                                          maxLines: 3,
                                                          style: FontPalette
                                                              .black12w500,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Row(
                                                          children: [
                                                            data.optionColorCode!.isNotEmpty ?
                                                            Container(
                                                                              height:
                                                                              10.h,
                                                                              width:
                                                                              10.w,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                color:  HexColor(
                                                                                    "#${data.optionColorCode}"),
                                                                                borderRadius:
                                                                                BorderRadius.circular(2.r),
                                                                                border: Border.all(
                                                                                    color:
                                                                                    Colors.black),
                                                                              ),
                                                                              margin: EdgeInsets.only(
                                                                                  right:
                                                                                  4.w),
                                                                            ) : const SizedBox(),
                                                          ],
                                                        ),
                                                        // data.type!.toLowerCase() ==
                                                        //         Constants.simple
                                                        //     ? const SizedBox()
                                                        //     : data.optionColorCode != null
                                                        //         ?

                                                        // Old listview with wrap

                                                        // Wrap(
                                                        //   crossAxisAlignment: WrapCrossAlignment.center,
                                                        //             children: [
                                                        //               Text(
                                                        //                 "${Constants.color}  ",
                                                        //                 maxLines:
                                                        //                     1,
                                                        //                 style: FontPalette
                                                        //                     .black10Regular,
                                                        //               ),
                                                        //               data.optionColorCode!.isNotEmpty ?   Container(
                                                        //                 height:
                                                        //                 10.h,
                                                        //                 width:
                                                        //                 10.w,
                                                        //                 decoration:
                                                        //                 BoxDecoration(
                                                        //                   color: HexColor(
                                                        //                       "#${data.optionColorCode}") ,
                                                        //                   borderRadius:
                                                        //                   BorderRadius.circular(2.r),
                                                        //                   border: Border.all(
                                                        //                       color:
                                                        //                       Colors.black),
                                                        //                 ),
                                                        //                 margin: EdgeInsets.only(
                                                        //                     right:
                                                        //                     4.w),
                                                        //               ) : SizedBox(),
                                                        //
                                                        //
                                                        //             ],
                                                        //           )
                                                                // : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "${data.salesQty}",
                                                    maxLines: 1,
                                                    style:
                                                        FontPalette.black12w500,
                                                  ),
                                                  Text(
                                                    "SAR ${data.unitSplPrice ?? ""}",
                                                    maxLines: 1,
                                                    style:
                                                        FontPalette.black16W500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                },
                                itemCount: cProvider.salesData!.length,
                              ),
                            ),

                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 42.h
                    ),
                    // Directionality(
                    //   textDirection: AppData.appLocale == "ar"
                    //       ? TextDirection.rtl
                    //       : TextDirection.ltr,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text.rich(
                    //           TextSpan(
                    //           text: "${Constants.amtPaid} : ",
                    //           style: FontPalette.black12w500,
                    //           children: <InlineSpan>[
                    //             TextSpan(
                    //               text:
                    //                   "SAR ${widget.orderItem?.grandTotal ?? ""}",
                    //               style: FontPalette.black24W700,
                    //             )
                    //           ]))
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 30.h
                    // ),
                  ],
                );
  }
}

