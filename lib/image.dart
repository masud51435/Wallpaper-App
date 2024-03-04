import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ShowImage extends StatefulWidget {
  final String image;
  final int index;
  const ShowImage({
    super.key,
    required this.index,
    required this.image,
  });

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  Future<void> setWallpaper() async {
    var file = await DefaultCacheManager().getSingleFile(widget.image);
    (bool,) result = (
      await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        goToHome: false,
        toastDetails: ToastDetails(message: 'WallPaper Added'),
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InkWell(
            child: Center(
              child: Hero(
                tag: 'pic${widget.index}',
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // color: Colors.transparent,
              padding: const EdgeInsets.all(10),
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                onPressed: () {
                  setWallpaper();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Set WallPaper',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
