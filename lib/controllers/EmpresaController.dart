import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Empresa.dart';

class EmpresaController {
  // Singleton
  static final EmpresaController _instance = EmpresaController._internal();
  factory EmpresaController() => _instance;
  EmpresaController._internal();

   // Lista de todas las empresas en memoria
  Empresa? datosdeempresa;

  List<Empresa> lista_de_empresas = [];

  // 1. Guardar empresa
  // Guardar Empresa publicamente si fuera privada tendria que colocar un _ jusnto al nomobre de la funcion
  Future<bool> guardarEmpresa(Empresa nuevoEmpresa) async {
    try{

      //Guardar los daots del Empresa temporalmente
      lista_de_empresas.add(nuevoEmpresa);

      await SupabaseService.client
          .from('Empresas')
          .insert(nuevoEmpresa.toJson());

      print("Empresa insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Empresa + $e" );

      return false;
    }
  }

  
  Future<List<Empresa>> obtenerTodasEmpresas() async {
  try {
    final respuesta = await SupabaseService.client
        .from('Empresas')
        .select();

    print("Empresas encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Empresa
    final List<Empresa> listaEmpresas = (respuesta as List)
        .map((e) => Empresa.fromJson(e as Map<String, dynamic>))
        .toList();

    lista_de_empresas = listaEmpresas;
    return listaEmpresas;
  } catch (e) {
    print("Hay un problema al obtener las empresas: $e");
    return [];
  }
}

  Empresa? FiltrarEmpresa(String id) {
    try {
      return lista_de_empresas.firstWhere(
        (empresa) => empresa.Id == id,
      );
    } catch (e) {
      return null; // si no existe
    }
  }


  // 3. Obtener una empresa por id del usuario
  Future<List<Empresa>> obtenerEmpresasPorUsuario(String usuarioId) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Empresas')
        .select()
        .eq("Id_Usuario", usuarioId);

    print("Empresas encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Empresa
    final List<Empresa> listaEmpresas = (respuesta as List)
        .map((e) => Empresa.fromJson(e as Map<String, dynamic>))
        .toList();

    lista_de_empresas = listaEmpresas;
    print(listaEmpresas);
    return listaEmpresas;
  } catch (e) {
    print("Hay un problema al obtener las empresas: $e");
    return [];
  }
}


  // 5. Actualizar una empresa existente
  Future<bool> actualizarEmpresa(Empresa EmpresaActualizado) async {
    try{

      

      await SupabaseService.client
          .from('Empresas')
          .update(EmpresaActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", EmpresaActualizado.Id!);

      print("Empresa actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Empresa + $e" );

      return false;
    }
  }


  // 2. Eliminar empresa por ID
 Future<bool> eliminarEmpresa(String Id)  async{
    try{

      await SupabaseService.client
          .from('Empresas')
          .delete()
          .eq("Id",Id);

      print("Empresa borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Empresa + $e" );

      return false;
    }
  }
} 