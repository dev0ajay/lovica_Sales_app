// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lovica_sales_app/common/constants.dart';
// import 'package:lovica_sales_app/common/font_palette.dart';
// import 'package:lovica_sales_app/models/product_model.dart';
// import 'package:lovica_sales_app/views/products/product_tile.dart';
// import 'package:lovica_sales_app/views/products/product_tile_expanded.dart';
// import 'package:lovica_sales_app/widgets/reusable_widgets.dart';
//
// import '../../models/category_model.dart';
//
// class ExpandableTile extends StatelessWidget {
//   final MainCategory subCategory;
//   final bool isDetailView;
//
//   ExpandableTile({required this.subCategory, required this.isDetailView});
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//
//       onExpansionChanged: (value) {
//         if (value) {
//
//         }
//       },
//       key: PageStorageKey<MainCategory>(subCategory),
//       title: Text(subCategory.categoryName ?? "",
//           style: FontPalette.black16Regular),
//       children: <Widget>[
//         CustomScrollView(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverPadding(padding: EdgeInsets.only(top: 5.h)),
//             SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   if (index == 4) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextButton(
//                             onPressed: () {},
//                             child: Row(
//                               children: [
//                                 Text(
//                                   Constants.seeMore,
//                                   style: FontPalette.black14Regular,
//                                 ),
//                                 SizedBox(
//                                   width: 8.w,
//                                 ),
//                                 const Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 15,
//                                 )
//                               ],
//                             )),
//                       ],
//                     );
//                   }
//                   if (isDetailView) {
//                     return ProductCardExpanded(
//                       product: Product(
//                           productId: "1",
//                           productName: "Vaseline",
//                           productNameArabic: "dsfdsfdf",
//                           inclCats: "20",
//                           description:
//                               "Intensive moisturizing care, with a great formula infusedwith the Nivea Deep MoistureSerum and aloe vera fornourished and soft skin witha delicate fragrance.",
//                           descriptionArabic: "asd",
//                           image:
//                               "https://lovicasales.demoatcrayotech.com/images/category/1680849009_3ecbb6a64388bceb2279.svg"),
//                       onTap: () {},
//                       isDetailed: false,
//                     );
//                   }
//
//                   return ProductCard(
//                     product: Product(
//                         productId: "1",
//                         productName: "Vaseline ",
//                         productNameArabic: "dsfdsfdf",
//                         inclCats: "20",
//                         description: "dsfgfgfsfgsf   agsfgf",
//                         descriptionArabic: "asd",
//                         image:
//                             "https://lovicasales.demoatcrayotech.com/images/category/1680849009_3ecbb6a64388bceb2279.svg"),
//                     onTap: () {
//                      /* Future.microtask(() =>
//                           ReusableWidgets.modalBottomSheet(
//                               context));*/
//                     },
//                     isDetailed: false,
//                   );
//                 },
//                 childCount: 5,
//               ),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   // childAspectRatio: 1 /2,
//                   crossAxisSpacing: isDetailView ? 25.w : 46.w,
//                   mainAxisSpacing: 5.h,
//                   mainAxisExtent: isDetailView ? 230.h : 130.h,
//                   crossAxisCount: 3),
//             ),
//             SliverPadding(padding: EdgeInsets.only(top: 5.h)),
//           ],
//         ),
//       ],
//     );
//   }
// }
