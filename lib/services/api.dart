import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final Uri currencyURL = Uri.https(
    'bank.gov.ua',
    '/NBUStatService/v1/statdirectory/exchange',
    {'json': ''},
  );

  Future<List<Map<String, String>>> ApiResponse() async {
    http.Response res = await http.get(currencyURL);

    if (res.statusCode == 200) {
      var _response = jsonDecode(res.body);
      List<Map<String, String>> currencies = [];
      for (var currency in _response) {
        currencies.add({
          'ccy': currency['cc'],
          'rate': currency['rate'].toString(),
        });
      }
      currencies.add({'ccy': 'UAH', 'rate': '1'});
      return currencies;
    } else {
      throw Exception(res.statusCode.toString());
    }
  }

  Future<double> getRate(String from, String to, List<Map<String, String>> currencies) async {
    if (from == to) {
      return 1.0;
    }

    double? fromRate;
    double? toRate;

    for (var currency in currencies) {
      if (currency['ccy'] == to) {
        toRate = double.parse(currency['rate']!);
      }
      if (currency['ccy'] == from) {
        fromRate = double.parse(currency['rate']!);
      }
    }

    if (fromRate != null && toRate != null) {
      return toRate / fromRate;
    } else {
      throw Exception('Currency data not found');
    }
  }
}