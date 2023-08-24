// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Project imports:
import '../classes/movies.dart';
import '../utils/fetch_movies.dart';
import '../widgets/movie_display.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        title: Text(widget.title),
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
