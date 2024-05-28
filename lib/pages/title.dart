import 'package:flutter/material.dart';
import '../localizations.dart';
import 'main.dart';

void main() {
  runApp(CurrencyApp());
}

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Оновити мову додатка
                  AppLocalizations.of(context)?.setLocale(Locale(value, ''));
                  // Завантажити переклади
                  await AppLocalizations.of(context)?.load();
                  // Оновити інтерфейс з новою мовою
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => TitlePage()));
                }
              });
            },
            color: Colors.black,
          ),
        ],
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/money.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)?.translate('get_started') ?? 'Get Started!',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}