class Validator {
  static bool validateEmail(String value) {
    const String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    if (value.trim().isEmpty) return false;

    if (_hasMatch(pattern: emailPattern, value: value)) return true;

    return false;
  }

  static bool _hasMatch({
    required String pattern,
    required String value,
  }) =>
      RegExp(pattern).hasMatch(value);
}
