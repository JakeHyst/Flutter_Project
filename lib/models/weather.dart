class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double humidity;
  final double windSpeed;
  final double precipitation;
  final String sunrise;
  final String sunset;
  final String moonPhase;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    final sys = json['sys'];

    return Weather(
      cityName: json['name'],
      temperature: main['temp'].toDouble(),
      description: weather['description'],
      humidity: main['humidity'].toDouble(),
      windSpeed: wind['speed'].toDouble(),
      precipitation: json['rain']?['1h']?.toDouble() ?? 0.0,
      sunrise: _convertTimestampToTime(sys['sunrise']),
      sunset: _convertTimestampToTime(sys['sunset']),
      moonPhase: 'Not Available', // Ideally would be from a separate API
    );
  }

  static String _convertTimestampToTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
