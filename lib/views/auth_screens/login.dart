import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';

class LogInScreen extends StatefulWidget {
  final String? email;

  const LogInScreen({super.key, this.email});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<AuthenticationProvider, AppLocalizationProvider>(
          builder: (context, value, localeProvider, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18.h
                      ),
                      Image.asset(
                        Assets.iconsLovicaAppIconSmall,
                        width: 110.w,
                        height: 46.h,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        mainAxisAlignment: AppData.appLocale == "ar"
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            Constants.signIn,
                            style: FontPalette.black24Regular,
                            textAlign: AppData.appLocale == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 27.h,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: AppData.appLocale == "ar"
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.userName,
                                  style: FontPalette.black16Regular,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CustomTextFormField(
                              hintText: Constants.enterUname,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.enterUname,
                              controller: _uNameController,
                              style: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              validator: (val) {
                                return Validator.validateUserName(val);
                              },
                              // readOnly: true,
                            ),
                            SizedBox(
                              height: 21.h,
                            ),
                            Row(
                              mainAxisAlignment: AppData.appLocale == "ar"
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.password,
                                  style: FontPalette.black16Regular,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h
                            ),
                            CustomTextFormField(
                              hintText: Constants.enterPwd,
                              hintFontPalette: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              labelText: Constants.enterPwd,
                              controller: _passwordController,
                              style: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              validator: (val) {
                                return Validator.validateEMptyField(val);
                              },
                              isObscure: true,
                              // readOnly: true,
                            ),
                            SizedBox(
                              height: 8.h
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => NavRoutes.navToPgtPwd(context),
                                  child: Text(
                                    Constants.fgtPwd,
                                    style: FontPalette.black12w500,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35.h
                      ),
                      CustomCommonButton(
                        buttonText: Constants.login,
                        onTap: () async {
                          print(AppData.appLocale.toString());
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<AuthenticationProvider>().login(
                                context: context,
                                uName: _uNameController.text,
                                password: _passwordController.text,
                                locale: AppData.appLocale,
                            );
                          } else {
                            debugPrint("Invalid validation");
                          }
                        },
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

  @override
  void dispose() {
    _uNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
