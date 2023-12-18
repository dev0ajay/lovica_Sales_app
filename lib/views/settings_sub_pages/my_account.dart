import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
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

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AuthenticationProvider>().getProfile(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Consumer<AuthenticationProvider>(
            builder: (context, value, child) {
              return NetworkConnectivity(
                inAsyncCall: value.loaderState == LoadState.loading,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTile(
                        showAppIcon: true,
                        title: Constants.myAccount,
                        onTapBack: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 17.h,
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
                              Text(Constants.settings,
                                  style: FontPalette.grey10Italic),
                              Text(" / ", style: FontPalette.grey10Italic),
                              Text(Constants.myAccount,
                                  style: FontPalette.grey10Italic)
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
                              Expanded(child: Text(value.userData?.name ?? "")),
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
                                  child:
                                      Text(value.userData?.mobileNumber ?? "")),
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
                                        Constants.bankIban,
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
                                  child: Text(value.userData?.bankIBAN ?? "")),
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
                                        Constants.employeeId,
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
                                  child: Text(value.userData?.iDNumber ?? "")),
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
                                  child: Text(value.userData?.address ?? "")),
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
                                  child: Text(
                                      AppData.appLocale=="ar"?value.userData?.countryNameAr ?? "":value.userData?.countryNameEn ?? "")),
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
                                  child:
                                      Text(AppData.appLocale=="ar"?value.userData?.cityNameAr ?? "":value.userData?.cityNameEn ?? "")),
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
                            NavRoutes.navToProfileEdit(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.edit,
                                  ),
                              ),
                              Text(
                                Constants.editProfile,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
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
      ),
      // appBar: CommonAppBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
