import 'package:reminds/models/audio.model.dart';
import 'package:reminds/models/message.model.dart';
import 'package:reminds/models/participant.model.dart';
import 'package:reminds/models/photo.model.dart';

class OneResult{
  String? lastmessageseen;
  List<Participant> participants;
  List<Message> messages;
  List<Photo>? photos;
  OneResult({
    this.lastmessageseen,
    required this.participants,
    required this.messages,
    this.photos
  });
  factory OneResult.fromJson(Map<String, dynamic> json) {
      var participantsJson = json['participants'] as List;
      var messagesJson = json['messages'] as List;
      List<Photo>? allPhotos = [];

      List<Participant> participants = participantsJson.map((p) => Participant(name: p['name'], email: p['email'])).toList();
      List<Message> messages = messagesJson.map((m) => Message(
          message_id: m['message_id']?.toString(),
          sendername: m['sender_name'] ?? '',
          timestampms: m['timestamp_ms'] ?? 0,
          content: m['content'] ?? '',
          ip: m['ip'] ?? '',
          audios: (m['audio_files'] as List?)?.map((a) => Audio(uri: a['uri'], creationtimestamp: a['creation_timestamp'])).toList(),
          photos: (m['photos'] as List?)?.map((ph) {
            var photoItem = Photo(uri: ph['uri'], creationtimestamp: ph['creation_timestamp'], backupuri: ph['backup_uri']);
            allPhotos.add(photoItem);
            return photoItem;
          }
          ).toList(),
        )
      ).toList();
      allPhotos.sort((a, b) => a.creationtimestamp.compareTo(b.creationtimestamp));
      messages.sort((a, b) => a.timestampms.compareTo(b.timestampms));
      return OneResult(lastmessageseen : json['last_message_seen']?.toString(),participants: participants, messages: messages, photos: allPhotos);
  }
}
