import 'package:books_flutter/providers/local_provider.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class LibraryBookDetails extends StatefulWidget {
  final Book book;

  LibraryBookDetails(this.book);

  @override
  _BookDetailPageState createState() => _BookDetailPageState(book);
}

class _BookDetailPageState extends State<LibraryBookDetails> {
  final Book book;
  List<Book> booksList;

  _BookDetailPageState(this.book);

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
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book _book;

  BookDetails(this._book);

  @override
  Widget build(BuildContext context) {
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
                      child: Image.network(_book.thumbnailUrl),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _book.author,
                      style: TextStyle(color: Colors.grey[600], fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      '_book.publisher',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      AppLocalizations.of(context).publishedText +
                          ': ' +
                          _book.publishedDate.replaceAll('-', '.'),
                      style: TextStyle(color: Colors.grey[500], fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      '_book.description',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
