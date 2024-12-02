class UserLocationModel {
  final String id;
  final String tripId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  UserLocationModel({
    required this.id,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'],
      tripId: json['tripId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
