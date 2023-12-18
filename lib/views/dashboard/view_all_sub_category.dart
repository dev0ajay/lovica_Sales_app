
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/providers/localization_provider.dart';
import 'package:lovica_sales_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/nav_routes.dart';
import '../../common/network_connectivity.dart';
import '../../providers/category_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/common_header_tile.dart';

class ViewAllSubCategoryScreen extends StatefulWidget {
  const ViewAllSubCategoryScreen({super.key, this.catId, this.catName});
  final String? catId;
  final String? catName;

  @override
  State<ViewAllSubCategoryScreen> createState() => _ViewAllSubCategoryScreenState();
}

class _ViewAllSubCategoryScreenState extends State<ViewAllSubCategoryScreen> {
  final ValueNotifier<bool> enableError = ValueNotifier(false);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool _isDrawerOpen = false;
  int? selected;

  @override
  void initState() {
    // Future.microtask(() => context
    //     .read<CategoryProvider>()
    //     .getSubCategoryListForExpansion(context: context, catId: "5"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Consumer3<CategoryProvider, ProductProvider, AppLocalizationProvider>(
          builder: (context, cValue, pValue, lp, child) {
            return
              NetworkConnectivity(
                inAsyncCall: cValue.loaderState == LoadState.loading ||
                    pValue.loaderState == LoadState.loading,
                child: cValue.subCategories != null
                    ?
                buildBody(cValue, context)
                    : const SizedBox(),
              );
          }),
      // appBar: CommonAppBar(),
    );
  }

  Column buildBody(CategoryProvider cValue, BuildContext context) {
    return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150.h
                    ),
                    HeaderTile(
                      showGridIcon: false,
                      showAppIcon: false,
                      showElevation: false,
                      title: widget.catName,
                      showDetailIcon: cValue.isDetailView,
                      onTapGridDetail: () {
                        cValue.updateIsDetailView(true);
                      },
                      onTapGrid: () {
                        cValue.updateIsDetailView(false);
                      },
                      onTapBack: () => Navigator.pop(context),
                    ),


                    buildSubHeader(),
                    SizedBox(
                      height: 18.h
                    ),
                    cValue.subCategoryForExpansion?.isNotEmpty ?? true
                        ?
                    buildExpandedScrollableBody(cValue, context)
                        : cValue.loaderState == LoadState.loading
                        ? const SizedBox()
                        :  CommonErrorWidget(
                        types: ErrorTypes.noDataFound,buttonText:
                    Constants.backHome,
                        onTap: () {
                          NavRoutes.navToDashboard(context);
                        }),
                  ],
                );
  }

  Expanded buildExpandedScrollableBody(CategoryProvider cValue, BuildContext context) {
    return Expanded(
                        child: CustomScrollView(
                          shrinkWrap: true,
                          controller: scrollController,
                          physics:
                          const BouncingScrollPhysics(),
                          slivers: [
                            cValue.subCategoryForExpansion
                                        ?.isNotEmpty ??
                                    true
                                ?
                            SliverGrid(
                              delegate:
                              SliverChildBuilderDelegate(
                                    (ctx, idx) {
                                  return Container(
                                    margin: EdgeInsets
                                        .only(
                                        left:
                                        12.w,
                                        right:
                                        12.w),
                                    child:
                                    OutlinedButton(
                                      style: OutlinedButton
                                          .styleFrom(
                                        backgroundColor:
                                        Colors
                                            .transparent,
                                        side: BorderSide(
                                            color: idx == 5
                                                ? Colors
                                                .white
                                                : Colors
                                                .black,
                                            width:
                                            1), //<-- SEE HERE
                                      ),
                                      onPressed: () {
                                         if (cValue
                                            .subCategoryForExpansion![
                                        idx]
                                            .categoryId !=
                                            null) {
                                          NavRoutes.navToProductListing(
                                              context,
                                              catId: cValue.subCategoryForExpansion![idx].categoryId ??
                                                  "",
                                              catName:
                                              cValue.subCategoryForExpansion![idx].categoryName ??
                                                  "");
                                        }
                                      },
                                      child: Text(
                                        AppData.appLocale == "ar"
                                            ? cValue.subCategoryForExpansion![idx].categoryNameArabic ??
                                                ""
                                            : cValue.subCategoryForExpansion![idx].categoryName ??
                                                "",
                                        maxLines:
                                        1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: FontPalette
                                            .black12Regular,
                                      ),
                                    ),
                                  );
                                },
                                childCount:
                                (cValue.subCategoryForExpansion!.length >
                                    5 ||
                                    cValue.subCategoryForExpansion!.length ==
                                        5)
                                    ? 6
                                    : cValue.subCategoryForExpansion!.length,
                              ),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                // childAspectRatio: 1 /2,
                                // crossAxisSpacing: 2.w,
                                  mainAxisSpacing:
                                  10.h,
                                  mainAxisExtent:
                                  40.h,
                                  crossAxisCount:
                                  2),
                            )
                            : const SliverToBoxAdapter(
                                child: SizedBox(),
                              ),

                            SliverPadding(
                                padding:
                                EdgeInsets.only(
                                    top: 5.h)),
                          ],
                        ));
  }

  Padding buildSubHeader() {
    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Wrap(
                        children: [
                          Text(
                            Constants.home,
                            style: FontPalette.grey10Italic,
                          ),
                          Text(" / ", style: FontPalette.grey10Italic),
                          Text(widget.catName ?? "",
                              style: FontPalette.grey10Italic)
                        ],
                      ),
                    );
  }
}
