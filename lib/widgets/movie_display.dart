import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/routes/movie_details_page.dart';
import "package:extended_image/extended_image.dart";

class MovieWidget extends StatelessWidget {
  const MovieWidget({
    super.key,
    required this.movie,
  });

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetailsPage(movie: movie.id ?? 0))),
      child: Column(
        children: [
          Expanded(
              child: ExtendedImage.network(
                  "https://image.tmdb.org/t/p/w300/${movie.posterPath}",
                  handleLoadingProgress: true,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  height: 300.h,
                  fit: BoxFit.fitHeight,
                  shape: BoxShape.rectangle,
                  width: 200.w,
                  clearMemoryCacheIfFailed: true,
                  clearMemoryCacheWhenDispose: true,
                  cache: false, loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        color: Colors.blueAccent,
                      )
                    ],
                  ),
                );
              case LoadState.completed:
                return null;
              case LoadState.failed:
                return GestureDetector(
                  child: const Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Icon(Icons.error),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Text(
                          "load image failed, click to reload",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
                break;
            }
          })),
          Container(
              padding: const EdgeInsets.all(10),
              width: 200,
              alignment: Alignment.center,
              child: Center(child: Text(movie.originalTitle ?? "No title"))),
        ],
      ),
    );
  }
}
