import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_forecast/services/weather_forecast_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;
  const ForecastScreen({required this.city, super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherForecastService _weatherForecastService =
      WeatherForecastService();

  List<dynamic>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _forecast == null
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
                height: MediaQuery.of(context).size.height,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Text(
                                "Previsão para os próximos dias para ${widget.city}",
                                style: GoogleFonts.lato(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _forecast!.length,
                        itemBuilder: (context, index) {
                          final day = _forecast![index];
                          String iconURL =
                              'https:${day['day']['condition']['icon']}';
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: AlignmentDirectional.topStart,
                                      end: AlignmentDirectional.bottomEnd,
                                      colors: [
                                        const Color(0xFF1A2344)
                                            .withOpacity(0.5),
                                        const Color(0xFF1A2344)
                                            .withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Image.network(iconURL),
                                    title: Text(
                                      '${day['date']}\n${day['day']['avgtemp_c'].round()} °C',
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      day['day']['condition']['text'],
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Min: ${day['day']['mintemp_c']}°C\nMax: ${day['day']['maxtemp_c']}°C',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _fetchForecast() async {
    try {
      final forecastData =
          await _weatherForecastService.fetch7DayForeCast(widget.city);
      setState(
        () {
          _forecast = forecastData['forecast']['forecastday'];
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
