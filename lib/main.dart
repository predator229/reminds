import 'package:flutter/material.dart';
import 'package:reminds/views/home.page.view.dart';
import 'package:reminds/views/internal.image.view.dart';
import 'package:reminds/views/loading.view.dart';
import 'package:reminds/views/login.view.dart';
import 'package:reminds/views/messages.view.dart';
import 'package:reminds/views/photo.view.dart';
import 'package:reminds/views/photos.all.view.dart';

void main() {
  runApp(const MyMainActivity());
}

class MyMainActivity extends StatefulWidget {
  const MyMainActivity({super.key});

  @override
  State<MyMainActivity> createState() => _MyMainActivityState();
}

class _MyMainActivityState extends State<MyMainActivity> {
  // late Future<AuthentificationToken> monToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoadingView.routeName : (context) => const LoadingView(),
        LoginView.routeName : (context) => const LoginView(),
        MessagesView.routeName : (context) => const MessagesView(),
        PhotoView.routeName : (context) => PhotoView(),
        PhotosAllView.routeName : (context) => PhotosAllView(),
        HomePage.routeName : (context) => HomePage(),
        InternalImageView.routeName : (context) => InternalImageView(),
      },
      initialRoute: LoadingView.routeName,
    );
  }
}
