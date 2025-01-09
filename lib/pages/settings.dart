import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome to the Weather App!"),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String selectedLocation = "Current Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Dark Mode"),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Manage Location Preferences"),
            subtitle: Text(selectedLocation),
            onTap: () async {
              String? newLocation = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return LocationDialog(currentLocation: selectedLocation);
                },
              );
              if (newLocation != null) {
                setState(() {
                  selectedLocation = newLocation;
                });
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Notifications"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LocationDialog extends StatefulWidget {
  final String currentLocation;

  LocationDialog({required this.currentLocation});

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentLocation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Manage Location Preferences"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: "Enter location"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text("Save"),
        ),
      ],
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final Map<String, bool> _notifications = {
    "Severe Weather Alerts": false,
    "Daily Weather Summary": false,
    "Rain Notifications": false,
    "Wind Alerts": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Settings"),
      ),
      body: ListView(
        children: _notifications.keys.map((String key) {
          return SwitchListTile(
            title: Text(key),
            value: _notifications[key]!,
            onChanged: (bool value) {
              setState(() {
                _notifications[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
