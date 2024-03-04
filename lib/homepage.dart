import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper/image.dart';
import 'package:wallpaper/keys.dart';
import 'package:wallpaper/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentImage = 1;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
      _scrollController.addListener(_loadMoreImageOnScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Wallpaper> fetchApi(int page) async {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/curated?per_page=80&page=$page'),
      headers: {HttpHeaders.authorizationHeader: ApiKeys},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Wallpaper.fromJson(data);
    } else {
      throw Exception('Failed to load album');
    }
  }

  void _loadMoreImageOnScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreImages();
    }
  }

  void _loadMoreImages() {
    currentImage++;
    fetchApi(currentImage).then((newData) {
      setState(() {
        // Append new images to the existing list
        _wallpaperData.photos!.addAll(newData.photos!);
      });
    });
  }

  late Wallpaper _wallpaperData;
  //amra caile direct snapshot.data.image diyeo krt pari full kaj ta _wallpaperData ai variable use na kore.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Wallpaper>(
        future: fetchApi(currentImage),
        builder: (BuildContext context, AsyncSnapshot<Wallpaper> snapshot) {
          if (snapshot.hasData) {
            _wallpaperData = snapshot.data!;
            return GridView.custom(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                pattern: [
                  const QuiltedGridTile(1, 2),
                  const QuiltedGridTile(2, 1),
                  const QuiltedGridTile(2, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(2, 1),
                  const QuiltedGridTile(1, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                  childCount: _wallpaperData.photos!.length + 1,
                  (context, index) {
                if (index < _wallpaperData.photos!.length) {
                  return InkWell(
                    child: Hero(
                      tag: 'pic$index',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _wallpaperData.photos![index].src!.tiny.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        reverseTransitionDuration: const Duration(seconds: 1),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ShowImage(
                          image: _wallpaperData.photos![index].src!.large2x
                              .toString(),
                          index: index,
                        ),
                      ),
                      // MaterialPageRoute(
                      //   builder: (context) => ShowImage(
                      //     image: snapshot.data!.photos![index].src!.original
                      //         .toString(),
                      //     index: index,
                      //   ),
                      // ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
