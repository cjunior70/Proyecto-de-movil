// test/mocks/supabase_mock.dart
// ✅ Mock de Supabase para pruebas sin conexión real

import 'package:supabase_flutter/supabase_flutter.dart';

/// 🎭 Mock básico de SupabaseClient
class MockSupabaseClient {
  final Map<String, List<Map<String, dynamic>>> _tablas = {
    'Reservaciones': [],
    'Servicios': [],
    'Empleados': [],
    'Clientes': [],
    'Empresas': [],
    'Inter_Servicio_Reservacion': [],
    'Inter_Servicio_Empleado': [],
  };

  /// Simula un SELECT de Supabase
  MockPostgrestFilterBuilder from(String tabla) {
    return MockPostgrestFilterBuilder(
      tabla: tabla,
      datos: _tablas[tabla] ?? [],
    );
  }

  /// Simula INSERT
  Future<void> insert(String tabla, Map<String, dynamic> data) async {
    _tablas[tabla]?.add(data);
  }

  /// Simula UPDATE
  Future<void> update(String tabla, Map<String, dynamic> data, String id) async {
    final index = _tablas[tabla]?.indexWhere((item) => item['Id'] == id);
    if (index != null && index != -1) {
      _tablas[tabla]?[index] = {..._tablas[tabla]![index], ...data};
    }
  }

  /// Simula DELETE
  Future<void> delete(String tabla, String id) async {
    _tablas[tabla]?.removeWhere((item) => item['Id'] == id);
  }

  /// Limpiar todas las tablas (útil para setUp/tearDown)
  void limpiarTodo() {
    for (var tabla in _tablas.keys) {
      _tablas[tabla]?.clear();
    }
  }

  /// Agregar datos de prueba
  void agregarDatosPrueba(String tabla, List<Map<String, dynamic>> datos) {
    _tablas[tabla]?.addAll(datos);
  }
}

/// 🎭 Mock del QueryBuilder de Supabase
class MockPostgrestFilterBuilder {
  final String tabla;
  final List<Map<String, dynamic>> datos;
  List<Map<String, dynamic>> _resultado;

  MockPostgrestFilterBuilder({
    required this.tabla,
    required this.datos,
  }) : _resultado = List.from(datos);

  /// Simula .select()
  MockPostgrestFilterBuilder select([String? columnas]) {
    // En pruebas simples, devolvemos todo
    return this;
  }

  /// Simula .eq('columna', valor)
  MockPostgrestFilterBuilder eq(String columna, dynamic valor) {
    _resultado = _resultado.where((item) => item[columna] == valor).toList();
    return this;
  }

  /// Simula .gte() y .lte() para rangos de fechas
  MockPostgrestFilterBuilder gte(String columna, dynamic valor) {
    _resultado = _resultado.where((item) {
      final itemValor = item[columna];
      if (itemValor is String && valor is String) {
        return itemValor.compareTo(valor) >= 0;
      }
      return true;
    }).toList();
    return this;
  }

  MockPostgrestFilterBuilder lte(String columna, dynamic valor) {
    _resultado = _resultado.where((item) {
      final itemValor = item[columna];
      if (itemValor is String && valor is String) {
        return itemValor.compareTo(valor) <= 0;
      }
      return true;
    }).toList();
    return this;
  }

  /// Simula .single() - Devuelve un solo resultado
  Future<Map<String, dynamic>> single() async {
    if (_resultado.isEmpty) {
      throw Exception('No se encontraron registros');
    }
    if (_resultado.length > 1) {
      throw Exception('Se encontraron múltiples registros');
    }
    return _resultado.first;
  }

  /// Simula .maybeSingle() - Devuelve un resultado o null
  Future<Map<String, dynamic>?> maybeSingle() async {
    if (_resultado.isEmpty) return null;
    return _resultado.first;
  }

  /// Simula la respuesta de una lista completa
  Future<List<Map<String, dynamic>>> then(
    Function(List<Map<String, dynamic>>) onValue,
  ) async {
    return onValue(_resultado);
  }

  /// Para poder usar `await` directamente
  Future<List<Map<String, dynamic>>> call() async {
    return _resultado;
  }
}

/// 🏭 Factory para crear mocks con datos de prueba
class MockDataFactory {
  /// Crear una reservación de prueba
  static Map<String, dynamic> crearReservacionMock({
    String? id,
    String? empresaId,
    String? clienteId,
    DateTime? fecha,
    double? total,
    String estado = 'Pendiente',
  }) {
    return {
      'Id': id ?? 'reserv-test-123',
      'Fecha': (fecha ?? DateTime.now()).toIso8601String(),
      'Valor': total ?? 50000.0,
      'Estado': estado,
      'Comentario': 'Reserva de prueba',
      'Extrellas': null,
      'Id_Empresa': empresaId ?? 'empresa-test-1',
      'Id_Cliente': clienteId ?? 'cliente-test-1',
      'Id_Contabilidad': null,
      'Creacion': DateTime.now().toIso8601String(),
    };
  }

  /// Crear un servicio de prueba
  static Map<String, dynamic> crearServicioMock({
    String? id,
    String? empresaId,
    String nombre = 'Corte de Cabello',
    double precio = 25000.0,
    String tiempo = '00:45:00',
  }) {
    return {
      'Id': id ?? 'servicio-test-1',
      'Nombre': nombre,
      'Precio': precio,
      'Tiempo': tiempo,
      'Descripcion': 'Servicio de prueba',
      'Id_Empresa': empresaId ?? 'empresa-test-1',
    };
  }

  /// Crear un empleado de prueba
  static Map<String, dynamic> crearEmpleadoMock({
    String? id,
    String? empresaId,
    String nombre = 'Juan',
    String apellido = 'Pérez',
    String estado = 'Activo',
  }) {
    return {
      'Id': id ?? 'empleado-test-1',
      'Cedula': '1234567890',
      'PrimerNombre': nombre,
      'SegundoNombre': null,
      'PrimerApellido': apellido,
      'SegundoApellido': null,
      'Telefono': '3001234567',
      'Correo': 'juan.perez@test.com',
      'Sexo': 'Masculino',
      'Foto': null,
      'FechaDeInicio': DateTime.now().toIso8601String(),
      'FechaActual': DateTime.now().toIso8601String(),
      'Cargo': 'Barbero',
      'Estado': estado,
      'Estacion': 'Estación 1',
      'Id_Empresa': empresaId ?? 'empresa-test-1',
    };
  }

  /// Crear un cliente de prueba
  static Map<String, dynamic> crearClienteMock({
    String? id,
    String nombre = 'María',
    String apellido = 'González',
  }) {
    return {
      'Id': id ?? 'cliente-test-1',
      'Cedula': '9876543210',
      'PrimerNombre': nombre,
      'SegundoNombre': null,
      'PrimerApellido': apellido,
      'SegundoApellido': null,
      'Telefono': '3009876543',
      'Correo': 'maria.gonzalez@test.com',
      'Sexo': 'Femenino',
      'Foto': null,
    };
  }

  /// Crear relación Servicio-Empleado
  static Map<String, dynamic> crearRelacionServicioEmpleadoMock({
    required String empleadoId,
    required String servicioId,
  }) {
    return {
      'Id': 'rel-${empleadoId.substring(0, 8)}-${servicioId.substring(0, 8)}',
      'Id_Empleado': empleadoId,
      'Id_Servicio': servicioId,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Crear relación Reservación-Empleado-Servicio
  static Map<String, dynamic> crearRelacionReservacionMock({
    required String reservacionId,
    required String empleadoId,
    required String servicioId,
  }) {
    return {
      'Id': 'rel-reserv-${DateTime.now().millisecondsSinceEpoch}',
      'Id_Reservaciones': reservacionId, // ✅ Plural como en tu BD
      'Id_Empleado': empleadoId,
      'Id_Servicio': servicioId,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}