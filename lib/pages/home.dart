import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import 'Forecast_B.dart';
import 'settings.dart';
import 'weather_map.dart';
import 'package:video_player/video_player.dart';

/*import 'package:video_player/video_player.dart';*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  bool _isLoading = false;
  String? _errorMessage;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController =
        VideoPlayerController.asset('assets/video/background.mp4')
          ..initialize().then((_) {
            _videoController.setLooping(true);
            _videoController.play();
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

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
      case 'sunny':
        return Image.asset('assets/images/sun.png', width: 50, height: 50);
      case 'partly sunny':
        return Image.asset('assets/images/cloudy-day.png',
            width: 50, height: 50);
      default:
        return Image.asset('assets/images/sunset.png', width: 50, height: 50);
    }
  }

  Widget _buildSunMoonCard() {
    if (_weatherData == null) return const SizedBox();

    final sunrise = (_weatherData!['sys'] != null &&
            _weatherData!['sys']['sunrise'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(
            _weatherData!['sys']['sunrise'] * 1000)
        : null;
    final sunset =
        (_weatherData!['sys'] != null && _weatherData!['sys']['sunset'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                _weatherData!['sys']['sunset'] * 1000)
            : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Sunrise & Sunset Times',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sunrise != null
                  ? Column(
                      children: [
                        Image.asset('assets/images/sunrise.png',
                            width: 40, height: 40),
                        const SizedBox(height: 5),
                        Text(
                          'Sunrise: ${DateFormat('h:mm a').format(sunrise)}',
                          style: GoogleFonts.lato(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    )
                  : const SizedBox(),
              sunset != null
                  ? Column(
                      children: [
                        Image.asset('assets/images/sunsetc.png',
                            width: 40, height: 40),
                        const SizedBox(height: 5),
                        Text(
                          'Sunset: ${DateFormat('h:mm a').format(sunset)}',
                          style: GoogleFonts.lato(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
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
            'Weather in ${_weatherData!['name']}',
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

  Widget _buildForecastSummary() {
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
            '6-Day Forecast',
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
              dailyForecastList.length > 6 ? 6 : dailyForecastList.length,
              (index) {
                final dayData = dailyForecastList[index].value;
                final dateTime = DateTime.parse(dayData[0]['dt_txt']);
                final dayName =
                    DateFormat('EEEE').format(dateTime).substring(0, 3);

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

                return Column(
                  children: [
                    Text(dayName,
                        style: GoogleFonts.lato(
                            fontSize: 14, color: Colors.black)),
                    const SizedBox(height: 5),
                    getWeatherIcon(dayData[0]['weather'][0]['main']),
                    const SizedBox(height: 5),
                    Text(
                      '${highestTemp.toStringAsFixed(0)}/${lowestTemp.toStringAsFixed(0)}°C',
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
                final hour = DateFormat('hh a').format(dateTime); // e.g., 02 PM

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2) {
      if (_weatherData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherMapPage(
              latitude: _weatherData!['coord']['lat'],
              longitude: _weatherData!['coord']['lon'],
            ),
          ),
        );
      }
    } else if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForecastBPage(
            location: _weatherData!['name'], // Actual location
          ),
        ),
      );
    }
  }

  Widget _buildWeatherNews() {
    if (_weatherData == null || _weatherData!['weather_news'] == null) {
      return const SizedBox(); // Return empty if no news
    }

    final weatherNews =
        _weatherData!['weather_news']; // Get weather news/alerts

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Weather News/Info',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          weatherNews is List
              ? Column(
                  children: weatherNews.map<Widget>((newsItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        newsItem['description'] ?? 'No description available.',
                        style:
                            GoogleFonts.lato(fontSize: 16, color: Colors.black),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  weatherNews ?? 'No weather news available.',
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                ),
        ],
      ),
    );
  }

  void _openAboutDrawer(BuildContext context) {
    Navigator.of(context).push(_CustomModalRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: Text(
          'Weather App',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF2A2A2A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1C),
              ),
              child: Text(
                'Weather App',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              color: Color(0xFF333333),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading:
                          const Icon(Icons.location_on, color: Colors.white),
                      title: const Text('Manage Locations',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Divider(color: Color(0xFF555555), height: 1),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading:
                          const Icon(Icons.notifications, color: Colors.white),
                      title: const Text('Daily Summary Notification',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Divider(color: Color(0xFF555555), height: 1),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(Icons.settings, color: Colors.white),
                      title: const Text('Settings',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Color(0xFF333333),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(Icons.help, color: Colors.white),
                      title: const Text('Help',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Divider(color: Color(0xFF555555), height: 1),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading:
                          const Icon(Icons.privacy_tip, color: Colors.white),
                      title: const Text('Privacy Settings',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Divider(color: Color(0xFF555555), height: 1),
                  InkWell(
                    onTap: () {
                      _openAboutDrawer(context);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.info, color: Colors.white),
                      title: const Text('About',
                          style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search City',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final city = _searchController.text;
                          if (city.isNotEmpty) {
                            _fetchWeather(city);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage != null)
                    Center(child: Text(_errorMessage!))
                  else
                    Column(
                      children: [
                        _buildWeatherCard(),
                        const SizedBox(height: 16),
                        _buildSunMoonCard(),
                        const SizedBox(height: 16),
                        _buildHourlyForecast(),
                        const SizedBox(height: 16),
                        _buildForecastSummary(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Radar',
          ),
        ],
      ),
    );
  }
}

class _CustomModalRoute extends PageRouteBuilder {
  _CustomModalRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _AboutDrawer(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}

class _AboutDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2A2A2A),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This is a Flutter project done by Mohamed Amine Hatimy and Issam Krourou',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://example-link-to-the-website.com'));
            },
            child: const Text(
              'https://example-link-to-the-website.com',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://example-link-to-terms.com'));
            },
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://example-link-to-licenses.com'));
            },
            child: const Text(
              'Licenses',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  void launchUrl(Uri parse) {}
}
