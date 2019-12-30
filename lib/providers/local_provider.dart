import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:books_flutter/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle {
    return Intl.message('Books App',
        name: 'appTitle', desc: 'The application title');
  }

  String get bookTitleField {
    return Intl.message('Title',
        name: 'bookTitleField', desc: 'Book title in textField');
  }

  String get bookAuthorField {
    return Intl.message('Author',
        name: 'bookAuthorField', desc: 'Book Author in textField');
  }

  String get bookListPageTitle {
    return Intl.message('Available Books',
        name: 'bookListPageTitle', desc: 'Book list page title');
  }

  String get addButtonTooltip {
    return Intl.message('Add book to your library',
        name: 'addButtonTooltip',
        desc: 'Tooltip on ADD button on book details page');
  }

  String get publishedText {
    return Intl.message('Published',
        name: 'publishedText', desc: 'Book details page published text.');
  }

  String get addedBookAlertMessage {
    return Intl.message('Book has been added to your library!',
        name: 'addedBookAlertMessage', desc: 'Added book alert dialog text');
  }

  String get libraryPageTitle {
    return Intl.message('Library', name: 'libraryPageTitle', desc: 'Library page title text');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
