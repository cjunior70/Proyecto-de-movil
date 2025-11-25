import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Reservacion.dart';

class ReservacionController {
  Reservacion? _reservacion;

  List<Reservacion> Listadereservacionesdeempresas = [];
  List<Reservacion> Listadereservacionesdecliente = [];

  // Guardar la reservación (recibe el objeto completo)
  Future<bool> guardarReservacion(Reservacion nuevoReservacion) async {
    try{

      //Guardar los daots del Reservacion temporalmente
      _reservacion = nuevoReservacion;

      await SupabaseService.client
          .from('Reservaciones')
          .insert(nuevoReservacion.toJson());

      //print("Reservacion insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      //print("Hay un problema en el guardado del Reservacion + $e" );

      return false;
    }
  }

  
  Future<List<Reservacion>> obtenerReservacionesPorEmpresa(String Empresa_id) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Reservaciones')
        .select()
        .eq("Id_Empresa", Empresa_id);

    //print("Reservacions encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Reservacion
    final List<Reservacion> listaReservacions = (respuesta as List)
        .map((e) => Reservacion.fromJson(e as Map<String, dynamic>))
        .toList();

    Listadereservacionesdeempresas = listaReservacions;
    //print(listaReservacions);
    return listaReservacions;
  } catch (e) {
    //print("Hay un problema al obtener las Reservacions: $e");
    return [];
  }
}

  // 3. Obtener una Reservacion por id del usuario
  Future<List<Reservacion>> obtenerReservacionesPorCliente(String Cliente_id) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Reservaciones')
        .select()
        .eq("Id_Cliente", Cliente_id);

    //print("Reservacions encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Reservacion
    final List<Reservacion> listaReservacions = (respuesta as List)
        .map((e) => Reservacion.fromJson(e as Map<String, dynamic>))
        .toList();

    Listadereservacionesdecliente = listaReservacions;
    //print(listaReservacions);
    return listaReservacions;
  } catch (e) {
    //print("Hay un problema al obtener las Reservacions: $e");
    return [];
  }
}


  // 5. Actualizar una Reservacion existente
  Future<bool> actualizarReservacion(Reservacion ReservacionActualizado) async {
    try{

      await SupabaseService.client
          .from('Reservaciones')
          .update(ReservacionActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", ReservacionActualizado.Id!);

      //print("Reservacion actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      //print("Hay un problema en el eliminar el Reservacion + $e" );

      return false;
    }
  }


  // 2. Eliminar Reservacion por ID
 Future<bool> eliminarReservacion(String Id)  async{
    try{

      await SupabaseService.client
          .from('Reservaciones')
          .delete()
          .eq("Id",Id);

      //print("Reservacion borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      //print("Hay un problema en el eliminar el Reservacion + $e" );

      return false;
    }
  }
}
