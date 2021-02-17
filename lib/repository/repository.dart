
import 'package:ebooky2/dao/book_dao.dart';
import 'package:ebooky2/model/book_model.dart';

class Repository {
  final bookDao = BookDao();

  Future getAllBook({String query}) => bookDao.getBooks(query: query);
  Future updateBook({Book book,int newNum}) => bookDao.updateBook(book,newNum);
  Future getUser({String userName,String password}) => bookDao.getUser(userName:  userName,password: password);
  Future addUser({String userName,String password }) => bookDao.addUser(userName: userName,password: password);

}
