import 'package:books_flutter/providers/local_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:books_flutter/screens/bookList_screen.dart';
import 'package:books_flutter/screens/library_screen.dart';
import 'package:books_flutter/models/book_model.dart';
import 'package:barcode_scan/barcode_scan.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).appTitle),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  _navigateToLibraryPage(context);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    _scanBarcode();
                    print(isbn);
                    if (isbn != 'Unknown') {
                      _navigateToBookListPage(null, null, isbn, context);
                    }
                  }),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Builder(
              builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).bookTitleField,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Title of Book!';
                            }
                          },
                          onSaved: (val) => setState(() => _book.title = val),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).bookAuthorField,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Author of Book!';
                            }
                          },
                          onSaved: (val) => setState(() => _book.author = val),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: RaisedButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                _book.save();
                                _navigateToBookListPage(
                                    _book.title, _book.author, isbn, context);
                              }
                            },
                            child: Text('Submit'),
                          ),
                        )
                      ],
                    ),
                  )),
        ));
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
