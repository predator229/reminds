import 'package:reminds/models/photo.model.dart';
import 'package:reminds/models/audio.model.dart';

class Message {
  String sendername;
  int timestampms;
  String? content;
  String? ip;
  List<Audio>? audios;
  List<Photo>? photos;
  bool showDetailMessage = false;

  Message({
    required this.sendername,
    required this.timestampms,
    this.content,
    this.ip,
    this.audios,
    this.photos,
  });
}
