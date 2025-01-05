import 'package:flutter/material.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/controllers/api.login.controller.dart';
import 'package:reminds/models/auth.model.dart';
import 'package:reminds/models/authentification.model.dart';
import 'package:reminds/views/home.page.view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  static const routeName = 'login-view';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final logoWith = 60.0;
  final logoHeight = 60.0;

  final formKey = GlobalKey<FormState>() ;
  final emailContainer = TextEditingController();
  final tokenController = TextEditingController();

  var iHaveToken = false;

  late Future<AuthentificationToken> monToken;
  bool firstBuild = true;
  @override
  void initState() {
    super.initState();
    monToken = LoginService.startToken();
  }
    @override
  Widget build(BuildContext context) {
    var auth = ModalRoute.of(context)?.settings.arguments as Auth?;
    if ((auth == null || auth.email == "") && firstBuild){
      monToken = LoginService.startToken();
      auth = Auth(email: "", token: "");
      firstBuild = false;
    }
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), 
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple,
                Colors.deepPurpleAccent,
                Colors.deepOrangeAccent,
                Colors.deepOrange,
              ],
            )
          ),
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                    height: MediaQuery.of(context).size.height * (iHaveToken ? 1/2 : 1/3),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                          SizedBox(
                              width: logoWith,
                              height: logoHeight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Center(child: Image.asset("images/favicon.png"),),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Center(child: Text('AUTHENTIFICATION')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: emailContainer,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ),
                            if (iHaveToken) 
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tokenController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Token',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    iHaveToken = !iHaveToken;
                                  });
                                },
                                child: Text(iHaveToken ? 'Demander un token' : 'J\'ai mon token !'),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _loginFunction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Sign In')
                            )
                          ],
                        ),
                      ),
                    ),
                  ), 
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loginFunction() async {
    final email = emailContainer.text.trim();
    final token = tokenController.text.trim();

    if (email.isEmpty || !_emailValidateFormat(email)) {
      Fluttertoast.showToast(
        msg: "L'email est invalide",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    if (token.isEmpty) {
      if (!iHaveToken){
        setState(() {
          monToken = LoginService.sendToken(email);
          iHaveToken = true;
        });
        Fluttertoast.showToast(
          msg: "Envoie du token encours... veuillez consulter votre boite mail!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      var state = await LoginService.checkToken(email, token);
      if (state.isCorrectToken) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MyTools().changeRoutePerso(HomePage(), Auth(email: email, token: token))); // ce que je veux utiliser
        });
      }else{
        // Fluttertoast.showToast(
        //   msg: "Le token entre est invalide !",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
    }
  }
  _emailValidateFormat(email){ return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);}

}