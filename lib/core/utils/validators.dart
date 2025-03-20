class Validators {
  // Name must be at least 8 characters
  static String? validateName(String? value) {
    if (value == null || value.trim().length < 8) {
      return "Name must be at least 8 characters long.";
    }
    return null;
  }

  // Email must be a valid format
  static String? validateEmail(String? value) {
    if (value == null || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return "Enter a valid email address.";
    }
    return null;
  }

  // Phone number must be 11 digits long
  static String? validatePhone(String? value) {
    if (value == null || value.trim().length != 11 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Phone number must be 11 digits long.";
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    }
    if (value.length < 8) {
      errors.add("at least 8 characters");
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add("one uppercase letter");
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add("one lowercase letter");
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      errors.add("one number");
    }

    if (errors.isEmpty) return null;

    // Format the message correctly
    String errorMessage = "Password must contain " +
        errors.sublist(0, errors.length - 1).join(", ") +
        (errors.length > 1 ? ", and " : "") +
        errors.last +
        ".";

    return errorMessage;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm password cannot be empty.";
    }
    if (value != password) {
      return "Passwords do not match.";
    }
    return null;
  }

  // Generic validation for required fields
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName cannot be empty.";
    }
    return null;
  }
}