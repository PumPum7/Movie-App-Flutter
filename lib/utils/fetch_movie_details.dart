import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/classes/movie_details.dart';

Future<MovieDetailsResponse> fetchMovieDetails(num movie) async {
  Map<String, String> requestHeaders = {
    "Authorization": "Bearer ${dotenv.get('API_READ_ACCESS')}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/$movie?append_to_response=providers%2Csimilar%2Cvideos&language=en-US"),
      headers: requestHeaders);

  if (response.statusCode == 200) {

      return MovieDetailsResponse.fromJson(jsonDecode(response.body));
  } else {

    throw Exception("Failed to load movie details!");
  }
}
