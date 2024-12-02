class Destination {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;

  Destination({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  // Method to create a Destination object from Supabase map
  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'] as String,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      type: map['type'] as String,
    );
  }

  // Method to convert a Destination object to map (useful for saving data to Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    };
  }
}
