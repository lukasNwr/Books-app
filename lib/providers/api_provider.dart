import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:books_flutter/models/book_model.dart';

class APIProvider {
  static final APIProvider api = APIProvider._();
  final String apiKey = 'AIzaSyAm4IX8slQCnJFdmMOIpo9LVJe8mS59Uv8';

  APIProvider._();

  Future<List<Book>> fetchBooks(String title, String author, String isbn) async {

    String url = 'https://www.googleapis.com/books/v1/volumes?';
    if(isbn != 'Unknown') {
      url += 'q=isbn:$isbn';
    } else if (title == null && author == null) {
      print('Error fatching, no author and title provided');
    } else if (author == null) {
      url += 'q=$title';
    } else if (title == null) {
      url += 'inauthor:$author';
    } else {
      url += 'q=$title+inauthor:$author';
    }

    url += '&key=$apiKey';


    final response = await http.get(url);
    if (response.statusCode == 200) {
      return _parseBooksJson(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  List<Book> _parseBooksJson(String jsonStr) {
    final jsonMap = json.decode(jsonStr);
    final jsonList = (jsonMap['items'] as List);
    return jsonList.map((data) => new Book.booksFromJson(data)).toList();
  }

  Future<Book> fetchBook(String id) async {
    String url =
        'https://www.googleapis.com/books/v1/volumes/$id?key=$apiKey';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}

