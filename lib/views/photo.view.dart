import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reminds/models/photo.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PhotoView extends StatefulWidget {
  static const routeName = 'show-image';
  const PhotoView({super.key});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  late String pathToSave;

  @override
  void initState() {
    super.initState();
    _setPath();
    
}
  void _setPath() async {
    pathToSave = (await getExternalStorageDirectory())!.path;
    if (mounted) return;
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final filePath = '$pathToSave/$fileName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        Fluttertoast.showToast(
          msg: "Telechargement reussi: $filePath",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to download file",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ooooh, attend la mise a jour ! :)",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final instancePhoto = ModalRoute.of(context)?.settings.arguments as Photo ;
    final imgWidth = MediaQuery.of(context).size.width*0.80;
    final imgHeigth = MediaQuery.of(context).size.height*0.80;
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_new)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed : () async {
                  final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
                  await _downloadFile(instancePhoto.backupuri ?? instancePhoto.uri, fileName);
                  },
                icon: Icon(Icons.file_download_rounded),
              ),
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: imgWidth,
              height: imgHeigth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color.fromARGB(255, 37, 37, 37).withOpacity(0.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: instancePhoto.backupuri ?? instancePhoto.uri,
                  child: Image.network(
                    instancePhoto.backupuri ?? instancePhoto.uri,
                    width: imgWidth,
                    height: imgHeigth,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }
}