import 'dart:developer';

import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Horario.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/Models/Empresa.dart';

class Empleado extends Datospersonales {
  DateTime? FechaDeInicio;
  DateTime? FechaActual;
  String? Cargo;
  String? Estado;
  String? Estacion;
  Vacaciones? vacaciones;
  Empresa? empresa;
  List<Service>? ListaDeServiciosDelEmpleado = [];
  List<Horario>? horario = [];

  Empleado({
    //El super es para poder acceder a los atributos de la clase datosperonales y lo agrega autamticamente a la clase Usuarios
    super.Id,
    super.Cedula,
    super.PrimerNombre,
    super.SegundoNombre,
    super.PrimerApellido,
    super.SegundoApellido,
    super.Telefono,
    super.Correo,
    super.Sexo,
    super.Foto,
    super.Rol,
    this.FechaDeInicio,
    this.FechaActual,
    this.Cargo,
    this.Estado,
    this.Estacion,
    this.vacaciones,
    this.empresa,
    this.ListaDeServiciosDelEmpleado,
    this.horario,
  });
}
