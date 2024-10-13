import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherForecastService {
  final String apiKey = "YOUR_API_KEY_HERE";
  final String forecastBaseURL = "https://api.weatherapi.com/v1/forecast.json";
  final String searchBaseURL = "https://api.weatherapi.com/v1/search.json";

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url =
        '$forecastBaseURL?key=$apiKey&q=$city&days=1&aqi=no&alerts=no&lang=pt';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Falha ao carregar dados sobre o tempo atual!\n\nResposta do servidor da Weather API:\n\n${jsonDecode(response.body)['error']['message']}',
      );
    }
  }

  Future<Map<String, dynamic>> fetch7DayForeCast(String city) async {
    final url =
        '$forecastBaseURL?key=$apiKey&q=$city&days=7&aqi=no&alerts=no&lang=pt';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Falha ao carregar dados sobre a previsão do tempo para os próximos 7 dias!\n\Resposta do servidor da Weather API:\n\n${jsonDecode(response.body)['error']['message']}',
      );
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
