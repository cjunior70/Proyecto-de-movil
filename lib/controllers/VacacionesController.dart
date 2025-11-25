import 'package:proyecto/Models/Vacaciones.dart';

class VacacionesController {
  Vacaciones? _vacaciones; // única instancia en memoria

  // ✅ Guardar vacaciones
  void guardarVacaciones(Vacaciones nuevasVacaciones) {
    if (_vacaciones != null) {
      //print("⚠️ Ya existen vacaciones registradas. Usa actualizarVacaciones().");
      return;
    }

    _vacaciones = nuevasVacaciones;
    //print("✅ Vacaciones registradas desde ${_vacaciones!.Inicio} hasta ${_vacaciones!.Final}");
  }

  // ✅ Obtener vacaciones actuales
  Vacaciones? obtenerVacaciones() {
    if (_vacaciones == null) {
      //print("⚠️ No hay vacaciones registradas actualmente.");
      return null;
    }
    return _vacaciones;
  }

  // ✅ Actualizar vacaciones
  void actualizarVacaciones(Vacaciones vacacionesActualizadas) {
    if (_vacaciones == null) {
      //print("⚠️ No hay vacaciones registradas para actualizar.");
      return;
    }

    if (_vacaciones!.Id != vacacionesActualizadas.Id) {
      //print("⚠️ El ID no coincide con las vacaciones actuales.");
      return;
    }

    _vacaciones = vacacionesActualizadas;
    //print("🔄 Vacaciones actualizadas: ${_vacaciones!.Inicio} → ${_vacaciones!.Final}");
  }

  // ✅ Eliminar vacaciones
  void eliminarVacaciones() {
    if (_vacaciones == null) {
      //print("⚠️ No hay vacaciones registradas para eliminar.");
      return;
    }

    //print("🗑️ Vacaciones eliminadas: ${_vacaciones!.Inicio} → ${_vacaciones!.Final}");
    _vacaciones = null;
  }

  // ✅ Mostrar resumen
  void mostrarResumen() {
    if (_vacaciones == null) {
      //print("⚠️ No hay vacaciones registradas.");
      return;
    }
  }
}