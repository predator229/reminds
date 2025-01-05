import 'package:flutter/material.dart';

class InternalImageView extends StatelessWidget {
  static const routeName = 'show-image-internal';
  const InternalImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = ModalRoute.of(context)?.settings.arguments as String ;
    final imgWidth = MediaQuery.of(context).size.width*0.80;
    final imgHeigth = MediaQuery.of(context).size.height*0.80;
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home:Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: imgWidth,
              height: imgHeigth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color.fromARGB(255, 37, 37, 37).withOpacity(0.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: "ksejfbsue",
                  child: Image.asset(
                    imagePath,
                    width: imgWidth,
                    height: imgHeigth,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }
}