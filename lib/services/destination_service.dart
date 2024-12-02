import 'package:flutter_atp/models/destination_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DestinationService {
  final supabase = Supabase.instance.client;

  Future<List<Destination>> getAllDestination() async {
    final response = await supabase.from('destinations').select('*');

    if (response.isEmpty) {
      throw Exception('Failed to load destinations');
    }

    return (response as List)
        .map((destination) => Destination.fromMap(destination))
        .toList();
  }

  Future<List<Destination>> getDestinationByType(String type) async {
    final response =
        await supabase.from('destinations').select('*').eq('type', type);

    if (response.isEmpty) {
      throw Exception('Failed to load destinations by type');
    }

    return (response as List)
        .map((destination) => Destination.fromMap(destination))
        .toList();
  }

  Future<List<Destination>> getDestinationById(String id) async {
    final response =
        await supabase.from('destinations').select('*').eq('id', id);

    if (response.isEmpty) {
      throw Exception('Failed to load destinations by id');
    }

    return (response as List)
        .map((destination) => Destination.fromMap(destination))
        .toList();
  }

  Future<PostgrestList> getKrlCities() async {
    final response = await supabase.from('cities').select('*');

    if (response.isEmpty) {
      throw Exception('Failed to load KRL cities');
    }

    return response;
  }

  Future<PostgrestList> getKrlLines() async {
    final response = await supabase.from('lines').select('*');

    if (response.isEmpty) {
      throw Exception('Failed to load KRL lines');
    }

    return response;
  }

  Future<PostgrestList> getKrlLinesByCity(String city) async {
    final response = await supabase
        .from('lines')
        .select('*, cities!inner(name)')
        .eq('cities.name', city);

    if (response.isEmpty) {
      throw Exception('Failed to load KRL lines');
    }

    return response;
  }

  Future<PostgrestList> getKrlStationsByCityAndLine(
      String city, String line) async {
    final response = await supabase.rpc('get_krl_stations_by_city_and_line',
        params: {'city_name_param': city, 'line_name_param': line}).select('*');

    if (response.isEmpty) {
      throw Exception('Failed to load KRL stations');
    }

    return response;
  }
}
