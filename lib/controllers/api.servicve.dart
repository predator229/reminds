import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/message.model.dart';
import 'package:reminds/models/messageobject.model.dart';
import 'package:reminds/models/oneresult.model.dart';
import 'package:reminds/models/participant.model.dart';

class ApiService {
  late Dio dio;
  ApiService(){
    dio = Dio(
    BaseOptions(
        baseUrl: "https://messengerapi.cybersds.tech",
        connectTimeout: 5000,  // délai d'attente pour établir la connexion
        receiveTimeout: 30000,  // délai d'attente pour recevoir la réponse
        headers: {
          "Accept": "application/json",  // Changer de "*/*" à "application/json"
          "Accept-Encoding": "gzip,deflate,br",
          "Connection": "keep-alive",
          "Host": "messengerapi.cybersds.tech",
          "User-Agent": "Reminds/1.0.0 (Android; OS-Version)",
          "Authorization": "Bearer 8010da612e588fcc872fce56ea4df2ec46426307",  // Ton jeton d'authentification
        },
        responseType: ResponseType.json,  // Assurez-vous que la réponse est traitée en JSON
        followRedirects: true,  // Permet de suivre les redirections
        validateStatus: (status) {
          return status! < 500;  // Validation des codes de statut pour accepter la réponse
        },
      ),
    );
    dio.options.contentType = Headers.formUrlEncodedContentType;
  }

  Future<MessageObject> fetchMessages(Memory memo) async {
    // Vérification de base des données
    if (memo.auth.token.isEmpty || memo.auth.email.isEmpty) {
      showErrorToast("Email or token is missing.");
      return _emptyMessageObject();
    }

    final data = {
      "token": memo.auth.token,
      "email": memo.auth.email,
      "discursion_name": memo.discussionInfo.participant.name,
      "fromMobil": 1,
    };

    try {
      final response = await dio.post(
        "/?endpoint=getMessages",
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        return MessageObject.fromJson(jsonResponse);
      } else {
        showErrorToast("Server error: ${response.statusCode}");
        return _emptyMessageObject();
      }
    } on DioError catch (e) {
      _handleDioError(e);
      return _emptyMessageObject();
    } catch (e) {
      showErrorToast("Unexpected error: $e");
      return _emptyMessageObject();
    }
  }

  MessageObject _emptyMessageObject() {
    final participants = Participant(name: "");
    final messages = Message(sendername: "", timestampms: 0);
    final results = OneResult(participants: [participants], messages: [messages]);
    return MessageObject(error: 0, results: results);
  }

  void _handleDioError(DioError e) {
    String errorMessage;

    switch (e.type) {
      case DioErrorType.sendTimeout:
        errorMessage = "Send timeout. Please try again.";
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = "Receive timeout. Please try again.";
        break;
      case DioErrorType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      default:
        errorMessage = "Connection timeout. Please check your Internet.";
        break;
    }

    showErrorToast(errorMessage);
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
