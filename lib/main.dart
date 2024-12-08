import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/saved_locations_page.dart';

void main() {
  runApp(NearbyLandmarksApp());
}

class NearbyLandmarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Landmarks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/saved-locations': (context) => SavedLocationsPage(),
      },
    );
  }
}
