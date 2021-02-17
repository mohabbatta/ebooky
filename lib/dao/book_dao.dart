import 'dart:async';

import 'package:ebooky2/database/database.dart';
import 'package:ebooky2/model/book_model.dart';
import 'package:ebooky2/model/user_model.dart';

class BookDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Book>> getBooks({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(todoTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(todoTABLE, columns: columns);
    }

    List<Book> books = result.isNotEmpty
        ? result.map((item) => Book.fromJson(item)).toList()
        : [];
    return books;
  }

  updateBook(Book book,int newNum) async {
     final db = await dbProvider.database;
    var res = await db.rawUpdate('''
    UPDATE Book 
    SET num = ? 
    WHERE id = ?
    ''',
        [ newNum, book.id]);
    print(await db.query('Book'));

    return res;
  }
  addUser({String userName,String password })async{
    final db = await dbProvider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into User (id,username,password)"
            " VALUES (?,?,?)",
        [id, userName,password]);
    print(await db.query('User'));

    return raw;
  }

  getUser({String userName, String password}) async {
    final db = await dbProvider.database;
    var res = await db.query("User", where: "username = ? AND password = ? ", whereArgs: [userName,password]);
    return res.isNotEmpty ? User.fromJson(res.first) : null;
  }

}
