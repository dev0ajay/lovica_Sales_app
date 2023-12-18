import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/route_generator.dart';
import '../../common/validator.dart';
import '../../models/route_arguments.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';
import 'forget_pwd_change.dart';

class ForgetPwdOtpScreen extends StatefulWidget {
  String? uName;

  ForgetPwdOtpScreen({super.key, this.uName});

  @override
  State<ForgetPwdOtpScreen> createState() => _ForgetPwdOtpScreenState();
}

class _ForgetPwdOtpScreenState extends State<ForgetPwdOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as RouteArguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 28.h,
                    ),
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.fgtPwd,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22.w, right: 22.h),
                      child: Form(
                        key: _formKey,
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
                              labelText: Constants.enterOtp,
                              controller: _otpController,
                              style: FontPalette.black12Regular
                                  .copyWith(color: HexColor("#7A7A7A")),
                              validator: (val) {
                                return Validator.validateEMptyField(val);
                              },

                              // readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24.w, right: 24.w),
                      child: CustomCommonButton(
                        buttonText: Constants.confirm,
                        onTap: () async {
                          print(widget.uName);
                          if (_formKey.currentState?.validate() ?? false) {
                           await Future.microtask(() => context
                                .read<AuthenticationProvider>()
                                .verifyOtp(
                                    context: context,
                                    uName: widget.uName,
                                    from: 0,
                                    otp: _otpController.text.trim() ?? ""),


                           );
                           // ignore: use_build_context_synchronously
                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(
                               builder: (context) =>  ForgetPwdChangeScreen(uName: widget.uName)
                             ),
                           );

                          } else {
                            debugPrint("Invalid validation");
                          }

                        },
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
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
