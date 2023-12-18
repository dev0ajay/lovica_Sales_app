import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension FlavourTypeExtension on String {
  String getBaseUrl() {
    switch (this) {
      case 'dev':
        return 'https://gogo.webc.in/';
      case 'stage':
        return 'https://gogo.webc.in/';
      case 'prod':
        return 'https://gogo.webc.in/';
      default:
        return 'https://gogo.webc.in/';
    }
  }

  String getPublishableKEY() {
    switch (this) {
      case 'dev':
        return 'pk_test_51LLfvNGymmd4fBoC9HZrv07RDY5uKIfQMj15MbkIBrL6tCHx5laNnwpDBQLqwY4mIaxPwlqi7hwJHDr4U23QQMZt003anBTKLc';
      case 'stage':
        return 'pk_test_51LLfvNGymmd4fBoC9HZrv07RDY5uKIfQMj15MbkIBrL6tCHx5laNnwpDBQLqwY4mIaxPwlqi7hwJHDr4U23QQMZt003anBTKLc';
      case 'prod':
        return 'pk_test_51LLfvNGymmd4fBoC9HZrv07RDY5uKIfQMj15MbkIBrL6tCHx5laNnwpDBQLqwY4mIaxPwlqi7hwJHDr4U23QQMZt003anBTKLc';
      default:
        return 'pk_test_51LLfvNGymmd4fBoC9HZrv07RDY5uKIfQMj15MbkIBrL6tCHx5laNnwpDBQLqwY4mIaxPwlqi7hwJHDr4U23QQMZt003anBTKLc';
    }
  }

  String getSecretKEY() {
    switch (this) {
      case 'dev':
        return 'sk_test_51LLfvNGymmd4fBoC1wvZbCcbV63CuDEX9JISKHBS0n2FVMYFENTnRpkLlIewHHhRvxGFvwIKSNRcbkot80etZUvX00lTW4oOMT';
      case 'stage':
        return 'sk_test_51LLfvNGymmd4fBoC1wvZbCcbV63CuDEX9JISKHBS0n2FVMYFENTnRpkLlIewHHhRvxGFvwIKSNRcbkot80etZUvX00lTW4oOMT';
      case 'prod':
        return 'sk_test_51LLfvNGymmd4fBoC1wvZbCcbV63CuDEX9JISKHBS0n2FVMYFENTnRpkLlIewHHhRvxGFvwIKSNRcbkot80etZUvX00lTW4oOMT';
      default:
        return 'sk_test_51LLfvNGymmd4fBoC1wvZbCcbV63CuDEX9JISKHBS0n2FVMYFENTnRpkLlIewHHhRvxGFvwIKSNRcbkot80etZUvX00lTW4oOMT';
    }
  }

  String getFlavourName() {
    switch (this) {
      case 'dev':
        return 'Development';
      case 'stage':
        return 'Staging';
      case 'prod':
        return 'Production';
      default:
        return 'Production';
    }
  }

  String capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  String cvtToAr({String loc = 'ar'}) {
    if (loc != 'ar') return this;
    var sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      switch (this[i]) {
        //To arabic digits
        case '0':
          sb.write('\u0660');
          break;
        case '1':
          sb.write('\u0661');
          break;
        case '2':
          sb.write('\u0662');
          break;
        case '3':
          sb.write('\u0663');
          break;
        case '4':
          sb.write('\u0664');
          break;
        case '5':
          sb.write('\u0665');
          break;
        case '6':
          sb.write('\u0666');
          break;
        case '7':
          sb.write('\u0667');
          break;
        case '8':
          sb.write('\u0668');
          break;
        case '9':
          sb.write('\u0669');
          break;
        case '.':
          sb.write(',');
          break;
        default:
          sb.write(this[i]);
          break;
      }
    }
    return sb.toString();
  }
}

extension CheckNull on dynamic {
  bool get isNull => this == null ? true : false;
}

extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }

  void rootPop() {
    Navigator.of(this, rootNavigator: true).pop();
  }

  /// Localization
  //
  // AppLocalizations get loc => AppLocalizations.of(this)!;
  //
  // String get myLocale => Localizations.localeOf(this).languageCode;
  //
  // bool get isArabic => myLocale == 'ar' ? true : false;
}

extension DoubleExtension on double? {
  String roundTo2() {
    double val = this ?? 0.0;
    return val.toStringAsFixed(2);
  }
}

extension WidgetExtension on Widget {
  Widget animatedSwitch({Curve? curvesIn, Curve? curvesOut}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: this,
      switchInCurve: curvesIn ?? Curves.linear,
      switchOutCurve: curvesOut ?? Curves.linear,
    );
  }
}

extension InkWellExtension on InkWell {
  InkWell removeSplash({Color color = Colors.transparent}) {
    return InkWell(
      child: child,
      onTap: onTap,
      splashColor: color,
      highlightColor: color,
    );
  }
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension Log on Object {
  void log({String name = ''}) => devtools.log(toString(), name: name);
}
