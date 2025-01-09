import 'dart:convert';
import 'package:http/http.dart' as http;

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

class WeatherService {
  final String apiKey = '475d1683b44f8f9843f15be6ab7f387b';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String geoApiKey = 'key to be inserted here later';
  final String geoBaseUrl = 'https://api.opencagedata.com/geocode/v1/json';

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<Map<String, dynamic>> getDailyForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load daily forecast data');
    }
  }

  Future<Map<String, dynamic>> getAirQuality(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  Future<LatLng> getLatLng(String city) async {
    final url = Uri.parse('$geoBaseUrl?q=$city&key=$geoApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final lat = data['results'][0]['geometry']['lat'];
      final lng = data['results'][0]['geometry']['lng'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to get latitude and longitude');
    }
  }

  Future<Map<String, dynamic>> getWeatherNews(String city) async {
    return {
      "weather_news":
          "Stay informed: A storm is expected to hit in the coming days. Stay safe!"
    };
  }
}
