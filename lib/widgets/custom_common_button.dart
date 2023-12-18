import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
class CustomCommonButton extends StatelessWidget {
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final Color? buttonColor;
  final double? radius;
  final double? width;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  const CustomCommonButton({
    Key? key,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonColor,
    this.radius,
    this.width,
    this.onTap,
    this.padding,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: context.sw(
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor??Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          elevation: 1.0,
        ),
        child:  Padding(
          padding: EdgeInsets.all(10.h),
          child: Text(
            buttonText??"",
            style:buttonTextStyle?? TextStyle(
                fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
