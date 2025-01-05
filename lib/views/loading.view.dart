import 'package:flutter/material.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/views/login.view.dart';

class LoadingView extends StatefulWidget {
  static const routeName = 'loading-page';
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  var sizeWidth = 4;
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  } 
  Future<void> _initializeAnimation() async {
    for (int sec=1; sec <3; sec++){
      await Future.delayed(const Duration(seconds: 1), () {return true;});
      if (mounted){
        setState(() {
          sizeWidth -= 2;
        });
      }
    }
    if (mounted){
      Navigator.of(context).pushReplacement(MyTools().changeRoutePerso(LoginView(), null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Colors.deepPurple,
          //       Colors.deepPurpleAccent,
          //       Colors.deepOrangeAccent,
          //       Colors.deepOrange,
          //     ],
          //   )
          // ),
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: MediaQuery.of(context).size.width*1/(sizeWidth >0 ? sizeWidth : 1),
                  height: MediaQuery.of(context).size.height*1/(sizeWidth >0 ? sizeWidth : 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(child: Image.asset("images/favicon.png"),),
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }

}