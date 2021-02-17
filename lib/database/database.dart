import 'dart:async';
import 'dart:io';
import 'package:ebooky2/model/book_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final todoTABLE = 'Book';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  List<Book> testBooks = [
    Book(
        id: 1,
        name: 'harry potter and the philosopher\'s stone',
        pic: 'images/b10.jpg',
        num: 2),
    Book(
        id: 2,
        name: 'harry potter and chamber of secrets',
        pic: 'images/b20.jpg',
        num: 1),
    Book(
        id: 3,
        name: 'harry potter and prisoner of azkaban',
        pic: 'images/b30.jpg',
        num: 30),
    Book(
        id: 4,
        name: 'harry potter and goblet of fire',
        pic: 'images/b40.jpg',
        num: 10),
    Book(
        id: 5,
        name: 'harry potter and half blood prince',
        pic: 'images/b50.jpg',
        num: 20)
  ];
  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "ReactiveTodo.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE Book ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "pic TEXT,"
        "num INTEGER"
        ")");
    await database.execute("CREATE TABLE User ("
        "id INTEGER PRIMARY KEY,"
        "username TEXT,"
        "password TEXT"
        ")");
    testBooks.forEach((element) async {
      await database.execute(
          "INSERT Into Book (id,name,pic,num)"
          " VALUES (?,?,?,?)",
          [element.id, element.name, element.pic, element.num]);
    });
  }
}
