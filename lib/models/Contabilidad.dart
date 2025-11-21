import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Reservacion.dart';

class Contabilidad {
  String? Id;
  double? PagoPorDia;
  DateTime? Fecha;
  Empresa? empresa;
  Reservacion? reservacion;

  Contabilidad({
    this.Id,
    this.PagoPorDia,
    this.Fecha,
    this.empresa,
    this.reservacion,
  });

  // Convertir objeto -> JSON (para enviar a Supabase)
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "PagoPorDia": PagoPorDia,
      "Fecha": Fecha?.toIso8601String(),
      "Id_Empresa": empresa?.Id,       // Referencia (no el objeto)
      "Id_Reservacion": reservacion?.Id // Referencia (no el objeto)
    };
  }

  // Convertir JSON -> Objeto (cuando recibes de Supabase)
  factory Contabilidad.fromJson(Map<String, dynamic> json) {
    return Contabilidad(
      Id: json["Id"],
      PagoPorDia: json["PagoPorDia"] != null
          ? (json["PagoPorDia"] as num).toDouble()
          : null,
      Fecha: json["Fecha"] != null ? DateTime.parse(json["Fecha"]) : null,
      empresa: json["Id_Empresa"] != null ? Empresa(Id: json["Id_Empresa"]) : null,
      reservacion: json["Id_Reservacion"] != null
          ? Reservacion(Id: json["Id_Reservacion"])
          : null,
    );
  }

  @override
  String toString() {
    return "Contabilidad{Id: $Id, PagoPorDia: $PagoPorDia, Fecha: $Fecha, Empresa: ${empresa?.Id}, Reservacion: ${reservacion?.Id}}";
  }
}
