import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';



class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);


  static const supportedLocales = [Locale('pt'), Locale('en')];


  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocDelegate();


  static List<LocalizationsDelegate> get localizationsDelegates => [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];


  static AppLocalizations? of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations);


  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'NetMaster',
      'login_title': 'Welcome to NetMaster',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'modules': 'Modules',
      'lesson_continue': 'Continue',
      'correct': 'Correct 🎉',
      'incorrect': 'Incorrect',
    },
    'pt': {
      'app_title': 'NetMaster',
      'login_title': 'Bem-vindo ao NetMaster',
      'email': 'Email',
      'password': 'Senha',
      'login': 'Entrar',
      'modules': 'Módulos',
      'lesson_continue': 'Continuar',
      'correct': 'Correto 🎉',
      'incorrect': 'Incorreto',
    }
  };


  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}


class _AppLocDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocDelegate();


  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);


  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);


  @override
  bool shouldReload(_AppLocDelegate old) => false;
}