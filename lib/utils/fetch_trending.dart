// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../classes/trending_media.dart';

Future<TrendingMedia> fetchTrending(String type) async {
  Map<String, String> requestHeaders = {
    "Authorization":
    "Bearer ${dotenv.get('API_READ_ACCESS', fallback: const String.fromEnvironment("API_READ_ACCESS"))}",
    "Accept": "application/json"
  };
  final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/trending/$type/day?language=en-US"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return TrendingMedia.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load trending type $type!");
  }
}
