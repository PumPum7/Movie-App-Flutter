import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/classes/movie.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

Future<MovieResponse> fetchMovies() async {
  Map<String, String> requestHeaders = {
    "Authorization":
        "Bearer ${dotenv.get('API_READ_ACCESS', fallback: 'Default fallback value')}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return MovieResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load movies!");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Movie App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<MovieResponse> futureMovie;

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
            title: const Text("Movie App"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          resizeToAvoidBottomInset: false,
          body: FutureBuilder<MovieResponse>(
            future: futureMovie,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                children: [
                                  for (Movie movie
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

class MovieWidget extends StatelessWidget {
  const MovieWidget({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          FittedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                constraints: BoxConstraints.tight(const Size(200, 300)),
                child: Image(
                    height: 200,
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w200/${movie.posterPath}")),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
              width: 150,
              alignment: Alignment.center,
              child: Center(child: Text(movie.originalTitle ?? "No title"))),
        ],
      ),
    );
  }
}
