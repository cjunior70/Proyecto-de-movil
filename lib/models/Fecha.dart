import 'package:proyecto/models/Empresa.dart';

class Fecha {
  String? Id;
  DateTime? FechaActual;
  String? Estado;
  Empresa? empresa;

  Fecha({
    this.Id,
    this.FechaActual,
    this.Estado,
    this.empresa,
  });
}
