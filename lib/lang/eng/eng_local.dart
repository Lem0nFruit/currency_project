class Eng {
  static const Map<String, String> _localizedValues = {
    'title': 'Racist Currency',
    'get_started': 'Get Started!',
    'language_1': 'Ukrainian',
    'language_2': 'English',
    'input_value_to_convert': 'Input value to convert',
    'result': 'Result',
    'greet': 'Welcome to the Racist Currency App!'
  };

  static Map<String, String> get localizedValues => _localizedValues;

  String? translate(String key) {
    return _localizedValues[key];
  }
}
