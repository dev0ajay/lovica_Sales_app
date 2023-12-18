import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';

class OTPScreen extends StatefulWidget {
  String? mobile;
  String? countryCode;

  OTPScreen({super.key, this.mobile,this.countryCode});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => context
        .read<AuthenticationProvider>()
        .sendOtp(context: context, mob: widget.mobile,countryCode: widget.countryCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      HeaderTile(
                        showAppIcon: true,
                        title: Constants.verification,
                        onTapBack: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 32.w, right: 32.h),
                        child: Form(
                          key: _formKey,
                          child: Directionality(
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      Constants.enterOtp,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomTextFormField(
                                  hintText: Constants.enterOtp,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterUname,
                                  controller: _otpController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateUserName(val);
                                  },

                                  // readOnly: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Directionality(
                        textDirection: AppData.appLocale == "ar"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Container(
                          margin: EdgeInsets.only(left: 32.w, right: 32.w),
                          child: CustomCommonButton(
                            buttonText: Constants.confirm,
                            onTap: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<AuthenticationProvider>()
                                    .verifyMobile(
                                        context: context,
                                        otp: _otpController.text.trim(),
                                        mob: widget.mobile ?? "");
                              } else {
                                debugPrint("Invalid validation");
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
