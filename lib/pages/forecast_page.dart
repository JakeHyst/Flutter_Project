import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const ForecastPage({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final forecastList = weatherData['list'] as List;

    final Map<String, List<Map<String, dynamic>>> dailyForecast = {};
    for (final entry in forecastList) {
      final dateTime = DateTime.parse(entry['dt_txt']);
      final day = DateFormat('yyyy-MM-dd').format(dateTime);
      if (!dailyForecast.containsKey(day)) {
        dailyForecast[day] = [];
      }
      dailyForecast[day]!.add(entry);
    }

    final dailyForecastEntries = dailyForecast.entries.toList();

    while (dailyForecastEntries.length < 8) {
      dailyForecastEntries.add(dailyForecastEntries.last);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('6-Day Forecast'),
      ),
      body: ListView.builder(
        itemCount: dailyForecastEntries.length,
        itemBuilder: (context, index) {
          final dayDataList = dailyForecastEntries[index].value;
          final dateTime = DateTime.parse(dayDataList[0]['dt_txt']);
          final dayName = DateFormat('EEEE').format(dateTime);

          double highestTemp = dayDataList[0]['main']['temp'];
          double lowestTemp = dayDataList[0]['main']['temp'];

          for (final entry in dayDataList) {
            highestTemp = highestTemp > entry['main']['temp']
                ? highestTemp
                : entry['main']['temp'];
            lowestTemp = lowestTemp < entry['main']['temp']
                ? lowestTemp
                : entry['main']['temp'];
          }

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                dayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Temperature: ${highestTemp.toStringAsFixed(0)}/${lowestTemp.toStringAsFixed(0)}°C"),
                  Text(
                      "Condition: ${dayDataList[0]['weather'][0]['description']}"),
                  const SizedBox(height: 10),
                  _buildHourlyForecast(dayDataList),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHourlyForecast(List<Map<String, dynamic>> dayDataList) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dayDataList.length,
          itemBuilder: (context, index) {
            final entry = dayDataList[index];
            final dateTime = DateTime.parse(entry['dt_txt']);
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
                  const SizedBox(height: 5),
                  Text(
                    '${entry['main']['temp']}°C',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
