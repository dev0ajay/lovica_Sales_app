import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/generated/assets.dart';

import '../common/color_palette.dart';
import '../common/constants.dart';
import '../services/app_data.dart';

class HeaderTile extends StatelessWidget {
  final String? title;
  final bool? showAppIcon;
  final bool? showGridIcon;
  final bool showDetailIcon;
  final bool showElevation;
  final Function()? onTapBack;
  final Function()? onTapGrid;
  final Function()? onTapGridDetail;

  const HeaderTile({
    Key? key,
    this.title,
    this.showAppIcon = false,
    this.showGridIcon = false,
    this.showDetailIcon = false,
    this.showElevation = true,
    this.onTapGrid,
    this.onTapBack,
    this.onTapGridDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 70.h,
          padding:
          EdgeInsets.only(top: 10.h, bottom: 10.h, left: 12.w, right: 8.w),

          margin: EdgeInsets.only(bottom: 6.h),
          //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r)),
            color: Colors.white,
            boxShadow: [
              showElevation
                  ? BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.r,
              )
                  : const BoxShadow(color: Colors.transparent),
            ],
          ),
          child: AppData.appLocale == "ar"
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //takes the row to the top
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //Used this for spacing between the children
            children: [
              showGridIcon ?? true
                  ? Row(
                children: [
                  InkWell(
                    onTap: showDetailIcon
                        ? onTapGrid
                        : onTapGridDetail,
                    child: SizedBox(
                      height: 24.h,
                      width: 28.w,
                      child: Image.asset(
                          showDetailIcon
                          ? Assets.iconsPdtGridIconSelected
                          : Assets.iconsPdtGridIconUnselected),
                    ),
                  ),
                ],
              )
                  : const SizedBox(),
              showAppIcon ?? true
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 120.h,
                      child: Image.asset(
                          Assets.iconsLovicaAppIconSmall)),
                ],
              )
                  : SizedBox(),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    //used for aligning the children vertically
                    children: [
                      Text(
                        title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: onTapBack,
                    child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: RotatedBox(
                            quarterTurns:
                            AppData.appLocale == "ar" ? 2 : 0,
                            child: Image.asset(Assets.iconsBackIcon))),
                  ),
                ],
              ),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //takes the row to the top
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //Used this for spacing between the children
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onTapBack,
                    child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: Image.asset(Assets.iconsBackIcon)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    //used for aligning the children vertically
                    children: [
                      Text(
                        title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              showGridIcon ?? true
                  ? Row(
                children: [
                  InkWell(
                    onTap: showDetailIcon
                        ? onTapGrid
                        : onTapGridDetail,
                    child: SizedBox(
                      height: 24.h,
                      width: 28.w,
                      child: Image.asset(showDetailIcon
                          ? Assets.iconsPdtGridIconSelected
                          : Assets.iconsPdtGridIconUnselected),
                    ),
                  ),
                ],
              )
                  : SizedBox(),
              showAppIcon ?? true
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 120.h,
                      child: Image.asset(
                          Assets.iconsLovicaAppIconSmall)),
                ],
              )
                  : SizedBox(),
            ],
          ),
        ));

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
            color: Colors.white,
            elevation: showElevation ? 2 : 0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, bottom: 10.h, left: 12.w, right: 8.w),
                  child: AppData.appLocale == "ar"
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //takes the row to the top
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //Used this for spacing between the children
                    children: [
                      showGridIcon ?? true
                          ? Row(
                        children: [
                          InkWell(
                            onTap: showDetailIcon
                                ? onTapGrid
                                : onTapGridDetail,
                            child: SizedBox(
                              height: 24.h,
                              width: 28.w,
                              child: Image.asset(showDetailIcon
                                  ? Assets.iconsPdtGridIconSelected
                                  : Assets
                                  .iconsPdtGridIconUnselected),
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),
                      showAppIcon ?? true
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: 120.h,
                              child: Image.asset(
                                  Assets.iconsLovicaAppIconSmall)),
                        ],
                      )
                          : SizedBox(),
                      Expanded(child: SizedBox()),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            //used for aligning the children vertically
                            children: [
                              Text(
                                title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: onTapBack,
                            child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: RotatedBox(
                                    quarterTurns:
                                    AppData.appLocale == "ar" ? 2 : 0,
                                    child: Image.asset(
                                        Assets.iconsBackIcon))),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //takes the row to the top
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //Used this for spacing between the children
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: onTapBack,
                            child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Image.asset(Assets.iconsBackIcon)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            //used for aligning the children vertically
                            children: [
                              Text(
                                title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      showGridIcon ?? true
                          ? Row(
                        children: [
                          InkWell(
                            onTap: showDetailIcon
                                ? onTapGrid
                                : onTapGridDetail,
                            child: SizedBox(
                              height: 24.h,
                              width: 28.w,
                              child: Image.asset(showDetailIcon
                                  ? Assets.iconsPdtGridIconSelected
                                  : Assets
                                  .iconsPdtGridIconUnselected),
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),
                      showAppIcon ?? true
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: 120.h,
                              child: Image.asset(
                                  Assets.iconsLovicaAppIconSmall)),
                        ],
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
                // SizedBox(height: 24.h,)
              ],
            )));
  }
}
