import 'package:flutter/material.dart';
import '../data/shared_preferences_helper.dart';
import '../models/location.dart';

class SavedLocationsPage extends StatefulWidget {
  @override
  _SavedLocationsPageState createState() => _SavedLocationsPageState();
}

class _SavedLocationsPageState extends State<SavedLocationsPage> {
  final SharedPreferencesHelper sharedPreferencesHelper =
  SharedPreferencesHelper();
  List<Location> savedLocations = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedLocations();
  }

  Future<void> _fetchSavedLocations() async {
    List<Location> locations =
    await sharedPreferencesHelper.getSavedLocations();
    setState(() {
      savedLocations = locations;
    });
  }

  Future<void> _deleteLocation(int index) async {
    savedLocations.removeAt(index);
    await sharedPreferencesHelper.clearSavedLocations();
    for (var location in savedLocations) {
      await sharedPreferencesHelper.saveLocation(location);
    }
    setState(() {});
  }

  Widget _buildLocationCard(Location location, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 150, // Consistent height for cards
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    location.name, // Location name
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    location.address, // Location address
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Lat: ${location.latitude.toStringAsFixed(4)}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black, // Black for better readability
                    ),
                  ),
                  Text(
                    'Lng: ${location.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black, // Black for better readability
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteLocation(index),
              tooltip: 'Delete Location',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, // Taller AppBar for better presence
        title: const Text(
          'Saved Locations',
          style: TextStyle(
            fontSize: 26, // Larger font for better readability
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/map_pattern.png'), // Subtle map pattern
              fit: BoxFit.cover,
              opacity: 0.2, // Overlay effect
            ),
          ),
        ),
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // Rounded corners
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: savedLocations.isEmpty
            ? const Center(
          child: Text(
            'No saved locations yet.',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: savedLocations.length,
          itemBuilder: (context, index) {
            return _buildLocationCard(savedLocations[index], index);
          },
        ),
      ),
    );
  }
}
