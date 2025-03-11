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

static String? validatePhone(String? value) {
     if (value == null || value.trim().length == 11) {
      return "Phone Number must be 11 characters long.";
    }
    return null;
  }
  // Password must be 8+ characters with at least 1 uppercase, 1 lowercase, 1 number, and 1 special character
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

  // Generic validation for required fields
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName cannot be empty.";
    }
    return null;
  }
}
