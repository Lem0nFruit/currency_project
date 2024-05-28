import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'lang/eng/eng_local.dart';
import 'lang/uk/uk_local.dart';

class AppLocalizations {
  Locale? _locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(Locale locale) {
    _locale = locale;
    _localizedStrings = {};
  }

  Locale? get locale => _locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<void> load() async {
    switch (_locale?.languageCode) {
      case 'uk':
        _localizedStrings = Uk.localizedValues;
        break;
      case 'en':
      default:
        _localizedStrings = Eng.localizedValues;
        break;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  void setLocale(Locale locale) {
    _locale = locale;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'uk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}