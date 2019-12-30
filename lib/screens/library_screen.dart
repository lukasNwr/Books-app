import 'package:books_flutter/providers/local_provider.dart';
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).libraryPageTitle),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete All',
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
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
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data[index].thumbnailUrl),
                ),
                title: Text(snapshot.data[index].title),
                subtitle: Text(snapshot.data[index].author),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                    onPressed: () {
                      DBProvider.db.delete(snapshot.data[index].title);
                      setState(() {

                      });
                    }
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          );
        }
      },
    );
  }
}
