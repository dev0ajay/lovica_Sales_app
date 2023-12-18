import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/services/app_data.dart';
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
  final Function? onFieldSubmitted;
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
  final FocusNode? focusNode;
  final Widget? label;
  final bool? enable;


  const CustomTextFormField({
    super.key,
    this.hintText = '',
    this.labelText,
    this.prefix,
    this.inputType,
    this.validator,
    this.hintFontPalette,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.focusNode,
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
    this.label,
    this.enable,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool enableLabel = false;
  bool enableObscure = true;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5.r));
    final outlinedErrorBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5.r));
    final outlinedFocusedBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5.r));
    return Theme(
      data: ThemeData(
        primarySwatch: ColorPalette.materialGrey,
        hintColor: HexColor("#7A7A7A"),
      ),
      child: Directionality(

        textDirection:
            AppData.appLocale == "ar" ? TextDirection.rtl : TextDirection.ltr,
        child: TextFormField(

          enabled: widget.enable,
          textInputAction:widget.inputAction??TextInputAction.done,
          readOnly: widget.readOnly,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted != null
              ? (val) => widget.onFieldSubmitted!(val)
              : null,
          style: widget.style ?? FontPalette.black10Regular,
          onChanged:
              widget.onChanged != null ? (val) => widget.onChanged!(val) : null,
          onTap: () => setState(() {
            enableLabel = true;
            if (widget.onTap != null) {
              widget.onTap;
            }
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
          cursorColor: HexColor("#7A7A7A"),
          keyboardType: widget.inputType,
          maxLines: widget.maxLines ?? 1,
          decoration: InputDecoration(
            prefixIcon:
                AppData.appLocale == "ar" ? widget.suffix : widget.prefixIcon,
            suffixIcon:
                AppData.appLocale == "ar" ? widget.prefixIcon : widget.suffix,
            border: outlinedBorder,
            enabledBorder: outlinedBorder,
            counterText: "",
            focusedBorder: outlinedFocusedBorder,
            focusedErrorBorder: outlinedErrorBorder,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            errorBorder: outlinedErrorBorder,
            errorStyle: FontPalette.red10Regular,
            label: widget.label,
            labelText: enableLabel ? widget.labelText : null,
            hintText: widget.hintText,
            hintStyle: widget.hintFontPalette ?? FontPalette.black10Regular,
            filled: true,
            fillColor: Colors.white,
            prefix: widget.prefix,

          ),
        ),
      ),
    );
  }
}
