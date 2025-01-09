import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class WeatherMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherMapPage(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<WeatherMapPage> createState() => _WeatherMapPageState();
}

class _WeatherMapPageState extends State<WeatherMapPage> {
  String _currentLayer = 'temp_new';
  bool _showCities = false; // To toggle city markers
  double _zoomLevel = 8.0; // Default zoom level

  // Layers for OpenWeatherMap
  final Map<String, String> _layers = {
    'Temperature': 'temp_new',
    'Precipitation': 'precipitation_new',
    'Clouds': 'clouds_new',
    'Wind': 'wind_new',
  };

  final List<Map<String, dynamic>> _cities = [
    {'name': 'Casablanca', 'latitude': 33.5731, 'longitude': -7.5898},
    {'name': 'Rabat', 'latitude': 34.020882, 'longitude': -6.84165},
    {'name': 'Marrakech', 'latitude': 31.6349, 'longitude': -8.0029},
    {'name': 'Fes', 'latitude': 34.0336, 'longitude': -5.0000},
    {'name': 'Tangier', 'latitude': 35.7678, 'longitude': -5.7998},
    {'name': 'Agadir', 'latitude': 30.4278, 'longitude': -9.5982},
    {'name': 'Oujda', 'latitude': 34.6811, 'longitude': -1.9133},
    {'name': 'Meknes', 'latitude': 33.8938, 'longitude': -5.5517},
    {'name': 'Sale', 'latitude': 34.0209, 'longitude': -6.7983},
    {'name': 'Tetouan', 'latitude': 35.5743, 'longitude': -5.3700},
    {'name': 'Kenitra', 'latitude': 34.2621, 'longitude': -6.5770},
    {'name': 'El Jadida', 'latitude': 33.2514, 'longitude': -8.5069},
    {'name': 'Nador', 'latitude': 35.1841, 'longitude': -2.9333},
    {'name': 'Khenifra', 'latitude': 32.9383, 'longitude': -5.6730},
    {'name': 'Beni Mellal', 'latitude': 32.3319, 'longitude': -6.3611},
    // Algeria
    {
      'name': 'Algiers',
      'latitude': 36.7528,
      'longitude': 3.0420,
      'temperature': 20
    },
    {
      'name': 'Oran',
      'latitude': 35.6971,
      'longitude': -0.6305,
      'temperature': 22
    },
    {
      'name': 'Constantine',
      'latitude': 36.3650,
      'longitude': 6.6141,
      'temperature': 19
    },
    {
      'name': 'Annaba',
      'latitude': 36.8750,
      'longitude': 7.7667,
      'temperature': 21
    },
    {
      'name': 'Blida',
      'latitude': 36.4819,
      'longitude': 2.8669,
      'temperature': 18
    },
    {
      'name': 'Batna',
      'latitude': 35.5612,
      'longitude': 6.1781,
      'temperature': 17
    },
    {
      'name': 'Tlemcen',
      'latitude': 34.8886,
      'longitude': -1.3169,
      'temperature': 19
    },
    {
      'name': 'Sétif',
      'latitude': 36.1911,
      'longitude': 5.4111,
      'temperature': 18
    },
    {
      'name': 'Chlef',
      'latitude': 36.1667,
      'longitude': 1.3333,
      'temperature': 18
    },
    {
      'name': 'Biskra',
      'latitude': 34.8480,
      'longitude': 5.7243,
      'temperature': 24
    },
    {
      'name': 'Tiaret',
      'latitude': 35.3747,
      'longitude': 1.3175,
      'temperature': 17
    },
    {
      'name': 'Mostaganem',
      'latitude': 35.9333,
      'longitude': 0.0897,
      'temperature': 21
    },
    {
      'name': 'El Oued',
      'latitude': 33.3833,
      'longitude': 6.8667,
      'temperature': 26
    },
    {
      'name': 'Béjaïa',
      'latitude': 36.7500,
      'longitude': 5.0667,
      'temperature': 22
    },
    {
      'name': 'M’Sila',
      'latitude': 35.7000,
      'longitude': 4.5500,
      'temperature': 18
    },
    {
      'name': 'Skikda',
      'latitude': 36.8667,
      'longitude': 6.9067,
      'temperature': 21
    },
    {
      'name': 'Ghardaïa',
      'latitude': 32.4833,
      'longitude': 3.6667,
      'temperature': 27
    },
    {
      'name': 'Bordj Bou Arréridj',
      'latitude': 36.0733,
      'longitude': 4.7806,
      'temperature': 19
    },
    {
      'name': 'Ouargla',
      'latitude': 31.9500,
      'longitude': 5.3167,
      'temperature': 28
    },
    {
      'name': 'El Tarf',
      'latitude': 36.8000,
      'longitude': 8.3000,
      'temperature': 21
    },
    {
      'name': 'Khenchela',
      'latitude': 35.4347,
      'longitude': 7.1403,
      'temperature': 18
    },
    {
      'name': 'Tamanrasset',
      'latitude': 22.7833,
      'longitude': 5.4167,
      'temperature': 30
    },
    {
      'name': 'Laghouat',
      'latitude': 33.8000,
      'longitude': 2.8667,
      'temperature': 24
    },
    {
      'name': 'El Bayadh',
      'latitude': 33.6750,
      'longitude': 1.0267,
      'temperature': 23
    },
    {
      'name': 'Tlemcen',
      'latitude': 34.8886,
      'longitude': -1.3169,
      'temperature': 19
    },
    {
      'name': 'Medea',
      'latitude': 36.2667,
      'longitude': 2.8667,
      'temperature': 17
    },
    {
      'name': 'Tizi Ouzou',
      'latitude': 36.7167,
      'longitude': 4.0333,
      'temperature': 19
    },
    {
      'name': 'Sidi Bel Abbès',
      'latitude': 35.1886,
      'longitude': -0.6300,
      'temperature': 20
    },
    {
      'name': 'El Harrach',
      'latitude': 36.7528,
      'longitude': 3.1633,
      'temperature': 20
    },

    // Mauritania
    {
      'name': 'Nouakchott',
      'latitude': 18.0735,
      'longitude': -15.9582,
      'temperature': 30
    },
    {
      'name': 'Nouadhibou',
      'latitude': 20.9316,
      'longitude': -17.0341,
      'temperature': 28
    },

    // Western Sahara
    {
      'name': 'Laayoune',
      'latitude': 27.1415,
      'longitude': -13.2000,
      'temperature': 25
    },
    {
      'name': 'Dakhla',
      'latitude': 23.7343,
      'longitude': -15.9449,
      'temperature': 26
    },

    // Spain (near Morocco)
    {
      'name': 'Ceuta',
      'latitude': 35.8895,
      'longitude': -5.3167,
      'temperature': 23
    },
    {
      'name': 'Melilla',
      'latitude': 35.2935,
      'longitude': -2.9384,
      'temperature': 22
    },

    // France

    {
      'name': 'Paris',
      'latitude': 48.8566,
      'longitude': 2.3522,
      'temperature': 18
    },
    {
      'name': 'Marseille',
      'latitude': 43.2965,
      'longitude': 5.3698,
      'temperature': 20
    },
    {
      'name': 'Lyon',
      'latitude': 45.7640,
      'longitude': 4.8357,
      'temperature': 17
    },
    {
      'name': 'Toulouse',
      'latitude': 43.6047,
      'longitude': 1.4442,
      'temperature': 22
    },
    {
      'name': 'Nice',
      'latitude': 43.7102,
      'longitude': 7.2620,
      'temperature': 23
    },
    {
      'name': 'Nantes',
      'latitude': 47.2184,
      'longitude': -1.5536,
      'temperature': 19
    },
    {
      'name': 'Strasbourg',
      'latitude': 48.5734,
      'longitude': 7.7521,
      'temperature': 16
    },
    {
      'name': 'Montpellier',
      'latitude': 43.6117,
      'longitude': 3.8767,
      'temperature': 24
    },
    {
      'name': 'Bordeaux',
      'latitude': 44.8378,
      'longitude': -0.5792,
      'temperature': 21
    },
    {
      'name': 'Lille',
      'latitude': 50.6292,
      'longitude': 3.0573,
      'temperature': 15
    },
    {
      'name': 'Rennes',
      'latitude': 48.1173,
      'longitude': -1.6778,
      'temperature': 17
    },
    {
      'name': 'Le Havre',
      'latitude': 49.4944,
      'longitude': 0.1079,
      'temperature': 18
    },
    {
      'name': 'Saint-Étienne',
      'latitude': 45.4397,
      'longitude': 4.3872,
      'temperature': 16
    },
    {
      'name': 'Toulon',
      'latitude': 43.1242,
      'longitude': 5.9280,
      'temperature': 23
    },
    {
      'name': 'Aix-en-Provence',
      'latitude': 43.5297,
      'longitude': 5.4474,
      'temperature': 22
    },
    {
      'name': 'Angers',
      'latitude': 47.4784,
      'longitude': -0.5632,
      'temperature': 18
    },
    {
      'name': 'Dijon',
      'latitude': 47.3220,
      'longitude': 5.0415,
      'temperature': 17
    },
    {
      'name': 'Le Mans',
      'latitude': 48.0061,
      'longitude': 0.1996,
      'temperature': 18
    },
    {
      'name': 'Clermont-Ferrand',
      'latitude': 45.7772,
      'longitude': 3.0870,
      'temperature': 16
    },
    {
      'name': 'Grenoble',
      'latitude': 45.1885,
      'longitude': 5.7245,
      'temperature': 15
    },
    {
      'name': 'Caen',
      'latitude': 49.4144,
      'longitude': -0.6883,
      'temperature': 17
    },
    {
      'name': 'Nancy',
      'latitude': 48.6921,
      'longitude': 6.1844,
      'temperature': 16
    },
    {
      'name': 'Perpignan',
      'latitude': 42.6985,
      'longitude': 2.8956,
      'temperature': 21
    },
    {
      'name': 'Tours',
      'latitude': 47.3941,
      'longitude': 0.6848,
      'temperature': 19
    },
    {
      'name': 'Amiens',
      'latitude': 49.8941,
      'longitude': 2.3022,
      'temperature': 17
    },
    {
      'name': 'Valence',
      'latitude': 44.9333,
      'longitude': 4.8750,
      'temperature': 20
    },
    {
      'name': 'Brest',
      'latitude': 48.3904,
      'longitude': -4.4861,
      'temperature': 15
    },
    {
      'name': 'Nîmes',
      'latitude': 43.8367,
      'longitude': 4.3601,
      'temperature': 22
    },
    {
      'name': 'La Rochelle',
      'latitude': 46.1603,
      'longitude': -1.1511,
      'temperature': 19
    },
    {
      'name': 'Sète',
      'latitude': 43.4084,
      'longitude': 3.6937,
      'temperature': 22
    },
    {
      'name': 'Cannes',
      'latitude': 43.5513,
      'longitude': 7.0108,
      'temperature': 23
    },
    {
      'name': 'Antibes',
      'latitude': 43.5804,
      'longitude': 7.1251,
      'temperature': 23
    },
    {
      'name': 'Biarritz',
      'latitude': 43.4833,
      'longitude': -1.5584,
      'temperature': 20
    },
    {
      'name': 'Bayonne',
      'latitude': 43.4925,
      'longitude': -1.4747,
      'temperature': 20
    },
    {
      'name': 'Troyes',
      'latitude': 48.2974,
      'longitude': 4.0745,
      'temperature': 16
    },
    {
      'name': 'La Roche-sur-Yon',
      'latitude': 46.6701,
      'longitude': -1.4342,
      'temperature': 19
    },
    {
      'name': 'Chambéry',
      'latitude': 45.5646,
      'longitude': 5.9151,
      'temperature': 16
    },
    {
      'name': 'Colmar',
      'latitude': 48.0796,
      'longitude': 7.3585,
      'temperature': 17
    },
    {
      'name': 'Vannes',
      'latitude': 47.6553,
      'longitude': -2.7600,
      'temperature': 18
    },

    // Spain
    {
      'name': 'Madrid',
      'latitude': 40.4168,
      'longitude': -3.7038,
      'temperature': 20
    },
    {
      'name': 'Barcelona',
      'latitude': 41.3884,
      'longitude': 2.1915,
      'temperature': 22
    },
    {
      'name': 'Valencia',
      'latitude': 39.4699,
      'longitude': -0.3763,
      'temperature': 21
    },
    {
      'name': 'Seville',
      'latitude': 37.3886,
      'longitude': -5.9823,
      'temperature': 23
    },
    {
      'name': 'Zaragoza',
      'latitude': 41.6488,
      'longitude': -0.8891,
      'temperature': 22
    },
    {
      'name': 'Malaga',
      'latitude': 36.7213,
      'longitude': -4.4214,
      'temperature': 24
    },
    {
      'name': 'Murcia',
      'latitude': 37.9835,
      'longitude': -1.1307,
      'temperature': 22
    },
    {
      'name': 'Palma de Mallorca',
      'latitude': 39.5696,
      'longitude': 2.6502,
      'temperature': 25
    },
    {
      'name': 'Las Palmas de Gran Canaria',
      'latitude': 28.1235,
      'longitude': -15.4367,
      'temperature': 26
    },
    {
      'name': 'Bilbao',
      'latitude': 43.2630,
      'longitude': -2.9350,
      'temperature': 18
    },
    {
      'name': 'Alicante',
      'latitude': 38.3452,
      'longitude': -0.4810,
      'temperature': 22
    },
    {
      'name': 'Córdoba',
      'latitude': 37.8882,
      'longitude': -4.7794,
      'temperature': 23
    },
    {
      'name': 'Valladolid',
      'latitude': 41.6523,
      'longitude': -4.7247,
      'temperature': 18
    },
    {
      'name': 'Vigo',
      'latitude': 42.2406,
      'longitude': -8.7207,
      'temperature': 17
    },
    {
      'name': 'Gijón',
      'latitude': 43.5322,
      'longitude': -5.6613,
      'temperature': 16
    },
    {
      'name': 'Santander',
      'latitude': 43.4623,
      'longitude': -3.8099,
      'temperature': 18
    },
    {
      'name': 'Oviedo',
      'latitude': 43.3617,
      'longitude': -5.8494,
      'temperature': 17
    },
    {
      'name': 'Logroño',
      'latitude': 42.4663,
      'longitude': -2.4500,
      'temperature': 19
    },
    {
      'name': 'Burgos',
      'latitude': 42.3402,
      'longitude': -3.6997,
      'temperature': 18
    },
    {
      'name': 'Salamanca',
      'latitude': 40.9634,
      'longitude': -5.6635,
      'temperature': 20
    },
    {
      'name': 'Toledo',
      'latitude': 39.8628,
      'longitude': -4.0273,
      'temperature': 21
    },
    {
      'name': 'Segovia',
      'latitude': 40.9481,
      'longitude': -4.1175,
      'temperature': 18
    },
    {
      'name': 'Albacete',
      'latitude': 38.9940,
      'longitude': -1.8585,
      'temperature': 22
    },
    {
      'name': 'Huelva',
      'latitude': 37.2615,
      'longitude': -6.9447,
      'temperature': 24
    },
    {
      'name': 'Algeciras',
      'latitude': 36.1408,
      'longitude': -5.4590,
      'temperature': 23
    },
    {
      'name': 'Tarragona',
      'latitude': 41.1180,
      'longitude': 1.2445,
      'temperature': 21
    },
    {
      'name': 'Santiago de Compostela',
      'latitude': 42.8782,
      'longitude': -8.5448,
      'temperature': 16
    },
    {
      'name': 'Girona',
      'latitude': 41.9794,
      'longitude': 2.8210,
      'temperature': 19
    },
    {
      'name': 'León',
      'latitude': 42.5987,
      'longitude': -5.5671,
      'temperature': 17
    },
    {
      'name': 'Cádiz',
      'latitude': 36.5311,
      'longitude': -6.2919,
      'temperature': 23
    },
    {
      'name': 'Badajoz',
      'latitude': 38.8794,
      'longitude': -6.9707,
      'temperature': 22
    },
    {
      'name': 'Jaén',
      'latitude': 37.7797,
      'longitude': -3.7792,
      'temperature': 21
    },
    {
      'name': 'Lleida',
      'latitude': 41.6176,
      'longitude': 0.6200,
      'temperature': 20
    },
    {
      'name': 'Cuenca',
      'latitude': 40.0704,
      'longitude': -2.1376,
      'temperature': 19
    },
    {
      'name': 'Ávila',
      'latitude': 40.6563,
      'longitude': -4.6900,
      'temperature': 18
    },
    {
      'name': 'Huesca',
      'latitude': 42.1400,
      'longitude': -0.4096,
      'temperature': 18
    },
    {
      'name': 'Zaragoza',
      'latitude': 41.6488,
      'longitude': -0.8891,
      'temperature': 22
    },

    // Italy
    {
      'name': 'Rome',
      'latitude': 41.9028,
      'longitude': 12.4964,
      'temperature': 18
    },
    {
      'name': 'Milan',
      'latitude': 45.4642,
      'longitude': 9.1900,
      'temperature': 17
    },
    {
      'name': 'Naples',
      'latitude': 40.8522,
      'longitude': 14.2681,
      'temperature': 19
    },
    {
      'name': 'Turin',
      'latitude': 45.0703,
      'longitude': 7.6869,
      'temperature': 16
    },
    {
      'name': 'Florence',
      'latitude': 43.7696,
      'longitude': 11.2558,
      'temperature': 18
    },

    // Germany
    {
      'name': 'Berlin',
      'latitude': 52.5200,
      'longitude': 13.4050,
      'temperature': 14
    },
    {
      'name': 'Munich',
      'latitude': 48.1351,
      'longitude': 11.5820,
      'temperature': 16
    },
    {
      'name': 'Hamburg',
      'latitude': 53.5511,
      'longitude': 9.9937,
      'temperature': 15
    },
    {
      'name': 'Frankfurt',
      'latitude': 50.1109,
      'longitude': 8.6821,
      'temperature': 17
    },
    {
      'name': 'Cologne',
      'latitude': 50.9375,
      'longitude': 6.9603,
      'temperature': 16
    },

    // United Kingdom
    {
      'name': 'London',
      'latitude': 51.5074,
      'longitude': -0.1278,
      'temperature': 14
    },
    {
      'name': 'Manchester',
      'latitude': 53.4808,
      'longitude': -2.2426,
      'temperature': 13
    },
    {
      'name': 'Birmingham',
      'latitude': 52.4862,
      'longitude': -1.8904,
      'temperature': 12
    },
    {
      'name': 'Edinburgh',
      'latitude': 55.9533,
      'longitude': -3.1883,
      'temperature': 13
    },
    {
      'name': 'Liverpool',
      'latitude': 53.4084,
      'longitude': -2.9916,
      'temperature': 14
    },

    // United States
    {
      'name': 'New York',
      'latitude': 40.7128,
      'longitude': -74.0060,
      'temperature': 20
    },
    {
      'name': 'Los Angeles',
      'latitude': 34.0522,
      'longitude': -118.2437,
      'temperature': 22
    },
    {
      'name': 'Chicago',
      'latitude': 41.8781,
      'longitude': -87.6298,
      'temperature': 18
    },
    {
      'name': 'Houston',
      'latitude': 29.7604,
      'longitude': -95.3698,
      'temperature': 25
    },
    {
      'name': 'Miami',
      'latitude': 25.7617,
      'longitude': -80.1918,
      'temperature': 27
    },

    // Canada
    {
      'name': 'Toronto',
      'latitude': 43.65107,
      'longitude': -79.347015,
      'temperature': 10
    },
    {
      'name': 'Vancouver',
      'latitude': 49.2827,
      'longitude': -123.1207,
      'temperature': 12
    },
    {
      'name': 'Montreal',
      'latitude': 45.5017,
      'longitude': -73.5673,
      'temperature': 8
    },
    {
      'name': 'Ottawa',
      'latitude': 45.4215,
      'longitude': -75.6972,
      'temperature': 5
    },

    // Brazil
    {
      'name': 'São Paulo',
      'latitude': -23.5505,
      'longitude': -46.6333,
      'temperature': 26
    },
    {
      'name': 'Rio de Janeiro',
      'latitude': -22.9068,
      'longitude': -43.1729,
      'temperature': 28
    },
    {
      'name': 'Brasília',
      'latitude': -15.7801,
      'longitude': -47.9292,
      'temperature': 22
    },
    {
      'name': 'Salvador',
      'latitude': -12.9714,
      'longitude': -38.5014,
      'temperature': 30
    },

    // Australia
    {
      'name': 'Sydney',
      'latitude': -33.8688,
      'longitude': 151.2093,
      'temperature': 20
    },
    {
      'name': 'Melbourne',
      'latitude': -37.8136,
      'longitude': 144.9631,
      'temperature': 18
    },
    {
      'name': 'Brisbane',
      'latitude': -27.4698,
      'longitude': 153.0251,
      'temperature': 22
    },
    {
      'name': 'Perth',
      'latitude': -31.9505,
      'longitude': 115.8605,
      'temperature': 24
    },

    // Japan
    {
      'name': 'Tokyo',
      'latitude': 35.6762,
      'longitude': 139.6503,
      'temperature': 15
    },
    {
      'name': 'Osaka',
      'latitude': 34.6937,
      'longitude': 135.5023,
      'temperature': 16
    },
    {
      'name': 'Kyoto',
      'latitude': 35.0116,
      'longitude': 135.7681,
      'temperature': 14
    },
    {
      'name': 'Sapporo',
      'latitude': 43.0667,
      'longitude': 141.3500,
      'temperature': 10
    },

    // China
    {
      'name': 'Beijing',
      'latitude': 39.9042,
      'longitude': 116.4074,
      'temperature': 12
    },
    {
      'name': 'Shanghai',
      'latitude': 31.2304,
      'longitude': 121.4737,
      'temperature': 18
    },
    {
      'name': 'Guangzhou',
      'latitude': 23.1291,
      'longitude': 113.2644,
      'temperature': 20
    },
    {
      'name': 'Shenzhen',
      'latitude': 22.5431,
      'longitude': 114.0579,
      'temperature': 22
    },

    // South Africa
    {
      'name': 'Cape Town',
      'latitude': -33.9249,
      'longitude': 18.4241,
      'temperature': 16
    },
    {
      'name': 'Johannesburg',
      'latitude': -26.2041,
      'longitude': 28.0473,
      'temperature': 18
    },
    {
      'name': 'Durban',
      'latitude': -29.8587,
      'longitude': 31.0218,
      'temperature': 22
    },

    // India
    {
      'name': 'New Delhi',
      'latitude': 28.6139,
      'longitude': 77.2090,
      'temperature': 25
    },
    {
      'name': 'Mumbai',
      'latitude': 19.0760,
      'longitude': 72.8777,
      'temperature': 28
    },
    {
      'name': 'Kolkata',
      'latitude': 22.5726,
      'longitude': 88.3639,
      'temperature': 26
    },
    {
      'name': 'Bangalore',
      'latitude': 12.9716,
      'longitude': 77.5946,
      'temperature': 24
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchCityTemperatures();
  }

  Future<void> _fetchCityTemperatures() async {
    final apiKey = '475d1683b44f8f9843f15be6ab7f387b';
    final List<Map<String, dynamic>> updatedCities = [];

    for (var city in _cities) {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${city['latitude']}&lon=${city['longitude']}&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        city['temperature'] = data['main']['temp'];
        updatedCities.add(city);
      } else {
        print('Failed to load temperature for ${city['name']}');
      }
    }

    setState(() {
      _cities.clear();
      _cities.addAll(updatedCities);
    });
  }

  void _changeLayer(String layer) {
    setState(() {
      _currentLayer = layer;
    });
  }

  void _toggleCities(bool? value) {
    setState(() {
      _showCities = value ?? false;
    });
  }

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < 18.0) _zoomLevel += 1.0;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 4.0) _zoomLevel -= 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Map'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.latitude, widget.longitude),
              initialZoom: _zoomLevel,
              minZoom: 4.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              TileLayer(
                urlTemplate:
                    'https://tile.openweathermap.org/map/$_currentLayer/{z}/{x}/{y}.png?appid=475d1683b44f8f9843f15be6ab7f387b',
                userAgentPackageName: 'com.example.weatherapp',
                tileProvider: NetworkTileProvider(),
              ),
              if (_showCities)
                MarkerLayer(
                  markers: _cities.map((city) {
                    return Marker(
                      point: LatLng(city['latitude'], city['longitude']),
                      width: 100,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            city['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (city['temperature'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${city['temperature']}°C',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ..._layers.entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _changeLayer(entry.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              _currentLayer == entry.value
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: _currentLayer == entry.value
                                  ? Colors.blueAccent
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                color: _currentLayer == entry.value
                                    ? Colors.blueAccent
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: _showCities,
                          onChanged: (bool? value) {
                            setState(() {
                              _showCities = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Show Cities Temperature',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
