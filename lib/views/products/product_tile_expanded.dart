import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/product_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/color_palette.dart';
import '../../services/app_data.dart';

class ProductCardExpanded extends StatelessWidget {
  final Product? product;
  final bool? isDetailed;
  final Function()? onTap;

  const ProductCardExpanded(
      {super.key, required this.product, required this.onTap, required this.isDetailed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 1,right: 1),
            child: Container(
              height: 230.h,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 2.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        -0.0, // Move to bottom 10 Vertically
                      ),

                    ),
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 2.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        -0.0, // Move to bottom 10 Vertically
                      ),

                    )
                  ],
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.w)),
                // boxShadow: [BoxShadow(
                //   color: Colors.grey,
                //   offset: const Offset(1.0, 1.0), //(x,y)
                //   blurRadius: 6.r,
                // )] ,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, ColorPalette.boxGrey])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(11.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.w),
                            child: AspectRatio(
                              aspectRatio: 1.5,
                              child: CachedNetworkImage(
                                useOldImageOnUrlChange: true,
                                fit: BoxFit.fill,
                                height: 87.h,
                                // width: 20.w,
                                placeholder: (_, v) {
                                  return Center(
                                      child: Shimmer.fromColors(
                                        baseColor: ColorPalette.shimmerBaseColor,
                                        highlightColor: ColorPalette.shimmerHighlightColor,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border:
                                                Border.all(color: Colors.black, width: 1.w),
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5.w)))),
                                      ));
                                },
                                errorWidget: (context, c, w) {
                                  return Container(
                                    height: 88.h,
                                    width: 40.w,
                                    color: ColorPalette.shimmerBaseColor,

                                  );
                                },

                                imageUrl: product?.image ?? "",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            AppData.appLocale == "ar"
                                ? product?.brandNameArabic ?? ""
                                : product?.brandNameEnglish ?? "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: AppData.appLocale == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: 1,
                            style: FontPalette.grey10Regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            AppData.appLocale == "ar"
                                ? product?.productNameArabic ?? ""
                                : product?.productName ?? "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: AppData.appLocale == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: AppData.appLocale == "ar" ? 1 : 3,
                            style: FontPalette.black10w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            parse(AppData.appLocale == "ar"
                                    ? product?.descriptionArabic ?? ""
                                    : product?.description ?? "")
                                .body!
                                .text,
                            overflow: TextOverflow.ellipsis,
                            textAlign: AppData.appLocale == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: AppData.appLocale == "ar" ? 2 : 3,
                            style: FontPalette.grey8Regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            "SAR ${product?.total!.toStringAsFixed(2)}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: AppData.appLocale == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: AppData.appLocale == "ar"
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: 6,
                            style: FontPalette.black16W500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
