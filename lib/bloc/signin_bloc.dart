import 'dart:async';
import 'package:ebooky2/main.dart';
import 'package:ebooky2/model/email_signin_model.dart';
import 'package:ebooky2/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmailSignInBloc {

final Repository repository = Repository();

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  void dispose() {
    _modelController.close();
  }

  void updateWith(
      {String email,
      String password,
      EmailSignInformType formType,
      bool isLoaded,
      bool submitted}) {
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoaded: isLoaded,
        submitted: submitted);
    _modelController.add(_model);
  }

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: _model.formType == EmailSignInformType.signIn
          ? EmailSignInformType.register
          : EmailSignInformType.signIn,
      submitted: false,
      isLoaded: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit(BuildContext context) async {
    updateWith(submitted: true, isLoaded: true);

      if (_model.formType == EmailSignInformType.signIn) {
       var user = await repository.getUser(userName: _model.email,password: _model.password);
        if(user != null){
          print(user.toString());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLogin', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        }else{
          updateWith(isLoaded: false);
          return showDialog<void>(
              context: context,
              barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('SignIn Failed'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Incorrect username or password'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
        }
        updateWith(isLoaded: false);
      } else {
        var x =  await repository.addUser(userName: _model.email,password: _model.password);
        print(x.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }

  }
}
