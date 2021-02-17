import 'package:ebooky2/bloc/book_bloc.dart';
import 'package:ebooky2/common_widgets/category_custom_shape.dart';
import 'package:ebooky2/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class HomePage extends StatelessWidget {
  final BookBloc bookBloc = BookBloc();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F6F8),
        leading: IconButton(
            onPressed: (){bookBloc.setLogOut(context);},
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          'eBooky',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Container(child: getBooksWidget()),
    );
  }


  _showMaterialDialog(BuildContext context,Book book) {
    showDialog(
      context: context,
      builder: (context) {
        int copies = 0;
        bool error = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Numbers of Copies "),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.add), onPressed: (){
                        setState(() {
                          copies ++;
                        });
                      }),
                      Text('$copies'),
                      IconButton(icon: Icon(Icons.minimize), onPressed: (){
                        setState(() {
                          copies --;
                        });
                      }),
                    ],),
                  error ? Text('there is no enough') : Text(' '),
                ],),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: () async {
                    if(copies<= book.num){
                      var left = book.num - copies;
                        bookBloc.updateBook(book, left);
                      Navigator.pop(context);
                    }else{
                      setState(() {
                        error = true;
                      });
                    }
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget getBooksWidget() {
    return StreamBuilder(
      stream: bookBloc.books,
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        return getBookWidget(snapshot, context);
      },
    );
  }

  Widget getBookWidget(
      AsyncSnapshot<List<Book>> snapshot, BuildContext context) {
    if (snapshot.hasData) {
      int columnCount = 2;
      return snapshot.data.length != 0
          ? AnimationLimiter(
              child: GridView.count(
                crossAxisCount: columnCount,
                children: List.generate(
                  snapshot.data.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: columnCount,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                _showMaterialDialog(context, snapshot.data[index]);
                              },
                              child: Stack(
                                children: <Widget>[
                                  ClipPath(
                                    clipper: CategoryCustomShape(),
                                    child: Container(
                                        color: Color(0xFFF3F6F8),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                snapshot.data[index].num
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFF171717)
                                                        .withOpacity(.6)),
                                              )
                                            ])),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: AspectRatio(
                                      aspectRatio: 1.5,
                                      child:
                                          Image.asset(snapshot.data[index].pic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : Container(
              child: Center(
              child: noBookWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    bookBloc.getBooks();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noBookWidget() {
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    bookBloc.dispose();
  }
}

