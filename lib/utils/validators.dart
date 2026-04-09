class Validators {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (name.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    return null;
  }

  // Phone validation
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Address is required';
    }

    if (address.length < 10) {
      return 'Please enter a complete address';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      return 'Price is required';
    }

    final priceValue = double.tryParse(price);
    if (priceValue == null || priceValue <= 0) {
      return 'Enter a valid price greater than 0';
    }

    return null;
  }

  // Application ID validation
  static String? validateApplicationId(String? appId) {
    if (appId == null || appId.isEmpty) {
      return 'Application ID is required';
    }

    if (!appId.startsWith('APP-')) {
      return 'Invalid application ID format';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Numeric validation
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
        r'^(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$');
    if (!urlRegex.hasMatch(url)) {
      return 'Enter a valid URL';
    }

    return null;
  }
}
