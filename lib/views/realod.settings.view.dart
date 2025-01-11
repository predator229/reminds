import 'package:flutter/material.dart';
import 'package:reminds/controllers/api.login.controller.dart';
import 'package:reminds/controllers/api.servicve.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/models/last.messages.model.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/views/login.view.dart';

class ReloadSettingsView extends StatefulWidget {
  static const routeName = 'reload-settings';
  const ReloadSettingsView({super.key});

  @override
  State<ReloadSettingsView> createState() => _ReloadSettingsViewState();
}

class _ReloadSettingsViewState extends State<ReloadSettingsView> {
  late Memory memo;

  @override
  void initState() {
    super.initState();
    memo = LoginService.emptyMemo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Memory? receivedMemo = ModalRoute.of(context)?.settings.arguments as Memory?;
    if (receivedMemo != null) {
      memo = receivedMemo;
    }
    if (memo == LoginService.emptyMemo() || memo.auth.email.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MyTools().changeRoutePerso(const LoginView(), memo.auth),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reload Settings"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Recharger les paramètres",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Après la sauvegarde, il faudra recharger la conversation.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<LastMessage>>(
                  future: ApiService.refreshFromSave(memo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return _buildErrorContainer(snapshot.error.toString());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return
                       ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final each = snapshot.data![index];
                          final sendTime = DateTime.fromMillisecondsSinceEpoch(each.timestampms);
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              onTap: () {
                                ApiService.updateAsLastSave(memo, each.id_save);
                                Navigator.pop(context);
                              },
                              title: Text("Message sauvegardé : ${each.content}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Envoyé par : ${each.sendername}"),
                                  Text("Date : ${sendTime.toLocal()}"),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text("Aucune sauvegarde disponible."),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildErrorContainer(String errorMessage) {
    return Center(
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
