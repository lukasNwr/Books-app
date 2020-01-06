import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:books_flutter/models/book_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Book table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'book_library.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Book('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'author TEXT,'
          'publisher TEXT,'
          'publishedDate TEXT,'
          'description TEXT,'
          'pageCount INTEGER,'
          'rating REAL,'
          'thumbnailUrl TEXT'
          ')');
    });
  }

  // Insert book on database
  createBook(Book newBook) async {
    //await deleteAllBooks();
    final db = await database;
    final res = await db.insert('Book', newBook.toJson());

    return res;
  }

  // Delete all Books
  Future<int> deleteAllBooks() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Book');

    return res;
  }

  //Delete one Book
  Future<int> delete(String title) async {
    return await _database
        .delete('Book', where: 'title = ?', whereArgs: [title]);
  }

  //Get all books from database
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Book");

    List<Book> list =
        res.isNotEmpty ? res.map((c) => Book.fromDatabaseJson(c)).toList() : [];

    return list;
  }
}
