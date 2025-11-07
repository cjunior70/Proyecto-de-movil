import 'package:proyecto/models/Cliente.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/models/Empresa.dart';

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
  });

  // Convertir objeto a JSON para enviar a backend
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Fecha": Fecha?.toIso8601String(),
      "Valor": Total,
      "Estado": Estado,
      "Comentarios": Comentario,
      "Extrellas": Estrellas,
      "Id_Empresa": empresa?.Id,
      "Id_Cliente": cliente?.Id,
      "Id_Contabilidad": contabilidad?.Id,
    };
  }

  // Convertir JSON recibido desde backend a Objeto
  factory Reservacion.fromJson(Map<String, dynamic> json) {
    return Reservacion(
      Id: json["Id"],
      Creacion: json["Creacion"] != null ? DateTime.parse(json["Creacion"]) : null,
      Fecha: json["Fecha"] != null ? DateTime.parse(json["Fecha"]) : null,
      Total: json["Valor"] != null ? (json["Valor"] as num).toDouble() : null,
      Estado: json["Estado"],
      Comentario: json["Comentario"],
      Estrellas: json["Extrellas"] != null ? (json["Extrellas"] as num).toDouble() : null,

      // Solo guardamos los IDs, luego si necesitas, haces fetch completo
      empresa: json["Id_Empresa"] != null ? Empresa(Id: json["Id_Empresa"]) : null,
      cliente: json["Id_Cliente"] != null ? Cliente(Id: json["Id_Cliente"]) : null,
      contabilidad: json["Id_Contabilidad"] != null ? Contabilidad(Id: json["Id_Contabilidad"]) : null,
    );
  }

  @override
  String toString() {
    return 'Reservación{Id: $Id, Fecha: $Fecha, Total: $Total, Estado: $Estado, Estrellas: $Estrellas}';
  }
}
