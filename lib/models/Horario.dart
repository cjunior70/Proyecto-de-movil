import 'package:flutter/material.dart';
import 'package:proyecto/Models/empleado.dart';

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
}
