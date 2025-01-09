import 'package:flutter/material.dart';

Widget getWeatherIcon(String weatherMain) {
  switch (weatherMain.toLowerCase()) {
    case 'clear':
      return Image.asset('assets/images/sun.png', width: 50, height: 50);
    case 'clouds':
      return Image.asset('assets/images/cloud.png', width: 50, height: 50);
    case 'scattered clouds':
      return Image.asset('assets/images/cloudy-day.png', width: 50, height: 50);
    case 'light rain':
      return Image.asset('assets/images/heavy-rain-day.png',
          width: 50, height: 50);
    case 'heavy rain':
      return Image.asset('assets/images/heavy-rain.png', width: 50, height: 50);
    case 'thunderstorm':
      return Image.asset('assets/images/thunderstorm.png',
          width: 50, height: 50);
    case 'snow':
      return Image.asset('assets/images/snowy.png', width: 50, height: 50);
    case 'mist':
      return Image.asset('assets/images/foggy-night.png',
          width: 50, height: 50);
    case 'sunny':
      return Image.asset('assets/images/sun.png', width: 50, height: 50);
    case 'partly sunny':
      return Image.asset('assets/images/cloudy-day.png', width: 50, height: 50);
    default:
      return Image.asset('assets/images/cloudy.png', width: 50, height: 50);
  }
}

/*
IconData getWeatherIcon(String weatherMain) {
  switch (weatherMain.toLowerCase()) {
    case 'clear':
      return Icons.wb_sunny;
    case 'clouds':
      return Icons.wb_cloudy;
    case 'rain':
      return Icons.water_drop;
    case 'snow':
      return Icons.cloudy_snowing;
    case 'thunderstorm':
      return Icons.thunderstorm;
    default:
      return Icons.warning_amber_rounded;
  }
}
*/