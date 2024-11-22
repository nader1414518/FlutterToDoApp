import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewerScreen extends StatefulWidget {
  String url;

  PhotoViewerScreen({
    super.key,
    required this.url,
  });

  @override
  PhotoViewerScreenState createState() => PhotoViewerScreenState();
}

class PhotoViewerScreenState extends State<PhotoViewerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage(
          widget.url,
        ),
      )),
    );
  }
}
