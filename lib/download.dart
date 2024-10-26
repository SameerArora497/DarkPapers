
import 'package:flutter/material.dart';
import 'package:walli/service/pixelbayapi.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Download extends StatefulWidget {

  final int imageID;
  final String imageUrl;

  const Download({
    super.key,
    required this.imageID,
    required this.imageUrl,
  });
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

  final pixabayapi = PixelBayApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dark',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'FontBold',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Text('PAPERS',
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'FontBold',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ]
          ),
        ),
      ),
      body: CachedNetworkImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        imageUrl: widget.imageUrl,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.download),
        onPressed: () {
          pixabayapi.storeImages(context, widget.imageUrl, widget.imageID);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
