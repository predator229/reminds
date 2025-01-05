import 'package:reminds/models/oneresult.model.dart';

class MessageObject {
  int error;
  OneResult results;

  MessageObject({
    required this.error,
    required this.results,
  });
  factory MessageObject.fromJson(Map<String, dynamic> json) {
    return MessageObject(
      error: json['error'],
      results: OneResult.fromJson(json['results']),
    );
  }
}