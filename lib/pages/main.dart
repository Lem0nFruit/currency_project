import 'package:flutter/material.dart';
import 'package:racist_currency/services/api.dart';
import 'package:racist_currency/widgets/drop_down.dart';
import '../localizations.dart';
import 'title.dart';

class CurrencyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('uk', ''),
      ],
      home: TitlePage(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiClient client = ApiClient();

  Color mainColor = Colors.white;
  Color secondColor = Colors.blue;

  List<Map<String, String>> currencies = [];
  String from = '';
  String to = '';

  double rate = 0.0;
  String result = '';
  double inputValue = 0.0;

  Future<void> getCurrencyList() async {
    try {
      List<Map<String, String>> list = await client.ApiResponse();
      setState(() {
        currencies = list;
        // Встановлюємо значення за замовчуванням для "from" та "to"
        if (currencies.isNotEmpty) {
          from = currencies.first['ccy']!;
          to = currencies.length > 1 ? currencies[1]['ccy']! : currencies.first['ccy']!;
        }
      });
      await calculateResult();
    } catch (e) {
      // Обробка помилок при завантаженні списку валют
      print("Error fetching currency list: $e");
    }
  }

  Future<void> calculateResult() async {
    if (from.isNotEmpty && to.isNotEmpty && inputValue > 0) {
      try {
        rate = await client.getRate(from, to, currencies);
        setState(() {
          result = (rate * inputValue).toStringAsFixed(2);
        });
      } catch (e) {
        // Обробка помилок при розрахунку результату
        print("Error calculating result: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrencyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)?.translate('title') ?? 'Racist Currency',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
              ],
            ),
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () async {
              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(10, AppBar().preferredSize.height, 0, 0),
                items: [
                  PopupMenuItem<String>(
                    value: 'uk',
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/ukraine.png',
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)?.translate('language_1')
                            ?? 'Ukrainian', style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/uk.png',
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)?.translate('language_2')
                            ?? 'English', style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ],
                elevation: 8.0,
              ).then((value) async {
                if (value != null) {
                  AppLocalizations.of(context)?.setLocale(Locale(value, ''));
                  await AppLocalizations.of(context)?.load();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                }
              });
            },
            color: Colors.black,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/money.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              inputValue = double.tryParse(value) ?? 0;
                              calculateResult();
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            labelText: AppLocalizations.of(context)
                                ?.translate('input_value_to_convert')
                                ?? 'Input value to convert',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: secondColor,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customDropDown(
                              currencies.map((currency) => currency['ccy']).where((val) => val != null
                                  && val != to).cast<String>().toList(),
                              from,
                                  (val) {
                                setState(() {
                                  from = val!;
                                  calculateResult();
                                });
                              },
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                String temp = from;
                                setState(() {
                                  from = to;
                                  to = temp;
                                  calculateResult();
                                });
                              },
                              elevation: 0.0,
                              backgroundColor: secondColor,
                              child: const Icon(Icons.swap_horiz),
                            ),
                            customDropDown(
                              currencies.map((currency) => currency['ccy']).where((val) => val != null
                                  && val != from).cast<String>().toList(),
                              to,
                                  (val) {
                                setState(() {
                                  to = val!;
                                  calculateResult();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)?.translate('result') ?? 'Result',
                                style: TextStyle(
                                  color: secondColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                result,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}