import 'package:books_flutter/app.dart';
import 'package:books_flutter/providers/local_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:books_flutter/screens/bookList_screen.dart';
import 'package:books_flutter/screens/library_screen.dart';
import 'package:books_flutter/models/book_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _book = Book();
  final _formKey = GlobalKey<FormState>();
  String isbn = 'Unknown';

  Future _scanBarcode() async {
    String _scanResult;

    try {
      _scanResult = await BarcodeScanner.scan();
      setState(() {
        isbn = _scanResult;
        print(isbn);
      });
      print(_scanResult);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera perimission denied!');
      } else {
        print('Unknown error: $ex');
      }
    } on FormatException {
      print('Button back was pressed without scanning code');
    } catch (ex) {
      print('Unknown error: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle selectedStyle = TextStyle(color: Theme.of(context).accentColor);

    return Scaffold(
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Slovenčina',
                style: _getLanguageCode(context) == 'sk' ? selectedStyle : null,
              ),
              onTap: () async {
                print(_getLanguageCode(context));
                if (_getLanguageCode(context) != 'sk') {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.setString('languageCode', 'sk');
                  await prefs.setString('countryCode', '');

                  App.setLocale(context, Locale('sk', ''));
                }
              },
            ),
            ListTile(
              title: Text(
                'English',
                style: _getLanguageCode(context) == 'en' ? selectedStyle : null,
              ),
              onTap: () async {
                print(_getLanguageCode(context));
                if (_getLanguageCode(context) != 'en') {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.setString('languageCode', 'en');
                  await prefs.setString('countryCode', '');

                  App.setLocale(context, Locale('en', ''));
                }
              },
            )
          ],
        )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      child: Image(
                        image: AssetImage('images/library_01.jpg'),
                        color: Colors.brown[300],
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12),
                      child: Container(
                        height: 130.0,
                        width: 130.0,
                        child: Image(
                          image: AssetImage('images/books_logo.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.315,
                        left: MediaQuery.of(context).size.width * 0.040,
                        right: MediaQuery.of(context).size.width * 0.040),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          iconSize: 30,
                          color: Colors.white,
                          onPressed: () {
                            _scanBarcode();
                            print(isbn);
                            if (isbn != 'Unknown') {
                              _navigateToBookListPage(
                                  null, null, isbn, context);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.library_books),
                          iconSize: 30,
                          color: Colors.white,
                          onPressed: () {
                            _navigateToLibraryPage(context);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Builder(
                      builder: (context) => Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .bookTitleField,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter the Title of Book!';
                                    }
                                  },
                                  onSaved: (val) =>
                                      setState(() => _book.title = val),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .bookAuthorField,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter the Author of Book!';
                                    }
                                  },
                                  onSaved: (val) =>
                                      setState(() => _book.author = val),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(15.0),
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onPressed: () {
                                      final form = _formKey.currentState;
                                      if (form.validate()) {
                                        form.save();
                                        _book.save();
                                        _navigateToBookListPage(_book.title,
                                            _book.author, isbn, context);
                                      }
                                    },
                                    child: Text(
                                      'Search',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                ),
              ),
            ],
          ),
        ));
  }

  _getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }
}

void _navigateToBookListPage(
    String title, String author, String isbn, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookListPage(title, author, isbn),
  ));
}

void _navigateToLibraryPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Library()));
}
