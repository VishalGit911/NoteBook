import 'package:flutter/material.dart';
import 'package:note_book/screen/note_screen/insert_screen.dart';
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
            return ListView.builder(
              itemCount: newlist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shadowColor: Colors.deepPurple,
                    elevation: 8,
                    color: Colors.white,
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundColor: Colors.deepPurple.shade500,
                      //   foregroundColor: Colors.white,
                      //   child: Text(newlist[index]["id"].toString()),
                      // ),
                      title: Text(
                        newlist[index]["title"],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      subtitle: Text(
                        newlist[index]["description"],
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            deletedata(newlist[index]["title"]);
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  ),
                );
              },
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => InsertScreen(),
            ),
            (route) => false,
          );
        },
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
