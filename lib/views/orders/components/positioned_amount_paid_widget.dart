import 'package:flutter/cupertino.dart';

import '../../../common/constants.dart';
import '../../../common/font_palette.dart';
import '../../../services/app_data.dart';
import '../order_details.dart';

class PositionedAmountPaidWidget extends StatelessWidget {
  const PositionedAmountPaidWidget({
    super.key,
    required this.widget,
  });

  final OrderDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      // heightFactor: 20,
      child: Directionality(
        textDirection: AppData.appLocale == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
                TextSpan(
                    text: "${Constants.amtPaid} : ",
                    style: FontPalette.black12w500,
                    children: <InlineSpan>[
                      TextSpan(
                        text:
                        "SAR ${widget.orderItem?.grandTotal ?? ""}",
                        style: FontPalette.black24W700,
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
