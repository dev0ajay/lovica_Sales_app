import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lovica_sales_app/views/menu/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/localization_provider.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,

          body: SingleChildScrollView(
            child: Consumer<AppLocalizationProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  children: [
                    HeaderTile(
                      showAppIcon: false,
                      title: AppData.appLocale == "ar" ?  value.headingAr : value.headingEn,
                      onTapBack: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),

                          ),
                        );
                        print(value.headingEn);
                      },
                    ),
                    value.contentEn  == null || value.contentAr == null ? const SizedBox() :
                    Directionality(
                      textDirection: AppData.appLocale == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Html(data:
                      AppData.appLocale == "ar" ? value.contentAr : value.contentEn
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        )
    );

  }
}
