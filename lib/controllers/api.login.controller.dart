import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminds/models/auth.model.dart';
import 'package:reminds/models/authentification.model.dart';
import 'package:reminds/models/discussion.info.model.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/participant.model.dart';

class LoginService {
  static Future<AuthentificationToken> sendToken(email) async {
    final datas = {
      'email': email,
      'fromMobil' : 1,
    };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=getTokenAuthentification"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      jsonResponse['isCorrectToken'] = false;
      return AuthentificationToken.fromJson(jsonResponse);
    } else {
      throw Exception(response.statusCode);
    }
  }
  static Future<AuthentificationToken> checkToken(email, token) async {
    if (email.isEmpty || token.isEmpty) {
    }
    final datas = {
      'email': email,
      'token': token,
      'fromMobil' : 1,
    };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=checkTokenAuthentification"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      jsonResponse['isCorrectToken'] = jsonResponse['error'] == 0;
      jsonResponse['email'] = email;
      jsonResponse['token'] = token;
      return AuthentificationToken.fromJson(jsonResponse);
    } else {
      return startToken();
    }
  }
  static Future<AuthentificationToken> startToken() async {
    return  AuthentificationToken(error: 0, isSentCodeEmail: false, isCorrectToken: false);
  }
  static Memory emptyMemo() {
    final discussionInfo =  DiscussionInfo(participant: Participant(name: ""), discussionId: "0", imagePath: "", color: Colors.white);
    final auth = Auth(email: "", token: "");
    return Memory(auth: auth, authToken: startToken(), discussionInfo: discussionInfo);
  }
}