import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import '../../common/color_palette.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget? child;
  final void Function(T)? onChange;
  final List<DropdownItem<T>>? items;
  final DropdownStyle? dropdownStyle;
  final DropdownButtonStyle? dropdownButtonStyle;
  final Icon? icon;
  final bool hideIcon;
  final bool leadingIcon;
  final BorderSide? borderSide;
  final String? errorText;
  final ButtonStyle? buttonStyle;

  const CustomDropdown(
      {Key? key,
        this.hideIcon = false,
        @required this.child,
        @required this.items,
        this.dropdownStyle,
        this.dropdownButtonStyle,
        this.icon,
        this.leadingIcon = false,
        this.onChange,
        this.errorText,
        this.buttonStyle,
        this.borderSide})
      : super(key: key);

  @override
  CustomDropdownState<T> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle!;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            // width: style.width,
            // height: style.height,
            child: SizedBox(
              height: 52.h,
              child: OutlinedButton(
                style: widget.buttonStyle ??
                    OutlinedButton.styleFrom(
                      padding: style.padding,
                      backgroundColor: Colors.white,
                      elevation: style.elevation,
                      foregroundColor: Colors.white,
                      side: widget.errorText == null
                          ? widget.borderSide ??
                          BorderSide(
                              color: Colors.black, width: 1.5.r)
                          : BorderSide(
                          color: widget.errorText != null
                              ? HexColor("#E63030")
                              : HexColor("#343434"),
                          width: 1.5.r),
                    ),
                onPressed: _toggleDropdown,
                child: Row(
                  mainAxisAlignment:
                  style.mainAxisAlignment ?? MainAxisAlignment.start,
                  textDirection: widget.leadingIcon
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    if (_currentIndex == -1) ...[
                      widget.child!,
                    ] else ...[
                      widget.items![_currentIndex],
                    ],
                    const Spacer(),
                    if (!widget.hideIcon)
                      RotationTransition(
                        turns: _rotateAnimation,
                        child: widget.icon ??
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: HexColor('#616161'),
                            ),
                      ),
                    // SizedBox(
                    //   width: 10.w,
                    // )
                  ],
                ),
              ),
            ),
          ),
          if (widget.errorText != null) 8.verticalSpace,
          if (widget.errorText != null)
            Text(
              widget.errorText ?? "",
              maxLines: 2,
              style: FontPalette.black14Regular,
            ),
          if (widget.errorText != null) 2.verticalSpace,
        ],
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: topOffset,
                width: widget.dropdownStyle?.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.dropdownStyle?.offset ??
                      Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle?.elevation ?? 0,
                    borderRadius:
                    widget.dropdownStyle?.borderRadius ?? BorderRadius.zero,
                    color: Colors.white,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle?.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding:
                          EdgeInsets.fromLTRB(14.33.w, 5.h, 14.33.w, 5.h),
                          shrinkWrap: true,
                          children: widget.items!.asMap().entries.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => _currentIndex = item.key);
                                if (widget.onChange != null) {
                                  widget.onChange!(item.value.value);
                                }
                                _toggleDropdown();
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: item.value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    FocusScope.of(context).unfocus();
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({Key? key, required this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Offset? offset;
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
