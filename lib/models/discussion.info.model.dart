import 'dart:ui';

import 'package:reminds/models/participant.model.dart';

class DiscussionInfo{
  Participant participant;
  String discussionId;
  String imagePath;
  Color color;

  DiscussionInfo({required this.participant, required this.discussionId, required this.imagePath, required this.color});
}