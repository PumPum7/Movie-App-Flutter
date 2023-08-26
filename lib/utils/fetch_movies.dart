// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:movie_faves/classes/movies.dart';

Future<MoviesResponse> fetchMovies() async {
  Map<String, String> requestHeaders = {
    "Authorization":
    "Bearer ${dotenv.get('API_READ_ACCESS', fallback: const String.fromEnvironment("API_READ_ACCESS"))}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return MoviesResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load movies!");
  }
}
