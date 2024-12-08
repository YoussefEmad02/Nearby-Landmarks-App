import 'package:geocoding/geocoding.dart';

class GeocodingService {
  /// Fetch address and nearby contextual details
  static Future<Map<String, dynamic>> getLocationDetails(
      double latitude, double longitude) async {
    try {
      // Fetch the human-readable address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      String address = "Unknown Address";
      List<Map<String, String>> nearbyLandmarks = [];

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Construct address
        address = "${place.street}, ${place.locality}, ${place.country}";

        // Add only landmarks with names to the nearbyLandmarks list
        if (place.locality != null && place.locality!.isNotEmpty) {
          nearbyLandmarks.add({'name': place.locality!, 'address': address});
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          nearbyLandmarks.add({'name': place.subLocality!, 'address': address});
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          nearbyLandmarks.add({
            'name': place.administrativeArea!,
            'address': address,
          });
        }
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          nearbyLandmarks.add({'name': place.thoroughfare!, 'address': address});
        }
      }

      return {
        'address': address,
        'nearbyLandmarks': nearbyLandmarks,
      };
    } catch (e) {
      throw Exception('Failed to fetch location details: $e');
    }
  }
}
