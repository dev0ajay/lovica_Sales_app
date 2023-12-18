import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/helpers.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/models/order_list_model.dart';
import 'package:lovica_sales_app/providers/check_out_provider.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../providers/authentication_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<City> city = ValueNotifier(City());
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final checkOutProvider =
        Provider.of<CheckOutProvider>(context, listen: false);
    _scollListen(checkOutProvider);
    Future.microtask(() {
      checkOutProvider
        ..initPage()
        ..getOrdersList(
            context: context, "", initialLoad: true, start: 0, limit: 20);
    });
  }

  void _scollListen(CheckOutProvider checkOutProvider) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (checkOutProvider.totPdtCount! >
            checkOutProvider.totPdtCountAftrPagination!) {
          pageStartCount.value = pageStartCount.value + 20;
          checkOutProvider.getOrdersList("",
              context: context,
              limit: 20,
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<CheckOutProvider, AppLocalizationProvider>(
          builder: (context, value, lp, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.sales,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
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
                                style: FontPalette.grey10Italic)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              suffix: suffixWidget(),
                              onChanged: (val) {
                                Future.microtask(() =>
                                    context.read<CheckOutProvider>()
                                      ..clearOrdersList()
                                      ..getOrdersList(
                                          initialLoad: true,
                                          context: context,
                                          searchController.text));
                              },

                              hintText: Constants.searchForOrderId,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.searchForOrderId,
                              controller: searchController,
                              style: FontPalette.grey12Italic
                                  .copyWith(color: HexColor("#7A7A7A")),
                              // readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 34.h,
                    ),
                    value.ordersList?.isNotEmpty ?? true
                        ? Expanded(
                            child: Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: CupertinoScrollbar(
                                thumbVisibility: false,
                                thickness: 3,
                                controller: scrollController,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: scrollController,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    OrderItem? item = value.ordersList?[index];
                                    return item != null
                                        ? InkWell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  bottom: 16.h),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                color: const Color(0xFFF5F5F5),
                                                child: Padding(
                                                  padding: EdgeInsets.all(11.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${Constants.orderNumber} :${item.orderNumber ?? ""}",
                                                            style: FontPalette
                                                                .black12w500,
                                                          ),
                                                          SizedBox(
                                                            height: 7.h,
                                                          ),
                                                          Text(
                                                            "${Constants.totItems} :${item.itemsCount ?? 0}",
                                                            style: FontPalette
                                                                .grey10Regular,
                                                          ),
                                                          SizedBox(
                                                            height: 3.h,
                                                          ),
                                                          Text(
                                                            "${Constants.amtPaid} : SAR ${Helpers.convertToDouble(item.grandTotal ?? 0)}",
                                                            style: FontPalette
                                                                .grey10Regular,
                                                          ),
                                                          SizedBox(
                                                            height: 3.h,
                                                          ),
                                                          Text(
                                                            "${Constants.date} : ${item.orderDate ?? ""}",
                                                            style: FontPalette
                                                                .grey10Regular,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 17.w,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              AppData.appLocale ==
                                                                      "ar"
                                                                  ? item.statusAr ??
                                                                      ""
                                                                  : item.status ??
                                                                      "",
                                                              style: FontPalette
                                                                  .black16W500,
                                                              maxLines: 4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${Constants.name} : ${item.customerName ?? ""}",
                                                              maxLines: 1,
                                                              style: FontPalette
                                                                  .black12Regular,
                                                            ),
                                                            SizedBox(
                                                              height: 9.h
                                                            ),
                                                            Text(
                                                              "${Constants.city} : ${AppData.appLocale=="ar"?item.arcity ?? "":item.city?? ""}",

                                                              style: FontPalette
                                                                  .grey10Regular,
                                                            ),
                                                            SizedBox(
                                                              height: 15.h
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                NavRoutes
                                                                    .navToOrderDetails(
                                                                        context,
                                                                        item);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      Constants
                                                                          .viewDetails,
                                                                      style: FontPalette
                                                                          .black10w600,
                                                                    ),
                                                                  ),
                                                                  const Flexible(
                                                                    child: Icon(Icons
                                                                        .arrow_right),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                          )
                                        : const SizedBox();
                                  },
                                  itemCount: value.ordersList?.length,
                                ),
                              ),
                            ),
                          )
                        : value.loaderState != LoadState.loading
                            ? Center(
                                child: SizedBox(
                                child: Text(Constants.noData),
                              ))
                            : const SizedBox(),
                    Center(
                        child: ReusableWidgets.paginationLoader(
                            value.paginationLoader))
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

  Widget prefixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: const Text(
            '+966',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          height: 55.h,
          width: 1.w,
          color: Colors.black,
        ),
        SizedBox(
          width: 12.w,
        )
      ],
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

// this method shows the modal dialog
  dynamic _showModal(BuildContext context) async {
    // show the modal dialog and pass some data to it
    final result = await Navigator.of(context).push(FullScreenModal(
        title: Constants.submitted,
        description: 'Just some dummy description text'));

    // print the data returned by the modal if any
    debugPrint(result.toString());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
