import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/Models/Empleado.dart';
import 'package:proyecto/Models/Empresa.dart';
import 'package:proyecto/models/Contabilidad.dart';

class Reservacion {
  String? Id;
  DateTime? Creacion;
  DateTime? Fecha;
  double? Total;
  String? Estado;
  String? Comentario;
  double? Estrellas;
  Empresa? empresa;
  Cliente? cliente;
  Contabilidad? contabilidad;
  List<Empleado>? ListaDeEmpleados = [];

  Reservacion({
    this.Id,
    this.Creacion,
    this.Fecha,
    this.Total,
    this.Estado,
    this.Comentario,
    this.Estrellas,
    this.empresa,
    this.cliente,
    this.contabilidad,
    this.ListaDeEmpleados,
  });
}
