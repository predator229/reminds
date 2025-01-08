import 'package:flutter/material.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/controllers/api.login.controller.dart';
import 'package:reminds/models/auth.model.dart';
import 'package:reminds/models/authentification.model.dart';
import 'package:reminds/models/discussion.info.model.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/participant.model.dart';
import 'package:reminds/views/internal.image.view.dart';
import 'package:reminds/views/login.view.dart';
import 'package:reminds/views/messages.view.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  late Future<AuthentificationToken> monToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = ModalRoute.of(context)?.settings.arguments as Auth;
    monToken = LoginService.checkToken(auth.email, auth.token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ModalRoute.of(context)?.settings.arguments as Auth;
    if (auth.email.isEmpty) {
      Navigator.of(context).pushReplacement(MyTools().changeRoutePerso(LoginView(), auth));
    }

    return FutureBuilder<AuthentificationToken>(
      future: monToken,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorContainer(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return _buildScaffold(auth, monToken, snapshot.data!);
        }
        return const Center(child: Text('Unexpected error'));
      },
    );
  }

  Widget _buildScaffold(Auth auth, Future<AuthentificationToken> monToken, AuthentificationToken tokenData) {
    if (!tokenData.isCorrectToken) {
      return _buildErrorContainer('Invalid token');
    }
    final participants = tokenData.participants ?? [];
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home_sharp),
          title: const Text('Discussions'),
          actions: [
            IconButton(
              onPressed: () => logOut(auth),
              icon: const Icon(Icons.logout_rounded),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
            ),
          ],
        ),
        body: participants.isNotEmpty
            ? _buildListParticipants(auth, monToken, participants)
            : const Center(child: Text('No participants found')),
      ),
    );
  }

  Widget _buildListParticipants(Auth auth, Future<AuthentificationToken> monToken, List<Participant> participants) {
    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return _buildListParticipant(auth, monToken, participants[index]);
      },
    );
  }

  Widget _buildErrorContainer(String errorMessage) {
    return Center(
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildListParticipant(Auth auth, Future<AuthentificationToken> monToken, Participant participant) {
    final imagePath = _getImagePath(participant.name);

    final Brightness brightness = Theme.of(context).brightness;
    final discussionInfo = DiscussionInfo(participant: participant, discussionId: participant.name, imagePath: imagePath, color: _getColor(participant.name));
    return Container(
      decoration: BoxDecoration(
        border: brightness == Brightness.dark ? Border(bottom: BorderSide(color: Color(0xFF505050)) ) : Border(bottom: BorderSide(color: const Color.fromARGB(255, 196, 196, 196))),
      ),

      child: Row(
        children: [
          _buildParticipantImage(imagePath),
          Flexible(child: _buildParticipantInfo(auth, monToken, discussionInfo, participant.name)),
        ],
      ),
    );
  }

  String _getImagePath(String name) {
    return "images/default_user.png";
  //   return {
  //     "case1": "images/case1.jpeg",
  //     "case2": "images/case2.jpeg",
  //   }[name.toLowerCase().replaceAll(" ", "")] ?? 'images/default_user.png';
  }

  Color _getColor(String name){
    return Colors.lightBlueAccent;
    //   return {
    //   "case1": Colors.redAccent,
    //   "case2": Colors.blueAccent,
    // }[name.toLowerCase().replaceAll(" ", "")] ?? Colors.lightBlueAccent;
  }

  Widget _buildParticipantImage(String imagePath) {
    final size = MediaQuery.of(context).size.width / 5;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: () {Navigator.pushNamed(context, InternalImageView.routeName, arguments: imagePath);},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Hero(tag: "ksejfbsue",child: Image.asset(imagePath)),
        ),
      ),
    );
  }

  Widget _buildParticipantInfo(Auth auth, Future<AuthentificationToken> monToken, DiscussionInfo discussionInfo, String name) {
    return Flexible(
      child: InkWell(
        onTap: () => showInbox(auth, monToken, discussionInfo),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style:  TextStyle(fontSize: 16),
            ),
            Text(
              "Ouvrir inbox",
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  void logOut(Auth auth) {
    auth = Auth.destroy();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(MyTools().changeRoutePerso(LoginView(), auth));
    });
  }

  void showInbox(Auth auth, Future<AuthentificationToken> monToken, DiscussionInfo discussionInfo) {
    final memo = Memory(auth: auth, authToken: monToken, discussionInfo: discussionInfo);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, MessagesView.routeName, arguments: memo);
    });
  }
}