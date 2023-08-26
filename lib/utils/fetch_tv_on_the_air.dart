// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../classes/tv_on_the_air.dart';

Future<TvOnTheAir> fetchTvOnTheAir() async {
  Map<String, String> requestHeaders = {
    "Authorization":
    "Bearer ${dotenv.get('API_READ_ACCESS', fallback: const String.fromEnvironment("API_READ_ACCESS"))}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/tv/on_the_air?language=en-US&page=1&with_original_language=en"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return TvOnTheAir.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load tv on air!");
  }
}
