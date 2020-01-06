import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'providers/local_provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState state = context.findAncestorStateOfType<State<App>>();

    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _AppState extends State<App> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else
      return MaterialApp(
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (this.locale == null) {
            this.locale = deviceLocale;
          }
          return this.locale;
        },
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale("sk"), const Locale("en")],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        title: 'Books App',
        home: Home(),
      );
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('language_code') == null) {
      return null;
    }

    return Locale(
        prefs.getString('language_code'), prefs.getString('country_code'));
  }
}
