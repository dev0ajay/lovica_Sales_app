import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/views/settings_sub_pages/terms_and_conditions_screen.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../providers/authentication_provider.dart';
import '../../services/app_data.dart';
import 'dart:developer';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AppLocalizationProvider>(
          builder: (context, value, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTile(
                        showAppIcon: true,
                        title: Constants.settings,
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
                              Text(Constants.settings,
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
                        child: Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      NavRoutes.navToMyAccount(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.w, vertical: 12.h),
                                      child: Text(
                                        Constants.myAccount,
                                        style: FontPalette.black16Regular,
                                      ),
                                    ),
                                  ),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () {
                                        Future.microtask(() =>
                                            NavRoutes.navToNotifications(
                                                context));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                        child: Text(
                                          Constants.notification,
                                          style: FontPalette.black16Regular,
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () {
                                        NavRoutes.navToChangePwd(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                        child: Text(
                                          Constants.changePwdTitle,
                                          style: FontPalette.black16Regular,
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () {
                                        value.handlePopupVisibility();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Constants.changeLang,
                                              style: FontPalette.black16Regular,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  value.handlePopupVisibility();
                                                },
                                                icon: SizedBox(
                                                  height: 15.h,
                                                  width: 15.w,
                                                  child: value.showPopup
                                                      ? Image.asset(Assets
                                                          .iconsUpArrowIcon)
                                                      : Image.asset(Assets
                                                          .iconsDownArrowIcon),
                                                ))
                                          ],
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () async {
                                        await context
                                            .read<AppLocalizationProvider>()
                                            .getTermsAndConditions(
                                                cmsId: "1", context: context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                        child: Text(
                                          AppData.appLocale == "ar"
                                              ? "الأحكام والشروط"
                                              : Constants.termsAndConditions,
                                          style: FontPalette.black16Regular,
                                          // textDirection: AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                    onTap: () async {
                                      await context
                                          .read<AppLocalizationProvider>()
                                          .getTermsAndConditions(
                                              cmsId: "4", context: context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.w, vertical: 12.h),
                                      child: Text(
                                        AppData.appLocale == "ar"
                                            ? "سياسة الخصوصية"
                                            : Constants.privacy,
                                        style: FontPalette.black16Regular,
                                      ),
                                    ),
                                  ),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read<AuthenticationProvider>()
                                            .logOut(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                        child: Text(
                                          Constants.logout,
                                          style: FontPalette.black16Regular,
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                  InkWell(
                                      onTap: () {
                                        showAlertDialogForDeleteAccount(
                                          context,
                                          value,
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                        child: Text(
                                          AppData.appLocale == "ar"
                                              ? "حذف الحساب"
                                              : Constants.deleteAccount,
                                          style: FontPalette.black16Regular,
                                        ),
                                      )),
                                  ReusableWidgets.divider(height: 1.h),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  value.showPopup
                      ? Positioned(
                          top: MediaQuery.of(context).size.height / 2.7,
                          left: 10,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 13.h),
                            child: Card(
                              elevation: 4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                      value: language.en.name,
                                      groupValue: value.selectedLanguage,
                                      onChanged: (val) {
                                        context
                                            .read<AppLocalizationProvider>()
                                            .chooseLocale(
                                                currentLang: language.en.name);
                                        print("Lang: ${language.en.name}");
                                        value
                                          ..updateLanguage(language.en.name)
                                          ..handlePopupVisibility()
                                          ..updateLabels(context);
                                      }),
                                  Text(
                                    "English",
                                    style: FontPalette.black14w400,
                                  ),
                                  SizedBox(
                                    width: 46.w,
                                  ),
                                  Radio(
                                      value: language.ar.name,
                                      groupValue: value.selectedLanguage,
                                      onChanged: (val) {
                                        context
                                            .read<AppLocalizationProvider>()
                                            .chooseLocale(
                                                currentLang: language.ar.name);
                                        print("Lang: ${language.ar.name}");
                                        value
                                          ..updateLanguage(language.ar.name)
                                          ..handlePopupVisibility()
                                          ..updateLabels(context);
                                      }),
                                  Text(
                                    Constants.arabic,
                                    style: FontPalette.black14w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///Alert Dialogue method for delete account
  showAlertDialogForDeleteAccount(
    BuildContext context,
    AppLocalizationProvider appLocalizationProvider,
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
          appLocalizationProvider.deleteUserAccount(
            confirmation: "yes",
            deviceType: Platform.isIOS ? "iphone" : "android",
            context: context,
          );


        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      // alignment: Alignment.center,
      title: Directionality(
        textDirection:
            AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
        child: Text(Constants.warning),
      ),
      content: Directionality(
        textDirection:
            AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
        child: AppData.appLocale == "ar"
            ? const Text("هل أنت متأكد أنك تريد حذف هذا الحساب؟")
            : const Text("Are you sure you want to delete this account?"),
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
}
