import 'package:proyecto/models/Empresa.dart';

class Contabilidad {
  String? Id;
  double? PagoPorDia;
  DateTime? Fecha;
  Empresa? empresa;

  Contabilidad({
    this.Id,
    this.PagoPorDia,
    this.Fecha,
    this.empresa
  });
}
