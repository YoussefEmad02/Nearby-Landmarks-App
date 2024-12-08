class Location {
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'] ?? 'Unknown Name', // Provide a default name
      latitude: map['latitude'] ?? 0.0, // Default to 0.0 if null
      longitude: map['longitude'] ?? 0.0, // Default to 0.0 if null
      address: map['address'] ?? 'Unknown Address', // Default address
    );
  }
}
