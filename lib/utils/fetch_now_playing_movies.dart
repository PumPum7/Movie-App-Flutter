// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../classes/now_playing_movies.dart';

Future<NowPlayingMovies> fetchNowPlayingMovies() async {
  Map<String, String> requestHeaders = {
    "Authorization":
        "Bearer ${dotenv.get('API_READ_ACCESS', fallback: const String.fromEnvironment("API_READ_ACCESS"))}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1&region=us"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return NowPlayingMovies.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load now playing!");
  }
}
