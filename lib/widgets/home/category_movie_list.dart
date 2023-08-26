// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:movie_faves/classes/now_playing_movies.dart';
import 'package:movie_faves/classes/tv_on_the_air.dart';
import 'package:movie_faves/utils/fetch_now_playing_movies.dart';
import 'package:movie_faves/utils/fetch_tv_on_the_air.dart';
import 'package:movie_faves/widgets/movie_display.dart';

class SidewayMovieList extends StatefulWidget {
  const SidewayMovieList({super.key, required this.category});

  final String category;

  @override
  State<SidewayMovieList> createState() => _SidewayMovieListState();
}

class _SidewayMovieListState extends State<SidewayMovieList> {
  late Future<TvOnTheAir> _futureTvOnTheAir;
  late Future<NowPlayingMovies> _futureNowPlayingMovies;

  @override
  void initState() {
    super.initState();
    if (widget.category == "tv") {
      _futureTvOnTheAir = fetchTvOnTheAir();
    } else if (widget.category == "theater") {
      _futureNowPlayingMovies = fetchNowPlayingMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category == "tv") {
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              TvOnTheAir data = snapshot.data as TvOnTheAir;

              return Container(
                height: 300,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.results?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    TvShow? show = data.results?[index];

                    if (show != null) {
                      return SizedBox(
                        width: 160.0,
                        child: MovieWidget(
                            movie: Movie(
                                originalTitle: show.name,
                                posterPath: show.posterPath,
                                id: show.id)),
                      );
                    }
                    return null;
                  },
                ),
              );
            }
            return const Text("No shows found");
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
        future: _futureTvOnTheAir,
      );
    } else if (widget.category == "theater") {
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data?.results != null) {
              NowPlayingMovies data = snapshot.data as NowPlayingMovies;

              return Container(
                height: 300,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.results?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Movie? movie = data.results?[index];
                    if (movie != null) {
                      return SizedBox(
                        width: 160.0,
                        child: MovieWidget(movie: movie),
                      );
                    }
                    return null;
                  },
                ),
              );
            }
            return const Text("No shows found");
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
        future: _futureNowPlayingMovies,
      );
    }
    return Placeholder();
  }
}
