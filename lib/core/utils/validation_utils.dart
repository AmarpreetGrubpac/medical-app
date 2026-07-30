import 'package:grubpac_driver/core/utils/app_string.dart';

class AppValidation {
  /// EMPTY
  static String? emptyValidator(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// NULL
  static String? nullValidator<T>(T? value, String errorMessage) {
    if (value == null) {
      return errorMessage;
    }
    return null;
  }

  /// FULL NAME
  static String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.required;
    } else if (value.trim().length < 2) {
      return AppString.nameMustBe2Char;
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return AppString.validFullName;
    }

    return null;
  }

  /// EMAIL
  static String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
        r'((\[[0-9]{1,3}(\.[0-9]{1,3}){3}\])|(([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,63}))$';
    RegExp regex = RegExp(pattern);

    if (value == null || value.trim().isEmpty) {
      return AppString.required;
    } else if (!regex.hasMatch(value)) {
      return AppString.enterValidEmail;
    }

    return null;
  }

  /// PASSWORD
  static String? passValidator(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);

    if (value == null || value.trim().isEmpty) {
      return AppString.enterPassValidation;
    } else if (value.trim().length < 8) {
      return AppString.passEightChar;
    } else if (!regex.hasMatch(value)) {
      return AppString.passValidationError;
    }
    return null;
  }

  /// CONFIRM PASSWORD
  static String? confirmPassValidator(String? value, String? passValue) {
    if (value == null || value.trim().isEmpty) {
      return AppString.passReEnter;
    } else if (value.trim() != passValue?.trim()) {
      return AppString.passNotMatch;
    }
    return null;
  }

  /// MOBILE NUMBER
  static String? mobileNumberValidator(String? value) {
    if (!(value!.length > 6 && value.length < 14)) {
      return AppString.enterValidNumber;
    }
    return null;
  }

  /// OLD PASSWORD
  static String? oldPassValidator(String? value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = RegExp(pattern);

    if (value == null || value.trim().isEmpty) {
      return AppString.enterCurrentPassValidation;
    } else if (value.trim().length < 8) {
      return AppString.currentPassEightChar;
    }
    //  else if (!regex.hasMatch(value)) {
    //   return AppString.passValidationError;
    // }
    return null;
  }

  /// NEW PASSWORD
  static String? newPassValidator(String? value, String? passValue) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);

    if (value?.trim() == passValue?.trim()) {
      return AppString.sameCurrentNewPass;
    } else if (value == null || value.trim().isEmpty) {
      return AppString.enterNewPassValidation;
    } else if (value.trim().length < 8) {
      return AppString.newPassEightChar;
    } else if (!regex.hasMatch(value)) {
      return AppString.passValidationError;
    }

    return null;
  }

}
