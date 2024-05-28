class Uk {
  static const Map<String, String> _localizedValues = {
    'title': 'Racist Currency',
    'get_started': 'Розпочати!',
    'language_1': 'Українська',
    'language_2': 'Англійська',
    'input_value_to_convert': 'Введіть значення для конвертації',
    'result': 'Результат',
    'greet': 'Ласкаво просимо до додатку Racist Currency!'
  };

  static Map<String, String> get localizedValues => _localizedValues;

  String? translate(String key) {
    return _localizedValues[key];
  }
}
