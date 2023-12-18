import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/views/auth_screens/login.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../widgets/common_header_tile.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/authentication_provider.dart';

class ForgetPwdChangeScreen extends StatefulWidget {
  final String? uName;

  const ForgetPwdChangeScreen({super.key, this.uName});

  @override
  State<ForgetPwdChangeScreen> createState() => _ForgetPwdChangeScreenState();
}

class _ForgetPwdChangeScreenState extends State<ForgetPwdChangeScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecure = false;

  @override
  void initState() {
    super.initState();
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
                              // suffix: suffixWidget(Constants.show),
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
                              isObscure: false,
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
                            SizedBox(
                              height: 8.h,
                            ),
                            CustomTextFormField(
                              // suffix: suffixWidget(Constants.show),
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
                              isObscure: false,
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
                        buttonText: Constants.confirmNewPwd,
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            print("Username: ${widget.uName}");
                             await context
                                .read<AuthenticationProvider>()
                                .fgtPwdChange(
                                    context: context,
                                    password: _passwordController.text,
                                    uName: widget.uName ?? "");
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  const LogInScreen()
                              ),
                            );

                            // if (updateResult) {}
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

  Widget suffixWidget(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                isObsecure = !isObsecure;
              });
            },
            child: Text(
              text,
              style: FontPalette.black12Regular,
            ),
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
        title: Constants.pwdChanged,
        description: 'Goto Login page'));

    // print the data returned by the modal if any
    debugPrint(result.toString());
  }
  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
