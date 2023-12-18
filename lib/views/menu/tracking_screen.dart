import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../models/order_list_model.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/check_out_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dropdown/custom_dropdown.dart';
import '../../widgets/reusable_widgets.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TextEditingController searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<City> city = ValueNotifier(City());
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.text = "";
    final checkOutProvider =
        Provider.of<CheckOutProvider>(context, listen: false);
    _scollListen(checkOutProvider);
    Future.microtask(() {
      checkOutProvider
        ..clearOrdersList()
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
                      title: Constants.tracking,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
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
                            Text(Constants.tracking,
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
                                          context: context,
                                          initialLoad: true,
                                          start: 0,
                                          limit: 20,
                                          searchController.text));
                              },
                              hintText: Constants.searchForOrderId,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.searchForOrderId,
                              controller: searchController,
                              style: FontPalette.grey12Italic
                                  .copyWith(color: HexColor("#7A7A7A")),
                              validator: (val) {
                                return Validator.validateEMptyField(val);
                              },
                              // readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 34.h,
                    ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 12.w, right: 12.w, bottom: 16.h),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          color: const Color(0xFFF5F5F5),
                          child: Padding(
                            padding: EdgeInsets.all(7.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // use whichever suits your need
                              children: <Widget>[
                                Text(
                                  Constants.orderNo,
                                  style: FontPalette.black16W500,
                                ),
                                Text(
                                  Constants.custName,
                                  style: FontPalette.black16W500,
                                ),
                                Text(
                                  Constants.orderStatus,
                                  style: FontPalette.black16W500,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    value.ordersList?.isNotEmpty ?? true
                        ? Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Expanded(
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
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 12.w,
                                                right: 12.w,
                                                bottom: 16.h),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              color: const Color(0xFFF5F5F5),
                                              child: Padding(
                                                padding: EdgeInsets.all(7.w),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  // use whichever suits your need
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.orderNumber ?? "",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: FontPalette
                                                            .black16Regular,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.customerName ?? "",
                                                        style: FontPalette
                                                            .black16W500,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        AppData.appLocale ==
                                                                "ar"
                                                            ? item.shippingStatusAr ??
                                                                ""
                                                            : item.shippingStatus ??
                                                                "",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color: item.shippingStatus ==
                                                                  "Pending"
                                                              ? Colors
                                                                  .deepOrangeAccent
                                                              : item.shippingStatus ==
                                                                      "Delivered"
                                                                  ? Colors.green
                                                                  : item.shippingStatus ==
                                                                          "Intransit"
                                                                      ? Colors
                                                                          .amber
                                                                      : item.shippingStatus ==
                                                                              "Out for delivery"
                                                                          ? Colors
                                                                              .orange
                                                                          : item.shippingStatus == "orderplaced"
                                                                              ? Colors.lightGreen
                                                                              : Colors.black,
                                                        ),
                                                        // style: FontPalette
                                                        //     .black16W500,
                                                        maxLines: 8,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox();
                                  },
                                  itemCount: value.ordersList!.length,
                                ),
                              ),
                            ),
                          )
                        : value.loaderState != LoadState.loading
                            ? Center(
                                child: SizedBox(
                                child: Text(Constants.noData),
                              ),
                    )
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
}
