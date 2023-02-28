import 'package:books_flutter/providers/local_provider.dart';
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
                Text(AppLocalizations.of(context).addedBookAlertMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          book.title,
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: BorderSide(color: Colors.grey[700], width: 2.5)),
        icon: Icon(
          Icons.add_circle,
          color: Colors.grey[700],
        ),
        label: Text(
          'Add to library',
          style: TextStyle(color: Colors.grey[800]),
        ),
        onPressed: () async {
          await DBProvider.db.createBook(book);
          _showBookAddedAlert();
        },
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
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20.0,
                                    spreadRadius: 2.0)
                              ]),
                              child: ClipRRect(
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "images/no-image-placeholder.png",
                                  fit: BoxFit.contain,
                                  image: book.thumbnailUrl,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      'images/no-image-placeholder.png',
                                      height: 150,
                                      width: 150,
                                    );
                                  },
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _book.author,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 20.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _book.publisher,
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                AppLocalizations.of(context).publishedText +
                                    ': ' +
                                    _book.publishedDate.replaceAll('-', '.'),
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 15.0),
                              ),
                            ),
                            Html(
                              padding: const EdgeInsets.only(top: 10),
                              data: _book.description,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
