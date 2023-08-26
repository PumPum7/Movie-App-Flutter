// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:movie_faves/classes/trending_media.dart';
import 'package:movie_faves/routes/profile.dart';
import 'package:movie_faves/utils/fetch_trending.dart';
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/widgets/home/category_movie_list.dart';
import 'package:movie_faves/widgets/home/search_field.dart';
import 'package:movie_faves/widgets/star_rating.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<TrendingMedia> futureMovie;
  late Future<User?> _currentUser;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchTrending("all");
    _currentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Movie Faves',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          resizeToAvoidBottomInset: false,
          body: FutureBuilder<TrendingMedia>(
            future: futureMovie,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FlutterNativeSplash.remove();

                return SlidingUpPanel(
                  renderPanelSheet: false,
                  minHeight: MediaQuery.of(context).size.height / 2.7,
                  maxHeight: MediaQuery.of(context).size.height,
                  // panel
                  panel: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 253, 253, 253),
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Colors.grey,
                          ),
                        ]),
                    margin: const EdgeInsets.all(24.0),
                    child: PanelContent(
                      data: snapshot.data,
                    ),
                  ),
                  body: BodyContent(
                    user: _currentUser,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
}

class BodyContent extends StatelessWidget {
  BodyContent({
    super.key,
    required this.user,
  });

  late Future<User?> user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: user,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${snapshot.data?.displayName} 👋',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Text("Lets enjoy some movies!")
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else {
                return const CircularProgressIndicator();
              }
            }),
        const Center(
            child: Padding(padding: EdgeInsets.all(20), child: SearchField())),
        DefaultTabController(
          length: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: SafeArea(
              child: Stack(
                children: [
                  SegmentedTabControl(
                    backgroundColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    tabTextColor: Colors.black45,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    height: 45,
                    tabs: const [
                      SegmentTab(
                        label: 'In Theaters',
                      ),
                      SegmentTab(
                        label: 'On TV',
                      ),
                    ],
                    selectedTabTextColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const SidewayMovieList(category: "theater")),
                        Container(
                          alignment: Alignment.center,
                          child: const SidewayMovieList(category: "tv"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
                  color: Colors.grey.shade400)),
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
