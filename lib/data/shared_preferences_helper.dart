import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

class SharedPreferencesHelper {
  static const String _locationsKey = 'saved_locations';

  /// Save a location to SharedPreferences
  Future<void> saveLocation(Location location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current list of saved locations
    List<String> savedLocations =
        prefs.getStringList(_locationsKey) ?? <String>[];

    // Add the new location as a JSON string
    savedLocations.add(jsonEncode(location.toMap()));

    // Save the updated list back to SharedPreferences
    await prefs.setStringList(_locationsKey, savedLocations);
  }

  /// Retrieve all saved locations from SharedPreferences
  Future<List<Location>> getSavedLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the list of saved locations
    List<String> savedLocations =
        prefs.getStringList(_locationsKey) ?? <String>[];

    // Decode each JSON string into a Location object
    return savedLocations
        .map((locationJson) => Location.fromMap(jsonDecode(locationJson)))
        .toList();
  }

  /// Clear all saved locations
  Future<void> clearSavedLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationsKey);
  }
}
