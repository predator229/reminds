import 'package:flutter/material.dart';
import 'package:reminds/controllers/my.tools.controller.dart';
import 'package:reminds/models/photo.model.dart';
import 'package:reminds/views/photo.view.dart';

class PhotosAllView extends StatelessWidget {
  static const routeName = 'show-all-image';
  const PhotosAllView({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = ModalRoute.of(context)?.settings.arguments as List<Photo>;

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_new)),
          title: Text("Contenus multimedias, fichiers et liens"),
          centerTitle: false,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: photos.length, 
          itemBuilder: (context, index){
            final laPhoto = photos[index];
            return _buildImageGrid(context,laPhoto);
          }
        ),
      ),
    );
  }

  Widget _buildImageGrid(context,Photo imageI){
    final imgWidth = MediaQuery.of(context).size.width*1/3;
    final imgHeigth = MediaQuery.of(context).size.height*1/3;
    final Brightness brightness = Theme.of(context).brightness;
    final color_ = brightness != Brightness.dark ? Colors.white : Colors.black;

    return Container(
      width: imgWidth,
      height: imgHeigth,
      decoration: BoxDecoration(
        border: Border.all(
          color: color_,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap : () {
          Navigator.of(context).push(MyTools().changeRoutePerso(PhotoView(), imageI));
      },
        child: ClipRRect(
          child: Hero(
            tag: "ariuvaoiuerbv",
            child: Image.network(imageI.uri),
            ),
        ),
      ),
    );
  }
}
