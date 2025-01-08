import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reminds/controllers/api.login.controller.dart';
import 'package:reminds/controllers/api.servicve.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/models/audio.model.dart';
import 'package:reminds/models/helper.display.view.dart';
import 'package:reminds/models/memory.model.dart';
import 'package:reminds/models/message.model.dart';
import 'package:reminds/models/messageobject.model.dart';
import 'package:reminds/models/photo.model.dart';
import 'package:reminds/views/audio.view.dart';
import 'package:reminds/views/login.view.dart';
import 'package:reminds/views/photo.view.dart';
import 'package:reminds/views/photos.all.view.dart';

class MessagesView extends StatefulWidget {
    static const routeName = 'messages';
    const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}
class _MessagesViewState extends State<MessagesView> {
  // late Future<MessageObject> monObjet;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  List<Message>? _originalMessages;
  List<Message>? messageFiltered;
  List<Photo>? allPhotosFirstBuild;
  late Memory memo;

  bool isDataLoaded = false;
  bool showProfil = false;

  var sort = false;
  var showSearchZone = false;

@override
  void initState() {
    super.initState();
    // monObjet = ApiService.emptyMessageObject();
    memo = LoginService.emptyMemo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDataLoaded) {
      final Memory? receivedMemo = ModalRoute.of(context)?.settings.arguments as Memory?;
      if (receivedMemo != null) {
        memo = receivedMemo;
      } 
      if (memo == LoginService.emptyMemo() || memo.auth.email.isEmpty){
        // monObjet = ApiService.fetchMessages(memo);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MyTools().changeRoutePerso(LoginView(), memo.auth));
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: 
        isDataLoaded ? _buildUI() : _buildFuture(),
    );
  }

  // WIDGET
  Widget _buildFuture(){
    return FutureBuilder<MessageObject>(
      future: ApiService.fetchMessages(memo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorContainer(snapshot.error.toString());
        } else if (snapshot.hasData && snapshot.data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              allPhotosFirstBuild = snapshot.data?.results.photos;
              _originalMessages = snapshot.data?.results.messages;
              messageFiltered = _originalMessages!;
              isDataLoaded = true;
            });
          });
          return Container();
        }
        return Container();
      },
    );
  }
  Widget _buildUI() {
      return Scaffold(
        appBar: _buildAppBar(),
      body: _buildMessageList(),
      floatingActionButton: _buildFloatActionButton(),
    );
  }
  FloatingActionButton _buildFloatActionButton(){
  return FloatingActionButton(
      onPressed: crollingFunction,
      child: Container(
        width: MediaQuery.of(context).size.width * 1/10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Transform.rotate(
          angle: pi/2,
          child: Icon(Icons.compare_arrows_outlined),
        ),
      ),
    );
}
  AppBar _buildAppBar(){
    return AppBar(
      leading: IconButton(
        onPressed: () { Navigator.pop(context); },
        icon: Icon(Icons.arrow_back_ios_new)
      ),
      centerTitle: false,
      title: _buildToogleTitle(),
      actions: _buildActionAppBar(),
    );
  }
  Widget _buildFormZone(){
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _searchController,
        onChanged: (text) {
          if (_originalMessages != null) {
            setState(() {
                messageFiltered = _originalMessages!.where((message) => message.content!.toLowerCase().contains(text.toLowerCase())).toList();
            });
          }
        },
        decoration: InputDecoration(
          labelText: "Rechercher",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget _buildTitle(){
    final Brightness brightness = Theme.of(context).brightness;
    if (memo.discussionInfo.participant.name.isEmpty || memo.discussionInfo.imagePath.isEmpty){
      return Container();
    }
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Hero(
            tag: memo.discussionInfo.participant.name,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(memo.discussionInfo.imagePath, width: 40, height: 40),
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: (){
              if (allPhotosFirstBuild != null){
                Navigator.pushNamed(context, PhotosAllView.routeName, arguments: allPhotosFirstBuild);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  memo.discussionInfo.participant.name, 
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Voir toutes les photos', 
                  style: TextStyle(
                    fontSize: 10,
                    color: brightness == Brightness.dark ? const Color.fromARGB(255, 208, 207, 207) : const Color.fromARGB(255, 111, 110, 110)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildErrorContainer(String errorMessage) {
    return Center(
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  Widget _buildMessageList() {
    final displayedMessages = showSearchZone ? messageFiltered ?? [] : _originalMessages ?? [];
    if (displayedMessages.isEmpty && memo.discussionInfo.participant.name.isNotEmpty) {
      return const Center(child: Text('Aucun message trouvé.'));
    }
    return ListView.builder(
      itemCount: displayedMessages.length,
      itemBuilder: (context, index) {

        final message = displayedMessages[index];
        final isMe = message.sendername.toLowerCase().replaceAll(" ", "") != memo.discussionInfo.participant.name.toLowerCase().replaceAll(" ", "");
        
        final whatIFinalyShow = showProfil;

        if (isMe){ showProfil =true; }
        if (!isMe && showProfil){ showProfil =false; }

        final columAlinment = !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
        final rowAlinment = !isMe ? MainAxisAlignment.start : MainAxisAlignment.end;
        final bgMessage = !isMe ? const Color.fromARGB(255, 210, 214, 222) : memo.discussionInfo.color;
        final msgMessage = !isMe ? Colors.black : Colors.white;

        final avatarPath = isMe ? "images/default_user.jpeg" : memo.discussionInfo.imagePath;
        final avatarSize = MediaQuery.of(context).size.width*0.1;
        final sendTime = DateTime.fromMillisecondsSinceEpoch(message.timestampms);

        final helper = HelperDisplayView(
          columAlinment: columAlinment,
          rowAlinment: rowAlinment,
          bgMessage: bgMessage,
          isMe: isMe,
          avatarPath : avatarPath,
          avatarSize : avatarSize,
        );

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: columAlinment,
            children: [
              if (message.content != null && message.content!.isNotEmpty)
                Row(
                  mainAxisAlignment: rowAlinment,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe && whatIFinalyShow)
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(avatarPath),
                      ), 
                    ),
                    if ((!isMe && !whatIFinalyShow) || isMe)
                    SizedBox(
                      width: avatarSize*(isMe?2:1),
                      height: avatarSize*(isMe?2:1),
                    ),
                    Flexible(
                    child: Column(
                      crossAxisAlignment: columAlinment,
                        children: [
                          if (message.showDetailMessage)
                          Text("$sendTime"),
                           Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: bgMessage,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            child: Text(
                                message.content!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: msgMessage,
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMe)
                    SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                    )
                  ],
                ),
              if (message.photos != null && message.photos!.isNotEmpty)
                _buildImagePreview(message.photos!, helper),
              if (message.audios != null && message.audios!.isNotEmpty)
                _buildAudios(message.audios!, helper)
            ],
          ),
        );
      },
      controller: _scrollController,
    );
  }
  Widget _buildImagePreview(List<Photo> photos, HelperDisplayView helper) {
    return Column(
      children: photos.map((photo) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: helper.rowAlinment,
            children: [
              if (!helper.isMe)
              Container(
                width: helper.avatarSize,
                height: helper.avatarSize,
                padding: EdgeInsets.all(8.0),
              ),
              Container(
                width: 240,
                height: 440,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {Navigator.pushNamed(context, PhotoView.routeName, arguments: photo);}, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: photo.backupuri ?? photo.uri,
                      child: Image.network(
                        photo.backupuri ?? photo.uri,
                        width: 240,
                        height: 440,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  Widget _buildAudios(List<Audio> audios, dynamic helper) {
    return Column(
      children: audios.map((audio) {
        return AudioView(audioUri: audio.uri, helper: helper);
      }).toList(),
    );
  }
  Widget _buildToogleTitle() {
    return showSearchZone ? _buildFormZone() : _buildTitle();
  }
  List<Widget> _buildActionAppBar(){
    return [
      if (!showSearchZone)
      IconButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: () {
          setState(() { showSearchZone=true;});
        },
        icon: const Icon(Icons.search_outlined),
      ),
      if (showSearchZone)
      IconButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: () {
          setState(() { 
            messageFiltered = _originalMessages;
            showSearchZone=false;
          });
        },
        icon: const Icon(Icons.cancel_outlined),
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: () {
          setState(() { sort = !sort;});
          final messagesTotries = showSearchZone ? messageFiltered : _originalMessages;
          messagesTotries?.sort((a, b) => sort ? b.timestampms.compareTo(a.timestampms) : a.timestampms.compareTo(b.timestampms));
        },
        icon: const Icon(Icons.sort),
      ),
    ];
  }
  //FUNCTIONS
  crollingFunction(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut, );
        }else {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut,);
        }
      }
    });
  }

  
}

