import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(ClimaCastApp());

class ClimaCastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClimaCast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClimaCastHomePage(),
    );
  }
}

class ClimaCastHomePage extends StatefulWidget {
  @override
  _ClimaCastHomePageState createState() => _ClimaCastHomePageState();
}

class _ClimaCastHomePageState extends State<ClimaCastHomePage> {
  String cityName = '';
  String temp = '';
  String desVal = '';
  String humVal = '';
  String feelsVal = '';
  String windVal = '';

  void fetchWeatherData(String city) async {
    String apiKey = 'cb2e560ae699e1d52367949f70dcc2ad';
    String url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    Uri uri = Uri.parse(url); // Create a Uri object from the URL string

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        cityName = data['name'];
        temp = data['main']['temp'].toString();
        desVal = data['weather'][0]['description'];
        humVal = data['main']['humidity'].toString();
        feelsVal = data['main']['feels_like'].toString();
        windVal = data['wind']['speed'].toString();
      });
    } else {
      // Handle error
      print('Failed to fetch weather data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ClimaCast ☁'),
        backgroundColor: Color(0xFF131515),
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/Wbackground.jpeg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  cityName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$temp℃',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Description: $desVal',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Humidity: $humVal%',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Feels Like: $feelsVal℃',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Wind Speed: $windVal km/h',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Search'),
                  onSubmitted: (value) {
                    fetchWeatherData(value);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchWeatherData(cityName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Set the button color here
                  ),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
