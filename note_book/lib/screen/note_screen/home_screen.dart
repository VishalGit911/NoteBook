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
  }

  List<Map<String, dynamic>> newlist = [];

  Future<Database> getdata() async {
    Database db = await DatabaseHelper.dbHelper();
    newlist = await db.rawQuery("SELECT * FROM notes");

    return db;
  }

  Future<void> deletedata(String title) async {
    Database db = await DatabaseHelper.dbHelper();
    db.delete("notes", where: "title= ?", whereArgs: [title]);

    newlist = await db.rawQuery("SELECT * FROM notes");
    setState(() {});
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Search note",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
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
                                      newlist[index]["title"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      newlist[index]["description"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(newlist[index]["date"].toString()),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateScreen(
                                                    title: newlist[index]
                                                        ["title"],
                                                    decsriprion: newlist[index]
                                                        ["description"],
                                                    id: newlist[index]["id"],
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
                                            deletedata(newlist[index]["title"]);
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
