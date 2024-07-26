import 'package:flutter/material.dart';
import 'package:note_book/sqflight/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UpdateScreen extends StatefulWidget {
  final String title;
  final String decsriprion;
  final int id;

  UpdateScreen(
      {super.key,
      required this.title,
      required this.decsriprion,
      required this.id});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  void initState() {
    titlecontroller.text = widget.title;
    decsriptioncontroller.text = widget.decsriprion;
    upadateid = widget.id;

    DateTime now = DateTime.now();
    String currentDate = '${now.day}/${now.month}/${now.year}';
    datecontoller.text = currentDate;

    super.initState();
  }

  late int upadateid;

  final titlecontroller = TextEditingController();
  final decsriptioncontroller = TextEditingController();
  final datecontoller = TextEditingController();

  Future<void> updatedate(
      {required int id,
      required String title,
      required String decsriprion}) async {
    Database db = await DatabaseHelper.dbHelper();

    await db.rawUpdate(
      "UPDATE notes SET title = '$title', description = '$decsriprion' WHERE id = '$upadateid'",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 25,
                      ),
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: decsriptioncontroller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Notes",
                    hintStyle: TextStyle(
                      fontSize: 25,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                          updatedate(
                                  id: upadateid,
                                  title: titlecontroller.text.toString(),
                                  decsriprion:
                                      decsriptioncontroller.text.toString())
                              .then(
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