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
      title: json['volumeInfo']['title'],
      author: (json['volumeInfo']['authors'] as List).join(', '),
      thumbnailUrl: json['volumeInfo']['imageLinks']['smallThumbnail'],
      id: json['id'],
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      author: (json['volumeInfo']['authors'] as List).join(', '),
      publisher: json['volumeInfo']['publisher'],
      publishedDate: json['volumeInfo']['publishedDate'],
      description: json['volumeInfo']['description'],
      pageCount: json['volumeInfo']['pageCount'],
      rating: json['volumeInfo']['averageRating'],
      thumbnailUrl: json['volumeInfo']['imageLinks']['smallThumbnail'],
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
