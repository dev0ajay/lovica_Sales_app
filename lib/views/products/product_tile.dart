import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/models/product_model.dart';
import '../../services/app_data.dart';
import 'components/product_cardImage_widget.dart';
import 'components/product_cardSubTitle_widget.dart';
import 'components/product_cardTitle_widget.dart';

class ProductCard extends StatelessWidget {
  final Product? product;
  final bool? isDetailed;
  final Function()? onTap;

  const ProductCard(
      {super.key, required this.product, required this.onTap, required this.isDetailed});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0,right: 2.0),
        child: Column(
          crossAxisAlignment: AppData.appLocale == "ar"
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            ProductCardImageWidget(product: product),
            SizedBox(
                height: 7.h
            ),
            ProductCardSubTitleTextWidget(product: product),
            SizedBox(
              height: 1.h
            ),
            ProductCardTitleTextWidget(product: product),
          ],
        ),
      ),
    );
  }
}



