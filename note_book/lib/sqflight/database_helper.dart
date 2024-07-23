import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> dbhelper() async {
    Database database = await openDatabase(
        join(await getDatabasesPath(), "NoteBook.db"), onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE NoTeBook (id INTEGER PRIMARY KEY  AUTOINCREMENT, title TEXT,description TEXT)");
    }, version: 1);
    return database;
  }
}
