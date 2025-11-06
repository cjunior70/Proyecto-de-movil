import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Empleado.dart';

class EmpleadoController {
  Empleado? empleado; // único empleado en memoria

  List<Empleado> lista_de_Empleados = [];

  // 🔹 1. Guardar empleado
  Future<bool> guardarEmpleado(Empleado nuevoEmpleado) async {
    try{

      //Guardar los daots del Empleado temporalmente
      empleado = nuevoEmpleado;

      await SupabaseService.client
          .from('Empleados')
          .insert(nuevoEmpleado.toJson());

      print("Empleado insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Empleado + $e" );

      return false;
    }
  }

//   // 🔹 2. Eliminar empleado
//   Future<List<Empleado>> obtenerTodasEmpleados() async {
//   try {
//     final respuesta = await SupabaseService.client
//         .from('Empleados')
//         .select();

//     print("Empleados encontradas correctamente en Supabase: $respuesta");

//     // Convertir la lista de mapas a lista de objetos Empleado
//     final List<Empleado> listaEmpleados = (respuesta as List)
//         .map((e) => Empleado.fromJson(e as Map<String, dynamic>))
//         .toList();

//     lista_de_Empleados = listaEmpleados;
//     return listaEmpleados;
//   } catch (e) {
//     print("Hay un problema al obtener las Empleados: $e");
//     return [];
//   }
// }

  // 🔹 3. Obtener empleado actual
  Future<List<Empleado>> obtenerEmpleadosPorEmpresa(String EmpresaId) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Empleados')
        .select()
        .eq("Id_Empresa", EmpresaId);

    print("Empleados encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Empleado
    final List<Empleado> listaEmpleados = (respuesta as List)
        .map((e) => Empleado.fromJson(e as Map<String, dynamic>))
        .toList();

    lista_de_Empleados = listaEmpleados;
    print(listaEmpleados);
    return listaEmpleados;
  } catch (e) {
    print("Hay un problema al obtener las Empleados: $e");
    return [];
  }
}

  // 🔹 4. Actualizar empleado existente
 Future<bool> actualizarEmpleado(Empleado EmpleadoActualizado) async {
    try{

      await SupabaseService.client
          .from('Empleados')
          .update(EmpleadoActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", EmpleadoActualizado.Id!);

      print("Empleado actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Empleado + $e" );

      return false;
    }
  }

  // 2. Eliminar Empleado por ID
 Future<bool> eliminarEmpleado(String Id)  async{
    try{

      await SupabaseService.client
          .from('Empleados')
          .delete()
          .eq("Id",Id);

      print("Empleado borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Empleado + $e" );

      return false;
    }
  }

}
