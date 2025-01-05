import 'package:reminds/models/auth.model.dart';
import 'package:reminds/models/authentification.model.dart';
import 'package:reminds/models/discussion.info.model.dart';

class Memory {
  Auth auth;
  Future<AuthentificationToken> authToken;
  DiscussionInfo discussionInfo;

  Memory({required this.auth, required this.authToken, required this.discussionInfo});
}