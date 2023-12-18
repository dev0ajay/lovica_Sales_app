import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/font_palette.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../common/route_generator.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../models/country_model_class.dart';
import '../../models/route_arguments.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/customer_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_common_button.dart';
import '../../widgets/custom_text_field.dart';

class CustomerViewScreen extends StatefulWidget {
  const CustomerViewScreen({Key? key, this.custId}) : super(key: key);
  final String? custId;

  @override
  State<CustomerViewScreen> createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<CustomerProvider>()
      ..clearCustomerForEdit()
      ..getCustomerDetails(context: context, customerId: widget.custId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<AuthenticationProvider, CustomerProvider>(
          builder: (context, value, cProvider, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading ||
                  cProvider.loaderState == LoadState.loading,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.customerDetails,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    // Directionality(
                    //   textDirection: AppData.appLocale == "ar"
                    //       ? TextDirection.rtl
                    //       : TextDirection.ltr,
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           Constants.home,
                    //           style: FontPalette.grey10Italic,
                    //         ),
                    //         Text(" / ", style: FontPalette.grey10Italic),
                    //         Text(Constants.settings,
                    //             style: FontPalette.grey10Italic),
                    //         Text(" / ", style: FontPalette.grey10Italic),
                    //         Text(Constants.myAccount,
                    //             style: FontPalette.grey10Italic)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 21.h,
                    // ),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                      Constants.name,
                                      style: FontPalette.black14w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.h),
                                    child: Text(
                                      ":",
                                      style: FontPalette.black14Regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 31.w,
                            ),
                            Expanded(
                                child: Text(cProvider
                                        .customerModelForEditCustomer
                                        ?.customerName ??
                                    "")),
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
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                      Constants.country,
                                      style: FontPalette.black14w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.h),
                                    child: Text(
                                      ":",
                                      style: FontPalette.black14Regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 31.w,
                            ),
                            Expanded(
                                child: Text(AppData.appLocale == "ar"
                                    ? cProvider.customerModelForEditCustomer
                                            ?.customerCountrynameAr ??
                                        ""
                                    : cProvider.customerModelForEditCustomer
                                            ?.customerCountrynameEn ??
                                        "")),
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
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                      Constants.city,
                                      style: FontPalette.black14w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.h),
                                    child: Text(
                                      ":",
                                      style: FontPalette.black14Regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 31.w,
                            ),
                            Expanded(
                                child: Text(AppData.appLocale == "ar"
                                    ? cProvider.customerModelForEditCustomer
                                            ?.customerCitynameAr ??
                                        ""
                                    : cProvider.customerModelForEditCustomer
                                            ?.customerCitynameEn ??
                                        "")),
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
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                      Constants.address,
                                      style: FontPalette.black14w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.h),
                                    child: Text(
                                      ":",
                                      style: FontPalette.black14Regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 31.w,
                            ),
                            Expanded(
                                child: Text(cProvider
                                        .customerModelForEditCustomer
                                        ?.customerAddress ??
                                    "")),
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
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                      Constants.mobileNumber,
                                      style: FontPalette.black14w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.h),
                                    child: Text(
                                      ":",
                                      style: FontPalette.black14Regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 31.w,
                            ),
                            Expanded(
                                child: AppData.appLocale == "ar"
                                    ? Text(
                                        " ${cProvider.customerModelForEditCustomer?.customerMobile ?? ""} ${cProvider.customerModelForEditCustomer?.customerCountryCode ?? ""} +")
                                    : Text(
                                        "+${cProvider.customerModelForEditCustomer?.customerCountryCode ?? ""} ${cProvider.customerModelForEditCustomer?.customerMobile ?? ""}")),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RouteGenerator.routeCustomerEdit,
                                  arguments: RouteArguments(
                                      customerID: cProvider
                                              .customerModelForEditCustomer
                                              ?.customerId ??
                                          ""))
                              .then((value) {
                            Future.microtask(() =>
                                context.read<CustomerProvider>()
                                  ..getCustomerDetails(
                                      context: context,
                                      customerId: widget.custId));
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                            RouteGenerator.routeCustomerEdit,
                                            arguments: RouteArguments(
                                                customerID: cProvider
                                                    .customerModelForEditCustomer
                                                    ?.customerId))
                                        .then((value) {
                                      Future.microtask(
                                          () => Navigator.pop(context, true));
                                    });
                                  },
                                )),
                            Text(
                              Constants.editCustomer,
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 12.w,
                            )
                          ],
                        ),
                      ),
                    )
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
}
