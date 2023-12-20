import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lovica_sales_app/common/helpers.dart';
import 'package:lovica_sales_app/models/order_duplicate_model.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/font_palette.dart';
import '../../common/network_connectivity.dart';
import '../../common/route_generator.dart';
import '../../models/checkout_model.dart';
import '../../models/customer_model.dart';
import '../../models/route_arguments.dart';
import '../../providers/check_out_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/localization_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_common_button.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  OrderDuplicateModel? orderDuplicateModel;
  bool oneTime = true;
  bool isPoped = false;
  String permitValue = "";

  @override
  void initState() {
    // String cityId = context.read<AuthenticationProvider>().userData?.city ?? "";
    // Future.microtask(() => context
    //         .read<CustomerProvider>()
    //         .getCustomers(cityId, "", "", "", context: context))
    //     .then((value) => Future.microtask(() => context
    //         .read<CheckOutProvider>()
    //         .masterCheckout(context: context, customerId: "0")));

    Future.microtask(() => context.read<CheckOutProvider>()
      ..updateCustomer(null)
      ..upateCustomerDataPopupVisibility(false));

    // context.read<CheckOutProvider>().
    // paymentType(context: context, paymentType: "Cash On Delivery", totalAmount: value.grandTotal!.toStringAsFixed(2));
    super.initState();
  }

  void unselectRadio() {
    setState(() {
      oneTime = false;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   if(oneTime == true) {
  //     context.read<CheckOutProvider>().
  //     paymentType(context: context, paymentType: "Cash on Delivery", totalAmount: ""
  //     );
  //     setState(() {
  //       oneTime = false;
  //     });
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar:
      body: SafeArea(
        child: Consumer3<CheckOutProvider, CustomerProvider,
            AppLocalizationProvider>(
          builder: (context, value, cusProvider, lp, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading ||
                  cusProvider.loaderState == LoadState.loading,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: AppData.appLocale == "ar"
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: AppData.appLocale == "ar"
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderTile(
                          showAppIcon: true,
                          title: Constants.checkoutPage,
                          onTapBack: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 20.h),
                        const SubHeaderWidget(),
                        SizedBox(height: 21.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            Constants.customerDetails,
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        buildCustomerSelectMethod(cusProvider, value),
                        SizedBox(
                          height: 14.h
                        ),
                        value.showCustomerPopup &&
                                value.selectedCustomer != null
                            ? Directionality(
                                textDirection: AppData.appLocale == "ar"
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  child: Card(
                                    elevation: 2,
                                    color: HexColor("#F3F3F3"),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            child: IconButton(
                                              iconSize: 15.w,
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                value
                                                  ..handleCustomerDataPopupVisibility()
                                                  ..updateCustomer(null);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 120.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: Text(
                                                        Constants.name,
                                                        style: FontPalette
                                                            .black14w400,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 0.h),
                                                      child: Text(
                                                        ":",
                                                        style: FontPalette
                                                            .black14Regular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 31.w,
                                              ),
                                              Expanded(
                                                  child: Text(value
                                                          .selectedCustomer
                                                          ?.customerName ??
                                                      "")),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 120.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: Text(
                                                        Constants.mobileNumber,
                                                        style: FontPalette
                                                            .black14w400,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 0.h),
                                                      child: Text(
                                                        ":",
                                                        style: FontPalette
                                                            .black14Regular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 31.w,
                                              ),
                                              Expanded(
                                                  child: Text(value
                                                          .selectedCustomer
                                                          ?.customerNumber ??
                                                      "")),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 120.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: Text(
                                                        Constants.address,
                                                        style: FontPalette
                                                            .black14w400,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 0.h),
                                                      child: Text(
                                                        ":",
                                                        style: FontPalette
                                                            .black14Regular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 31.w),
                                              Expanded(
                                                  child: Text(value
                                                          .selectedCustomer
                                                          ?.customerAddress ??
                                                      "")),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 120.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: Text(
                                                        Constants.city,
                                                        style: FontPalette
                                                            .black14w400,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 0.h),
                                                      child: Text(
                                                        ":",
                                                        style: FontPalette
                                                            .black14Regular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 31.w,
                                              ),
                                              Expanded(
                                                  child: Text(AppData
                                                              .appLocale ==
                                                          "ar"
                                                      ? value.selectedCustomer
                                                              ?.cityNameArabic ??
                                                          ""
                                                      : value.selectedCustomer
                                                              ?.cityName ??
                                                          "")),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pushNamed(
                                                            RouteGenerator
                                                                .routeCustomerEdit,
                                                            arguments: RouteArguments(
                                                                customerID: value
                                                                        .selectedCustomer!
                                                                        .customerId ??
                                                                    ""))
                                                        .then((data) {
                                                      final cusProvider =
                                                          context.read<
                                                              CustomerProvider>();

                                                      cusProvider
                                                        ..clearData()
                                                        ..getCustomers("", "",
                                                                initialLoad:
                                                                    true,
                                                                start: 0,
                                                                limit: 0,
                                                                context:
                                                                    context)
                                                            .then((boolValue) {
                                                          if (boolValue) {
                                                            print(
                                                                "customer length : ${context.read<CustomerProvider>().customerList.length}");

                                                            value
                                                              ..updateCustomerAfterEditFromCheckOut(
                                                                  context,
                                                                  value
                                                                      .selectedCustomer
                                                                      ?.customerId)
                                                              ..upateCustomerDataPopupVisibility(
                                                                  true);
                                                          }
                                                        });
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    // width: 20.w,
                                                    height: 30.h,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0.w),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/edit_cust_icon.svg"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 14.w,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pushNamed(
                                                            RouteGenerator
                                                                .routeCustomerView,
                                                            arguments: RouteArguments(
                                                                customerID: value
                                                                        .selectedCustomer!
                                                                        .customerId ??
                                                                    ""))
                                                        .then((data) {
                                                      final cusProvider =
                                                          context.read<
                                                              CustomerProvider>();

                                                      cusProvider
                                                        ..clearData()
                                                        ..getCustomers("", "",
                                                                initialLoad:
                                                                    true,
                                                                start: 0,
                                                                limit: 0,
                                                                context:
                                                                    context)
                                                            .then((boolValue) {
                                                          if (boolValue) {
                                                            print(
                                                                "customer length : ${context.read<CustomerProvider>().customerList.length}");

                                                            value
                                                              ..updateCustomerAfterEditFromCheckOut(
                                                                  context,
                                                                  value
                                                                      .selectedCustomer
                                                                      ?.customerId)
                                                              ..upateCustomerDataPopupVisibility(
                                                                  true);
                                                          }
                                                        });
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    // width: 20.w,
                                                    height: 30.h,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0.w),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/view_cust_icon.svg"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25.w)
                                              ],
                                            )

                                            // InkWell(
                                            //   child: SvgPicture.asset(
                                            //       "assets/icons/edit_cust_icon.svg"),
                                            //   onTap: () {
                                            //     Navigator.of(context,
                                            //             rootNavigator: true)
                                            //         .pushNamed(
                                            //             RouteGenerator
                                            //                 .routeCustomerEdit,
                                            //             arguments: RouteArguments(
                                            //                 customerID: value
                                            //                         .selectedCustomer!
                                            //                         .customerId ??
                                            //                     ""))
                                            //         .then((data) async {
                                            //       final cusProvider = context
                                            //           .read<CustomerProvider>();
                                            //
                                            //       cusProvider
                                            //         ..clearData()
                                            //         ..getCustomers("", "",
                                            //                 initialLoad: true,
                                            //                 start: 0,
                                            //                 limit: 0,
                                            //                 context: context)
                                            //             .then((boolValue) {
                                            //           if (boolValue) {
                                            //
                                            //             print(
                                            //                 "customer length : ${context.read<CustomerProvider>().customerList.length}");
                                            //
                                            //             value
                                            //               ..updateCustomerAfterEditFromCheckOut(
                                            //                   context,
                                            //                   value
                                            //                       .selectedCustomer
                                            //                       ?.customerId)
                                            //               ..upateCustomerDataPopupVisibility(
                                            //                   true);
                                            //           }
                                            //         });
                                            //     });
                                            //   },
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: 14.h),
                        Center(
                          child: InkWell(
                            onTap: () {
                              // String cityId = context
                              //         .read<AuthenticationProvider>()
                              //         .userData
                              //         ?.city ??
                              //     "";
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(RouteGenerator.routeAddCustomer,
                                      arguments:
                                          RouteArguments(from: "checkout"))
                                  .then((value) {
                                Future.microtask(() => context
                                    .read<CustomerProvider>()
                                    .getCustomers("", "",
                                        initialLoad: true,
                                        start: 0,
                                        limit: 0,
                                        context: context));
                                Future.microtask(
                                    () => context.read<CheckOutProvider>()
                                      // ..updateCustomer(customer)
                                      ..upateCustomerDataPopupVisibility(true));
                              });
                            },
                            child: Container(
                              width: 150.w,
                              // height: 24.h,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5.h),
                                  child: Text(
                                    Constants.addNewCustomer,
                                    style: FontPalette.white14w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            Constants.shippingInfo,
                            style: FontPalette.black16W500,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            itemCount: value.shippingInfo?.length,
                            itemBuilder: (ctx, i) {
                              ShippingMethods? shippingMethod =
                                  value.shippingInfo?[i];

                              return SizedBox(
                                height: 40.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Radio(
                                        value: shippingMethod,
                                        groupValue: value.selectedShippingInfo,
                                        onChanged: (val) async {
                                          if (shippingMethod != null) {
                                            value.updateShippingInfo(
                                                shippingMethod, context);
                                          }
                                        }),
                                    Expanded(
                                      child: Text(
                                        AppData.appLocale == "ar"
                                            ? shippingMethod
                                                    ?.shippingTitleArabic ??
                                                ""
                                            : shippingMethod?.shippingTitle ??
                                                "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontPalette.black14w400,
                                        // textAlign: AppData.appLocale=="ar"?TextAlign.right:TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1 / 2,
                                    mainAxisExtent: 60.h,
                                    crossAxisCount: 3),
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            Constants.noteToWareHouse,
                            style: FontPalette.black16W500,
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Card(
                              color: HexColor("#F3F3F3"),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                    maxLines: 6,
                                    textAlignVertical: TextAlignVertical.top,
                                    textInputAction: TextInputAction.done,
                                    controller: notesController,
                                    onChanged: (val) {},
                                    // textDirection: AppData.appLocale == "ar"
                                    //     ? TextDirection.rtl
                                    //     : TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    // textAlign: AppData.appLocale == "ar"
                                    //     ? TextAlign.start
                                    //     : TextAlign.end,
                                    decoration: InputDecoration(
                                        hintText: Constants.noteToWareHouse,
                                        hintTextDirection:
                                            AppData.appLocale == "ar"
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(5.h),
                                        border: InputBorder.none)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            Constants.paymentDetails,
                            style: FontPalette.black16W500,
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            itemCount: value.paymentMethods?.length,
                            itemBuilder: (ctx, i) {
                              PaymentMethods? paymentMethod =
                                  value.paymentMethods?[i];
                              return SizedBox(
                                height: 40.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                        // toggleable: true,
                                        value: oneTime == true
                                            ? false
                                            : paymentMethod,
                                        groupValue: value.selectedPaymentMethod,
                                        onChanged: (val) async {
                                          if (paymentMethod != null) {
                                            value.updatePaymentMethod(
                                                paymentMethod);
                                            unselectRadio();

                                            ///Method for checking the permit of selected payment method
                                            await context
                                                .read<CheckOutProvider>()
                                                .paymentType(
                                                    paymentType: value
                                                        .selectedPaymentMethod!
                                                        .paymentTitle!,
                                                    totalAmount: value
                                                        .grandTotal!
                                                        .toStringAsFixed(2));
                                            permitValue = value.permit;
                                            print("permit: $permitValue");
                                            value.permit == "No"
                                                ? AppData.appLocale == "ar"
                                                    ? Helpers.showToast(value
                                                        .paymentMethodMessageAr)
                                                    : Helpers.showToast(value
                                                        .paymentMethodMessage)
                                                : const SizedBox();

                                            //  final checkOutProvider =
                                            // await context.read<CheckOutProvider>();
                                            //  if (checkOutProvider.permit !=
                                            //      null) {
                                            //    String permit = checkOutProvider
                                            //        .permit;
                                            //    print("permit: $permit");
                                            //
                                            //
                                            //
                                            //
                                            //
                                            //    // value.isDuplicate == "Yes"
                                            //    // ?
                                            //
                                            //  } else {
                                            //    Helpers.showToast(
                                            //        Constants.selectCustomer);
                                            //  }
                                          }
                                        }),
                                    Expanded(
                                      child: Text(
                                        AppData.appLocale == "ar"
                                            ? paymentMethod
                                                    ?.paymentTitleArabic ??
                                                ""
                                            : paymentMethod?.paymentTitle ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontPalette.black14w400,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1 / 2,
                                    mainAxisExtent: 60.h,
                                    crossAxisCount: 3),
                          ),
                        ),

                        /// Invoice commented
                        /* SizedBox(
                          height: 26.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            Constants.invoice,
                            style: FontPalette.black16W500,
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            itemCount: value.invoice?.length,
                            itemBuilder: (ctx, i) {
                              String invoice = value.invoice?[i] ?? "";
                              return SizedBox(
                                height: 40.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                        value: invoice,
                                        groupValue: value.selectedInvoice,
                                        onChanged: (val) {
                                          value.updateInvoice(invoice);
                                        }),
                                    Expanded(
                                      child: Text(
                                        value.invoice?[i] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontPalette.black14w400,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1 / 2,
                                    mainAxisExtent: 60.h,
                                    crossAxisCount: 3),
                          ),
                        ),*/
                        SizedBox(height: 26.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: AppData.appLocale == "ar"
                                ? [
                                    Text(
                                      "SAR ${value.grandTotal ?? 0.0}",
                                      style: FontPalette.black24W700,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "(${Constants.totItems} ${value.cartCount})",
                                          style: FontPalette.blackShade12w400,
                                        ),
                                        Text(
                                          Constants.totPrice,
                                          style: FontPalette.black16W500,
                                        ),
                                      ],
                                    ),
                                  ]
                                : [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          Constants.totPrice,
                                          style: FontPalette.black16W500,
                                        ),
                                        Text(
                                          "(${Constants.totItems} ${value.cartCount})",
                                          style: FontPalette.blackShade12w400,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "SAR ${value.grandTotal!.toStringAsFixed(2)}",
                                      style: FontPalette.black24W700,
                                    )
                                  ],
                          ),
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 27.h,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 24.w, right: 24.w),
                                child: permitValue == "Yes"
                                    ? CustomCommonButton(
                                        buttonText: Constants.confirm,
                                        onTap: () async {
                                          if (notesController.text.isNotEmpty) {
                                            final checkOutProvider = context
                                                .read<CheckOutProvider>();
                                            if (checkOutProvider
                                                    .selectedCustomer !=
                                                null) {
                                              String customerId =
                                                  checkOutProvider
                                                          .selectedCustomer
                                                          ?.customerId ??
                                                      "0";
                                              print("customerId: $customerId");

                                              await context
                                                  .read<CheckOutProvider>()
                                                  .orderDuplicate(
                                                      context: context,
                                                      customerId: customerId);

                                              print("customerId: $customerId");
                                              value.isDuplicate == "Yes"
                                                  ? showAlertDialogForDuplicateOrder(

                                                      context,
                                                      checkOutProvider,
                                                      customerId)
                                                  : checkOutProvider.orderConfirmation(
                                                      context: context,
                                                      customerId: customerId,
                                                      notes: notesController
                                                              .text ??
                                                          "",
                                                      paymentId: checkOutProvider
                                                              .selectedPaymentMethod
                                                              ?.paymentId ??
                                                          "0",
                                                      shippingId: checkOutProvider
                                                              .selectedShippingInfo
                                                              ?.shippingId ??
                                                          "0",
                                                      invoice: checkOutProvider
                                                              .selectedInvoice ??
                                                          "0");
                                            } else {
                                              Helpers.showToast(
                                                  Constants.selectCustomer);
                                            }
                                          } else {
                                            AppData.appLocale == "ar"
                                                ? Helpers.showToast(
                                                    "يرجى تقديم مذكرة مستودع للمتابعة.")
                                                : Helpers.showToast(
                                                    "Please provide a warehouse note to continue.");
                                          }
                                        },
                                      )
                                    : const SizedBox(),
                              ),
                              SizedBox(height: 27.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                    value.showPopup
                        ? Positioned(
                            top: MediaQuery.of(context).size.height / 3.8,
                            left: 1.w,
                            right: 1.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11.w, vertical: 13.h),
                              child: Card(
                                elevation: 4,
                                child: cusProvider.customerList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            cusProvider.customerList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Customer? customer =
                                              cusProvider.customerList[index];

                                          return customer != null
                                              ? InkWell(
                                                  splashColor: Colors.black,
                                                  onTap: () {
                                                    context.read<
                                                        CheckOutProvider>()
                                                      ..handlePopupVisibility()
                                                      ..updateCustomer(customer)
                                                      ..handleCustomerDataPopupVisibility();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.h),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          customer.customerName ??
                                                              "",
                                                          maxLines: 1,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox();
                                        })
                                    :   Text(Constants.noData)
                                // Center(
                                //         child:
                                //         AppData.appLocale == "en" ?
                                //         Text(Constants.noData) : const Text("لاتوجد بيانات"),
                                //       ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding buildCustomerSelectMethod(CustomerProvider cusProvider, CheckOutProvider value) {
    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: DropdownSearch<Customer>(

                          items: cusProvider.customerList,
                          selectedItem: value.selectedCustomer,
                          itemAsString: (Customer customer) =>
                              customer.customerName ?? "",
                          dropdownDecoratorProps: DropDownDecoratorProps(

                            dropdownSearchDecoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  value.selectedCustomer?.customerName ??
                                      Constants.enterCustOrShopName,
                                  style: FontPalette.grey12Italic
                                      .copyWith(color: HexColor("#7A7A7A"),),
                                )),
                          ),
                          onChanged: (customer) {
                            if (customer != null) {
                              value
                                ..updateCustomer(customer)
                                ..upateCustomerDataPopupVisibility(true);
                            }
                          },
                          popupProps:  PopupProps.modalBottomSheet(
                            emptyBuilder: (context,searchEntry) => const Center(child: Text("")),
                            showSelectedItems: false,
                            showSearchBox: true,
                          ),
                        ),
                      );
  }

  ///Alert Dialogue method for duplicate orders.
  showAlertDialogForDuplicateOrder(
    BuildContext context,
    CheckOutProvider checkOutProvider,
    String customerId,
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
        child: Text(Constants.confirm),
        onPressed: () {
          Navigator.pop(context);
          checkOutProvider.orderConfirmation(
              context: context,
              customerId: customerId,
              notes: notesController.text ?? "",
              paymentId:
                  checkOutProvider.selectedPaymentMethod?.paymentId ?? "0",
              shippingId:
                  checkOutProvider.selectedShippingInfo?.shippingId ?? "0",

              invoice: checkOutProvider.selectedInvoice ?? "0");
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
      // alignment: Alignment.center,
      title: Directionality(
          textDirection:
              AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: Text(Constants.warning)),
      content: Directionality(
        textDirection:
            AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
        child: AppData.appLocale == "ar"
            ? Text(checkOutProvider.message_ar)
            : Text(checkOutProvider.message_en),
      ),
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

  Widget suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              context.read<CheckOutProvider>().showPopup
                  ? Icons.arrow_drop_up_rounded
                  : Icons.arrow_drop_down_rounded,
              size: 35.h,
              color: HexColor("#111111"),
            ),
            onPressed: () {
              context.read<CheckOutProvider>().handlePopupVisibility();
            },
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
    searchController.dispose();
    super.dispose();
  }
}

class SubHeaderWidget extends StatelessWidget {
  const SubHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Wrap(
        children: [
          Text(
            Constants.home,
            style: FontPalette.grey10Italic,
          ),
          Text(" / ", style: FontPalette.grey10Italic),
          Text(Constants.shoppingCart, style: FontPalette.grey10Italic),
          Text(" / ", style: FontPalette.grey10Italic),
          Text(
            Constants.checkout,
            style: FontPalette.grey10Italic,
          ),
        ],
      ),
    );
  }
}
