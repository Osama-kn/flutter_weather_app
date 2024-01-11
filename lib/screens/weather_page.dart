import 'package:flutter/material.dart';
import 'package:flutter_application_weather/data/weather_icons.dart';
import 'package:flutter_application_weather/models/weather_model.dart';
import 'package:flutter_application_weather/services/weather_service.dart';
import 'package:flutter_application_weather/widgets/autocomplete_search.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;
  final GlobalKey<AutocompleteSearchState> _autocompleteSearchKey = GlobalKey();

  _fetchWeather([String? selectedCity]) async {
    String city = selectedCity ?? await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _resetState() {
    print('reset weather app');
    setState(() {
      _weather = null;
    });
    _autocompleteSearchKey.currentState?.resetState();

    _fetchWeather();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Weather App'),
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(0.0),
          child: AutocompleteSearch(
            key: _autocompleteSearchKey,
            onCitySelected: (selectedCity) {
              _fetchWeather(selectedCity);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _resetState(); // Reset the state when the home button is pressed
            },
          ),
        ],
      ),
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
