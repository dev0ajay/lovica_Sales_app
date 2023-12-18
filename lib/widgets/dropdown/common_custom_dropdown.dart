import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import '../../common/color_palette.dart';
import 'custom_dropdown.dart';

class CommonCustomDropDown<T> extends StatefulWidget {
  final List<T> dropDownList;
  final String dropDownText;
  final void Function(T)? onChange;

  const CommonCustomDropDown(
      {Key? key,
        required this.dropDownList,
        required this.dropDownText,
        this.onChange})
      : super(key: key);

  @override
  State<CommonCustomDropDown> createState() => _CommonCustomDropDownState();
}

class _CommonCustomDropDownState extends State<CommonCustomDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      onChange: widget.onChange,
      errorText: null,
      dropdownStyle: const DropdownStyle(elevation: 5),
      dropdownButtonStyle: DropdownButtonStyle(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          height: 48.h,
          elevation: 0.5,
          padding: EdgeInsets.symmetric(horizontal: 16.w)),
      items: List.generate(
        widget.dropDownList.length,
            (index) => DropdownItem(
          value: widget.dropDownList[index],
          child: Text(
            widget.dropDownList[index].nameEn,
            style: FontPalette.black14Regular,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: Text(widget.dropDownText,
          style: widget.dropDownText==Constants.enterCity?FontPalette.black12Regular
        .copyWith(color: HexColor("#737373")):FontPalette.black12Regular)
    );
  }
}
