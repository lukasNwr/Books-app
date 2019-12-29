import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/book_model.dart';
import 'package:books_flutter/providers/db_provider.dart';
import 'package:books_flutter/providers/api_provider.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  BookDetailsPage(this.book);

  @override
  _BookDetailPageState createState() => _BookDetailPageState(book);
}

class _BookDetailPageState extends State<BookDetailsPage> {
  final Book book;
  List<Book> booksList;

  _BookDetailPageState(this.book);

  void _showBookAddedAlert() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Book ${book.title} has been added to your library!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            icon: const Icon(Icons.add),
            tooltip: 'Add book to your library',
            onPressed: () {
              booksList.add(book);
              DBProvider.db.createBook(book);
              _showBookAddedAlert();
              print('Book added');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIProvider.api.fetchBook(book.id),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Book _book = snapshot.data;
              return SingleChildScrollView(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(_book.thumbnailUrl),
                    SizedBox(height: 10.0),
                    Text(
                      _book.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _book.author,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _book.publisher,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Published: ' +
                            _book.publishedDate.replaceAll('-', '.'),
                      ),
                    ),
                    Html(
                        padding: const EdgeInsets.only(top: 10),
                        data: _book.description)
                  ],
                ),
              ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
