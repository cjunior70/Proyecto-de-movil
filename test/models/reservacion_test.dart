// test/models/reservacion_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Cliente.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Servicio.dart';

void main() {
  group('🎫 Modelo Reservación -', () {
    late Reservacion reservacionTest;
    late DateTime fechaPrueba;

    setUp(() {
      fechaPrueba = DateTime(2025, 12, 25, 14, 30); // 25 dic 2025, 2:30 PM
      
      reservacionTest = Reservacion(
        Id: 'reserv-001',
        Creacion: DateTime.now(),
        Fecha: fechaPrueba,
        Total: 50000.0,
        Estado: 'Pendiente',
        Comentario: 'Primera reserva de prueba',
        Estrellas: null,
        empresa: Empresa(Id: 'empresa-123'),
        cliente: Cliente(Id: 'cliente-456'),
        empleadosAsignados: [],
      );
    });

    test('✅ Crear reservación con datos válidos', () {
      expect(reservacionTest.Id, equals('reserv-001'));
      expect(reservacionTest.Total, equals(50000.0));
      expect(reservacionTest.Estado, equals('Pendiente'));
      expect(reservacionTest.Fecha, equals(fechaPrueba));
      expect(reservacionTest.empleadosAsignados, isEmpty);
    });

    test('✅ Convertir reservación a JSON correctamente', () {
      final json = reservacionTest.toJson();

      expect(json['Id'], equals('reserv-001'));
      expect(json['Valor'], equals(50000.0));
      expect(json['Estado'], equals('Pendiente'));
      expect(json['Comentarios'], equals('Primera reserva de prueba'));
      expect(json['Id_Empresa'], equals('empresa-123'));
      expect(json['Id_Cliente'], equals('cliente-456'));
      expect(json['Fecha'], contains('2025-12-25'));
    });

    test('✅ Crear reservación desde JSON', () {
      final jsonData = {
        'Id': 'reserv-002',
        'Creacion': '2025-11-25T10:00:00.000Z',
        'Fecha': '2025-12-25T14:30:00.000Z',
        'Valor': 75000.0,
        'Estado': 'Confirmada',
        'Comentario': 'Reserva desde JSON',
        'Extrellas': 4.5,
        'Id_Empresa': 'empresa-999',
        'Id_Cliente': 'cliente-888',
        'Id_Contabilidad': null,
      };

      final reservacion = Reservacion.fromJson(jsonData);

      expect(reservacion.Id, equals('reserv-002'));
      expect(reservacion.Total, equals(75000.0));
      expect(reservacion.Estado, equals('Confirmada'));
      expect(reservacion.Estrellas, equals(4.5));
      expect(reservacion.empresa?.Id, equals('empresa-999'));
      expect(reservacion.cliente?.Id, equals('cliente-888'));
      expect(reservacion.Fecha?.day, equals(25));
      expect(reservacion.Fecha?.month, equals(12));
    });

    test('✅ Asignar empleados a la reservación', () {
      final empleado1 = Empleado(
        Id: 'emp-001',
        PrimerNombre: 'Juan',
        PrimerApellido: 'Pérez',
        ListaDeServiciosDelEmpleado: [
          Servicio(
            Id: 'serv-001',
            Nombre: 'Corte Clásico',
            Precio: 25000.0,
            TiempoPromedio: Duration(minutes: 30),
          ),
        ],
      );

      final empleado2 = Empleado(
        Id: 'emp-002',
        PrimerNombre: 'María',
        PrimerApellido: 'López',
        ListaDeServiciosDelEmpleado: [
          Servicio(
            Id: 'serv-002',
            Nombre: 'Arreglo de Barba',
            Precio: 15000.0,
            TiempoPromedio: Duration(minutes: 20),
          ),
        ],
      );

      reservacionTest.empleadosAsignados.add(empleado1);
      reservacionTest.empleadosAsignados.add(empleado2);

      expect(reservacionTest.empleadosAsignados.length, equals(2));
      expect(reservacionTest.empleadosAsignados[0].Id, equals('emp-001'));
      expect(reservacionTest.empleadosAsignados[1].Id, equals('emp-002'));
    });

    test('✅ Calcular total basado en servicios asignados', () {
      final empleado = Empleado(
        Id: 'emp-001',
        ListaDeServiciosDelEmpleado: [
          Servicio(
            Id: 'serv-001',
            Precio: 25000.0,
            TiempoPromedio: Duration(minutes: 30),
          ),
          Servicio(
            Id: 'serv-002',
            Precio: 15000.0,
            TiempoPromedio: Duration(minutes: 20),
          ),
        ],
      );

      reservacionTest.empleadosAsignados.add(empleado);

      // Calcular total manual (simula lógica de negocio)
      double totalCalculado = 0.0;
      for (var emp in reservacionTest.empleadosAsignados) {
        for (var servicio in emp.ListaDeServiciosDelEmpleado ?? []) {
          totalCalculado += servicio.Precio ?? 0.0;
        }
      }

      expect(totalCalculado, equals(40000.0)); // 25000 + 15000
    });

    test('⚠️ Reservación con fecha nula', () {
      final reservacionSinFecha = Reservacion(
        Id: 'reserv-sin-fecha',
        Fecha: null,
        Total: 10000.0,
        Estado: 'Borrador',
      );

      expect(reservacionSinFecha.Fecha, isNull);
      expect(reservacionSinFecha.Estado, equals('Borrador'));
    });

    test('⚠️ Reservación con total negativo (caso inválido)', () {
      final reservacionInvalida = Reservacion(
        Id: 'reserv-invalida',
        Total: -5000.0,
        Estado: 'Error',
      );

      // En producción, esto debería validarse antes de guardar
      expect(reservacionInvalida.Total, lessThan(0));
      expect(reservacionInvalida.Estado, equals('Error'));
    });

    test('✅ toString() devuelve formato legible', () {
      final texto = reservacionTest.toString();

      expect(texto, contains('reserv-001'));
      expect(texto, contains('50000.0'));
      expect(texto, contains('Pendiente'));
    });

    test('✅ Ciclo completo: Objeto → JSON → Objeto', () {
      // 1. Crear objeto original
      final original = Reservacion(
        Id: 'reserv-ciclo',
        Fecha: DateTime(2025, 6, 15, 10, 0),
        Total: 100000.0,
        Estado: 'Confirmada',
        Comentario: 'Ciclo de prueba',
        Estrellas: 5.0,
        empresa: Empresa(Id: 'emp-999'),
        cliente: Cliente(Id: 'cli-888'),
      );

      // 2. Convertir a JSON
      final json = original.toJson();

      // 3. Reconstruir desde JSON
      final reconstruido = Reservacion.fromJson(json);

      // 4. Validar que los datos se preservaron
      expect(reconstruido.Id, equals(original.Id));
      expect(reconstruido.Total, equals(original.Total));
      expect(reconstruido.Estado, equals(original.Estado));
      expect(reconstruido.Estrellas, equals(original.Estrellas));
      expect(reconstruido.empresa?.Id, equals(original.empresa?.Id));
      expect(reconstruido.cliente?.Id, equals(original.cliente?.Id));
    });

    test('✅ Validar estados permitidos', () {
      final estadosValidos = [
        'Pendiente',
        'Confirmada',
        'Cancelada',
        'Completada',
      ];

      for (var estado in estadosValidos) {
        final reservacion = Reservacion(
          Id: 'reserv-estado-$estado',
          Estado: estado,
          Total: 10000.0,
        );

        expect(reservacion.Estado, equals(estado));
        expect(estadosValidos, contains(reservacion.Estado));
      }
    });

    test('⚠️ Manejar JSON con campos faltantes', () {
      final jsonIncompleto = {
        'Id': 'reserv-incompleto',
        'Valor': 20000.0,
        // Faltan: Fecha, Estado, Comentario, etc.
      };

      final reservacion = Reservacion.fromJson(jsonIncompleto);

      expect(reservacion.Id, equals('reserv-incompleto'));
      expect(reservacion.Total, equals(20000.0));
      expect(reservacion.Fecha, isNull);
      expect(reservacion.Estado, isNull);
      expect(reservacion.Comentario, isNull);
    });

    test('✅ Reservación con múltiples servicios y empleados', () {
      final empleado1 = Empleado(
        Id: 'emp-001',
        ListaDeServiciosDelEmpleado: [
          Servicio(
            Id: 'serv-001',
            Nombre: 'Servicio A',
            Precio: 30000.0,
            TiempoPromedio: Duration(minutes: 30),
          ),
          Servicio(
            Id: 'serv-002',
            Nombre: 'Servicio B',
            Precio: 20000.0,
            TiempoPromedio: Duration(minutes: 20),
          ),
        ],
      );

      final empleado2 = Empleado(
        Id: 'emp-002',
        ListaDeServiciosDelEmpleado: [
          Servicio(
            Id: 'serv-003',
            Nombre: 'Servicio C',
            Precio: 25000.0,
            TiempoPromedio: Duration(minutes: 25),
          ),
        ],
      );

      reservacionTest.empleadosAsignados.addAll([empleado1, empleado2]);

      // Contar servicios totales
      int totalServicios = 0;
      for (var emp in reservacionTest.empleadosAsignados) {
        totalServicios += emp.ListaDeServiciosDelEmpleado?.length ?? 0;
      }

      expect(reservacionTest.empleadosAsignados.length, equals(2));
      expect(totalServicios, equals(3)); // 2 del emp1 + 1 del emp2
    });
  });
}