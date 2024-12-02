import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseService? _supabaseService;

  SupabaseService._instance() {
    _supabaseService = this;
  }

  factory SupabaseService() => _supabaseService ?? SupabaseService._instance();

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 5,
        timeout: Duration(seconds: 30),
      ),
    );
  }
}
