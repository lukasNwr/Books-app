import 'package:books_flutter/screens/bookList_screen.dart';
import 'package:books_flutter/screens/library_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _book = Book();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Books App'),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  _navigateToLibraryPage(context);
                },
              ),
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
                            labelText: 'Title',
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
                            labelText: 'Author',
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
                                _navigateToBookFinderPage(_book.title, _book.author, context);
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

void _navigateToBookFinderPage(String title, String author, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookFinderPage(title, author),
  ));
}

void _navigateToLibraryPage(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Library()
  ));
}

