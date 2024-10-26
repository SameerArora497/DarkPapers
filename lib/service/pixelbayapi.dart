import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walli/Model/imageModel.dart';
import 'package:external_path/external_path.dart';

class PixelBayApi {

  String search_query = '';
  final String apiKey = '46674256-4047fea04d18cf52a27fbf07f';
  final String apiUrl = 'https://pixabay.com/api/?safesearch=true&image_type=photo&per_page=20&key=';

  Future<Images> fetchImageByID(int imageID) async {
    final url = '$apiUrl$apiKey&id=$imageID';
    Images image = Images.emptyConstructor();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        image = Images.fromJson(jsonData['hits']);
      }
    } catch (e) {
      print("fetchImageByID: ${e.toString()}");
    }
    return image;
  }

  Future<List<Images>> fetchImagesList(int? pageNumber) async {
    String? url;
    if (pageNumber == null) {
      url = '$apiUrl$apiKey';
    } else {
      url = '$apiUrl$apiKey&q=$search_query&page=$pageNumber';
    }
    List<Images> imagesList = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        for (var json in jsonData['hits']) {
          Images image = Images.fromJson(json);
          imagesList.add(image);
        }
      }
    } catch (e) {
      print("fetchImagesList: ${e.toString()}");
    }
    return imagesList;
  }

  Future<List<Images>> fetchImagesBySearch(String query) async {
    final url = '$apiUrl$apiKey&q=$query';
    List<Images> imagesList = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        search_query = query;
        final jsonData = json.decode(response.body);
        for (var json in jsonData['hits']) {
          Images image = Images.fromJson(json);
          imagesList.add(image);
        }
      }
    } catch (e) {
      print("fetchImagesBySearch: ${e.toString()}");
    }
    return imagesList;
  }

  Future<void> storeImages(BuildContext context, String imageURl, int imageID) async {
    try {
      final response = await http.get(Uri.parse(imageURl));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final imagePath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        final file = File("$imagePath/$imageID.png");
        await file.writeAsBytes(imageBytes);
        print("${file.path}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              content: Text("Downloaded to: ${file.path}"),
            ),
          );
        }
      }
    } catch (e) {
      print("storeImages: ${e.toString()}");
    }
  }

}
