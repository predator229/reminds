import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:reminds/models/last.messages.model.dart';
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
      "participant" : memo.discussionInfo.participant.email,
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

static Future<bool> sendLastMessageSeen(Memory memo, String? lastVisibleMessage) async {
    if (memo.auth.token == "" || memo.auth.email == "" || lastVisibleMessage == "" || lastVisibleMessage == null){ return false;}
    final datas = {
      "token": memo.auth.token,
      "email" : memo.auth.email,
      "participant" : memo.discussionInfo.participant.email,
      "fromMobil" : 1,
      "last_message_read" : lastVisibleMessage
    };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=saveSettings"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != 0) {
        Fluttertoast.showToast(
          msg: jsonResponse['message'] ?? "probleme lors de la sauvegarde du dernier message lu. Verifies ta connexion",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }else{
        Fluttertoast.showToast(
          msg: "Enregistré",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
      return true;
    } else{
      return false;
    }
}
  
static Future<List<LastMessage>> refreshFromSave(Memory memo) async {
    if (memo.auth.token == "" || memo.auth.email == ""){ return emptyLastMessage();}
    final datas = {
      "token": memo.auth.token,
      "email" : memo.auth.email,
      "participant" : memo.discussionInfo.participant.email,
      "fromMobil" : 1,
    };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=getSettings"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != 0) {
        Fluttertoast.showToast(
          msg: jsonResponse['message'] ?? "Probleme lors de la recuperation des derniers messages lus. Verifies ta connexion",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }else{
        emptyLastMessage();
      }
      var lastMessageJson = jsonResponse['results'] as List;
      var lastMessages = lastMessageJson.map((e) => LastMessage.fromJson(e)).toList();
      return lastMessages;
    } else{
      return emptyLastMessage();
    }
}
  
static Future updateAsLastSave(Memory memo, int lastVisibleMessage) async {
    if (memo.auth.token == "" || memo.auth.email == "" || lastVisibleMessage == 0){ return false;}
    final datas = {
      "token": memo.auth.token,
      "email" : memo.auth.email,
      "participant" : memo.discussionInfo.participant.email,
      "fromMobil" : 1,
      "last_message_read" : lastVisibleMessage
    };
    final response = await http.post(
      Uri.parse("https://messengerapi.cybersds.tech/?endpoint=updateSettingAsLastSave"),
      headers: { "Content-Type": "application/json"},
      body: jsonEncode(datas),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != 0) {
        Fluttertoast.showToast(
          msg: jsonResponse['message'] ?? "probleme lors de la sauvegarde du dernier message lu. Verifies ta connexion",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }else{
        Fluttertoast.showToast(
          msg: "Enregistré",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } 
}

  static Future<MessageObject> emptyMessageObject() async {
    final participants = Participant(name: "", email: "");
    final messages = Message(message_id: "", sendername: "", timestampms: 0);
    final results = OneResult(participants: [participants], messages: [messages]);
    return MessageObject(error: 0, results: results);
  }

  static Future<List<LastMessage>> emptyLastMessage() async {
    final result = LastMessage(id_save: 0,message_id: "0", sendername: "", timestampms: 0, content: "");
    return [result];
  }
}