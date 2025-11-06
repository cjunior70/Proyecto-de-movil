import 'package:flutter/material.dart';
import 'package:proyecto/ui/app.dart';
import 'package:proyecto/Conexion/supabase_service.dart'; // importa tu servicio

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // NECESARIO antes de inicializar
  await SupabaseService.init(); // Inicializa Supabase
  print("✅ Supabase inicializado correctamente");
  runApp(const MyApp());
}
