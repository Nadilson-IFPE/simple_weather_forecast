import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_forecast/services/weather_forecast_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherForecastService _weatherForecastService =
      WeatherForecastService();

  String _city = "Recife";

  Map<String, dynamic>? _currentWeather;

  TextEditingController? _dialogController;

  @override
  void initState() {
    super.initState();
    _fetchCityWeather();
  }

  @override
  void dispose() {
    _dialogController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentWeather == null
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A2344),
                    Color.fromARGB(255, 125, 32, 142),
                    Colors.purple,
                    Color.fromARGB(255, 151, 44, 170),
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              //  width: MediaQuery.of(context).size.width * 1,
              //   height: MediaQuery.of(context).size.height * 1,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A2344),
                    Color.fromARGB(255, 125, 32, 142),
                    Colors.purple,
                    Color.fromARGB(255, 151, 44, 170),
                  ],
                ),
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: _showCitySelectionDialog,
                    child: Text(
                      _city,
                      style: GoogleFonts.lato(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'http:${_currentWeather!['current']['condition']['icon']}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          '${_currentWeather!['current']['temp_c'].round()}°C',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_currentWeather!['current']['condition']['text']}',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Min: ${_currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Max: ${_currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetail(
                        'Amanhecer',
                        Icons.wb_sunny,
                        _currentWeather!['forecast']['forecastday'][0]['astro']
                            ['sunrise'],
                      ),
                      _buildWeatherDetail(
                        'Anoitecer',
                        Icons.brightness_3,
                        _currentWeather!['forecast']['forecastday'][0]['astro']
                            ['sunset'],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetail(
                        'Umidade',
                        Icons.opacity,
                        _currentWeather!['current']['humidity'],
                      ),
                      _buildWeatherDetail(
                        'Vento (Km/h)',
                        Icons.wind_power,
                        _currentWeather!['current']['wind_kph'],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForecastScreen(),
                          ),
                        ); */
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2344),
                      ),
                      child: const Text(
                        "Previsão (7 dias)",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _fetchCityWeather() async {
    try {
      final weatherData =
          await _weatherForecastService.fetchCurrentWeather(_city);
      setState(
        () {
          _currentWeather = weatherData;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _buildWeatherDetail(String label, IconData icon, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: const EdgeInsets.all(2),
            width: 150,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  const Color(0xFF1A2344).withOpacity(0.5),
                  const Color(0xFF1A2344).withOpacity(0.2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  value is String ? value : value.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informe a cidade:"),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                FocusScope(
                  child: TypeAheadField(
                    suggestionsCallback: (pattern) async {
                      /* print(
                          'Buscando sugestões para: $pattern'); // Log de entrada
                      final suggestions = await _weatherForecastService
                          .fetchCitySuggestions(pattern);
                      print(
                          'Sugestões recebidas: $suggestions'); // Log da resposta
                      return suggestions; */

                      return await _weatherForecastService
                          .fetchCitySuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['name']),
                      );
                    },
                    onSelected: (city) {
                      _city = city['name'];
                      _dialogController?.text = city['name'];
                      setState(() {});

                      FocusScope.of(context).unfocus();
                    },
                    errorBuilder: (context, error) =>
                        const Text('Erro ao carregar lista!'),
                    loadingBuilder: (context) =>
                        const Text('Aguardando lista de sugestões...'),
                    emptyBuilder: (context) =>
                        const Text('Nenhum item encontrado!'),
                    builder: (context, controller, focusNode) {
                      _dialogController = controller;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Cidade",
                        ),
                        onChanged: (value) {
                          setState(() {
                            _city = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _fetchCityWeather();
              },
              child: const Text("Enviar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
