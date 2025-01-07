import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
import 'package:reminds/models/auth.model.dart';
import 'package:reminds/models/authentification.model.dart';
import 'package:reminds/models/discussion.info.model.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/participant.model.dart';

class LoginService {
  late Dio dio;

  LoginService() {
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

    // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
    //   client.badCertificateCallback = (cert, host, port) => true;
    //   return client;
    // };
    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest:(options, handler){
    //     showErrorToast('Request: ${options.uri}');
    //     return handler.next(options); // continue
    //   },
    //   onResponse:(response, handler) {
    //     showErrorToast('Response: ${response.data}');
    //     return handler.next(response); // continue
    //   },
    //   onError: (DioException e, handler) {
    //     showErrorToast('Error: ${e.message}');
    //     return handler.next(e); // continue
    //   }
    // ));
  }
  Future<AuthentificationToken> sendToken(String email) async {
    final datas = {
      'email': email,
      'fromMobil': 1,
    };

    try {
      final response = await dio.post(
        "/?endpoint=getTokenAuthentification",
        data: jsonEncode(datas),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        jsonResponse['isCorrectToken'] = false;
        return AuthentificationToken.fromJson(jsonResponse);
      } else {
        showErrorToast("Server error: ${response.statusCode}");
        throw Exception("Failed to send token. Status code: ${response.statusCode}");
      }
    }on DioError catch (e) {
      _handleDioError(e);
      return startToken();
    } catch (e) {
      showErrorToast("Connection error. Please check your Internet.");
      rethrow;
    }
  }

  Future<AuthentificationToken> checkToken(String email, String token) async {
    if (email.isEmpty || token.isEmpty) {
      showErrorToast("Email or token cannot be empty.");
      throw Exception("Email or token cannot be empty.");
    }

    final datas = {
      'email': email,
      'token': token,
      'fromMobil': 1,
    };

    try {
      final response = await dio.post(
        "/?endpoint=checkTokenAuthentification",
        data: jsonEncode(datas),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        jsonResponse['isCorrectToken'] = jsonResponse['error'] == 0;
        jsonResponse['email'] = email;
        jsonResponse['token'] = token;
        if (jsonResponse['error'] == null || jsonResponse['error'] !=0) {
          showErrorToast("Email ou token Invalid.");
        }
        return AuthentificationToken.fromJson(jsonResponse);
      } else {
        showErrorToast("Server error: ${response.statusCode}");
        return startToken();
      }
    }on DioError catch (e) {
      _handleDioError(e);
      return startToken();
    } catch (e) {
      showErrorToast("Connection error. Please check your Internet.");
      return startToken();
    }
  }

  static Future<AuthentificationToken> startToken() async {
    return AuthentificationToken(
      error: 0,
      isSentCodeEmail: false,
      isCorrectToken: false,
    );
  }

  static Memory emptyMemo() {
    final discussionInfo = DiscussionInfo(
      participant: Participant(name: ""),
      discussionId: "0",
      imagePath: "",
      color: Colors.white,
    );
    final auth = Auth(email: "", token: "");
    return Memory(
      auth: auth,
      authToken: startToken(),
      discussionInfo: discussionInfo,
    );
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
      case DioErrorType.response:
        if (e.response != null) {
          errorMessage = "Server error: ${e.response?.statusCode} ${e.response?.statusMessage}";
          if (e.response?.data != null) {
            errorMessage += "\nDetails: ${e.response?.data}";
          }
        } else {
          errorMessage = "Unexpected server response.";
        }
        break;
      default:
        errorMessage = "Connection timeout. Please check your Internet.";
        break;
    }
    showErrorToast(errorMessage);
  }

}
