import 'package:flutter/material.dart';
import 'package:flutter_application_weather/services/weather_service.dart';

class AutocompleteSearch extends StatefulWidget {
  final Function(String) onCitySelected;
  GlobalKey<AutocompleteSearchState>? autocompleteKey;
  TextEditingController cityController = TextEditingController();

  AutocompleteSearch({
    Key? key,
    required this.onCitySelected,
    // required this.controller,
    this.autocompleteKey,
  }) : super(key: key);

  @override
  AutocompleteSearchState createState() => AutocompleteSearchState();
}

class AutocompleteSearchState extends State<AutocompleteSearch> {
  final _weatherService = WeatherService();
  // TextEditingController cityController = TextEditingController();
  List<String> _suggestions = [];

  _getCitySuggestions(String query) async {
    try {
      final suggestions = await _weatherService.getCitySuggestions(query);
      setState(() {
        _suggestions = suggestions;
      });
      print("Suggestions: $suggestions query: $query");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize _cityController when the widget is created
    // _cityController =
    //     widget.autocompleteKey?.currentState?.textEditingController;
  }

  // @override
  // void didUpdateWidget(covariant AutocompleteSearch oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // widget.controller.text = widget.controller.text;
  //   // Update _cityController when the widget is updated
  //   // _cityController =
  //   //     widget.autocompleteKey?.currentState?.textEditingController;
  // }

  void resetState() {
    print("Resetting state of autocomplete...");
    print( widget.cityController.text);
    // print("_cityController: $_cityController");
    // widget.local_controller.clear();
    widget.cityController.clear();
    // widget.cityController.text = '';
    // widget.controller.text = '';
    setState(() {
      _suggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Autocomplete<String>(
        // key: ValueKey(widget.local_controller),
        optionsBuilder: (TextEditingValue textEditingValue) {
          print(textEditingValue.text);
          // widget.controller.text = textEditingValue.text;
          // return _suggestions.toList();
          return _suggestions
              .where((suggestion) => suggestion
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()))
              .toList();
        },
        onSelected: (String selectedCity) {
          // widget.controller.text = selectedCity;
          print("SELECT CITY: $selectedCity");
          widget.onCitySelected(selectedCity);
        },
        fieldViewBuilder: (BuildContext context, cityController,
            FocusNode focusNode, VoidCallback onFieldSubmitted) {
          // widget.controller.text = textEditingController.text;

          return TextField(
            controller: cityController,
            focusNode: focusNode,
            onChanged: (String value) {
              // print("Text changed: $value");
              _getCitySuggestions(value);
            },
            onSubmitted: (_) => onFieldSubmitted(),
            decoration: const InputDecoration(
              hintText: 'Enter city name',
              border: OutlineInputBorder(),
            ),
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
