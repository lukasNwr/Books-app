import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'providers/local_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale("sk")],
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      title: 'Books App',
      home: Home(),
    );
  }
}
