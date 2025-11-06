import 'package:proyecto/Models/Reservacion.dart';

class ReservacionController {
  Reservacion? _reservacion;

  // ✅ Guardar la reservación (recibe el objeto completo)
  void guardarReservacion(Reservacion reservacion) {
    _reservacion = reservacion;
    print("✅ Reservación guardada correctamente.");
  }

  // ✅ Obtener la reservación
  Reservacion? obtenerReservacion() {
    return _reservacion;
  }

  // // ✅ Mostrar la información de la reservación
  // void mostrarReservacion() {
  //   if (_reservacion == null) {
  //     print("⚠️ No hay ninguna reservación registrada.");
  //     return;
  //   }

  //   print("===== RESERVACIÓN =====");
  //   print("ID: ${_reservacion!.Id}");
  //   print("Creación: ${_reservacion!.Creacion}");
  //   print("Fecha: ${_reservacion!.Fecha}");
  //   print("Total: \$${_reservacion!.Total}");
  //   print("Estado: ${_reservacion!.Estado}");
  //   print("Comentario: ${_reservacion!.Comentario ?? 'Ninguno'}");
  //   print("Estrellas: ${_reservacion!.Estrellas ?? 'Sin calificar'}");
  //   print("Empresa: ${_reservacion!.empresa.Nombre}");
  //   print("Cliente: ${_reservacion!.cliente.PrimerNombre}");
  //   print(
  //       "Empleados asignados: ${_reservacion!.ListaDeEmpleados?.length ?? 0}");
  // }
}
