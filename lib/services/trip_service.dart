import 'package:flutter_atp/services/db/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripService {
  final DatabaseService _db = DatabaseService();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> insertTrip(Map<String, dynamic> tripData) async {
    try {
      final db = await _db.database;
      await db!.insert(
        'trips',
        tripData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to insert trip: ${e.toString()}');
    }
  }

  Future<void> insertKrlTrip(Map<String, dynamic> tripData) async {
    try {
      final db = await _db.database;
      await db!.insert('trip_stations', tripData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Failed to insert trip station: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getTrips() async {
    try {
      final db = await _db.database;
      final List<Map<String, dynamic>> trips = await db!.query('trips');
      return trips;
    } catch (e) {
      throw Exception('Failed to retrieve trips: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getTripsWithDestinations() async {
    final db = await _db.database;
    List<Map<String, dynamic>> enrichedTrips = [];

    try {
      final List<Map<String, dynamic>> trips = await db!.query('trips');

      for (var trip in trips) {
        final destinationId = trip['destination_id'];

        final response = await supabase
            .from('destinations')
            .select('*')
            .eq('id', destinationId)
            .single();

        if (response.isNotEmpty) {
          final enrichedTrip = {
            ...trip,
            'destination': response,
          };
          enrichedTrips.add(enrichedTrip);
        } else {
          throw Exception(
              'Failed to fetch destination for trip ID: $destinationId');
        }
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch trips with destinations: ${e.toString()}');
    }
    return enrichedTrips;
  }

  Future<List<Map<String, dynamic>>> getKrlTrips() async {
    final db = await _db.database;
    List<Map<String, dynamic>> enrichedTrips = [];

    try {
      final List<Map<String, dynamic>> trips = await db!.query('trip_stations');

      for (var trip in trips) {
        final stationId = trip['station_id'];

        final response = await supabase
            .from('stations')
            .select('*')
            .eq('station_id', stationId)
            .single();

        if (response.isNotEmpty) {
          final enrichedTrip = {
            ...trip,
            'station': response,
          };
          enrichedTrips.add(enrichedTrip);
        } else {
          throw Exception(
              'Failed to fetch destination for trip ID: $stationId');
        }
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch trips with destinations: ${e.toString()}');
    }
    return enrichedTrips;
  }

  Future<void> updateTrip(String tripId, Map<String, Object?> data) async {
    try {
      final db = await _db.database;

      await db!.update('trips', data, where: 'id = ?', whereArgs: [tripId]);
    } catch (e) {
      throw Exception('Failed to update trip: ${e.toString()}');
    }
  }

  Future<void> updateKrlTrip(String tripId, Map<String, Object?> data) async {
    try {
      final db = await _db.database;

      await db!
          .update('trip_stations', data, where: 'id = ?', whereArgs: [tripId]);
    } catch (e) {
      throw Exception('Failed to update krl trip: ${e.toString()}');
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      final db = await _db.database;
      await db!.delete(
        'trips',
        where: 'id = ?',
        whereArgs: [tripId],
      );
    } catch (e) {
      throw Exception('Failed to delete trip: ${e.toString()}');
    }
  }

  Future<void> deleteKrlTrip(String tripId) async {
    try {
      final db = await _db.database;
      await db!.delete(
        'trip_stations',
        where: 'id = ?',
        whereArgs: [tripId],
      );
    } catch (e) {
      throw Exception('Failed to delete krl trip: ${e.toString()}');
    }
  }
}
