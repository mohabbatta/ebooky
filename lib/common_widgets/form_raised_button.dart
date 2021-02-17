import 'package:ebooky2/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormRaisedButton extends CustomRaisedButton {
  FormRaisedButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          height: 44.0,
          color: Colors.teal,
          onPressed: onPressed,
        );
}
