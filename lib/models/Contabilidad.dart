import 'package:proyecto/Models/empresa_model.dart';

class Contabilidad {
  String Id;
  double PagoPorDia;
  DateTime Fecha;
  Empresa empresa;

  Contabilidad({
    required this.Id,
    required this.PagoPorDia,
    required this.Fecha,
    required this.empresa
  });
}
