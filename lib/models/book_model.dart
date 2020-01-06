import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromDatabaseJson(x)));

class Book {
  String title;
  String author;
  String publisher;
  String id;
  String thumbnailUrl;
  String publishedDate;
  String description;
  int pageCount;
  double rating;

  Book({
    this.title,
    this.author,
    this.thumbnailUrl,
    this.id,
    this.publisher,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.rating,
  });

  factory Book.booksFromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'] == null
          ? 'Title not available!'
          : json['volumeInfo']['title'],
      author: json['volumeInfo']['authors'] == null
          ? 'Author not available!'
          : (json['volumeInfo']['authors'] as List).join(', '),
      thumbnailUrl: json['volumeInfo']['imageLinks']['smallThumbnail'] == null
          ? 'Thumbnail not available!'
          : json['volumeInfo']['imageLinks']['smallThumbnail'],
      publishedDate: json['volumeInfo']['publishedDate'] == null
          ? 'pubDate not available!'
          : json['volumeInfo']['publishedDate'],
      id: json['id'] == null ? 'Id not available!' : json['id'],
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'] == null
          ? 'Title not avaiable!'
          : json['volumeInfo']['title'],
      author: json['volumeInfo']['authors'] == null
          ? 'Author not available!'
          : (json['volumeInfo']['authors'] as List).join(', '),
      publisher: json['volumeInfo']['publisher'] == null
          ? 'publisher not available'
          : json['volumeInfo']['publisher'],
      publishedDate: json['volumeInfo']['publishedDate'] == null
          ? 'pubDate not available'
          : json['volumeInfo']['publishedDate'],
      description: json['volumeInfo']['description'] == null
          ? 'description not available'
          : json['volumeInfo']['description'],
      pageCount: json['volumeInfo']['pageCount'] == null
          ? 'pageCount not avaiable'
          : json['volumeInfo']['pageCount'],
      rating: json['volumeInfo']['averageRating'] == null
          ? 'rating not avaiable'
          : json['volumeInfo']['averageRating'],
      thumbnailUrl: json['volumeInfo']['imageLinks']['smallThumbnail'] == null
          ? 'thumbnail not available'
          : json['volumeInfo']['imageLinks']['smallThumbnail'],
    );
  }

  factory Book.fromDatabaseJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      publishedDate: json['publishedDate'],
      description: json['description'],
      pageCount: json['pageCount'],
      rating: json['rating'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'publisher': publisher,
        'publishedDate': publishedDate,
        'description': description,
        'pageCount': pageCount,
        'rating': rating,
        'thumbnailUrl': thumbnailUrl,
      };

  save() {
    print('title: ' + this.title);
    print('author: ' + this.author);
  }
}
