import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/Models/Contabilidad.dart';

class ContabilidadController {
  Contabilidad? contabilidad; // solo una contabilidad activa

  List<Contabilidad> ListadeContabilidadesdeempresas = [];

  //  Obtener contabilidad de la empresax|
  Future<List<Contabilidad>> obtenerContabilidadesPorEmpresa(String Empresa_id) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Contabilidad')
        .select()
        .eq("Id_Empresa", Empresa_id);

    print("Contabilidads encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Contabilidad
    final List<Contabilidad> listaContabilidads = (respuesta as List)
        .map((e) => Contabilidad.fromJson(e as Map<String, dynamic>))
        .toList();

    ListadeContabilidadesdeempresas = listaContabilidads;
    print(listaContabilidads);
    return listaContabilidads;
  } catch (e) {
    print("Hay un problema al obtener las Contabilidads: $e");
    return [];
  }
}

}
