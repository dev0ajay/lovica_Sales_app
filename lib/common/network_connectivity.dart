import 'package:flutter/material.dart';
import 'package:lovica_sales_app/widgets/shimmers/common_category_card_shimmer.dart';
import 'package:provider/provider.dart';

import '../providers/connectivity_provider.dart';
import '../widgets/common_error_widget.dart';
import '../widgets/reusable_widgets.dart';
import 'color_palette.dart';
import 'constants.dart';

class NetworkConnectivity extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Function? onTap;
  final Color color;

  const NetworkConnectivity(
      {Key? key,
      required this.child,
      this.inAsyncCall = false,
      this.opacity = 0.3,
      this.onTap,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, snapshot, _) {
      List<Widget> widgetList = [];
      widgetList.add(child);
      if (!snapshot.isConnected) {
        widgetList.add(Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: HexColor("#E8E8E8"),
          alignment: Alignment.center,
          child: CommonErrorWidget(
            types: ErrorTypes.networkErr,
            onTap: () {
              if (snapshot.isConnected) snapshot.updateEnableRefresh();
              if (onTap != null) {
                onTap!();
              }
            },
          ),
        ));
      }
      if (inAsyncCall) {
        Widget modal = SizedBox();
        modal = Stack(
          children: [
            Opacity(
              opacity: opacity,
              child:
                  ModalBarrier(dismissible: false, color: HexColor("#E8E8E8")),
            ),
            ReusableWidgets.circularLoader(),
          ],
        );

        widgetList.add(modal);
      }
      return Stack(
        children: widgetList,
      );
    });
  }
}
