import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/models/country_model_class.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/helpers.dart';
import '../../common/network_connectivity.dart';
import '../../common/route_generator.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../models/route_arguments.dart';
import '../../providers/authentication_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _idNumController = TextEditingController();
  final TextEditingController _bankIbanController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<City> city = ValueNotifier(City());
  String countryCode = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AuthenticationProvider>()
      ..updateCountry(null)
      ..updateCity(null)
      ..getCountryList(context: context));

    if (context.read<AuthenticationProvider>().userData != null) {
      setState(() {
        _uNameController.text =
            context.read<AuthenticationProvider>().userData?.name ?? "";
        _mobController.text =
            context.read<AuthenticationProvider>().userData?.mobileNumber ?? "";
        _idNumController.text =
            context.read<AuthenticationProvider>().userData?.iDNumber ?? "";
        _bankIbanController.text =
            context.read<AuthenticationProvider>().userData?.bankIBAN ?? "";
        _addressController.text =
            context.read<AuthenticationProvider>().userData?.address ?? "";
        // countryCode = context.read<AuthenticationProvider>().userData?.countryId ?? "";
      });
    }
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HeaderTile(
                          showAppIcon: true,
                          title: Constants.editProfile,
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.name,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    hintText: Constants.enterName,
                                    hintFontPalette: FontPalette.black12Regular
                                        .copyWith(color: HexColor("#7A7A7A")),
                                    labelText: Constants.enterName,
                                    controller: _uNameController,
                                    style: FontPalette.black12Regular
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
                        ),
                        SizedBox(
                          height: 21.h
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.mobileNumber,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 175,
                                        child: CustomTextFormField(
                                          maxLength: value.countrySelected?.maxLength??10,
                                          inputType: TextInputType.phone,
                                          hintText: Constants.enterMob,
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
                                      // const SizedBox(width: 5,),
                                      SizedBox(
                                        height: AppData.appLocale == "ar" ? 49:49,
                                        width: AppData.appLocale == "ar" ? 71:71,
                                        // decoration: BoxDecoration(
                                        //     border: Border.all(
                                        //      color: Colors.white, //color of border//width of border
                                        //     ),
                                        //     borderRadius: BorderRadius.circular(5)
                                        // ),
                                        child: value.countrySelected != null &&
                                            value.countrySelected!.countryCode!.isNotEmpty ? suffixWidget(value.isMobileVerified
                                            ? Constants.verified
                                            : Constants.verify,

                                          value.countrySelected!.countryListId!,
                                        ) : const SizedBox(),
                                      )
                                    ],
                                  ),

                                ),
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.bankIban,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    hintText: Constants.enterBankIban,
                                    hintFontPalette: FontPalette.black12Regular
                                        .copyWith(color: HexColor("#7A7A7A")),
                                    labelText: Constants.enterBankIban,
                                    controller: _bankIbanController,
                                    style: FontPalette.black12Regular
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.idNumber,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    hintText: Constants.enterIdNumber,
                                    hintFontPalette: FontPalette.black12Regular
                                        .copyWith(color: HexColor("#7A7A7A")),
                                    labelText: Constants.enterIdNumber,
                                    controller: _idNumController,
                                    style: FontPalette.black12Regular
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.address,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        /*Padding(
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
                                      padding: EdgeInsets.all(0.h),
                                      child: Text(
                                        Constants.city,
                                        style: FontPalette.black14Regular,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 17.h),
                                      child: Text(
                                        ":",
                                        style: FontPalette.black14Regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomDropdown(
                                  onChange: (val) {
                                    value.updateCity(val);
                                  },
                                  dropdownStyle:
                                      const DropdownStyle(elevation: 5),
                                  borderSide: BorderSide(
                                      color: HexColor("#62646C"), width: 1),
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.r)),
                                    height: 53.h,
                                    elevation: 0.5,
                                    padding: EdgeInsets.only(
                                        left: 13.w, right: 14.33.w),
                                  ),
                                  items: value.cityList.map((v) {
                                    return DropdownItem(
                                      value: v,
                                      child: Text(
                                        v.nameEn ?? "",
                                        style: FontPalette.black12Regular,
                                      ),
                                    );
                                  }).toList(),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5.w,
                                    ),
                                    child: value.selectedCity != null
                                        ? Text(
                                            value.selectedCity?.nameEn ?? "",
                                            style: FontPalette.black12Regular
                                                .copyWith(
                                                    color: HexColor("#7A7A7A")),
                                          )
                                        : Text(Constants.enterCity,
                                            style: FontPalette.black12Regular),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 39.h,
                        ),*/

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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.country,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: DropdownSearch<Country>(
                                    items: value.countryList,
                                    itemAsString: (Country country) =>
                                    AppData.appLocale == "ar"
                                        ? country.countrynameAr ?? ""
                                        : country.countrynameEn ?? "",
                                    dropdownDecoratorProps:
                                    DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.black),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text(
                                            AppData.appLocale == "ar"
                                                ? value.countrySelected?.countrynameAr ?? ""
                                                : value.countrySelected?.countrynameEn ??
                                                "",
                                            style: FontPalette.black12Regular
                                                .copyWith(
                                                color: HexColor("#7A7A7A")),
                                          )),
                                    ),
                                    onChanged: (country) {
                                      if (country != null) {
                                          Country? countryBefore =
                                              value.countrySelected;
                                          value
                                            ..updateCountry(country)
                                            ..getCityListForEachCountry(
                                                context: context,
                                                countryId: country.countryListId)
                                                .then((result) {
                                              if (countryBefore?.countryListId ==
                                                  country.countryListId) {
                                                debugPrint("No change in counrty");
                                              } else {
                                                debugPrint("change in counrty");
                                                value
                                                    .updateCity(null);
                                              }
                                            });



                                        value.updateCountry(country);
                                      }
                                    },
                                    popupProps: const PopupProps.modalBottomSheet(
                                      showSelectedItems: false,
                                      showSearchBox: true,
                                    ),
                                  ),
                                ),
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
                                        padding: EdgeInsets.all(0.h),
                                        child: Text(
                                          Constants.city,
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 17.h,left : AppData.appLocale == "ar" ? 17:0),
                                        child: Text(
                                          ":",
                                          style: FontPalette.black14Regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: DropdownSearch<City>(
                                    items: value.cityList,
                                    itemAsString: (City city) =>
                                        AppData.appLocale == "ar"
                                            ? city.nameAr ?? ""
                                            : city.nameEn ?? "",
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text(
                                            AppData.appLocale == "ar"
                                                ? value.selectedCity?.nameAr ?? ""
                                                : value.selectedCity?.nameEn ??
                                                    "",
                                            style: FontPalette.black12Regular
                                                .copyWith(
                                                    color: HexColor("#7A7A7A")),
                                          )),
                                    ),
                                    onChanged: (city) {
                                      if (city != null) {
                                        value.updateCity(city);
                                      }
                                    },
                                    popupProps: const PopupProps.modalBottomSheet(
                                      showSelectedItems: false,
                                      showSearchBox: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 39.h
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            child: CustomCommonButton(
                              buttonText: Constants.submit,
                              onTap: () async {
                                if (_formKey.currentState?.validate() == true &&
                                    value.selectedCity !=
                                        null &&
                                    value.countrySelected != null &&
                                    _mobController.text.length ==
                                        value.countrySelected?.maxLength) {
                                  bool updateResult = await context
                                      .read<AuthenticationProvider>()
                                      .updateUserData(
                                        context: context,
                                        gender: value.selectedGender ?? "",
                                        address: _addressController.text,
                                        name: _uNameController.text,
                                        mob: _mobController.text,
                                        emNum: value.userData
                                                ?.emergencyContactNumber ??
                                            "",
                                        iban: _bankIbanController.text,
                                        idNum: _idNumController.text,
                                        cityId: value.selectedCity?.id ?? "",
                                        countryId: value.countrySelected?.countryListId ?? "",
                                        type: 'update',
                                      );
                                  if (updateResult) {
                                    Future.microtask(() {
                                      _showModal(context);
                                    });
                                  }
                                }  else {
                                  if (_mobController.text.length !=
                                      value.countrySelected?.maxLength) {
                                    Helpers.showToast("${Constants.mobShouldContain} ${value.countrySelected?.maxLength} ${Constants.numbers}");
                                  }
                                  if (value.selectedCity ==
                                      null) {
                                    Helpers.showToast(Constants.selectCity);
                                  }
                                  if (value.countrySelected == null) {
                                    Helpers.showToast(Constants.selectCountry);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
                      ],
                    ),
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

  Widget suffixWidget(String title, String countryCode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: InkWell(
            child: Text(Constants.verify),
            onTap: () {
              print("CountryCode: $countryCode");
              if (_mobController.text.trim().isNotEmpty) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(RouteGenerator.routeOTP,
                        arguments:
                            RouteArguments(mobile: _mobController.text.trim(),countryID: countryCode))
                    .then((value) {});
              }
            },
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
    _uNameController.dispose();
    _mobController.dispose();
    _addressController.dispose();
    _idNumController.dispose();
    _bankIbanController.dispose();
    super.dispose();
  }
}
