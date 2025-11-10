import 'package:flutter/material.dart';
import 'package:proyecto/Models/Empleado.dart';

class Horario {
  String? Id;
  String? DiaSemana;
  TimeOfDay? TurnoManana;
  TimeOfDay? TurnoTarde;
  TimeOfDay? TurnoNoche;
  Empleado? empleado;

  Horario({
    this.Id,
    this.DiaSemana,
    this.TurnoManana,
    this.TurnoTarde,
    this.TurnoNoche,
    this.empleado,
  });

  // ---- Convert TimeOfDay → "HH:mm"
  String? _toTimeString(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  // ---- Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Dia": DiaSemana,
      "TurnoDeLaMañana": _toTimeString(TurnoManana),
      "TurnoDeLaTarde": _toTimeString(TurnoTarde),
      "TurnoDeLaNoche": _toTimeString(TurnoNoche),
      "Id_Empleado": empleado?.Id,
    };
  }

  // ---- Convert "HH:mm" → TimeOfDay
  TimeOfDay? _fromTimeString(String? time) {
    if (time == null || !time.contains(":")) return null;
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // ---- Convertir JSON a objeto
  factory Horario.fromJson(Map<String, dynamic> json) {
    Horario h = Horario(
      Id: json["Id"],
      DiaSemana: json["Dia"],
      TurnoManana: Horario()._fromTimeString(json["TurnoDeLaManana"]),
      TurnoTarde: Horario()._fromTimeString(json["TurnoDeLaTarde"]),
      TurnoNoche: Horario()._fromTimeString(json["TurnoDeLaNoche"]),
      empleado: json["Id_Empleado"] != null ? Empleado(Id: json["Id_Empleado"]) : null,
    );
    return h;
  }

  @override
  String toString() {
    return 'Horario{Dia: $DiaSemana, Mañana: ${_toTimeString(TurnoManana)}, Tarde: ${_toTimeString(TurnoTarde)}, Noche: ${_toTimeString(TurnoNoche)}}';
  }
}
