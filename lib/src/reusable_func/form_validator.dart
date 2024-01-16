class FormValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Password must contains non-numerical character(s).';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  static String? validateRePassword(String? password, String? retypePassword) {
    if (retypePassword == null || retypePassword.isEmpty) {
      return 'Please re-enter your password.';
    } else if (retypePassword != password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name.';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter something.';
    } else if (value.length > 100) {
      return 'Please enter the title no more than 100 characters.';
    }
    return null;
  }

  static String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter something.';
    }
    return null;
  }
}
