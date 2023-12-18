// this class defines the full-screen semi-transparent modal dialog
// by extending the ModalRoute class
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/constants.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/common/nav_routes.dart';

import '../services/app_data.dart';

class FullScreenModal extends ModalRoute {
  // variables passed from the parent widget
  final String title;
  final String description;


  // constructor
  FullScreenModal({
    required this.title,
    required this.description,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,) {
    return Material(
      type: MaterialType.transparency,
      child:  ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX:10 ,
              sigmaY:  10 ),
          child: Center(
            child: Directionality(
              textDirection: AppData.appLocale == "ar"
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: FontPalette.white36w600,
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // background (button) color
                      foregroundColor: Colors.white, // foreground (text) color

                    ),
                    onPressed: () {
                      if (title == Constants.pwdChanged) {
                        NavRoutes.navToLoginRemoveUntil(context);
                      } else {
                        NavRoutes.navToDashboard(context);
                      }
                    },
                    child: Text(
                      Constants.home,
                      style: TextStyle(color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        // add scale animation
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      ),
    );
  }
}
