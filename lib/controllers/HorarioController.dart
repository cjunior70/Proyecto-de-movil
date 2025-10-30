// import 'package:proyecto/Models/Horario.dart';


// class HorarioController {
//   List<Horario> listaDeHorarios = [];

//   // 🔹 1. Guardar horario
//   void guardarHorario(Horario nuevoHorario) {
//     listaDeHorarios.add(nuevoHorario);
//     print("✅ Horario agregado para el día: ${nuevoHorario.DiaSemana}");
//   }

//   // 🔹 2. Eliminar horario por ID
//   void eliminarHorarioPorId(String id) {
//     listaDeHorarios.removeWhere((h) => h.Id == id);
//     print("🗑️ Horario con ID $id eliminado correctamente.");
//   }

//   // 🔹 3. Buscar horario por día o ID
//   Horario? obtenerHorarioPorId(String id) {
//     try {
//       return listaDeHorarios.firstWhere((h) => h.Id == id);
//     } catch (e) {
//       print("⚠️ No se encontró un horario con ID $id");
//       return null;
//     }
//   }

//   Horario? obtenerHorarioPorDia(String diaSemana) {
//     try {
//       return listaDeHorarios.firstWhere(
//         (h) => h.DiaSemana.toLowerCase() == diaSemana.toLowerCase(),
//       );
//     } catch (e) {
//       print("⚠️ No se encontró un horario para el día $diaSemana");
//       return null;
//     }
//   }

//   // 🔹 4. Actualizar horario
//   void actualizarHorario(Horario horarioActualizado) {
//     final index = listaDeHorarios.indexWhere((h) => h.Id == horarioActualizado.Id);
//     if (index == -1) {
//       print("⚠️ No existe un horario con ID ${horarioActualizado.Id}");
//       return;
//     }

//     listaDeHorarios[index] = horarioActualizado;
//     print("🔄 Horario actualizado correctamente para el día: ${horarioActualizado.DiaSemana}");
//   }

//   // 🔹 5. Mostrar todos los horarios
//   void mostrarHorarios() {
//     if (listaDeHorarios.isEmpty) {
//       print("⚠️ No hay horarios registrados.");
//       return;
//     }

//     print("📅 Lista de Horarios Registrados:");
//     //for (var h in listaDeHorarios) {
//       // print("""
//       // 🗓️ Día: ${h.DiaSemana}
//       // 👨‍💼 Empleado: ${h.empleado} ${h.empleado.PrimerNombre}
//       // 🌅 Mañana: ${h.TurnoManana?.format(const TimeOfDayFormat.HH_colon_mm) ?? 'No asignado'}
//       // 🌇 Tarde: ${h.TurnoTarde?.format(const TimeOfDayFormat.HH_colon_mm) ?? 'No asignado'}
//       // 🌙 Noche: ${h.TurnoNoche?.format(const TimeOfDayFormatHH_colon_mm) ?? 'No asignado'}
//       // ---------------------------------------------
//       // """);
//     //}
//   }
// }
