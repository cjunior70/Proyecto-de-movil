import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/models/Empresa.dart';

void main() {
  group('✂️ Modelo Servicio -', () {
    test('✅ Crear servicio con datos válidos', () {
      final servicio = Servicio(
        Id: 'serv-001',
        Nombre: 'Corte Clásico',
        Precio: 25000.0,
        TiempoPromedio: Duration(minutes: 30),
        Descripcion: 'Corte de cabello estilo clásico',
        empresa: Empresa(Id: 'empresa-123'),
      );

      expect(servicio.Id, equals('serv-001'));
      expect(servicio.Nombre, equals('Corte Clásico'));
      expect(servicio.Precio, equals(25000.0));
      expect(servicio.TiempoPromedio.inMinutes, equals(30));
      expect(servicio.empresa?.Id, equals('empresa-123'));
    });

    test('✅ Convertir servicio a JSON', () {
      final servicio = Servicio(
        Id: 'serv-002',
        Nombre: 'Barba y Bigote',
        Precio: 15000.0,
        TiempoPromedio: Duration(hours: 1, minutes: 15),
        Descripcion: 'Arreglo completo de barba',
        empresa: Empresa(Id: 'empresa-456'),
      );

      final json = servicio.toJson();

      expect(json['Id'], equals('serv-002'));
      expect(json['Nombre'], equals('Barba y Bigote'));
      expect(json['Precio'], equals(15000.0));
      expect(json['Tiempo'], equals('01:15:00')); // Formato HH:mm:ss
      expect(json['Id_Empresa'], equals('empresa-456'));
    });

    test('✅ Crear servicio desde JSON', () {
      final jsonData = {
        'Id': 'serv-003',
        'Nombre': 'Tinte Premium',
        'Precio': '45000',
        'Tiempo': '02:30:00',
        'Descripcion': 'Tinte de alta gama',
        'Id_Empresa': 'empresa-789',
      };

      final servicio = Servicio.fromJson(jsonData);

      expect(servicio.Id, equals('serv-003'));
      expect(servicio.Nombre, equals('Tinte Premium'));
      expect(servicio.Precio, equals(45000.0));
      expect(servicio.TiempoPromedio.inHours, equals(2));
      expect(servicio.TiempoPromedio.inMinutes, equals(150));
      expect(servicio.empresa?.Id, equals('empresa-789'));
    });

    test('✅ Formatear Duration a string HH:mm:ss', () {
      final duraciones = [
        Duration(minutes: 30), // '00:30:00'
        Duration(hours: 1), // '01:00:00'
        Duration(hours: 2, minutes: 15), // '02:15:00'
        Duration(hours: 1, minutes: 45, seconds: 30), // '01:45:30'
      ];

      for (var duracion in duraciones) {
        final servicio = Servicio(
          Id: 'test',
          TiempoPromedio: duracion,
        );

        final tiempoStr = servicio.toJson()['Tiempo'];

        expect(tiempoStr, contains(':'));
        expect(tiempoStr.split(':').length, equals(3));
      }
    });

    test('✅ Servicio toString() legible', () {
      final servicio = Servicio(
        Id: 'serv-test',
        Nombre: 'Masaje Capilar',
        Precio: 20000.0,
        TiempoPromedio: Duration(minutes: 45),
      );

      final texto = servicio.toString();

      expect(texto, contains('serv-test'));
      expect(texto, contains('Masaje Capilar'));
      expect(texto, contains('20000'));
      expect(texto, contains('00:45:00'));
    });

    test('⚠️ Servicio con precio nulo', () {
      final servicio = Servicio(
        Id: 'serv-gratis',
        Nombre: 'Consulta Gratis',
        Precio: null,
        TiempoPromedio: Duration(minutes: 15),
      );

      expect(servicio.Precio, isNull);
      final json = servicio.toJson();
      expect(json['Precio'], isNull);
    });

    test('✅ Ciclo JSON completo: Objeto → JSON → Objeto', () {
      final original = Servicio(
        Id: 'serv-ciclo',
        Nombre: 'Tratamiento Completo',
        Precio: 80000.0,
        TiempoPromedio: Duration(hours: 3, minutes: 20),
        Descripcion: 'Tratamiento capilar completo',
        empresa: Empresa(Id: 'emp-999'),
      );

      final json = original.toJson();
      final reconstruido = Servicio.fromJson(json);

      expect(reconstruido.Id, equals(original.Id));
      expect(reconstruido.Nombre, equals(original.Nombre));
      expect(reconstruido.Precio, equals(original.Precio));
      expect(reconstruido.TiempoPromedio, equals(original.TiempoPromedio));
      expect(reconstruido.Descripcion, equals(original.Descripcion));
    });
  });
}