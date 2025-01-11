class LastMessage {
  String message_id;
  String sendername;
  int timestampms;
  String content;
  int id_save;

  LastMessage({
    required this.id_save,
    required this.message_id,
    required this.sendername,
    required this.timestampms,
    required this.content,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    
    return LastMessage(
      id_save: json['id_save'] ?? 0,
      message_id: json['content_id']?.toString() ?? "",
      sendername: json['sender_name'] ?? "",
      timestampms: json['created_at'] ?? 0,
      content: json['content'] ?? "",
    );
  }
}