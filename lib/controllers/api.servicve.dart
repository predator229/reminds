import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/message.model.dart';
import 'package:reminds/models/messageobject.model.dart';
import 'package:reminds/models/oneresult.model.dart';
import 'package:reminds/models/participant.model.dart';

class ApiService {
  static Future<MessageObject> fetchMessages(Memory memo) async {
    if (memo.auth.token == "" || memo.auth.email == ""){ return emptyMessageObject();}
    final datas = {
          "token": memo.auth.token,
          "email" : memo.auth.email,
          "discursion_name" : memo.discussionInfo.participant.name,
          "fromMobil" : 1,
      };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=getMessages"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return MessageObject.fromJson(jsonResponse);
    } else {
      return emptyMessageObject();
    }
  }

  static Future<MessageObject> emptyMessageObject() async {
    final participants = Participant(name: ""); 
    final messages = Message(sendername: "", timestampms: 0);
    final results = OneResult(participants: [participants], messages: [messages]);
    return MessageObject(error: 0, results: results);
  }
}