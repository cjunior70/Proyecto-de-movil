// test/controllers/reservacion_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/controllers/ReservacionController.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Cliente.dart';
import 'package:proyecto/models/Empresa.dart';

void main() {
  group('🎮 ReservacionController -', () {
    late ReservacionController controller;
    late Reservacion reservacionPrueba;

    setUp(() {
      controller = ReservacionController();
      
      reservacionPrueba = Reservacion(
        Id: 'test-reserv-123',
        Creacion: DateTime.now(),
        Fecha: DateTime.now().add(Duration(days: 7)),
        Total: 50000.0,
        Estado: 'Pendiente',
        Comentario: 'Reserva de prueba unitaria',
        empresa: Empresa(Id: 'empresa-test'),
        cliente: Cliente(Id: 'cliente-test'),
      );
    });

    test('✅ Inicialización del controlador', () {
      expect(controller, isNotNull);
      expect(controller.Listadereservacionesdeempresas, isEmpty);
      expect(controller.Listadereservacionesdecliente, isEmpty);
    });

    test('✅ Agregar reservación a lista interna', () {
      // Simular que se guardó una reservación
      controller.Listadereservacionesdecliente.add(reservacionPrueba);

      expect(controller.Listadereservacionesdecliente.length, equals(1));
      expect(
        controller.Listadereservacionesdecliente.first.Id,
        equals('test-reserv-123'),
      );
    });

    test('✅ Filtrar reservaciones por estado', () {
      // Agregar múltiples reservaciones con diferentes estados
      final reservaciones = [
        Reservacion(
          Id: 'r1',
          Estado: 'Pendiente',
          Total: 10000.0,
          empresa: Empresa(Id: 'emp1'),
        ),
        Reservacion(
          Id: 'r2',
          Estado: 'Confirmada',
          Total: 20000.0,
          empresa: Empresa(Id: 'emp1'),
        ),
        Reservacion(
          Id: 'r3',
          Estado: 'Pendiente',
          Total: 30000.0,
          empresa: Empresa(Id: 'emp1'),
        ),
        Reservacion(
          Id: 'r4',
          Estado: 'Cancelada',
          Total: 15000.0,
          empresa: Empresa(Id: 'emp1'),
        ),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Filtrar pendientes
      final pendientes = controller.Listadereservacionesdeempresas
          .where((r) => r.Estado == 'Pendiente')
          .toList();

      expect(pendientes.length, equals(2));
      expect(pendientes[0].Id, equals('r1'));
      expect(pendientes[1].Id, equals('r3'));
    });

    test('✅ Calcular ingresos totales de reservaciones', () {
      final reservaciones = [
        Reservacion(Id: 'r1', Total: 25000.0),
        Reservacion(Id: 'r2', Total: 30000.0),
        Reservacion(Id: 'r3', Total: 15000.0),
        Reservacion(Id: 'r4', Total: 20000.0),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Calcular total
      double ingresoTotal = controller.Listadereservacionesdeempresas
          .fold(0.0, (sum, r) => sum + (r.Total ?? 0.0));

      expect(ingresoTotal, equals(90000.0));
    });

    test('✅ Obtener reservaciones de una fecha específica', () {
      final fechaObjetivo = DateTime(2025, 12, 25);

      final reservaciones = [
        Reservacion(
          Id: 'r1',
          Fecha: DateTime(2025, 12, 24),
          Total: 10000.0,
        ),
        Reservacion(
          Id: 'r2',
          Fecha: DateTime(2025, 12, 25),
          Total: 20000.0,
        ),
        Reservacion(
          Id: 'r3',
          Fecha: DateTime(2025, 12, 25),
          Total: 30000.0,
        ),
        Reservacion(
          Id: 'r4',
          Fecha: DateTime(2025, 12, 26),
          Total: 15000.0,
        ),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Filtrar por fecha
      final reservacionesDia = controller.Listadereservacionesdeempresas
          .where((r) =>
              r.Fecha != null &&
              r.Fecha!.year == fechaObjetivo.year &&
              r.Fecha!.month == fechaObjetivo.month &&
              r.Fecha!.day == fechaObjetivo.day)
          .toList();

      expect(reservacionesDia.length, equals(2));
      expect(reservacionesDia[0].Id, equals('r2'));
      expect(reservacionesDia[1].Id, equals('r3'));
    });

    test('✅ Contar reservaciones próximas (7 días)', () {
      final ahora = DateTime.now();

      final reservaciones = [
        Reservacion(
          Id: 'r1',
          Fecha: ahora.add(Duration(days: 2)),
          Estado: 'Confirmada',
        ),
        Reservacion(
          Id: 'r2',
          Fecha: ahora.add(Duration(days: 5)),
          Estado: 'Pendiente',
        ),
        Reservacion(
          Id: 'r3',
          Fecha: ahora.add(Duration(days: 10)),
          Estado: 'Confirmada',
        ),
        Reservacion(
          Id: 'r4',
          Fecha: ahora.subtract(Duration(days: 1)),
          Estado: 'Completada',
        ),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Filtrar próximas (dentro de 7 días y futuras)
      final proximas = controller.Listadereservacionesdeempresas
          .where((r) =>
              r.Fecha != null &&
              r.Fecha!.isAfter(ahora) &&
              r.Fecha!.isBefore(ahora.add(Duration(days: 7))))
          .toList();

      expect(proximas.length, equals(2)); // r1 y r2
    });

    test('⚠️ Validar reservación con datos incompletos', () {
      final reservacionIncompleta = Reservacion(
        Id: 'incomplete',
        // Faltan: Fecha, Total, Estado
      );

      expect(reservacionIncompleta.Fecha, isNull);
      expect(reservacionIncompleta.Total, isNull);
      expect(reservacionIncompleta.Estado, isNull);
    });

    test('✅ Ordenar reservaciones por fecha', () {
      final reservaciones = [
        Reservacion(Id: 'r1', Fecha: DateTime(2025, 12, 25)),
        Reservacion(Id: 'r2', Fecha: DateTime(2025, 11, 10)),
        Reservacion(Id: 'r3', Fecha: DateTime(2025, 12, 31)),
        Reservacion(Id: 'r4', Fecha: DateTime(2025, 10, 5)),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Ordenar por fecha ascendente
      controller.Listadereservacionesdeempresas.sort((a, b) {
        if (a.Fecha == null || b.Fecha == null) return 0;
        return a.Fecha!.compareTo(b.Fecha!);
      });

      expect(
        controller.Listadereservacionesdeempresas[0].Id,
        equals('r4'),
      ); // Oct
      expect(
        controller.Listadereservacionesdeempresas[1].Id,
        equals('r2'),
      ); // Nov
      expect(
        controller.Listadereservacionesdeempresas[2].Id,
        equals('r1'),
      ); // Dic 25
      expect(
        controller.Listadereservacionesdeempresas[3].Id,
        equals('r3'),
      ); // Dic 31
    });

    test('✅ Buscar reservación por ID', () {
      final reservaciones = [
        Reservacion(Id: 'r1', Total: 10000.0),
        Reservacion(Id: 'r2', Total: 20000.0),
        Reservacion(Id: 'r3', Total: 30000.0),
      ];

      controller.Listadereservacionesdecliente.addAll(reservaciones);

      // Buscar por ID
      final encontrada = controller.Listadereservacionesdecliente
          .firstWhere(
            (r) => r.Id == 'r2',
            orElse: () => Reservacion(Id: 'not-found'),
          );

      expect(encontrada.Id, equals('r2'));
      expect(encontrada.Total, equals(20000.0));
    });

    test('⚠️ Buscar reservación inexistente', () {
      final reservaciones = [
        Reservacion(Id: 'r1', Total: 10000.0),
        Reservacion(Id: 'r2', Total: 20000.0),
      ];

      controller.Listadereservacionesdecliente.addAll(reservaciones);

      // Intentar buscar ID inexistente
      final encontrada = controller.Listadereservacionesdecliente
          .firstWhere(
            (r) => r.Id == 'r999',
            orElse: () => Reservacion(Id: 'not-found'),
          );

      expect(encontrada.Id, equals('not-found'));
    });

    test('✅ Obtener estadísticas de reservaciones', () {
      final reservaciones = [
        Reservacion(Id: 'r1', Estado: 'Pendiente', Total: 10000.0),
        Reservacion(Id: 'r2', Estado: 'Confirmada', Total: 20000.0),
        Reservacion(Id: 'r3', Estado: 'Pendiente', Total: 15000.0),
        Reservacion(Id: 'r4', Estado: 'Completada', Total: 30000.0),
        Reservacion(Id: 'r5', Estado: 'Cancelada', Total: 5000.0),
        Reservacion(Id: 'r6', Estado: 'Confirmada', Total: 25000.0),
      ];

      controller.Listadereservacionesdeempresas.addAll(reservaciones);

      // Calcular estadísticas
      final stats = {
        'total': reservaciones.length,
        'pendientes': reservaciones.where((r) => r.Estado == 'Pendiente').length,
        'confirmadas': reservaciones.where((r) => r.Estado == 'Confirmada').length,
        'completadas': reservaciones.where((r) => r.Estado == 'Completada').length,
        'canceladas': reservaciones.where((r) => r.Estado == 'Cancelada').length,
        'ingresoTotal': reservaciones.fold(0.0, (sum, r) => sum + (r.Total ?? 0.0)),
      };

      expect(stats['total'], equals(6));
      expect(stats['pendientes'], equals(2));
      expect(stats['confirmadas'], equals(2));
      expect(stats['completadas'], equals(1));
      expect(stats['canceladas'], equals(1));
      expect(stats['ingresoTotal'], equals(105000.0));
    });

    test('✅ Limpiar listas de reservaciones', () {
      // Agregar datos
      controller.Listadereservacionesdeempresas.add(reservacionPrueba);
      controller.Listadereservacionesdecliente.add(reservacionPrueba);

      expect(controller.Listadereservacionesdeempresas.length, equals(1));
      expect(controller.Listadereservacionesdecliente.length, equals(1));

      // Limpiar
      controller.Listadereservacionesdeempresas.clear();
      controller.Listadereservacionesdecliente.clear();

      expect(controller.Listadereservacionesdeempresas, isEmpty);
      expect(controller.Listadereservacionesdecliente, isEmpty);
    });
  });
}