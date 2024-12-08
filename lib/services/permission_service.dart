import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check and request location permission
  Future<bool> requestLocationPermission() async {
    // Check the current permission status
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true; // Permission already granted
    } else if (status.isDenied || status.isRestricted) {
      // Request permission
      final result = await Permission.locationWhenInUse.request();
      return result.isGranted; // Return true if permission is granted
    } else if (status.isPermanentlyDenied) {
      // Inform the user to enable permission from settings
      return false; // Permission cannot be requested programmatically
    }

    return false; // Default fallback
  }

  /// Check if location permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    return await Permission.locationWhenInUse.isPermanentlyDenied;
  }
}
