import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proyecto/Models/Reservacion.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/Models/empleado.dart';
import 'package:proyecto/Models/usuario.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/models/Fecha.dart';
import 'package:proyecto/Models/Ubicacion.dart';
import 'package:proyecto/Models/Servicio.dart';

class Empresa {
  String? Id;
  String? Nombre;
  double? Estrellas;
  String? Correo;
  String? DescripcionUbicacion;
  String? WhatsApp;
  String? Facebook;
  String? Instagram;
  Uint8List? ImagenMiniatura;
  Uint8List? ImagenGeneral;
  TimeOfDay? ComienzoLaboral;
  TimeOfDay? FinalizacionLaboral;
  Usuario? usuario;
  Ubicacion? ubicacion;
  Vacaciones? vacaciones;
  Contabilidad? contabilidad;
  List<Servicios>? ListaDeServicios = [];
  List<Empleado>? ListaDeEmpleados = [];
  List<Fecha>? ListaDeFechas = [];
  List<Reservacion>? ListaDeReservaciones = [];

  Empresa({
    this.Id,
    this.Nombre,
    this.Estrellas,
    this.Correo,
    this.DescripcionUbicacion,
    this.WhatsApp,
    this.Facebook,
    this.Instagram,
    this.ImagenMiniatura,
    this.ImagenGeneral,
    this.ComienzoLaboral,
    this.FinalizacionLaboral,
    // required this.usuario,
    this.usuario,
    this.ubicacion,
    this.vacaciones,
    this.contabilidad,
    this.ListaDeServicios,
    this.ListaDeEmpleados,
    this.ListaDeFechas,
    this.ListaDeReservaciones,
  });
}
