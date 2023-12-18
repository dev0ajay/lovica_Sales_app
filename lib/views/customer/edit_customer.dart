import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/helpers.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/models/country_model_class.dart';
import 'package:lovica_sales_app/providers/customer_provider.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({Key? key, this.custId}) : super(key: key);
  final String? custId;

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<CustomerProvider>()
      ..getCountryList(context: context)
      ..getCustomerDetails(context: context, customerId: widget.custId)
          .then((value) => {
                _uNameController.text = context
                        .read<CustomerProvider>()
                        .customerModelForEditCustomer
                        ?.customerName ??
                    "",
                _mobController.text = context
                        .read<CustomerProvider>()
                        .customerModelForEditCustomer
                        ?.customerMobile ??
                    "",
                _addressController.text = context
                        .read<CustomerProvider>()
                        .customerModelForEditCustomer
                        ?.customerAddress ??
                    "",
              }));
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
          child: Consumer2<AuthenticationProvider, CustomerProvider>(
            builder: (context, value, cusProvider, child) {
              return NetworkConnectivity(
                inAsyncCall: value.loaderState == LoadState.loading ||
                    cusProvider.loaderState == LoadState.loading,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HeaderTile(
                          showAppIcon: true,
                          title: Constants.editCustomer,
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
                                FilteringTextInputFormatter.allow(
                            RegExp("^[\u0621-\u064A\u0660-\u0669 a-zA-Z ]+\$"))
                              ],
                              hintText: Constants.enterPerOrCompany,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.enterPerOrCompany,
                              controller: _uNameController,
                              style: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              validator: (val) {
                                return Validator.validateName(val);
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
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text(
                                      AppData.appLocale == "ar"
                                          ? cusProvider.countrySelected
                                                  ?.countrynameAr ??
                                              ""
                                          : cusProvider.countrySelected
                                                  ?.countrynameEn ??
                                              "",
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
                                      borderSide:
                                          BorderSide(color: Colors.black),
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
                              inputType: TextInputType.text,
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
                              inputType: TextInputType.phone,
                              maxLength: cusProvider.countrySelected?.maxLength,
                              hintText: " ${cusProvider.countrySelected?.placeholder ?? " "}",
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
                          height: 21.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.w, right: 24.w),
                          child: CustomCommonButton(
                            buttonText: Constants.submit,
                            onTap: () async {
                              final provider = context.read<CustomerProvider>();
                              if (_formKey.currentState?.validate() == true &&
                                  provider.selectedCityForEditCustomer !=
                                      null &&
                                  provider.countrySelected != null &&
                                  _mobController.text.length ==
                                      cusProvider.countrySelected?.maxLength) {
                                bool updateResult =
                                    await provider.updateCustomer(
                                  context: context,
                                  address: _addressController.text,
                                  name: _uNameController.text,
                                  mob: _mobController.text,
                                  customerId: widget.custId ?? "",
                                  cityId: provider
                                          .selectedCityForEditCustomer?.id ??
                                      "",
                                  countryId:
                                      provider.countrySelected?.countryListId ??
                                          "",
                                );
                                if (updateResult) {
                                  Future.microtask(() =>
                                      Navigator.pop(context, updateResult));
                                }
                              } else {
                                if (_mobController.text.length !=
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
