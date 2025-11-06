import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Usuario.dart';
import 'package:proyecto/Models/Empresa.dart';

class UsuarioController {

  static final UsuarioController _instance = UsuarioController._internal();
  factory UsuarioController() => _instance;
  UsuarioController._internal();

  Usuario? _usuario; // único usuario en memoria

  // Guardar usuario publicamente si fuera privada tendria que colocar un _ jusnto al nomobre de la funcion
  Future<bool> guardarUsuario(Usuario nuevoUsuario) async {
    try{

      //Guardar los daots del Usuario temporalmente
      _usuario = nuevoUsuario;

      await SupabaseService.client
          .from('Usuarios')
          .insert(nuevoUsuario.toJson());

      print("Usuario insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Usuario + $e" );

      return false;
    }
  }

  // ✅ Obtener usuario actual
  Future<Usuario?> obtenerUsuario(String Id) async {
    try{

      final respuesta = await SupabaseService.client
          .from('Usuarios')
          .select().eq("Id", Id)
          //Single es para traer solo un registro
          .single();

      print("Usuario encontrado correctamente en Supabase : $respuesta");

      _usuario=Usuario.fromJson(respuesta);

      return _usuario;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Usuario + $e" );

      return null;
    }

  }
  // ✅ Actualizar usuario
  Future<bool> actualizarUsuario(Usuario UsuarioActualizado) async {
    try{

      await SupabaseService.client
          .from('Usuarios')
          .update(UsuarioActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", UsuarioActualizado.Id!);

      print("Usuario actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Usuario + $e" );

      return false;
    }
  }

  // ✅ Eliminar usuario
 Future<bool> eliminarUsuario(String Id)  async{
    try{

      await SupabaseService.client
          .from('Usuarios')
          .delete()
          .eq("Id", Id);

      print("Usuario borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Usuario + $e" );

      return false;
    }
  }


}
