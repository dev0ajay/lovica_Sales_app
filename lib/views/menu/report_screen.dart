import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/report_model_class.dart';
import 'package:lovica_sales_app/services/app_data.dart';
import 'package:lovica_sales_app/widgets/common_header_tile.dart';
import 'package:lovica_sales_app/widgets/custom_common_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../common/validator.dart';
import '../../models/city_model.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/localization_provider.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dropdown/custom_dropdown.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _uNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<City> city = ValueNotifier(City());

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<CustomerProvider>()..clearReports()..getReports(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer3<AuthenticationProvider, AppLocalizationProvider,
            CustomerProvider>(
          builder: (context, value, lp, cP, child) {
            return NetworkConnectivity(
              inAsyncCall: cP.loaderState == LoadState.loading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTile(
                    showAppIcon: true,
                    title: Constants.reports,
                    onTapBack: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Directionality(
                    textDirection: AppData.appLocale == "ar"
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Text(
                            Constants.home,
                            style: FontPalette.grey10Italic,
                          ),
                          Text(" / ", style: FontPalette.grey10Italic),
                          Text(Constants.reports, style: FontPalette.grey10Italic)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34.h,
                  ),
                  Directionality(
                    textDirection: AppData.appLocale == "ar"
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 19.w),
                        itemCount: cP.data.length,
                        itemBuilder: (ctx, i) {
                          TotalCustomers? item=cP.data[i];
                          return  Container(
                              height: 160.h,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5.r,
                                      spreadRadius: 0,
                                      offset: Offset(2, 2),
                                    )
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white, ColorPalette.boxGrey]),
                                  borderRadius: BorderRadius.circular(10.r)),
                              // margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10.w),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppData.appLocale == "ar"
                                                ? item.labelAr ?? ""
                                                : item.labelEn ?? "",

                                            style: FontPalette.blackShade12w400,
                                          ),
                                          Image.network(
                                            item.img??"",
                                              height: 31.h,
                                              width: 31.w,
                                              fit: BoxFit.contain,
                                              )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text.rich(TextSpan(
                                              text: "${item.count} ",
                                              style: FontPalette.black24W700,
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: AppData.appLocale == "ar"
                                                      ? item.labelAr ?? ""
                                                      : item.labelEn ?? "",
                                                  style: FontPalette.black12w500,
                                                )
                                              ]))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            AppData.appLocale == "ar"
                                                ? item.labelAr ?? ""
                                                : item.labelEn ?? "",
                                            style: FontPalette.grey10Regular,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: 1.0,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                          mainAxisExtent: 160.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // appBar: CommonAppBar(),
    );
  }

  Widget prefixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: const Text(
            '+966',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          height: 55.h,
          width: 1.w,
          color: Colors.black,
        ),
        SizedBox(
          width: 12.w,
        )
      ],
    );
  }

  Widget suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: HexColor("#7A7A7A"),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 12.w,
        )
      ],
    );
  }

// this method shows the modal dialog
  dynamic _showModal(BuildContext context) async {
    // show the modal dialog and pass some data to it
    final result = await Navigator.of(context).push(FullScreenModal(
        title: Constants.submitted,
        description: 'Just some dummy description text'));

    // print the data returned by the modal if any
    debugPrint(result.toString());
  }

  @override
  void dispose() {
    _uNameController.dispose();
    super.dispose();
  }
}
