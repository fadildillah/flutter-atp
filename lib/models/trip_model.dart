class Trip {
  final String id;
  final String destinationId;
  final DateTime startTime;
  final String status;

  Trip({
    required this.id,
    required this.destinationId,
    required this.startTime,
    required this.status,
  });

  // Method to create a Trip object from Supabase map
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String,
      destinationId: map['destination_id'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      status: map['status'] as String,
    );
  }

  // Method to convert a Trip object to map (useful for saving data to Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination_id': destinationId,
      'start_time': startTime.toIso8601String(),
      'status': status,
    };
  }
}
