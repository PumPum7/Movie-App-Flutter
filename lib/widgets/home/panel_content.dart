// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:movie_faves/classes/trending_media.dart';
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/widgets/home/grid_movie_tile.dart';
import 'package:movie_faves/widgets/star_rating.dart';

class PanelContent extends StatelessWidget {
  const PanelContent({super.key, required this.data});

  final TrendingMedia? data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: MediaQuery.of(context).size.width / 4,
          top: 5,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 3.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16, right: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            color: Colors.grey.shade600.withOpacity(0.2),
                            spreadRadius: 5)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () => context.go(
                          '/${data?.results?[0].mediaType}/${data?.results?[0].id}'),
                      child: Row(children: [
                        ExtendedImage.network(
                            "https://image.tmdb.org/t/p/w300/${data?.results?[0].posterPath}",
                            handleLoadingProgress: true,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            height: 125,
                            fit: BoxFit.fitHeight,
                            shape: BoxShape.rectangle,
                            clearMemoryCacheIfFailed: true,
                            clearMemoryCacheWhenDispose: true,
                            cache: false,
                            loadStateChanged: (ExtendedImageState state) {
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${data?.results?[0].originalTitle}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '${data?.results?[0].overview}',
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  StarRating(
                                    color: Colors.yellow,
                                    rating:
                                        ((data?.results?[0].voteAverage ?? 0) /
                                                2)
                                            .clamp(0, 5)
                                            .toDouble(),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${data?.results?[0].voteAverage?.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Trending",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () =>
                            context.goNamed(AppPage.discover.routeName),
                        child: const Text("Explore more"))
                  ],
                ),
              ),
              StaggeredGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[1].mediaType,
                      id: data?.results?[1].id,
                      image: data?.results?[1].posterPath,
                      name: data?.results?[1].originalTitle,
                      ranking: ((data?.results?[1].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[2].mediaType,
                      id: data?.results?[2].id,
                      image: data?.results?[2].posterPath,
                      name: data?.results?[2].title,
                      ranking: ((data?.results?[2].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[3].mediaType,
                      id: data?.results?[3].id,
                      image: data?.results?[3].posterPath,
                      name: data?.results?[3].originalTitle,
                      ranking: ((data?.results?[3].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[4].mediaType,
                      id: data?.results?[4].id,
                      image: data?.results?[4].posterPath,
                      name: data?.results?[4].originalTitle,
                      ranking: ((data?.results?[4].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[5].mediaType,
                      id: data?.results?[5].id,
                      image: data?.results?[5].posterPath,
                      name: data?.results?[5].originalTitle,
                      ranking: ((data?.results?[5].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: GridMovieTile(
                      mediaType: data?.results?[6].mediaType,
                      id: data?.results?[6].id,
                      image: data?.results?[6].posterPath,
                      name: data?.results?[6].originalTitle,
                      ranking: ((data?.results?[6].voteAverage ?? 0) / 2)
                          .clamp(0, 5)
                          .toDouble(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
