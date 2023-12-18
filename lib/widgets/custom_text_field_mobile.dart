import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import '../common/color_palette.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final Function? onTap;
  final Function? onEditingComplete;
  final bool isObscure;
  final Widget? prefix;
  final TextStyle? hintFontPalette;
  final Function? onSaved;
  final Function? onChanged;
  final TextInputAction? inputAction;
  final int? maxLines;
  final int? maxLength;
  final bool autoFocus;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool defaultFont;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final TextStyle? style;
  final Widget? suffix;

  const CustomTextFormField({
    Key? key,
    this.hintText = '',
    this.labelText,
    this.prefix,
    this.inputType,
    this.validator,
    this.hintFontPalette,
    this.onTap,
    this.onEditingComplete,
    this.autoFocus = false,
    this.isObscure = false,
    this.onSaved,
    this.onChanged,
    this.inputAction,
    this.inputFormatters,
    this.controller,
    this.maxLength,
    this.maxLines,
    this.defaultFont = true,
    this.prefixIcon,
    this.contentPadding,
    this.readOnly = false,
    this.style,
    this.suffix,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool enableLabel = false;
  bool enableObscure = true;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: HexColor("#2A2E35"), width: 1.5.r),
        borderRadius: BorderRadius.circular(5.r));
    final outlinedErrorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: HexColor("#E26262"), width: 1.5.r),
        borderRadius: BorderRadius.circular(5.r));
    final outlinedFocusedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: HexColor("#6D737D"), width: 1.5.r),
        borderRadius: BorderRadius.circular(5.r));
    return Theme(
      data: ThemeData(
        primarySwatch: ColorPalette.materialGrey,
        hintColor: HexColor("#626465"),
      ),
      child: TextFormField(
        readOnly: widget.readOnly,
        controller: widget.controller,
        style: widget.style ?? FontPalette.black10Regular,
        onChanged:
        widget.onChanged != null ? (val) => widget.onChanged!(val) : null,
        onTap: () => setState(() {
          enableLabel = true;
        }),
        validator: widget.validator == null
            ? (val) {
          return null;
        }
            : (val) {
          return widget.validator!(val);
        },
        autocorrect: false,
        enableSuggestions: false,
        obscureText: widget.isObscure ? enableObscure : false,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        autofocus: widget.autoFocus,
        cursorColor: HexColor("#626465"),
        keyboardType: widget.inputType,
        maxLines: widget.maxLines ?? 1,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          border: outlinedBorder,
          enabledBorder: outlinedBorder,
          counterText: "",
          focusedBorder: outlinedFocusedBorder,
          focusedErrorBorder: outlinedErrorBorder,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 17.h),
          errorBorder: outlinedErrorBorder,
          errorStyle: FontPalette.red10Regular,
          labelText: enableLabel ? widget.labelText : null,
          hintText: widget.hintText,
          hintStyle: widget.hintFontPalette ?? FontPalette.black10Regular,
          filled: true,
          fillColor: Colors.white,
          prefix: widget.prefix,
        ),
      ),
    );
  }
}
