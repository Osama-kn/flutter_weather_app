import 'package:flutter/material.dart';
import 'package:flutter_application_weather/data/weatherIcons.dart';
import 'package:flutter_application_weather/models/weather_model.dart';
import 'package:flutter_application_weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;

  _fetchWeather() async {
    String city = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_weather == null)
            Column(
              children: [
                Image.asset(
                  weatherIcons['loading']!,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text('Loading Weather...'),
              ],
            ),
          if (_weather != null)
            Column(
              children: [
                Text(_weather?.cityName ?? 'loading city.....'),
                Image.asset(
                  weatherIcons[_weather?.mainCondition.toLowerCase()] ??
                      weatherIcons['clear']!,
                  width: 200,
                ),
                Text(
                    '${_weather?.tempeture.round() ?? 'Loading tempeture...'}°C'),
                Text(_weather?.mainCondition ?? '')
              ],
            ),
        ],
      )),
    );
  }
}
