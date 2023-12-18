import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/widgets/main_header_tile.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../models/country_model_class.dart';
import '../../providers/notification_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/dropdown/common_custom_dropdown.dart';
import '../../widgets/custom_radio_btn.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String? email;

  const PersonalDetailsScreen({Key? key, this.email}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _idNumController = TextEditingController();
  final TextEditingController _bankIbanController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emNumController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<City> city = ValueNotifier(City());
  genderSelect selectedGender = genderSelect.male;
  String mobileNumber = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AuthenticationProvider>()
      ..getProfile(context: context)
      ..updateCountry(null)
      ..updateCity(null)
      ..getCountryList(context: context));
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
          child: Consumer2<AuthenticationProvider, AppLocalizationProvider>(
            builder: (context, value, lp, child) {
              return NetworkConnectivity(
                inAsyncCall: value.loaderState == LoadState.loading,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 28.h,
                        ),
                        HeaderTile(
                          showAppIcon: true,
                          title: Constants.personalDetails,
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
                              maxLength: 25,
                              maxLines: 1,
                              inputType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    "^[\u0621-\u064A\u0660-\u0669 a-zA-Z ]+\$"))
                              ],
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
                                  Constants.gender,
                                  style: FontPalette.black16Regular,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Padding(
                            padding: EdgeInsets.only(left: 45.w),
                            child: Row(
                              children: [
                                Radio(
                                    value: Constants.male,
                                    groupValue: value.selectedGender,
                                    onChanged: (val) {
                                      value.updateGender(Constants.male);
                                    }),
                                Text(
                                  Constants.male,
                                  style: FontPalette.black14w400,
                                ),
                                SizedBox(
                                  width: 46.w,
                                ),
                                Radio(
                                    value: Constants.female,
                                    groupValue: value.selectedGender,
                                    onChanged: (val) {
                                      value.updateGender(Constants.female);
                                    }),
                                Text(
                                  Constants.female,
                                  style: FontPalette.black14w400,
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
                              items: value.countryList,
                              itemAsString: (Country country) =>
                                  AppData.appLocale == "ar"
                                      ? country.countrynameAr ?? ""
                                      : country.countrynameEn ?? "",
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text(
                                      AppData.appLocale == "ar"
                                          ? value.countrySelected
                                                  ?.countrynameAr ??
                                              ""
                                          : value.countrySelected
                                                  ?.countrynameEn ??
                                              "",
                                      style: FontPalette.black12Regular
                                          .copyWith(color: HexColor("#7A7A7A")),
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
                                        value.updateCity(null);
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
                              items: value.cityList,
                              itemAsString: (City city) =>
                                  AppData.appLocale == "ar"
                                      ? city.nameAr ?? ""
                                      : city.nameEn ?? "",
                              dropdownDecoratorProps: DropDownDecoratorProps(
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
                                          : value.selectedCity?.nameEn ?? "",
                                      style: FontPalette.black12Regular
                                          .copyWith(color: HexColor("#7A7A7A")),
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
                        SizedBox(height: 8.h),
                        // Directionality(
                        //   textDirection: AppData.appLocale == "ar"
                        //       ? TextDirection.rtl
                        //       : TextDirection.ltr,
                        //   child:
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomTextFormField(
                            readOnly: true,
                            enable: false,
                            prefixIcon: prefixWidget(value),
                            inputType: TextInputType.phone,
                            maxLength: value.countrySelected != null
                                ? value.countrySelected?.maxLength
                                : 10,
                            hintText:
                                " ${value.countrySelected?.placeholder ?? " "}",
                            hintFontPalette: FontPalette.black12Regular
                                .copyWith(color: HexColor("#7A7A7A")),
                            // labelText: Constants.enterIdNumber,
                            controller: _mobController,

                            label: value.userData != null &&
                                    value.userData!.mobileNumber.toString() !=
                                        null &&
                                    value.userData!.mobileNumber
                                        .toString()
                                        .isNotEmpty
                                ? Text(value.userData!.mobileNumber.toString())
                                : Text(mobileNumber),
                            style: FontPalette.black12Regular
                                .copyWith(color: HexColor("#7A7A7A")),
                            // validator: (val) {
                            //   return Validator.validateEMptyField(val);
                            // },
                            // readOnly: true,
                          ),
                        ),
                        // ),
                        SizedBox(height: 21.h),
                        Directionality(
                          textDirection: AppData.appLocale == "ar"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              children: [
                                Text(
                                  Constants.emContactNum,
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
                              inputType: TextInputType.phone,
                              prefixIcon: prefixWidget(value),
                              maxLength: value.countrySelected != null
                                  ? value.countrySelected?.maxLength
                                  : 10,
                              hintText:
                                  " ${value.countrySelected?.placeholder ?? " "}",
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              controller: _emNumController,
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
                                  Constants.idNumber,
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
                                  Constants.bankIban,
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
                        ),
                        SizedBox(
                          height: 21.h,
                        ),

                        /*Directionality(
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
                              items: value.cityList,
                              itemAsString: (City city) =>AppData.appLocale == "ar"?city.nameAr??"": city.nameEn ?? "",
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
                                      AppData.appLocale == "ar"?value.selectedCity?.nameAr??"": value.selectedCity?.nameEn ?? "",
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
                        ),*/
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
                          height: 39.h,
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
                                if (_formKey.currentState?.validate() ?? true) {
                                  bool updateResult = await context
                                      .read<AuthenticationProvider>()
                                      .updateUserData(
                                        context: context,
                                        gender: value.selectedGender ?? "",
                                        address: _addressController.text,
                                        name: _uNameController.text,
                                        mob: _mobController.text,
                                        emNum: _emNumController.text,
                                        iban: _bankIbanController.text,
                                        idNum: _idNumController.text,
                                        cityId: value.selectedCity?.id ?? "",
                                        countryId: value.countrySelected
                                                ?.countryListId ??
                                            "", type: 'add',
                                      );

                                  Future.microtask(() =>
                                      context.read<AuthenticationProvider>()
                                        ..sendfcm(
                                            context: context, fcm: AppData.fcm)
                                        ..getProfile(context: context)
                                        ..getCartCount(context: context));

                                  if (updateResult) {
                                    Future.microtask(() => context
                                        .read<NotificationProvider>()
                                        .getNotificationList(
                                            context: context,
                                            start: 0,
                                            limit: 0));
                                    Future.microtask(() {
                                      _showModal(context);
                                    });
                                  }
                                } else {
                                  debugPrint("Invalid validation");
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

  Widget prefixWidget(AuthenticationProvider? provider) {
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

  Widget suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.black,
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
    _uNameController.dispose();
    _mobController.dispose();
    _addressController.dispose();
    _emNumController.dispose();
    _idNumController.dispose();
    _bankIbanController.dispose();
    super.dispose();
  }
}
