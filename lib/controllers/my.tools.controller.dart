import 'package:flutter/material.dart';

class MyTools {
  Route changeRoutePerso(Widget pageToGo, dynamic arguments) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => pageToGo,
      settings: RouteSettings(arguments: arguments),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
