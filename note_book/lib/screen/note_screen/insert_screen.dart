import 'package:flutter/material.dart';
import 'package:note_book/screen/note_screen/home_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../sqflight/database_helper.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final titlecontroller = TextEditingController();
  final decsriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade500,
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Title",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: titlecontroller,
                decoration: InputDecoration(border: null),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Decsription",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: decsriptioncontroller,
                maxLines: 5,
                decoration: InputDecoration(
                  border: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 100, left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(300, 50),
                            backgroundColor: Colors.deepPurple.shade500,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          insertData(
                                  title: titlecontroller.text.toString(),
                                  description:
                                      decsriptioncontroller.text.toString())
                              .then(
                            (value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ));
                            },
                          );
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> insertData(
    {required String title, required String description}) async {
  Database db = await DatabaseHelper.dbHelper();

  db.rawInsert(
      "Insert into notes(title,description) values('$title','$description')");

  print("data successfully inserted...");
}

