import "package:flutter/material.dart";
import "package:movie_app/classes/movie_details.dart";
import "package:movie_app/utils/fetch_movie_details.dart";
import "package:percent_indicator/circular_percent_indicator.dart";
import "package:url_launcher/url_launcher.dart";

class MovieDetailsPage extends StatefulWidget {
  final num movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetailsResponse> futureMovieDetails;

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    openTrailer(url) async {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    }

    return FutureBuilder<MovieDetailsResponse>(
      future: futureMovieDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MovieDetailsResponse? movie = snapshot.data;

          if (movie == null) {
            return const Center(
              child: Text("No movie details found!"),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text("Movie Details"),
              ),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image(
                              height: 200,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w400/${movie.backdropPath}")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            constraints:
                                BoxConstraints.tight(const Size(100, 135)),
                            child: Image(
                                height: 100,
                                width: 135,
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/${movie.posterPath}",
                                    scale: 1)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      movie.title != null ? "${movie.title}" : "No title",
                      style: const TextStyle(height: 1, fontSize: 20),
                    ),
                  ),
                  Text(movie.releaseDate != null
                      ? "(${movie.releaseDate?.split("-")[0]})"
                      : "No known release date"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (movie.voteAverage != null)
                        Row(
                          children: [
                            CircularPercentIndicator(
                              radius: 30,
                              lineWidth: 10,
                              animation: true,
                              percent: movie.voteAverage! / 10,
                              center: Text(movie.voteAverage != null
                                  ? "${(movie.voteAverage! * 10).round()}%"
                                  : ""),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("User Score"),
                            )
                          ],
                        ),
                      const VerticalDivider(
                        color: Colors.grey,
                        width: 20,
                        thickness: 1,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => openTrailer(
                            "https://www.youtube.com/watch?v=${movie.videos?.results?.firstWhere((video) => video.type == 'Trailer').key}"),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Play Trailer"),
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.transparent),
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                          shadowColor: MaterialStatePropertyAll<Color>(
                              Colors.transparent),
                        ),
                      )
                    ],
                  )
                ],
              ));
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
