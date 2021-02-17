import 'package:flutter/material.dart';

class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double wight = size.width;
    double cornerSize = 30;

    path.lineTo(0, height - cornerSize);
    path.quadraticBezierTo(0, height, cornerSize, wight);
    path.lineTo(wight - cornerSize, height);
    path.quadraticBezierTo(wight, height, wight, height - cornerSize);
    path.lineTo(wight, cornerSize);
    path.quadraticBezierTo(wight, 0, wight - cornerSize, 0);
    path.lineTo(cornerSize, cornerSize * 0.75);
    path.quadraticBezierTo(0, cornerSize, 0, cornerSize * 2);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
