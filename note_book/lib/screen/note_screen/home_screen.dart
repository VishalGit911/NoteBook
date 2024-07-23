import 'package:flutter/material.dart';
import 'package:note_book/screen/note_screen/insert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Note Book"),
        backgroundColor: Colors.deepPurple.shade500,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.deepPurple.shade100,
              child: ListTile(
                title: Text(
                  "Flutter Lecture",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                subtitle: Text(
                  "Data Base",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                trailing: Icon(Icons.delete),
              ),
            ),
          );
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
              ));
        },
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
