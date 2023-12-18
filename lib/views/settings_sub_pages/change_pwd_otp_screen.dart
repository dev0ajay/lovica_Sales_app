import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/views/menu/settings_screen.dart';
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

class ChangePwdOTPScreen extends StatefulWidget {
  String? uName;

  ChangePwdOTPScreen({super.key, this.uName});

  @override
  State<ChangePwdOTPScreen> createState() => _ChangePwdOTPScreenState();
}

class _ChangePwdOTPScreenState extends State<ChangePwdOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecure = true;

  @override
  void initState() {
    super.initState();
    // _uNameController.text = widget.email ?? "";
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
                        title: Constants.changePwdTitle,
                        onTapBack: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 25.h),
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
                                  suffix:
                                      suffixWidget(Constants.verify, 0, value),
                                  hintText: Constants.enterOtp,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterOtp,
                                  controller: _otpController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },

                                  // readOnly: true,
                                ),
                                SizedBox(
                                  height: 21.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Constants.enterNewPwd,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomTextFormField(
                                  readOnly:
                                      value.isPwdOtpVerified ? false : true,
                                  // suffix:
                                  //     suffixWidget(Constants.show, 1, value),
                                  hintText: Constants.enterNewPwd,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.enterNewPwd,
                                  controller: _passwordController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },
                                  // isObscure: isObsecure,
                                  // readOnly: true,
                                ),
                                SizedBox(
                                  height: 21.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Constants.confirmNewPwd,
                                      style: FontPalette.black16Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                CustomTextFormField(
                                  readOnly:
                                      value.isPwdOtpVerified ? false : true,
                                  // suffix:
                                  //     suffixWidget(Constants.show, 1, value),
                                  hintText: Constants.confirmNewPwd,
                                  hintFontPalette: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  labelText: Constants.confirmNewPwd,
                                  controller: _passwordConfirmController,
                                  style: FontPalette.black12Regular
                                      .copyWith(color: HexColor("#7A7A7A")),
                                  validator: (val) {
                                    return Validator.validateEMptyField(val);
                                  },
                                  // isObscure: isObsecure,
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
                            buttonColor: value.isPwdOtpVerified
                                ? Colors.black
                                : Colors.grey,
                            onTap: () async {
                              if (value.isPwdOtpVerified) {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await context
                                      .read<AuthenticationProvider>()
                                      .changePwd(
                                          context: context,
                                          password: _passwordController.text,
                                          passwordConfirm:
                                              _passwordConfirmController.text);
                                  // ignore: use_build_context_synchronously
                                }
                              } else {
                                debugPrint("Invalid validation");
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),
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

  Widget suffixWidget(String text, int from, AuthenticationProvider? provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: TextButton(
            onPressed: () {
              if (from == 0 && _otpController.text.isNotEmpty) {
                Future.microtask(() => context
                    .read<AuthenticationProvider>()
                    .verifyOtp(
                        context: context,
                        uName: widget.uName,
                        from: 1,
                        otp: _otpController.text.trim() ?? ""));
              } else {
                setState(() {
                  isObsecure = !isObsecure;
                });
              }
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  height: 2,
                  color: from == 0
                      ? Colors.black
                      : provider!.isPwdOtpVerified
                          ? Colors.black
                          : Colors.grey),
            ),
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
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
