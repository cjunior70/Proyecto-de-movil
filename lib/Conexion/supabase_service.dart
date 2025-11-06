import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  SupabaseService._internal();

  factory SupabaseService() => _instance;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://hgkcimmvcuvpqcwnuthn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhna2NpbW12Y3V2cHFjd251dGhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NTE1MzAsImV4cCI6MjA3NTUyNzUzMH0.DWGIJ9sfdigmKqEGOFovo22Kyd6cU2AUnVTPz8bNbkY',
    );
  }
}
