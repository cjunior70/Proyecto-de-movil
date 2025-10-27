import 'package:proyecto/Models/empresa_model.dart';

class Fecha {
  String Id;
  DateTime FechaActual;
  String Estado;
  Empresa empresa;

  Fecha({
    required this.Id,
    required this.FechaActual,
    required this.Estado,
    required this.empresa,
  });
}
