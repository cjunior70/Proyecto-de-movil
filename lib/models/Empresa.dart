import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proyecto/Models/Reservacion.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/Models/empleado_model.dart';
import 'package:proyecto/Models/usuario_model.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/models/Fecha.dart';
import 'package:proyecto/models/Ubicacion.dart';
import 'package:proyecto/models/servicio_model.dart';

class Empresa {
  String Id;
  String Nombre;
  double Estrellas;
  String Correo;
  String? DescripcionUbicacion;
  String? WhatsApp;
  String? Facebook;
  String? Instagram;
  Uint8List? ImagenMiniatura;
  Uint8List? ImagenGeneral;
  TimeOfDay? ComienzoLaboral;
  TimeOfDay? FinalizacionLaboral;
  Usuario usuario;
  Ubicacion? ubicacion;
  Vacaciones? vacaciones;
  Contabilidad? contabilidad;
  List<Servicio>? ListaDeServicios;
  List<Empleado>? ListaDeEmpleados;
  List<Fecha>? ListaDeFechas;
  List<Reservacion>? ListaDeReservaciones;

  Empresa({
    required this.Id,
    required this.Nombre,
    required this.Estrellas,
    required this.Correo,
    this.DescripcionUbicacion,
    this.WhatsApp,
    this.Facebook,
    this.Instagram,
    this.ImagenMiniatura,
    this.ImagenGeneral,
    this.ComienzoLaboral,
    this.FinalizacionLaboral,
    required this.usuario,
    this.ubicacion,
    this.vacaciones,
    this.contabilidad,
    this.ListaDeServicios,
    this.ListaDeEmpleados,
    this.ListaDeFechas,
    this.ListaDeReservaciones,
  });
}
