import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:lovica_sales_app/common/font_palette.dart';import 'package:lovica_sales_app/widgets/custom_common_button.dart';

import '../common/constants.dart';
import '../generated/assets.dart';

class CommonErrorWidget extends StatefulWidget {
  final ErrorTypes types;
  final Function? onTap;
  final String? buttonText;
  final String? errorTitle;
  final String? errorSubTitle;

  const CommonErrorWidget(
      {Key? key,
      required this.types,
      this.onTap,
      this.buttonText,
      this.errorTitle,
      this.errorSubTitle})
      : super(key: key);

  @override
  State<CommonErrorWidget> createState() => _CommonErrorWidgetState();
}

class _CommonErrorWidgetState extends State<CommonErrorWidget> {
  ValueNotifier<double> animateValue = ValueNotifier<double>(0.5);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => animateValue.value = 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
          valueListenable: animateValue,
          builder: (context, value, _) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: value,
              child: _errorView(),
            );
          }),
    );
  }

  Widget _errorView() {
    Widget _child = const SizedBox();
    switch (widget.types) {
      case ErrorTypes.serverError:
        _child = ErrorContainer(
          title: "serverError",
          subTitle: "Oops server error occured",
          btnText: widget.buttonText,
          image: Assets.iconsLovicaAppIconSmall,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.networkErr:
        _child = ErrorContainer(
          title: Constants.noNetwork,
          subTitle: Constants.noInternet,
          btnText: widget.buttonText,
          image: Assets.iconsLovicaAppIconSmall,
          onTap: widget.onTap,
        );
        break;

      case ErrorTypes.noDataFound:
        _child = ErrorContainer(
          title: Constants.noData,
          subTitle: Constants.noDataFound,
          btnText: widget.buttonText,
          image: Assets.iconsLovicaAppIconSmall,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.paymentFail:
        // TODO: Handle this case.
        break;
      case ErrorTypes.noMatchFound:
        // TODO: Handle this case.
        break;
    }
    return _child;
  }
}

class ErrorContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final Function? onTap;
  final String? btnText;

  const ErrorContainer(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.onTap,
      required this.btnText,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.sw(size: 0.1), vertical: context.sh(size: 0.1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              image,
              height: 95.w,
              width: 95.w,
            ),
            SizedBox(
              height: 12.3.h,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FontPalette.black16Regular,
            ),
            SizedBox(
              height: 11.h,
            ),
            Text(
              subTitle,
              strutStyle: StrutStyle(height: 1.5.h),
              textAlign: TextAlign.center,
              style: FontPalette.black14Regular,
            ),
            if (onTap != null) ...[
              SizedBox(
                height: 32.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: CustomCommonButton(
                  onTap: () => onTap!(),
                  buttonText: btnText ?? Constants.backHome,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
