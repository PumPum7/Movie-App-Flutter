// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Project imports:
import 'package:movie_faves/classes/movies.dart';
import 'package:movie_faves/utils/fetch_movies.dart';
import 'package:movie_faves/widgets/movie_display.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late Future<MoviesResponse> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovies();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Movie App',
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 10,
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<MoviesResponse>(
        future: futureMovie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FlutterNativeSplash.remove();
            if (snapshot.data == null) {
              return const Center(
                child: Text("No movies found!"),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Movies',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueAccent,
                            ),
                          ))),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                          "Found ${snapshot.data?.results?.length} movies:")),
                  CustomScrollView(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverGrid.count(
                            childAspectRatio: MediaQuery.of(context)
                                .size
                                .width /
                                (MediaQuery.of(context).size.height / 1.1),
                            crossAxisSpacing: 5,
                            crossAxisCount: MediaQuery.of(context)
                                .size
                                .width ~/ 200,
                            children: [
                              for (Movies movie
                              in snapshot.data?.results ?? [])
                                MovieWidget(movie: movie)
                            ]),
                      )
                    ],
                  ),
                ],
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
