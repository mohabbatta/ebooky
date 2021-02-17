

import 'dart:async';

import 'package:ebooky2/main.dart';
import 'package:ebooky2/model/book_model.dart';
import 'package:ebooky2/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookBloc {
  final _bookRepository = Repository();

  final _bookController = StreamController<List<Book>>.broadcast();

  get books => _bookController.stream;

  BookBloc() {
    getBooks();
  }

  getBooks({String query}) async {
    _bookController.sink.add(await _bookRepository.getAllBook(query: query));
  }

  updateBook(Book book,int newNum) async {
    await _bookRepository.updateBook(book: book, newNum: newNum);
    getBooks();
  }

  setLogOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }
  dispose() {
    _bookController.close();
  }
}
