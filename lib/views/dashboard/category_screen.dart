// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lovica_sales_app/common/nav_routes.dart';
// import 'package:provider/provider.dart';
//
// import '../../common/constants.dart';
// import '../../common/helpers.dart';
// import '../../common/network_connectivity.dart';
// import '../../models/category_model.dart';
// import '../../providers/category_provider.dart';
// import 'category_card.dart';
//
// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});
//
//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }
//
// class _CategoryScreenState extends State<CategoryScreen> {
//   final ValueNotifier<bool> enableError = ValueNotifier(false);
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   ScrollController scrollController = ScrollController();
//
//   int? mainCategoryCount = 0;
//
//   @override
//   void initState() {
//     Future.microtask(() => context
//         .read<CategoryProvider>()
//         .getcategoryList(context: context, catId: "0"));
//     super.initState();
//   }
//
//   Future<void> fetchData() async {}
//
//   @override
//   Widget build(BuildContext context) {
//     double textScale =
//         Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Consumer<CategoryProvider>(builder: (context, value, child) {
//         if (value.categories != null &&
//             (value.categories?.mainCategoryList?.isNotEmpty ?? true)) {
//           mainCategoryCount = value.categories?.mainCategoryList?.length;
//         }
//         return NetworkConnectivity(
//           inAsyncCall: value.loaderState == LoadState.loading,
//           child: value.categories != null &&
//                   (value.categories?.mainCategoryList?.isNotEmpty ?? true)
//               ? Stack(
//                   children: [
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 50.h,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(20.w),
//                           child: CustomScrollView(
//                             shrinkWrap: true,
//                             physics: const BouncingScrollPhysics(),
//                             controller: scrollController,
//                             slivers: [
//                               SliverPadding(padding: EdgeInsets.only(top: 5.h)),
//                               SliverGrid(
//                                 delegate: SliverChildBuilderDelegate(
//                                   (context, index) {
//                                     MainCategory? category =
//                                         value.categoryList?[index];
//
//                                     if (category == null) {
//                                       return const SizedBox();
//                                     }
//                                     return CategoryCard(
//                                       category: category,
//                                       colorBackground: Colors.white,
//                                       onTap: () {
//                                         NavRoutes.navToSubCategory(context,
//                                             catId: category.categoryId ?? "");
//                                       },
//                                     );
//                                   },
//                                   childCount: value.categoryList!.length,
//                                 ),
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         childAspectRatio: 1 / 2,
//                                         crossAxisSpacing: 40.w,
//                                         mainAxisSpacing: 20,
//                                         mainAxisExtent: 120,
//                                         crossAxisCount: 3),
//                               ),
//                               SliverPadding(padding: EdgeInsets.only(top: 5.h)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               : const SizedBox()
//
//           /*       value.categories != null &&
//                         (value.categories?.mainCategoryList?.isEmpty ?? true)
//                     ? const Center(
//                         child: CommonErrorWidget(
//                         types: ErrorTypes.noDataFound,
//                       ))
//                     : value.loaderState == LoadState.error
//                         ? const Center(
//                             child: CommonErrorWidget(
//                               types: ErrorTypes.serverError,
//                             ),
//                           )
//                         : value.loaderState == LoadState.networkErr
//                             ? const Center(
//                                 child: CommonErrorWidget(
//                                   types: ErrorTypes.networkErr,
//                                 ),
//                               )
//                             : Column(
//                                 children: [
//                                   Expanded(
//                                       child: Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 5.w),
//                                     child: value.loaderState ==
//                                             LoadState.loading
//                                         ? AlignedGridView.count(
//                                             itemCount: 3,
//                                             crossAxisCount: 2,
//                                             mainAxisSpacing: 5.h,
//                                             crossAxisSpacing: 5.h,
//                                             itemBuilder: (context, index) {
//                                               return const CategoryCardShimmer();
//                                             },
//                                           )
//                                         : CustomScrollView(
//                                             physics:
//                                                 const BouncingScrollPhysics(),
//                                             controller: scrollController,
//                                             slivers: [
//                                               SliverPadding(
//                                                   padding: EdgeInsets.only(
//                                                       top: 5.h)),
//                                               SliverGrid(
//                                                 delegate:
//                                                     SliverChildBuilderDelegate(
//                                                   (context, index) {
//                                                     MainCategory? category =
//                                                         value.categoryList?[
//                                                             index];
//
//                                                     if (category == null) {
//                                                       return const SizedBox();
//                                                     }
//                                                     return CategoryCard(
//                                                       category: category,
//                                                       colorBackground:
//                                                           Colors.white,
//                                                       onTap: () {},
//                                                     );
//                                                   },
//                                                   childCount: value
//                                                       .categoryList!.length,
//                                                 ),
//                                                 gridDelegate:
//                                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                                         crossAxisSpacing: 5.w,
//                                                         mainAxisSpacing: 5.h,
//                                                         crossAxisCount: 2),
//                                               ),
//                                               SliverPadding(
//                                                   padding: EdgeInsets.only(
//                                                       top: 5.h)),
//                                             ],
//                                           ),
//                                   ))
//                                 ],
//                               )*/
//           ,
//         );
//       })),
//       // appBar: CommonAppBar(),
//     );
//   }
// }
