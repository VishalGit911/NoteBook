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
  @override
  void initState() {
    DateTime now = DateTime.now();
    String currentDate = '${now.day}/${now.month}/${now.year}';
    datecontoller.text = currentDate;
    super.initState();
  }

  final titlecontroller = TextEditingController();
  final decsriptioncontroller = TextEditingController();
  final datecontoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade500,
        title: Text("Add Notes"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: titlecontroller,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 22,
                      ),
                      hintText: "Title",
                      border: null),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: decsriptioncontroller,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Notes",
                      hintStyle: TextStyle(
                        fontSize: 22,
                      ),
                      border: null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onTap: () async {
                    DateTime? datepick = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2050),
                      initialDate: DateTime.now(),
                    );

                    if (datepick != null) {
                      String dateformate =
                          '''${datepick.day}/${datepick.month}/${datepick.year}''';

                      setState(() {
                        datecontoller.text = dateformate.toString();
                      });
                    }
                  },
                  readOnly: true,
                  controller: datecontoller,
                  decoration: InputDecoration(
                      hintText: "Date",
                      suffixIcon: Icon(Icons.date_range),
                      border: null),
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
                            description: decsriptioncontroller.text.toString(),
                            date: datecontoller.text.toString(),
                          ).then(
                            (value) {
                              Navigator.pop(context);
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

Future<void> insertData({
  required String title,
  required String description,
  required String date,
}) async {
  Database db = await DatabaseHelper.dbHelper();

  await db.rawInsert(
    "INSERT INTO notes (title, description, date) VALUES (?, ?, ?)",
    [title, description, date],
  );

  print("Data successfully inserted...");
}
