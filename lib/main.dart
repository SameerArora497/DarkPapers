import 'dart:async';
import 'package:walli/download.dart';

import 'Model/imageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walli/service/pixelbayapi.dart';
import 'package:walli/widgets/CustomScrollBehavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      home: const MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {

  int pageNumber = 1;
  late Future<List<Images>>? images;
  final List<String> categories = ["Nature", "Bike", "Car", "Animals", "Technology", "Architecture", "Food", "Sports", "Travel", "Art"];

  final pixabayapi = PixelBayApi();
  final scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    images = pixabayapi.fetchImagesList(pageNumber);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
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


      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search wallpapers...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                controller: _searchController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z0-9]"),

                  ),
                ],
                onSubmitted: (value) {
                  getImagesBySearch(value);
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        getImagesBySearch(categories[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(categories[index],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontFamily: 'FontFont',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),

            const SizedBox(height: 10),

            FutureBuilder(future: images, builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading wallpapers"),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: MasonryGridView.count(
                        controller: ScrollController(),
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        itemBuilder: (context, index) {
                          double height = (index % 10 + 1) * 100;
                          return GestureDetector(
                            onTap: () {
                              final data = snapshot.data![index];
                              Navigator.push(context,
                                  MaterialPageRoute(
                                  builder: (context) => Download(
                                      imageID: data.imageID,
                                      imageUrl: data.imageUrl
                                  ))
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: (height > 300) ? 300 : height,
                                  imageUrl: snapshot.data![index].imageUrl,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: MaterialButton(
                onPressed: () {
                  pageNumber++;
                  images = pixabayapi.fetchImagesList(pageNumber);
                  setState((){});
                },
                color: Colors.blue,
                padding: const EdgeInsets.all(12),
                child: const Text("Load More"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getImagesBySearch(String query) {
    images = pixabayapi.fetchImagesBySearch(query);
    setState(() {});
  }

}
