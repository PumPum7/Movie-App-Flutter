import 'package:flutter/material.dart';
import 'package:movie_app/routes/movie_details_page.dart';

import '../classes/movies.dart';


class MovieWidget extends StatelessWidget {
  const MovieWidget({
    super.key,
    required this.movie,
  });

  final Movies movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie.id ?? 0))),
      child: Container(
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
      ),
    );
  }
}