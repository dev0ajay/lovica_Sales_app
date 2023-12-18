import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';
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
import 'forget_pwd_otp.dart';

class ForgetPwdScreen extends StatefulWidget {
  const ForgetPwdScreen({super.key});

  @override
  State<ForgetPwdScreen> createState() => _ForgetPwdScreenState();
}

class _ForgetPwdScreenState extends State<ForgetPwdScreen> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _mobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderTile(
                      showAppIcon: true,
                      title: Constants.fgtPwd,
                      onTapBack: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 25.h),
                    Padding(
                      padding: EdgeInsets.only(left: 22.w, right: 22.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  Constants.userName,
                                  style: FontPalette.black16Regular,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
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
                            SizedBox(height: 21.h),
                            Row(
                              children: [
                                Text(
                                  Constants.mobileNumber,
                                  style: FontPalette.black16Regular,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            CustomTextFormField(
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
                              inputType: TextInputType.phone,
                              // readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Container(
                      margin: EdgeInsets.only(left: 24.w, right: 24.w),
                      child: CustomCommonButton(
                        buttonText: Constants.sendOtp,
                        onTap: () async {
                          print(_uNameController.text);
                          if (_formKey.currentState?.validate() ?? false) {
                           await context
                                .read<AuthenticationProvider>()
                                .sendOtpFgtPwd(
                                  from: 0,
                                  context: context,
                                  mob: _mobController.text,
                                  uName: _uNameController.text,
                                );
                           // ignore: use_build_context_synchronously
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) =>  ForgetPwdOtpScreen(
                                     uName: _uNameController.text),
                               ),
                           );



                          } else {
                            debugPrint("Invalid validation");
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 50.h),
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
    _uNameController.dispose();
    _mobController.dispose();
    super.dispose();
  }
}
