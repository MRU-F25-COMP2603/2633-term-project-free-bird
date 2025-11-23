import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final String condition;
  final String icon;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.icon,
  });
}

class WeatherService {
  final String apiKey = "8bdc3be0387c9cf4fd0e2d5f0680cb44"; 

  Future<WeatherData?> getWeather(String city) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return WeatherData(
          temperature: (data["main"]["temp"] as num).toDouble(),
          condition: data["weather"][0]["description"],
          icon: data["weather"][0]["icon"],
        );
      } else {
        print("Weather error ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Weather exception: $e");
      return null;
    }
  }

  Future<WeatherData?> getWeatherByAirport(String code) {
    const airportToCity = {
      "YYC": "Calgary",
      "YYZ": "Toronto",
      "YVR": "Vancouver",
      "YEG": "Edmonton",
    };

    final city = airportToCity[code.toUpperCase()];
    if (city == null) {
      print("Unknown airport code: $code");
      return Future.value(null);
    }

    return getWeather(city);
  }
}
