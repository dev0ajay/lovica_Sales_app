import 'package:flutter/material.dart';

import 'constants.dart';

class Validator {
  Validator.__();

  static String? validateEMptyField(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyString;
    }
    // else if (value.length < 8) {
    //   return Constants.passwordValidationMsg;
    // } else if (!value.contains(RegExp(r'[0-9]'))) {
    //   return Constants.passwordContainOneNumber;
    // } else if (!value.contains(RegExp(r'[#?!@$%^&*-]'))) {
    //   return Constants.mustContainOneCharacter;
    // } else if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return Constants.passwordContainOneCapital;
    // } else if (!value.contains(RegExp(r'[a-z]'))) {
    //   return Constants.passwordContainOneSmall;
    // }
    return null;
  }

  static String? validateUserName(String? value) {
    // String pattern = r'^[a-zA-Z ]*$';
    // String pattern = RegExp("^[\u0621-\u064A\u0660-\u0669 1-9 a-zA-Z ]+\$");

    RegExp regExp = RegExp("^[\u0621-\u064A\u0660-\u0669 a-zA-Z ]+\$");
    if (value == null || value.isEmpty) {
      return Constants.emptyString;
    }
    // else if (!regExp.hasMatch(value)) {
    //   return Constants.enterValidUName;
    // }
    return null;
  }

  static String? validateName(String? value) {
    String pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = RegExp("^[\u0621-\u064A\u0660-\u0669 1-9a-zA-Z ]+\$");
    if (value == null || value.isEmpty) {
      return Constants.emptyString;
    }
    else if (!regExp.hasMatch(value)) {
      return Constants.enterValidUName;
    }
    return null;
  }
}
