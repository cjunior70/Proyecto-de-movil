import 'package:flutter/material.dart';
import 'package:proyecto/Models/empleado.dart';

class Horario {
  String Id;
  String DiaSemana;
  TimeOfDay? TurnoManana;
  TimeOfDay? TurnoTarde;
  TimeOfDay? TurnoNoche;
  Empleado empleado;

  Horario({
    required this.Id,
    required this.DiaSemana,
    this.TurnoManana,
    this.TurnoTarde,
    this.TurnoNoche,
    required this.empleado,
  });
}
