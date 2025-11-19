import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/controllers/ClienteController.dart';
import 'package:proyecto/controllers/UsuarioController.dart';
import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> Conexion(String correo, String password, String rolSeleccionado) async {
  UsuarioController usuarioCtrl = UsuarioController();
  ClienteController clienteCtrl = ClienteController();

  try {
    // 1. Autenticación con Supabase
    final res = await SupabaseService.client.auth.signInWithPassword(
      email: correo,
      password: password,
    );

    if (res.user == null) {
      print("❌ No se pudo iniciar sesión");
      return false;
    }

    final uid = res.user!.id;

    //Para almacenar los datos temporalmente
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    
    print("💾 UID guardado localmente: $uid");

    print("🔑 UID autenticado: $uid");

    // 2. Validar rol
    if (rolSeleccionado == "administrador") {
      Usuario? usuario = await usuarioCtrl.obtenerUsuario(uid);
      return usuario != null;
    }

    if (rolSeleccionado == "usuario") {
      Cliente? cliente = await clienteCtrl.obtenerCliente(uid);
      return cliente != null;
    }

    print("❌ Rol no reconocido");
    return false;

  } catch (e) {
    print("❌ Error en inicio de sesión: $e");
    return false;
  }
}
