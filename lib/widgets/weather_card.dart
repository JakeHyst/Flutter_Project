import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils.dart'; // Import the utility file where `getWeatherIcon` is defined

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // City Name and Weather Description
            Text(
              'Weather in ${weatherData['name'] ?? 'Unknown'}', // Check for null
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Weather Icon and Current Temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getWeatherIcon(weatherData['weather']?[0]['main'] ??
                    'Clear'), // Check for null
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData['weather']?[0]['description']
                              ?.toString()
                              .toUpperCase() ??
                          'No description', // Null check for description
                      style: GoogleFonts.lato(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${weatherData['main']?['temp'] ?? 0}°C', // Null check for temp
                      style: GoogleFonts.lato(fontSize: 24),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Separator line
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 10),

            // Weather Details: Humidity, Wind, Visibility, Dew Point
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                    'Humidity', '${weatherData['main']?['humidity'] ?? 0}%'),
                _buildDetailItem(
                    'Wind', '${weatherData['wind']?['speed'] ?? 0} m/s'),
                _buildDetailItem('Visibility',
                    '${(weatherData['visibility'] ?? 0) / 1000} km'),
                _buildDetailItem(
                    'Dew Point', '${weatherData['main']?['temp_min'] ?? 0}°C'),
              ],
            ),
            const SizedBox(height: 10),

            // Hourly Forecast Section
            _buildHourlyForecast(
                weatherData['hourly'] ?? []), // Hourly Forecast
            const SizedBox(height: 10),

            // Sun & Moon Times Section
            _buildSunMoonTimes(),
          ],
        ),
      ),
    );
  }

  // Method to build the hourly forecast
  Widget _buildHourlyForecast(List hourlyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hourly Forecast',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100, // Fixed height for hourly forecast
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length > 6
                ? 6
                : hourlyData.length, // Limit to 6 hours
            itemBuilder: (context, index) {
              final entry = hourlyData[index];
              final dateTime =
                  DateTime.parse(entry['dt_txt'] ?? DateTime.now().toString());
              final time = DateFormat('h a').format(dateTime);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(time,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 5),
                    Text(
                      '${entry['main']?['temp'] ?? 0}°C',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Sun and Moon times section
  Widget _buildSunMoonTimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sun & Moon Times',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSunMoonDetail('Sunrise', weatherData['sys']?['sunrise']),
            _buildSunMoonDetail('Sunset', weatherData['sys']?['sunset']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSunMoonDetail('Moonrise', weatherData['moonrise']),
            _buildSunMoonDetail('Moonset', weatherData['moonset']),
          ],
        ),
      ],
    );
  }

  // Helper method to build sunrise, sunset, moonrise, and moonset
  Widget _buildSunMoonDetail(String label, int? timestamp) {
    if (timestamp == null) return Container();
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formattedTime = DateFormat('h:mm a').format(time);
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(formattedTime, style: GoogleFonts.lato(fontSize: 14)),
      ],
    );
  }

  // Method to build the weather details (humidity, wind, visibility, etc.)
  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(value, style: GoogleFonts.lato(fontSize: 14)),
      ],
    );
  }

  Widget _buildWeatherNews() {
    final weatherNews =
        weatherData['weather_news'] ?? 'No weather news available.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Weather News',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            weatherNews,
            style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Air Quality Bar
  Widget _buildAirQualityBar() {
    if (weatherData['air_quality'] == null) {
      return const SizedBox(); // If no air quality data, return an empty box
    }

    double airQuality = weatherData['air_quality'] ?? 0;
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
            value: airQuality / 5, // Assuming AQI is between 1 and 5
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

  // Helper function to get color based on air quality value
  Color _getAirQualityColor(double aqi) {
    if (aqi <= 1) {
      return Colors.green; // Good
    } else if (aqi <= 2) {
      return Colors.yellow; // Moderate
    } else if (aqi <= 3) {
      return Colors.orange; // Unhealthy for sensitive groups
    } else if (aqi <= 4) {
      return Colors.red; // Unhealthy
    } else {
      return Colors.brown; // Very unhealthy
    }
  }
}
