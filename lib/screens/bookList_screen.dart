import 'package:books_flutter/providers/local_provider.dart';
import 'package:flutter/material.dart';

import 'bookDetails_screen.dart';
import 'package:books_flutter/models/book_model.dart';
import 'package:books_flutter/providers/api_provider.dart';

class BookListPage extends StatelessWidget {
  final String title;
  final String author;
  final String isbn;

  BookListPage(
    this.title,
    this.author,
    this.isbn,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: APIProvider.api.fetchBooks(title, author, isbn),
            builder: (context, AsyncSnapshot<List<Book>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.black,
                              iconSize: 30.0,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Text(
                              AppLocalizations.of(context).bookListPageTitle,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView(
                            children: snapshot.data
                                .map((book) => BookTile(book))
                                .toList()),
                      ),
                    ],
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;

  BookTile(this.book);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          _navigateToDetailsPage(book, context);
        },
        child: Container(
          child: FittedBox(
            child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(8.0),
              shadowColor: Colors.black26,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0)),
                      child: Image(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                          book.thumbnailUrl,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: 40.0,
                      width: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: <Widget>[
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: book.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 5.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: book.author,
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 4.5)),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          RichText(
                            text: TextSpan(
                                text:
                                    AppLocalizations.of(context).publishedText +
                                        ': ' +
                                        book.publishedDate.replaceAll('-', '.'),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 4.5)),
                          )
                        ]),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _navigateToDetailsPage(Book book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}
