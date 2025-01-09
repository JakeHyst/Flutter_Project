import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import 'package:video_player/video_player.dart';

class ForecastBPage extends StatefulWidget {
  final String location;

  const ForecastBPage({super.key, required this.location});

  @override
  State<ForecastBPage> createState() => _ForecastBPageState();
}

class _ForecastBPageState extends State<ForecastBPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  bool _isLoading = false;
  String? _errorMessage;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _fetchWeather(widget.location);
    _controller = VideoPlayerController.asset('assets/video/background.mp4')
      ..setLooping(true)
      ..setVolume(0);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _weatherService.getWeather(city);
      final forecast = await _weatherService.getForecast(city);
      setState(() {
        _weatherData = data;
        _forecastData = forecast['list'];
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch weather data. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Image.asset('assets/images/sun.png', width: 50, height: 50);
      case 'clouds':
        return Image.asset('assets/images/cloud.png', width: 50, height: 50);
      case 'scattered clouds':
        return Image.asset('assets/images/cloudy-day.png',
            width: 50, height: 50);
      case 'rain':
        return Image.asset('assets/images/heavy-rain.png',
            width: 50, height: 50);
      case 'light rain':
        return Image.asset('assets/images/heavy-rain.png',
            width: 50, height: 50);
      case 'heavy rain':
        return Image.asset('assets/images/heavy-rain.png',
            width: 50, height: 50);
      case 'thunderstorm':
        return Image.asset('assets/images/thunderstorm.png',
            width: 50, height: 50);
      case 'snow':
        return Image.asset('assets/images/snowy.png', width: 50, height: 50);
      case 'mist':
        return Image.asset('assets/images/foggy-night.png',
            width: 50, height: 50);
      default:
        return Image.asset('assets/images/sunset.png', width: 50, height: 50);
    }
  }

  Widget _buildWeatherCard() {
    if (_weatherData == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Weather in ${_weatherData!['name']}',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getWeatherIcon(_weatherData!['weather'][0]['main']),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weatherData!['weather'][0]['description']
                        .toString()
                        .toUpperCase(),
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_weatherData!['main']['temp']}°C',
                    style: GoogleFonts.lato(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.black.withOpacity(0.3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                  'Humidity', '${_weatherData!['main']['humidity']}%'),
              _buildDetailItem('Wind', '${_weatherData!['wind']['speed']} m/s'),
              _buildDetailItem(
                  'Visibility', '${_weatherData!['visibility'] / 1000} km'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.lato(fontSize: 14, color: Colors.black)),
        const SizedBox(height: 5),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildDetailedDailyForecast() {
    if (_forecastData == null) return const SizedBox();

    final Map<String, List<Map<String, dynamic>>> dailyForecast = {};
    for (final entry in _forecastData!) {
      final dateTime = DateTime.parse(entry['dt_txt']);
      final dayKey = DateFormat('yyyy-MM-dd').format(dateTime);

      if (!dailyForecast.containsKey(dayKey)) {
        dailyForecast[dayKey] = [];
      }
      dailyForecast[dayKey]!.add(entry);
    }

    final dailyForecastList = dailyForecast.entries.toList();
    return Column(
      children: List.generate(
        dailyForecastList.length > 6 ? 6 : dailyForecastList.length,
        (index) {
          final dayData = dailyForecastList[index].value;
          final dateTime = DateTime.parse(dayData[0]['dt_txt']);
          final dayName = DateFormat('EEEE').format(dateTime);

          double highestTemp = dayData[0]['main']['temp'];
          double lowestTemp = dayData[0]['main']['temp'];

          for (final entry in dayData) {
            highestTemp = highestTemp > entry['main']['temp']
                ? highestTemp
                : entry['main']['temp'];
            lowestTemp = lowestTemp < entry['main']['temp']
                ? lowestTemp
                : entry['main']['temp'];
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayName,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getWeatherIcon(dayData[0]['weather'][0]['main']),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayData[0]['weather'][0]['description']
                              .toString()
                              .toUpperCase(),
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'High: ${highestTemp.toStringAsFixed(1)}°C\nLow: ${lowestTemp.toStringAsFixed(1)}°C',
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.black.withOpacity(0.3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailItem(
                        'Humidity', '${dayData[0]['main']['humidity']}%'),
                    _buildDetailItem(
                        'Wind', '${dayData[0]['wind']['speed']} m/s'),
                    _buildDetailItem(
                        'Pressure', '${dayData[0]['main']['pressure']} hPa'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHourlyForecast() {
    if (_forecastData == null) return const SizedBox();

    final hourlyForecastData = _forecastData!
        .where((entry) {
          final dateTime = DateTime.parse(entry['dt_txt']);
          return dateTime.isAfter(DateTime.now());
        })
        .take(6)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Forecast',
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              hourlyForecastData.length,
              (index) {
                final hourData = hourlyForecastData[index];
                final dateTime = DateTime.parse(hourData['dt_txt']);
                final hour = DateFormat('hh a').format(dateTime);

                return Column(
                  children: [
                    Text(hour,
                        style: GoogleFonts.lato(
                            fontSize: 14, color: Colors.black)),
                    const SizedBox(height: 5),
                    getWeatherIcon(hourData['weather'][0]['main']),
                    const SizedBox(height: 5),
                    Text(
                      '${hourData['main']['temp']}°C',
                      style:
                          GoogleFonts.lato(fontSize: 14, color: Colors.black),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Weather Tips',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '• Stay hydrated during hot weather.\n'
            '• Dress in layers for cold conditions.\n'
            '• Avoid outdoor activities during thunderstorms.\n'
            '• Use sunscreen when outdoors on sunny days.',
            style: GoogleFonts.lato(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    if (_weatherData == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Additional Weather Information',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Wind Speed: ${_weatherData!['wind']['speed']} m/s\n'
            'Pressure: ${_weatherData!['main']['pressure']} hPa\n',
            style: GoogleFonts.lato(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityBar() {
    if (_weatherData == null || _weatherData!['air_quality'] == null) {
      return const SizedBox();
    }

    double airQuality = _weatherData!['air_quality'] ?? 0;
    Color barColor = _getAirQualityColor(airQuality);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Air Quality',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: airQuality / 500,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(barColor),
            minHeight: 10,
          ),
          const SizedBox(height: 10),
          Text(
            'Air Quality Index: $airQuality',
            style: GoogleFonts.lato(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _getAirQualityColor(double aqi) {
    if (aqi <= 1) {
      return Colors.green;
    } else if (aqi <= 2) {
      return Colors.yellow;
    } else if (aqi <= 3) {
      return Colors.orange;
    } else if (aqi <= 4) {
      return Colors.red;
    } else {
      return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1C1C),
        title: Text('Forecast for ${widget.location}'),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_errorMessage != null)
                      Center(child: Text(_errorMessage!))
                    else
                      Column(
                        children: [
                          _buildWeatherCard(),
                          const SizedBox(height: 16),
                          _buildHourlyForecast(),
                          const SizedBox(height: 16),
                          _buildDetailedDailyForecast(),
                          const SizedBox(height: 16),
                          _buildWeatherTips(),
                          const SizedBox(height: 16),
                          _buildAdditionalInfo(),
                          const SizedBox(height: 16),
                          _buildAirQualityBar(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
