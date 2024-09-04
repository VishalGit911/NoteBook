import 'package:flutter/material.dart';
import 'package:note_book/screen/note_screen/insert_screen.dart';
import 'package:note_book/screen/note_screen/update_screen.dart';
import 'package:note_book/screen/note_screen/view_screen.dart';
import 'package:note_book/sqflight/database_helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFAB = true;
  double _lastOffset = 0.0;

  List<Map<String, dynamic>> newlist = [];
  List<Map<String, dynamic>> filteredList = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    getdata();

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        double currentOffset = _scrollController.offset;
        if (currentOffset > _lastOffset) {
          // Scrolling down
          if (_showFAB) {
            setState(() {
              _showFAB = false;
            });
          }
        } else {
          // Scrolling up
          if (!_showFAB) {
            setState(() {
              _showFAB = true;
            });
          }
        }
        _lastOffset = currentOffset;
      }
    });
  }

  Future<void> getdata() async {
    Database db = await DatabaseHelper.dbHelper();
    newlist = await db.rawQuery("SELECT * FROM notes");
    filteredList = newlist;
    setState(() {}); // Ensure UI updates once data is fetched
  }

  Future<void> deletedata(String title) async {
    Database db = await DatabaseHelper.dbHelper();
    await db.delete("notes", where: "title= ?", whereArgs: [title]);

    newlist = await db.rawQuery("SELECT * FROM notes");
    updateSearchQuery(searchQuery); // Update the filtered list
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredList = newlist.where((note) {
        final titleLower = note["title"].toLowerCase();
        final descriptionLower = note["description"].toLowerCase();
        final datelover = note["date"].toLowerCase();
        final queryLower = query.toLowerCase();

        return titleLower.contains(queryLower) ||
            datelover.contains(queryLower) ||
            descriptionLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Note Book",
            style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image(
                image: AssetImage("assets/images/appbar.png"),
                height: 26,
                width: 26,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: newlist.isEmpty
            ? Center(
                child: Text(
                "Not found",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (query) => updateSearchQuery(query),
                      decoration: InputDecoration(
                        hintText: "Search note",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      controller: _scrollController,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      child: Text("${index + 1}"),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: NoteDetailScreen(
                                                    title: filteredList[index]
                                                        ["title"],
                                                    description:
                                                        filteredList[index]
                                                            ["description"],
                                                  ),
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade))
                                          .then(
                                        (value) {
                                          getdata();
                                        },
                                      );
                                    },
                                    title: Text(
                                      filteredList[index]["title"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      filteredList[index]["description"],
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey),
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
                                                  PageTransition(
                                                      child: UpdateScreen(
                                                        title:
                                                            filteredList[index]
                                                                ["title"],
                                                        decsriprion:
                                                            filteredList[index]
                                                                ["description"],
                                                        id: filteredList[index]
                                                            ["id"],
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeftWithFade))
                                              .then(
                                            (value) {
                                              getdata();
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Text("Delete Notes"),
                                                content: Text(
                                                  "Are you sure?",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deletedata(filteredList[
                                                              index]["title"])
                                                          .then((value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.blue
                                                                    .shade700,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            content: Text(
                                                              "Notes deleted successfully",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text("Ok"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
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
        floatingActionButton: _showFAB
            ? FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                          context,
                          PageTransition(
                              child: InsertScreen(),
                              type: PageTransitionType.rightToLeftWithFade))
                      .then(
                    (value) {
                      getdata();
                    },
                  );
                },
                label: Text("Add"),
                icon: Icon(Icons.add),
              )
            : null);
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
