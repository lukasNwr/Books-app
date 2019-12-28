import 'package:flutter/material.dart';

import 'bookDetails_screen.dart';
import 'package:books_flutter/models/book_model.dart';
import 'package:books_flutter/providers/api_provider.dart';

class BookFinderPage extends StatelessWidget {
  final String title;
  final String author;
  List<Book> booksList = [];

  BookFinderPage(
    this.title,
    this.author,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
          future: APIProvider.api.fetchBooks(title, author),
          builder: (context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView(
                    children:
                        snapshot.data.map((book) => BookTile(book, booksList)).toList());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  final List<Book> booksList;

  BookTile(this.book, this.booksList);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(book.thumbnailUrl),
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () => _navigateToDetailsPage(book, booksList, context),
    );
  }
}



void _navigateToDetailsPage(Book book, List<Book> bookList, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book, bookList),
  ));
}