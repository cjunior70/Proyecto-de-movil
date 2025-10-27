import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/Models/Empleado.dart';
import 'package:proyecto/Models/Empresa.dart';
import 'package:proyecto/models/Contabilidad.dart';

class Reservacion {
  String Id;
  DateTime Creacion;
  DateTime Fecha;
  double Total;
  String Estado;
  String? Comentario;
  double? Estrellas;
  Empresa empresa;
  Cliente cliente;
  Contabilidad contabilidad;
  List<Empleado>? ListaDeEmpleados;

  Reservacion({
    required this.Id,
    required this.Creacion,
    required this.Fecha,
    required this.Total,
    required this.Estado,
    this.Comentario,
    this.Estrellas,
    required this.empresa,
    required this.cliente,
    required this.contabilidad,
    this.ListaDeEmpleados,
  });
}
