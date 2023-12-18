import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/customer_model.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:provider/provider.dart';
import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/route_generator.dart';
import '../../common/validator.dart';
import '../../models/route_arguments.dart';
import '../../providers/customer_provider.dart';
import '../../providers/localization_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/custom_common_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/reusable_widgets.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _throttle;
  late final FocusNode _focus;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    _scollListen(customerProvider);
    _focus = FocusNode();
    // String cityId = context.read<AuthenticationProvider>().userData?.city ?? "";
    Future.microtask(() {
      customerProvider
        ..clearData()
        ..getCustomers("", "",
            initialLoad: true, start: 0, limit: 20, context: context);
    });
  }

  void _scollListen(CustomerProvider customerProvider) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (customerProvider.totPdtCount! >
            customerProvider.totPdtCountAftrPagination!) {
          pageStartCount.value = pageStartCount.value + 20;
          customerProvider.getCustomers("", "",
              context: context,
              limit: 20,
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    _focus.dispose();
    if (_throttle?.isActive ?? false) _throttle?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<CustomerProvider, AppLocalizationProvider>(
          builder: (context, value, localeProvider, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderTile(
                          showAppIcon: true,
                          title: Constants.customerList,
                          onTapBack: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          height: 12.h,
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
                                Text(Constants.customers,
                                    style: FontPalette.grey10Italic)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    suffix: suffixWidget(),
                                    hintText: Constants.enterCustOrShopName,
                                    hintFontPalette: FontPalette.black12Regular
                                        .copyWith(color: HexColor("#7A7A7A")),
                                    labelText: Constants.enterCustOrShopName,
                                    controller: _searchController,
                                    style: FontPalette.grey12Italic
                                        .copyWith(color: HexColor("#7A7A7A")),
                                    onChanged: (text) {
                                      Future.microtask(() =>
                                          context.read<CustomerProvider>()
                                            ..clearData()
                                            ..getCustomers("", text,
                                                initialLoad: true,
                                                start: 0,
                                                limit: 20,
                                                context: context));
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
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: CustomCommonButton(
                              buttonText: Constants.addCust,
                              onTap: () async {
                                // String cityId = context
                                //         .read<AuthenticationProvider>()
                                //         .userData
                                //         ?.city ??
                                    "";
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(RouteGenerator.routeAddCustomer,
                                        arguments: RouteArguments(
                                            from: "customerList"))
                                    .then((value) => Future.microtask(() =>
                                        context.read<CustomerProvider>()
                                          ..clearData()
                                          ..getCustomers("", "",
                                              initialLoad: true,
                                              start: 0,
                                              limit: 20,
                                              context: context)));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 33.h,
                        ),
                        Directionality(
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
                                      Constants.custID,
                                      maxLines: 1,
                                      style: FontPalette.black12W500,
                                    ),
                                    Text(
                                      Constants.custName,
                                      maxLines: 1,
                                      style: FontPalette.black12W500,
                                    ),
                                    Text(
                                      Constants.mobileNumber,
                                      maxLines: 1,
                                      style: FontPalette.black12W500,
                                    ),
                                    Text(
                                      Constants.action,
                                      maxLines: 1,
                                      style: FontPalette.black12W500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        value.customerList.isNotEmpty
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
                                        Customer customer =
                                            value.customerList[index];
                                        return customer != null
                                            ? Container(
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
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 7.h),
                                                    child: SizedBox(
                                                      height: 25.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          // Expanded(
                                                          //   flex:1,
                                                          //   child:
                                                          Text(
                                                            "${customer.customerId}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: FontPalette
                                                                .black12W400,
                                                          ),
                                                          // ),
                                                          // Expanded(
                                                          //   flex: 1,
                                                          //   child:
                                                          SizedBox(
                                                            width: 60.w,
                                                            child: Center(
                                                              child: Text(
                                                                "${customer.croppedName}",
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FontPalette
                                                                    .black12W400,
                                                              ),
                                                            ),
                                                          ),
                                                          // ),
                                                          // Expanded(
                                                          //   flex: 1,
                                                          //   child:
                                                          Text(
                                                              "${customer.customerNumber}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FontPalette
                                                                  .black12W400),

                                                          // ),

                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pushNamed(
                                                                          RouteGenerator
                                                                              .routeCustomerEdit,
                                                                          arguments: RouteArguments(
                                                                              customerID: customer
                                                                                  .customerId))
                                                                      .then((value) => Future.microtask(() => context.read<
                                                                          CustomerProvider>()
                                                                        // ..clearData()
                                                                        ..getCustomers(
                                                                            "",
                                                                            "",
                                                                            initialLoad: true,
                                                                            start: 0,
                                                                            limit: 20,
                                                                            context: context)));
                                                                },
                                                                child: SizedBox(
                                                                  // width: 20.w,
                                                                  height: 30.h,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .all(0
                                                                            .w),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/icons/edit_cust_icon.svg"),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pushNamed(
                                                                          RouteGenerator
                                                                              .routeCustomerView,
                                                                          arguments: RouteArguments(
                                                                              customerID: customer
                                                                                  .customerId))
                                                                      .then((value) => Future.microtask(() => context.read<CustomerProvider>()
                                                                        ..getCustomers(
                                                                            "",
                                                                            "",
                                                                            initialLoad:
                                                                                true,
                                                                            start: 0,
                                                                            limit: 20,
                                                                            context: context)));
                                                                },
                                                                child: SizedBox(
                                                                  // width: 20.w,
                                                                  height: 30.h,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .all(0
                                                                            .w),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/icons/view_cust_icon.svg"),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox();
                                      },
                                      itemCount: value.customerList.length,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Center(
                            child: ReusableWidgets.paginationLoader(
                                value.paginationLoader))
                      ],
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
              color: Colors.black,
              size: 25.h,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 12.w
        )
      ],
    );
  }
}
