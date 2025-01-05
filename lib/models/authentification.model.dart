import 'package:reminds/models/participant.model.dart';

class AuthentificationToken {
  final int error;
  final String? messageError;
  final bool isSentCodeEmail;
  final bool isCorrectToken;
  final String? email;
  final String? token;
  final List<Participant>? participants;

  AuthentificationToken({
    required this.error,
    this.messageError,
    required this.isSentCodeEmail,
    required this.isCorrectToken,
    this.email,
    this.token,
    this.participants,
  });

  factory AuthentificationToken.fromJson(Map<String, dynamic> json) {
    final result = json['results'] ?? [];
    if (result != null) {
      if (result['participants'] != null) {
        final participantsJson = result['participants'] as List;
        if (participantsJson.isNotEmpty){
          List<Participant> participants = participantsJson.map((p) => Participant(name: p['name'])).toList();
          return AuthentificationToken(
            error: json['error'] as int,
            messageError: json['messageError'] as String?,
            isSentCodeEmail: true,
            isCorrectToken: json['isCorrectToken'] as bool,
            email: json['email'] as String?,
            token: json['token'] as String?,
            participants: participants, //as List<Participant>?
          );
        }
      }
    }
    return AuthentificationToken(
      error: json['error'] as int,
      messageError: json['messageError'] as String?,
      isSentCodeEmail: true,
      isCorrectToken: json['isCorrectToken'] as bool,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }
  factory AuthentificationToken.destroy() {
    return AuthentificationToken(
      error: 0,
      messageError: null,
      isSentCodeEmail: false,
      isCorrectToken: false,
      email: null,
      token: null,
      participants: null,
    );
  }
}