import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import '../services/geocoding_service.dart';
import '../data/shared_preferences_helper.dart';
import '../models/location.dart';
import '../utils/helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String latitude = 'Fetching...';
  String longitude = 'Fetching...';
  String address = 'Fetching...';
  List<Map<String, String>> nearbyLocations = [];
  bool isLoading = false;

  final PermissionService permissionService = PermissionService();
  final LocationService locationService = LocationService();
  final SharedPreferencesHelper sharedPreferencesHelper =
  SharedPreferencesHelper();

  Future<void> _fetchLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool permissionGranted =
      await permissionService.requestLocationPermission();
      if (!permissionGranted) {
        throw Exception('Permission denied.');
      }

      Position position = await locationService.getCurrentLocation();
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      final locationDetails = await GeocodingService.getLocationDetails(
        position.latitude,
        position.longitude,
      );

      address = locationDetails['address'];
      nearbyLocations = locationDetails['nearbyLandmarks'] as List<Map<String, String>>;
    } catch (e) {
      showSnackbar(context, e.toString());
      latitude = 'Error';
      longitude = 'Error';
      address = 'Error';
      nearbyLocations = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveLocation(String name, String locationAddress) async {
    final location = Location(
      name: name,
      latitude: double.tryParse(latitude) ?? 0.0,
      longitude: double.tryParse(longitude) ?? 0.0,
      address: locationAddress,
    );

    await sharedPreferencesHelper.saveLocation(location);
    showSnackbar(context, '$name saved successfully!');
  }

  Future<void> _promptForNameAndSave() async {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Save Current Location',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter a name', // Placeholder text
                    hintStyle: const TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          await _saveLocation(name, address);
                          Navigator.pop(context); // Close the dialog
                        } else {
                          showSnackbar(context, 'Name cannot be empty!');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue[900],
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  Widget _buildCurrentLocationCard() {
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
                  const Text(
                    'Current Location',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Latitude: $latitude',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    'Longitude: $longitude',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    'Address: $address',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.save_alt, color: Colors.blue),
              onPressed: _promptForNameAndSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandmarkCard(Map<String, String> landmark) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 120, // Consistent height for cards
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
                    landmark['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    landmark['address'] ?? 'No address available',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.save_alt, color: Colors.blue),
              onPressed: () => _saveLocation(
                landmark['name'] ?? 'Unknown',
                landmark['address'] ?? 'No address available',
              ),
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
        toolbarHeight: 120, // Increased height for a more prominent AppBar
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              size: 30, // Larger icon for emphasis
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              'Nearby Landmarks',
              style: TextStyle(
                fontSize: 28, // Larger and more readable font size
                fontWeight: FontWeight.bold,
                color: Colors.white, // Ensure good contrast
              ),
            ),
          ],
        ),
        centerTitle: false, // Title aligned to the left for a professional look
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, size: 30, color: Colors.black), // Dark blue color
            onPressed: () {
              Navigator.pushNamed(context, '/saved-locations');
            },
          ),
          const SizedBox(width: 10), // Add spacing for a cleaner layout
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue], // Refined gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/map_pattern.png'), // Subtle map pattern image
              fit: BoxFit.cover,
              opacity: 0.2, // Adds a subtle background effect
            ),
          ),
        ),
        elevation: 6, // Shadow for a modern look
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // Rounded bottom corners
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator() // Show a loading spinner
              : (address == 'Fetching...'
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap the button below to fetch your current location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _fetchLocation,
                icon: const Icon(Icons.my_location, size: 28),
                label: const Text(
                  'Get Current Location',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentLocationCard(),
              const SizedBox(height: 20),
              const Text(
                'Nearby Locations:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: nearbyLocations.length,
                  itemBuilder: (context, index) {
                    return _buildLandmarkCard(nearbyLocations[index]);
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

}
