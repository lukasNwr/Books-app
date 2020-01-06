import 'package:books_flutter/models/book_model.dart';
import 'package:books_flutter/providers/local_provider.dart';
import 'package:books_flutter/screens/libraryBookDetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:books_flutter/providers/db_provider.dart';
import 'package:flutter/widgets.dart';

class Library extends StatefulWidget {
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBooksListView(),
    );
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllBooks();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All books deleted');
  }

  _buildBooksListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllBooks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30.0,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        AppLocalizations.of(context).libraryPageTitle,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        tooltip: 'Delete All',
                        onPressed: () async {
                          await _deleteData();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(snapshot.data[index].publisher);
                      return Dismissible(
                        key: UniqueKey(),
                        child: LibraryBookTile(snapshot.data[index]),
                        onDismissed: (direction) {
                          var item = snapshot.data.elementAt(index);
                          //To delete
                          setState(() {
                            DBProvider.db.delete(snapshot.data[index].title);
                          });
                          //To show a snackbar with the UNDO button
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Item deleted"),
                              action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    //To undo deletion
                                    setState(() {
                                      DBProvider.db.createBook(item);
                                    });
                                  })));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class LibraryBookTile extends StatelessWidget {
  final Book book;

  LibraryBookTile(this.book);

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
    builder: (context) => LibraryBookDetails(book),
  ));
}
