import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherForecastService {
  final String apiKey = "d58c5e8a0867475dac142419241010";
  final String forecastBaseURL = "http://api.weatherapi.com/v1/forecast.json";
  final String searchBaseURL = "http://api.weatherapi.com/v1/search.json";

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = '$forecastBaseURL?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar dados sobre o tempo atual!');
    }
  }

  Future<Map<String, dynamic>> fetch7DayForeCast(String city) async {
    final url = '$forecastBaseURL?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Falha ao carregar dados sobre a previsão do tempo dos últimos 7 dias!');
    }
  }

  Future<List<dynamic>?> fetchCitySuggestions(String query) async {
    final url = '$searchBaseURL?key=$apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
