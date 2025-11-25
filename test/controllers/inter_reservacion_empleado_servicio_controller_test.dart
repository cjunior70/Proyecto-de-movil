// test/controllers/inter_reservacion_empleado_servicio_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/controllers/InterReservacionEmpleadoServicioController.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Servicio.dart';

void main() {
  group('InterReservacionEmpleadoServicioController -', () {
    late InterReservacionEmpleadoServicioController controller;

    setUp(() {
      controller = InterReservacionEmpleadoServicioController();
    });

    test('Inicializacion del controlador (Singleton)', () {
      final otraInstancia = InterReservacionEmpleadoServicioController();
      expect(identical(controller, otraInstancia), isTrue);
    });

    test('Preparar datos para guardado de relaciones', () {
      final servicio1 = Servicio(
        Id: 'serv-001',
        Nombre: 'Corte',
        Precio: 25000.0,
        TiempoPromedio: Duration(minutes: 30),
      );

      final servicio2 = Servicio(
        Id: 'serv-002',
        Nombre: 'Barba',
        Precio: 0.0,
        TiempoPromedio: Duration(minutes: 20),
      );

      final empleado = Empleado(
        Id: 'emp-001',
        PrimerNombre: 'Juan',
        ListaDeServiciosDelEmpleado: [servicio1, servicio2],
      );

      final reservacion = Reservacion(
        Id: 'reserv-001',
        Total: 40000.0,
        empleadosAsignados: [empleado],
      );

      expect(reservacion.Id, equals('reserv-001'));
      expect(reservacion.empleadosAsignados.length, equals(1));
      expect(
        reservacion.empleadosAsignados.first.ListaDeServiciosDelEmpleado?.length,
        equals(2),
      );
    });

    test('Validar estructura de relaciones multiples', () {
      final empleado1 = Empleado(
        Id: 'emp-001',
        ListaDeServiciosDelEmpleado: [
          Servicio(Id: 'serv-001', TiempoPromedio: Duration.zero),
          Servicio(Id: 'serv-002', TiempoPromedio: Duration.zero),
        ],
      );

      final empleado2 = Empleado(
        Id: 'emp-002',
        ListaDeServiciosDelEmpleado: [
          Servicio(Id: 'serv-003', TiempoPromedio: Duration.zero),
        ],
      );

      final reservacion = Reservacion(
        Id: 'reserv-multi',
        empleadosAsignados: [empleado1, empleado2],
      );

      int totalRelaciones = 0;
      for (var emp in reservacion.empleadosAsignados) {
        totalRelaciones += emp.ListaDeServiciosDelEmpleado?.length ?? 0;
      }

      expect(totalRelaciones, equals(3));
    });

    test('Simular mapeo de relaciones', () {
      final relacionesBD = [
        {
          'Id_Reservaciones': 'reserv-001',
          'Id_Empleado': 'emp-001',
          'Id_Servicio': 'serv-001',
        },
        {
          'Id_Reservaciones': 'reserv-001',
          'Id_Empleado': 'emp-001',
          'Id_Servicio': 'serv-002',
        },
        {
          'Id_Reservaciones': 'reserv-001',
          'Id_Empleado': 'emp-002',
          'Id_Servicio': 'serv-003',
        },
      ];

      Map<String, List<String>> empleadoServicios = {};
      for (var item in relacionesBD) {
        final empleadoId = item['Id_Empleado'] as String;
        final servicioId = item['Id_Servicio'] as String;

        if (!empleadoServicios.containsKey(empleadoId)) {
          empleadoServicios[empleadoId] = [];
        }
        empleadoServicios[empleadoId]!.add(servicioId);
      }

      expect(empleadoServicios.keys.length, equals(2));
      expect(empleadoServicios['emp-001']?.length, equals(2));
      expect(empleadoServicios['emp-002']?.length, equals(1));
    });

    test('Validar unicidad de reservaciones por empleado', () {
      final reservacionesIds = [
        'reserv-001',
        'reserv-002',
        'reserv-001',
        'reserv-003',
        'reserv-002',
      ];

      final reservacionesUnicas = reservacionesIds.toSet().toList();

      expect(reservacionesUnicas.length, equals(3));
      expect(reservacionesUnicas, contains('reserv-001'));
      expect(reservacionesUnicas, contains('reserv-002'));
      expect(reservacionesUnicas, contains('reserv-003'));
    });

    test('Contar servicios unicos en reservacion', () {
      final serviciosIds = [
        'serv-001',
        'serv-002',
        'serv-001',
        'serv-003',
      ];

      final serviciosUnicos = serviciosIds.toSet();

      expect(serviciosUnicos.length, equals(3));
    });

    test('Validar que reservacion sin empleados no genera relaciones', () {
      final reservacion = Reservacion(
        Id: 'reserv-sin-empleados',
        Total: 0.0,
        empleadosAsignados: [],
      );

      expect(reservacion.empleadosAsignados, isEmpty);

      bool deberiaSerExitoso = reservacion.empleadosAsignados.isEmpty;
      expect(deberiaSerExitoso, isTrue);
    });

    test('Validar empleado sin servicios', () {
      final empleadoSinServicios = Empleado(
        Id: 'emp-sin-servicios',
        ListaDeServiciosDelEmpleado: null,
      );

      final reservacion = Reservacion(
        Id: 'reserv-test',
        empleadosAsignados: [empleadoSinServicios],
      );

      int totalServicios = 0;
      for (var emp in reservacion.empleadosAsignados) {
        totalServicios += emp.ListaDeServiciosDelEmpleado?.length ?? 0;
      }

      expect(totalServicios, equals(0));
    });

    test('Simular obtencion de estadisticas de servicio', () {
      final usoServicio = [
        {'reservacion': 'r1', 'empleado': 'e1'},
        {'reservacion': 'r2', 'empleado': 'e1'},
        {'reservacion': 'r3', 'empleado': 'e2'},
        {'reservacion': 'r4', 'empleado': 'e3'},
        {'reservacion': 'r5', 'empleado': 'e1'},
      ];

      final reservacionesUnicas = usoServicio
          .map((item) => item['reservacion'])
          .toSet()
          .length;

      final empleadosUnicos = usoServicio
          .map((item) => item['empleado'])
          .toSet()
          .length;

      expect(reservacionesUnicas, equals(5));
      expect(empleadosUnicos, equals(3));
    });

    test('Simular carga de trabajo de empleado', () {
      final reservacionesEmpleado = [
        {'id': 'r1', 'fecha': '2025-12-20'},
        {'id': 'r2', 'fecha': '2025-12-21'},
        {'id': 'r1', 'fecha': '2025-12-20'},
        {'id': 'r3', 'fecha': '2025-12-22'},
      ];

      final cargaTrabajo = reservacionesEmpleado
          .map((item) => item['id'])
          .toSet()
          .length;

      expect(cargaTrabajo, equals(3));
    });

    test('Verificar existencia de relacion especifica', () {
      final relacionExistente = {
        'Id_Reservaciones': 'reserv-123',
        'Id_Empleado': 'emp-456',
        'Id_Servicio': 'serv-789',
      };

      bool existeRelacion(String reservId, String empId, String servId) {
        return relacionExistente['Id_Reservaciones'] == reservId &&
            relacionExistente['Id_Empleado'] == empId &&
            relacionExistente['Id_Servicio'] == servId;
      }

      expect(existeRelacion('reserv-123', 'emp-456', 'serv-789'), isTrue);
      expect(existeRelacion('reserv-999', 'emp-456', 'serv-789'), isFalse);
    });

    test('Validar integridad de IDs antes de guardar', () {
      final reservacion = Reservacion(
        Id: '',
        empleadosAsignados: [
          Empleado(
            Id: 'emp-001',
            ListaDeServiciosDelEmpleado: [
              Servicio(Id: 'serv-001', TiempoPromedio: Duration.zero),
            ],
          ),
        ],
      );

      bool reservacionValida = reservacion.Id != null && reservacion.Id!.isNotEmpty;
      expect(reservacionValida, isFalse);
    });

    test('Validar empleados y servicios tienen IDs', () {
      final empleado = Empleado(
        Id: null,
        ListaDeServiciosDelEmpleado: [
          Servicio(Id: '', TiempoPromedio: Duration.zero),
        ],
      );

      bool empleadoValido = empleado.Id != null && empleado.Id!.isNotEmpty;
      bool servicioValido = empleado.ListaDeServiciosDelEmpleado
              ?.every((s) => s.Id.isNotEmpty) ??
          false;

      expect(empleadoValido, isFalse);
      expect(servicioValido, isFalse);
    });

    test('Generar registros para insercion masiva', () {
      final empleado = Empleado(
        Id: 'emp-001',
        ListaDeServiciosDelEmpleado: [
          Servicio(Id: 'serv-001', TiempoPromedio: Duration.zero),
          Servicio(Id: 'serv-002', TiempoPromedio: Duration.zero),
        ],
      );

      final reservacionId = 'reserv-001';
      List<Map<String, dynamic>> registros = [];

      for (var servicio in empleado.ListaDeServiciosDelEmpleado!) {
        registros.add({
          'Id_Reservaciones': reservacionId,
          'Id_Empleado': empleado.Id,
          'Id_Servicio': servicio.Id,
        });
      }

      expect(registros.length, equals(2));
      expect(registros[0]['Id_Reservaciones'], equals(reservacionId));
      expect(registros[0]['Id_Empleado'], equals('emp-001'));
      expect(registros[0]['Id_Servicio'], equals('serv-001'));
    });
  });
}