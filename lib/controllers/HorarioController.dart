import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Horario.dart';


class HorarioController {
  List<Horario> listaDeHorarios = [];

  Horario? datosdeHorario;

  // Guardar Horario publicamente si fuera privada tendria que colocar un _ jusnto al nomobre de la funcion
  Future<bool> guardarHorario(Horario nuevoHorario) async {
    try{

      //Guardar los daots del Horario temporalmente
      datosdeHorario = nuevoHorario;

      await SupabaseService.client
          .from('Horario')
          .insert(nuevoHorario.toJson());

      print("Horario insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Horario + $e" );

      return false;
    }
  }

  
  Future<List<Horario>> obtenerTodasHorarios() async {
  try {
    final respuesta = await SupabaseService.client
        .from('Horario')
        .select();

    print("Horarios encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Horario
    final List<Horario> listaHorarios = (respuesta as List)
        .map((e) => Horario.fromJson(e as Map<String, dynamic>))
        .toList();

    listaDeHorarios = listaHorarios;
    return listaHorarios;
  } catch (e) {
    print("Hay un problema al obtener las Horarios: $e");
    return [];
  }
}

  // 3. Obtener una Horario por id del usuario
  Future<List<Horario>> obtenerHorariosPorUsuario(String usuarioId) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Horario')
        .select()
        .eq("Id_Empleado", usuarioId);

    print("Horarios encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Horario
    final List<Horario> listaHorarios = (respuesta as List)
        .map((e) => Horario.fromJson(e as Map<String, dynamic>))
        .toList();

    listaDeHorarios = listaHorarios;
    print(listaHorarios);
    return listaHorarios;
  } catch (e) {
    print("Hay un problema al obtener las Horarios: $e");
    return [];
  }
}


  // 5. Actualizar una Horario existente
  Future<bool> actualizarHorario(Horario HorarioActualizado) async {
    try{

      await SupabaseService.client
          .from('Horario')
          .update(HorarioActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", HorarioActualizado.Id!);

      print("Horario actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Horario + $e" );

      return false;
    }
  }


  // 2. Eliminar Horario por ID
 Future<bool> eliminarHorario(String Id)  async{
    try{

      await SupabaseService.client
          .from('Horario')
          .delete()
          .eq("Id",Id);

      print("Horario borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Horario + $e" );

      return false;
    }
  }
 
}
