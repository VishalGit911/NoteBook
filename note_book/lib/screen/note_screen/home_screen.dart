import 'package:flutter/material.dart';
import 'package:note_book/screen/note_screen/insert_screen.dart';
import 'package:note_book/screen/note_screen/update_screen.dart';
import 'package:note_book/sqflight/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getdata();
    super.initState();
searchController.addListener(searchQuery());
  }

  List<Map<String, dynamic>> newlist = [];
  List<Map<String, dynamic>> filteredList = [];

  Future<Database> getdata() async {
    Database db = await DatabaseHelper.dbHelper();
    newlist = await db.rawQuery("SELECT * FROM notes");

    filteredList = newlist;
    return db;
  }

  Future<void> deletedata(String title) async {
    Database db = await DatabaseHelper.dbHelper();
    db.delete("notes", where: "title= ?", whereArgs: [title]);

    newlist = await db.rawQuery("SELECT * FROM notes");
    setState(() {});
  }
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  void serachquery(String query) {
    String query = searchController.text.toLowerCase();
    searchQuery = query;
    filteredList = newlist
        .where((note) =>
            note["title"].toLowerCase().contains(query.toLowerCase()) ||
            note["date"].toString().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Note Book"),
        backgroundColor: Colors.deepPurple.shade500,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) => serachquery(value),
                      decoration: InputDecoration(
                          hintText: "Search note",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                      itemCount: newlist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 3, left: 10, right: 10, bottom: 5),
                          child: Card(
                            shadowColor: Colors.black,
                            elevation: 8,
                            color: Colors.grey.shade200,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.deepPurple.shade500,
                                      foregroundColor: Colors.white,
                                      child: Text("${index + 1}"),
                                    ),
                                    title: Text(
                                      filteredList[index]["title"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      filteredList[index]["description"],
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        filteredList[index]["date"].toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateScreen(
                                                    title: filteredList[index]
                                                        ["title"],
                                                    decsriprion:
                                                        filteredList[index]
                                                            ["description"],
                                                    id: filteredList[index]
                                                        ["id"],
                                                  ),
                                                )).then(
                                              (value) {
                                                setState(() {});
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Delete Notes"),
                                                  content: Text(
                                                    "Are you sure?",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          deletedata(
                                                                  filteredList[
                                                                          index]
                                                                      ["title"])
                                                              .then(
                                                            (value) {
                                                              SnackBar snack =
                                                                  SnackBar(
                                                                      backgroundColor: Colors
                                                                          .deepPurple
                                                                          .shade500,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              5),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      content:
                                                                          Text(
                                                                        "Notes delete successfully",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ));
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snack);

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        },
                                                        child: Text("Ok"))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Container());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple.shade500,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertScreen(),
            ),
          ).then(
            (value) {
              setState(() {});
            },
          );
        },
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
