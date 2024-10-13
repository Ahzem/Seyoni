import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  static final String _apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  static Future<List<String>> fetchLocationSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> predictions =
          json.decode(response.body)['predictions'];
      return predictions
          .map((prediction) => prediction['description'] as String)
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
