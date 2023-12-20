

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/font_palette.dart';
import '../../../models/product_model.dart';
import '../../../services/app_data.dart';

class ProductCardSubTitleTextWidget extends StatelessWidget {
  const ProductCardSubTitleTextWidget({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Text(
        AppData.appLocale == "ar"
            ? product?.brandNameArabic ?? ""
            : product?.brandNameEnglish ?? "",
        overflow: TextOverflow.ellipsis,
        textAlign:
        AppData.appLocale == "ar" ? TextAlign.right : TextAlign.left,
        textDirection: AppData.appLocale == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        maxLines: 1,
        style: FontPalette.grey8Regular,
      ),
    );
  }
}
