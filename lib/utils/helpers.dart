import 'package:flutter/material.dart';

// Helper function to show a snackbar with a message
void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Helper function to format coordinates into a readable string
String formatCoordinates(double latitude, double longitude) {
  return 'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}';
}

// Helper function to handle errors gracefully
String handleError(dynamic error) {
  return 'An error occurred: ${error.toString()}';
}
