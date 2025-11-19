import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/Models/Cliente.dart';

class ClienteController {
  // Singleton privada 
  static final ClienteController _instance = ClienteController._internal();
  factory ClienteController() => _instance;
  ClienteController._internal();

  Cliente? _cliente;

  // Guardar cliente publicamente si fuera privada tendria que colocar un _ jusnto al nomobre de la funcion
  Future<bool> guardarCliente(Cliente nuevoCliente) async {
    try{

      //Guardar los daots del cliente temporalmente
      _cliente = nuevoCliente;

      final uid = await _crearClienteAuth(nuevoCliente);

      if (uid == null) {
        print("❌ No se pudo crear el usuario. Proceso detenido.");
        return false;
      }
      else{
         print("todo en orden uid : ${uid} ");
      }

      nuevoCliente.Id = uid;

      await SupabaseService.client
          .from('Clientes')
          .insert(nuevoCliente.toJson());

      print("Cliente insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del cliente + $e" );

      return false;
    }
  }

  Future<String?> _crearClienteAuth(Cliente cliente) async {
    try {
      final res = await SupabaseService.client.auth.signUp(
        email: cliente.Correo,
        password: cliente.Cedula!, // la cédula como contraseña
        data: {
          'nombre': cliente.PrimerNombre,
          'telefono': cliente.Telefono,
        },
      );

      return res.user?.id; // devuelve el UID de Supabase
    } catch (e) {
      print("❌ Error creando usuario en autenticación: $e");
      return null;
    }
  }

  // Obtener cliente
  Future<Cliente?> obtenerCliente(String Id) async {
    try{

      final respuesta = await SupabaseService.client
          .from('Clientes')
          .select().eq("Id", Id)
          //Single es para traer solo un registro
          .single();

      print("Cliente encontrado correctamente en Supabase : $respuesta");

      _cliente=Cliente.fromJson(respuesta);

      return _cliente;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el cliente + $e" );

      return null;
    }

  }

  // Actualizar cliente
  Future<bool> actualizarCliente(Cliente clienteActualizado) async {
    try{

    print(clienteActualizado);
    print("Utimas modificaciones");

      await SupabaseService.client
          .from('Clientes')
          .update(clienteActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", clienteActualizado.Id!).select();

      print("Cliente actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el cliente + $e" );

      return false;
    }
  }

   // Eliminar cliente
  Future<bool> eliminarCliente(Cliente nuevoCliente)  async{
    try{

      await SupabaseService.client
          .from('Clientes')
          .delete()
          .eq("Id", nuevoCliente.Id!);

      print("Cliente borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el cliente + $e" );

      return false;
    }
  }


}
