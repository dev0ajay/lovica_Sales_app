import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/extensions.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/color_palette.dart';
import '../../generated/assets.dart';

class CategoryCardShimmer extends StatefulWidget {
  const CategoryCardShimmer({Key? key}) : super(key: key);

  @override
  State<CategoryCardShimmer> createState() => _CategoryCardShimmerState();
}

class _CategoryCardShimmerState extends State<CategoryCardShimmer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //     top: 40.h,
        //     left: 20.w,
        //     child: Shimmer.fromColors(
        //       baseColor: ColorPalette.shimmerBaseColor,
        //       highlightColor: ColorPalette.shimmerHighlightColor,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 27.h,
        //                 width: 37.h,
        //                 child: Image.asset(Assets.iconsMenuIcon),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 20.h,
        //                 width: 20.h,
        //                 child: Image.asset(Assets.iconsNotifIcon),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 36.h,
        //                 width: 110.h,
        //                 child: Image.asset(Assets.iconsLovicaAppIconSmall),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 20.h,
        //                 width: 20.h,
        //                 child: Image.asset(Assets.iconsSearchIcon),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 20.h,
        //                 width: 20.h,
        //                 child: Image.asset(Assets.iconsScannerIcon),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             child: InkWell(
        //               onTap: () {},
        //               child: SizedBox(
        //                 height: 30.h,
        //                 width: 30.h,
        //                 child: Image.asset(Assets.iconsCartIcon),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
        Container(
          // margin: EdgeInsets.only(top: 100.h),
          padding: EdgeInsets.only(
            top: 14.h,
          ),
          decoration: BoxDecoration(
              color: HexColor("#E8E8E8"), borderRadius: BorderRadius.circular(8.sp)),
          child: Shimmer.fromColors(
              baseColor: ColorPalette.shimmerBaseColor,
              highlightColor: ColorPalette.shimmerHighlightColor,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) => Padding(
                  padding:
                      EdgeInsets.only(left: 20.w, bottom: 40.h),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w))),
                        height: 84.h,
                        width: 82.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w))),
                        height: 84.h,
                        width: 82.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w))),
                        height: 84.h,
                        width: 82.h,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
