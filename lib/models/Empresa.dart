import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proyecto/Models/Reservacion.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/Models/empleado.dart';
import 'package:proyecto/Models/Contabilidad.dart';
import 'package:proyecto/Models/Fecha.dart';
import 'package:proyecto/Models/Ubicacion.dart';
import 'package:proyecto/Models/Servicio.dart';
import 'package:proyecto/models/Usuario.dart';

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
  List<Servicio>? ListaDeServicios = [];
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

  // Conversión de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Nombre": Nombre,
      "Extrellas": Estrellas,
      "Correo": Correo,
      "DescripciondelaUbicacion": DescripcionUbicacion,
      "Whatsapp": WhatsApp,
      "Facebook": Facebook,
      "Instagram": Instagram,
      "ImagenEnMiniatura": ImagenMiniatura != null ? base64Encode(ImagenMiniatura!) : null,
      "ImagenGeneral": ImagenGeneral != null ? base64Encode(ImagenGeneral!) : null,
      "ComienzoLaboral": ComienzoLaboral != null ? "${ComienzoLaboral!.hour}:${ComienzoLaboral!.minute}" : null,
      "FinalizacionLaboral": FinalizacionLaboral != null ? "${FinalizacionLaboral!.hour}:${FinalizacionLaboral!.minute}" : null,
      "Id_Usuario": usuario?.Id, // solo el UUID del usuario
      "Id_Ubicacion": ubicacion?.Id, // solo el UUID de la ubicación
    };
  }

  // Conversión de JSON a objeto
  factory Empresa.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? time) {
      if (time == null) return null;
      final parts = time.split(":");
      if (parts.length != 2) return null;
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Empresa(
      Id: json["Id"],
      Nombre: json["Nombre"],
      Estrellas: json["Estrellas"] != null ? (json["Estrellas"] as num).toDouble() : null,
      Correo: json["Correo"],
      DescripcionUbicacion: json["DescripciondelaUbicacion"],
      WhatsApp: json["WhatsApp"],
      Facebook: json["Facebook"],
      Instagram: json["Instagram"],
      ImagenMiniatura: json["ImagenEnMiniatura"] != null ? base64Decode(json["ImagenMiniatura"]) : null,
      ImagenGeneral: json["ImagenGeneral"] != null ? base64Decode(json["ImagenGeneral"]) : null,
      ComienzoLaboral: parseTime(json["ComienzoLaboral"]),
      FinalizacionLaboral: parseTime(json["FinalizacionLaboral"]),
      usuario: Usuario(Id: json["usuarioId"]),
      ubicacion: json["ubicacionId"] != null ? Ubicacion(Id: json["ubicacionId"]) : null,
    );
  }

  String formatTime(TimeOfDay? t) {
    if (t == null) return "No definido";
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

@override
String toString() {
  return 'Empresa{Id: $Id, Nombre: $Nombre, Estrellas: $Estrellas, Correo: $Correo, Horario: ${formatTime(ComienzoLaboral)} - ${formatTime(FinalizacionLaboral)}}';
}


}
