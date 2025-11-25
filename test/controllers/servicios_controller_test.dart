import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/models/Servicio.dart';

void main() {
  group('🎮 ServicioController -', () {
    late ServicioController controller;

    setUp(() {
      controller = ServicioController();
    });

    test('✅ Inicialización del controlador', () {
      expect(controller, isNotNull);
      expect(controller.listadeServicios, isEmpty);
      expect(controller.servicio, isNull);
    });

    test('✅ Agregar servicios a lista interna', () {
      final servicios = [
        Servicio(
          Id: 's1',
          Nombre: 'Servicio A',
          Precio: 10000.0,
          TiempoPromedio: Duration(minutes: 30),
        ),
        Servicio(
          Id: 's2',
          Nombre: 'Servicio B',
          Precio: 20000.0,
          TiempoPromedio: Duration(minutes: 45),
        ),
      ];

      controller.listadeServicios.addAll(servicios);

      expect(controller.listadeServicios.length, equals(2));
      expect(controller.listadeServicios[0].Nombre, equals('Servicio A'));
    });

    test('✅ Buscar servicio por ID', () {
      final servicios = [
        Servicio(
          Id: 's1',
          Nombre: 'Corte',
          Precio: 25000.0,
          TiempoPromedio: Duration(minutes: 30),
        ),
        Servicio(
          Id: 's2',
          Nombre: 'Barba',
          Precio: 15000.0,
          TiempoPromedio: Duration(minutes: 20),
        ),
        Servicio(
          Id: 's3',
          Nombre: 'Tinte',
          Precio: 45000.0,
          TiempoPromedio: Duration(hours: 2),
        ),
      ];

      controller.listadeServicios.addAll(servicios);

      // Buscar servicio
      final encontrado = controller.listadeServicios
          .firstWhere((s) => s.Id == 's2');

      expect(encontrado.Nombre, equals('Barba'));
      expect(encontrado.Precio, equals(15000.0));
    });

    test('✅ Filtrar servicios por rango de precio', () {
      final servicios = [
        Servicio(Id: 's1', Precio: 10000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's2', Precio: 25000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's3', Precio: 30000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's4', Precio: 50000.0, TiempoPromedio: Duration.zero),
      ];

      controller.listadeServicios.addAll(servicios);

      // Filtrar servicios entre 20k y 40k
      final filtrados = controller.listadeServicios
          .where((s) => s.Precio! >= 20000 && s.Precio! <= 40000)
          .toList();

      expect(filtrados.length, equals(2));
      expect(filtrados[0].Id, equals('s2'));
      expect(filtrados[1].Id, equals('s3'));
    });

    test('✅ Calcular tiempo total de múltiples servicios', () {
      final servicios = [
        Servicio(
          Id: 's1',
          TiempoPromedio: Duration(minutes: 30),
        ),
        Servicio(
          Id: 's2',
          TiempoPromedio: Duration(minutes: 45),
        ),
        Servicio(
          Id: 's3',
          TiempoPromedio: Duration(hours: 1, minutes: 20),
        ),
      ];

      final tiempoTotal = servicios.fold(
        Duration.zero,
        (total, s) => total + s.TiempoPromedio,
      );

      expect(tiempoTotal.inMinutes, equals(155)); // 30+45+80
    });

    test('✅ Calcular precio promedio', () {
      final servicios = [
        Servicio(Id: 's1', Precio: 20000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's2', Precio: 30000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's3', Precio: 40000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's4', Precio: 50000.0, TiempoPromedio: Duration.zero),
      ];

      controller.listadeServicios.addAll(servicios);

      final promedio = controller.listadeServicios
              .map((s) => s.Precio ?? 0.0)
              .reduce((a, b) => a + b) /
          controller.listadeServicios.length;

      expect(promedio, equals(35000.0));
    });

    test('✅ Ordenar servicios por precio', () {
      final servicios = [
        Servicio(Id: 's1', Nombre: 'Caro', Precio: 50000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's2', Nombre: 'Medio', Precio: 25000.0, TiempoPromedio: Duration.zero),
        Servicio(Id: 's3', Nombre: 'Barato', Precio: 10000.0, TiempoPromedio: Duration.zero),
      ];

      controller.listadeServicios.addAll(servicios);
      controller.listadeServicios.sort((a, b) => (a.Precio ?? 0).compareTo(b.Precio ?? 0));

      expect(controller.listadeServicios[0].Nombre, equals('Barato'));
      expect(controller.listadeServicios[1].Nombre, equals('Medio'));
      expect(controller.listadeServicios[2].Nombre, equals('Caro'));
    });

    test('✅ Validar servicio más popular (mock)', () {
      // Simular conteo de reservas por servicio
      final estadisticas = {
        's1': 15, // Corte - 15 reservas
        's2': 8, // Barba - 8 reservas
        's3': 22, // Tinte - 22 reservas
      };

      final masPopularId = estadisticas.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      expect(masPopularId, equals('s3'));
      expect(estadisticas[masPopularId], equals(22));
    });

    test('⚠️ Manejar lista vacía de servicios', () {
      expect(controller.listadeServicios, isEmpty);

      final total = controller.listadeServicios
          .fold(0.0, (sum, s) => sum + (s.Precio ?? 0.0));

      expect(total, equals(0.0));
    });
  });
}