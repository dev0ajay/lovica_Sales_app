// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// class ValidationHelper {
//   static String? validateMobile(
//       BuildContext context, String val, int? maxLength) {
//     String value = val.trim();
//     String pattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
//     RegExp regExp = RegExp(pattern);
//     if (!regExp.hasMatch(value) ||
//         (maxLength != null && value.length != maxLength)) {
//       return context.loc.invalidMobile;
//     }
//     return null;
//   }
//
//   static String? validateEmail(BuildContext context, String val) {
//     String value = val.trim();
//     String pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);
//     if (regex.hasMatch(value)) {
//       return null;
//     } else {
//       return context.loc.invalidEmail;
//     }
//   }
//
//   static String? validateDate(BuildContext context, String val) {
//     String value = val.trim();
//
//     if (value.isNotEmpty) {
//       return null;
//     } else {
//       return "Please enter a date";
//     }
//   }
//
//   static String? validateName(BuildContext context, String val) {
//     String value = val.trim();
//     if (value.isEmpty) {
//       return context.loc.invalidName;
//     } else if (value.trim().length < 3) {
//       return null;
//     }
//     return null;
//   }
//
//   static String? validateLastName(BuildContext context, String val) {
//     String value = val.trim();
//     return (value.isEmpty)
//         ? context.loc.invalidLName
//         : null;
//   }
//
//   static String? validateText(BuildContext context, String value) {
//     return (value.trim().isEmpty) ? "Field can\'t be empty" : null;
//   }
//
//   static List<TextInputFormatter>? inputFormatter(String text) {
//     List<TextInputFormatter>? val;
//     switch (text) {
//       case "phoneNo":
//         val = [
//           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//         ];
//         break;
//       case "name":
//         val = [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))];
//         break;
//     }
//     return val;
//   }
// }
