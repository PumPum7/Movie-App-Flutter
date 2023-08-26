// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:movie_faves/widgets/star_rating.dart';

class GridMovieTile extends StatelessWidget {
  const GridMovieTile({
    super.key,
    required this.mediaType,
    required this.id,
    required this.image,
    required this.name,
    required this.ranking,
  });

  final String? mediaType;
  final num? id;
  final String? image;
  final String? name;
  final double ranking;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 70) / 3,
      child: InkWell(
        onTap: () => context.go('/$mediaType/$id'),
        child: Stack(
          children: [
            ExtendedImage.network("https://image.tmdb.org/t/p/w300/$image",
                handleLoadingProgress: true,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                fit: BoxFit.fitHeight,
                shape: BoxShape.rectangle,
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
                  }
                }),
            Positioned(
              left: 2,
              bottom: 40,
              child: Text(
                '$name',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 2,
              bottom: 20,
              child: Row(
                children: [
                  StarRating(
                    color: Colors.yellow,
                    rating: ranking,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      ranking.toStringAsFixed(1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
