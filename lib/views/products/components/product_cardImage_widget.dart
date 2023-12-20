import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/color_palette.dart';
import '../../../models/product_model.dart';

class ProductCardImageWidget extends StatelessWidget {
  const ProductCardImageWidget({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86.h,
      width: 84.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow:  [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),

          ),
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: const Offset(
              -1.0, // Move to right 10  horizontally
              -1.0, // Move to bottom 10 Vertically
            ),
          ),

        ],
        borderRadius:
        BorderRadius.all(Radius.circular(5.w),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.w),
        child: CachedNetworkImage(
          useOldImageOnUrlChange: true,
          fit: BoxFit.cover,
          // height: 84.h,
          // width: 82.w,
          placeholder: (_, v) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: ColorPalette.shimmerBaseColor,
                highlightColor: ColorPalette.shimmerHighlightColor,
                child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.black, width: 1.w),
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.w),
                    ),
                  ),
                ),

            ));
          },
          errorWidget: (context, c, w) {
            return Container(
              width: 72.w,
              height: 72.w,
              color: ColorPalette.shimmerBaseColor,
            );
          },
          imageUrl: product?.image ?? "",
          alignment: Alignment
          .center,


        ),
      ),
    );
  }
}
