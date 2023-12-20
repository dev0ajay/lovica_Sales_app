import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/models/country_model_class.dart';
import 'package:lovica_sales_app/providers/customer_provider.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/helpers.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../models/customer_model.dart';
import '../../providers/check_out_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<CustomerProvider>()
      ..updateCountryForCustomer(null)
      ..updateCityForEditCustomer(null)
      ..getCountryList(context: context));
    Future.microtask(() => context.read<ConnectivityProvider>()
      .updateVisibilityOfKeyboard(false,0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Consumer2<AuthenticationProvider, CustomerProvider>(
            builder: (context, value, cusProvider, child) {
              return NetworkConnectivity(
                inAsyncCall: value.loaderState == LoadState.loading ||
                    cusProvider.loaderState == LoadState.loading,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [

                        Column(
                          children: [
                            HeaderTile(
                              showAppIcon: false,
                              title: Constants.addNewCust,
                              onTapBack: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              height: 17.h
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.name,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: CustomTextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                RegExp("^[\u0621-\u064A\u0660-\u0669 1-9a-zA-Z ]+\$")
                              )
                                  ],
                                  hintText: Constants.enterPerOrCompany,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterPerOrCompany,
                                  controller: _uNameController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },
                                  // readOnly: true,
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
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.country,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: DropdownSearch<Country>(
                                  items: cusProvider.countryList,
                                  itemAsString: (Country country) =>
                                      AppData.appLocale == "ar"
                                          ? country.countrynameAr ?? ""
                                          : country.countrynameEn ?? "",
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        label: Text(
                                          AppData.appLocale == "ar"
                                              ? cusProvider.countrySelected?.countrynameAr ?? ""
                                              : cusProvider.countrySelected?.countrynameEn ?? "",
                                          style: FontPalette.black12Regular
                                              .copyWith(color: HexColor("#7A7A7A")),
                                        )),
                                  ),
                                  onChanged: (country) {
                                    if (country != null) {
                                      Country? countryBefore =
                                          cusProvider.countrySelected;
                                      cusProvider
                                        ..updateCountryForCustomer(country)
                                        ..getCityListForEachCountry(
                                                context: context,
                                                countryId: country.countryListId)
                                            .then((value) {
                                          if (countryBefore?.countryListId ==
                                              country.countryListId) {
                                            debugPrint("No change in counrty");
                                          } else {
                                            debugPrint("change in counrty");
                                            cusProvider
                                                .updateCityForEditCustomer(null);
                                          }
                                        });
                                    }
                                  },
                                  popupProps: const PopupProps.modalBottomSheet(
                                    showSelectedItems: false,
                                    showSearchBox: true,
                                  ),
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
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.city,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: DropdownSearch<City>(
                                  items: cusProvider.cityList,
                                  itemAsString: (City city) =>
                                      AppData.appLocale == "ar"
                                          ? city.nameAr ?? ""
                                          : city.nameEn ?? "",
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        label: Text(
                                          AppData.appLocale == "ar"
                                              ? cusProvider
                                                      .selectedCityForEditCustomer
                                                      ?.nameAr ??
                                                  ""
                                              : cusProvider
                                                      .selectedCityForEditCustomer
                                                      ?.nameEn ??
                                                  "",
                                          style: FontPalette.black12Regular
                                              .copyWith(color: HexColor("#7A7A7A")),
                                        )),
                                  ),
                                  onChanged: (city) {
                                    if (city != null) {
                                      cusProvider.updateCityForEditCustomer(city);
                                    }
                                  },
                                  popupProps: const PopupProps.modalBottomSheet(
                                    showSelectedItems: false,
                                    showSearchBox: true,
                                  ),
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
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.address,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: CustomTextFormField(
                                  maxLines: 3,
                                  hintText: Constants.enterAddress,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterAddress,
                                  controller: _addressController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },
                                  // readOnly: true,
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
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.mobileNumber,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Directionality(
                              textDirection: AppData.appLocale == "ar"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: CustomTextFormField(
                                  prefixIcon: prefixWidget(cusProvider),
                                  hintText: " ${cusProvider.countrySelected?.placeholder ?? " "}",
                                  inputType: TextInputType.phone,
                                  maxLength: cusProvider.countrySelected != null
                                      ? cusProvider.countrySelected?.maxLength
                                      : 10,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterMob,
                                  controller: _mobController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },
                                  // readOnly: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 24.w, right: 24.w),
                              child: CustomCommonButton(
                                buttonText: Constants.submit,
                                onTap: () async {
                                  final provider = context.read<CustomerProvider>();

                                  if (_formKey.currentState?.validate() == true &&
                                      provider.selectedCityForEditCustomer != null &&
                                      provider.countrySelected != null&&
                                      _mobController.text.length ==
                                          cusProvider.countrySelected?.maxLength) {
                                    bool updateResult = await provider.addCustomer(
                                      context: context,
                                      address: _addressController.text,
                                      name: _uNameController.text,
                                      mob: _mobController.text,
                                      cityId:
                                          provider.selectedCityForEditCustomer?.id ??
                                              "",
                                      countryId:
                                          provider.countrySelected?.countryListId ??
                                              "",
                                    );

                                    if (updateResult) {
                                      Future.microtask(
                                          () => Navigator.pop(context, updateResult));
                                    }
                                  } else {
                                    if (cusProvider.countrySelected!=null &&_mobController.text.length !=
                                        cusProvider.countrySelected?.maxLength) {
                                      Helpers.showToast("${Constants.mobShouldContain} ${cusProvider.countrySelected?.maxLength} ${Constants.numbers}");
                                    }
                                    if (provider.selectedCityForEditCustomer ==
                                        null) {
                                      Helpers.showToast(Constants.selectCity);
                                    }
                                    if (provider.countrySelected == null) {
                                      Helpers.showToast(Constants.selectCountry);
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
                        /*/// ios number keypad ISSUE RESOLVED
                        Platform.isIOS 
                            ? Positioned(
                          bottom:MediaQuery.of(context).viewInsets.bottom,
                          left: 0,
                          right: 0,
                          child: Consumer<ConnectivityProvider>(
                              builder: (context, provider, child) {
                                return KeyboardVisibility(
                                  // it will notify
                                    onChanged: (bool visible) {
                                      provider.updateVisibilityOfKeyboard(visible);
                                    },
                                    child: provider.isVisibleKeyboard
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              }),
                        )
                            : const SizedBox(),*/
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget prefixWidget(CustomerProvider? provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: AppData.appLocale == "ar"
          ? [
              SizedBox(
                width: 8.w,
              ),
              Container(
                height: 55.h,
                width: 1.w,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.all(8.h),
                child: Text(
                  provider?.countrySelected != null
                      ? "${provider?.countrySelected?.countryCode ?? " "} +"
                      : "+5xx",
                  style: TextStyle(
                    color: provider?.countrySelected != null
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ]
          : [
              Padding(
                padding: EdgeInsets.all(8.h),
                child: Text(
                  provider?.countrySelected != null
                      ? "+ ${provider?.countrySelected?.countryCode ?? " "}"
                      : "+5xx",
                  style: TextStyle(
                    color: provider?.countrySelected != null
                        ? Colors.black
                        : Colors.grey,
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
                width: 8.w,
              )
            ],
    );
  }

  @override
  void dispose() {
    _uNameController.dispose();
    _mobController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
