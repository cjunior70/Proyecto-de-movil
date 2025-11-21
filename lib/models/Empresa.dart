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
  
  // ✅ Campos para manejar tanto URLs como bytes
  Uint8List? ImagenMiniatura;
  Uint8List? ImagenGeneral;
  String? ImagenMiniaturaUrl; // Para URLs de imágenes
  String? ImagenGeneralUrl;   // Para URLs de imágenes
  
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
    this.ImagenMiniaturaUrl,
    this.ImagenGeneralUrl,
    this.ComienzoLaboral,
    this.FinalizacionLaboral,
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
      // ✅ Guardar como URL o base64 según lo que tengas
      "ImagenEnMiniatura": ImagenMiniaturaUrl ?? 
          (ImagenMiniatura != null ? base64Encode(ImagenMiniatura!) : null),
      "ImagenGeneral": ImagenGeneralUrl ?? 
          (ImagenGeneral != null ? base64Encode(ImagenGeneral!) : null),
      "ComienzoLaboral": ComienzoLaboral != null 
          ? "${ComienzoLaboral!.hour}:${ComienzoLaboral!.minute}" 
          : null,
      "FinalizacionLaboral": FinalizacionLaboral != null 
          ? "${FinalizacionLaboral!.hour}:${FinalizacionLaboral!.minute}" 
          : null,
      "Id_Usuario": usuario?.Id,
      "Id_Ubicacion": ubicacion?.Id,
    };
  }

  // ✅ Conversión de JSON a objeto CORREGIDA
  factory Empresa.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? time) {
      if (time == null || time.isEmpty) return null;
      try {
        final parts = time.split(":");
        if (parts.length != 2) return null;
        return TimeOfDay(
          hour: int.parse(parts[0]), 
          minute: int.parse(parts[1])
        );
      } catch (e) {
        print("⚠️ Error parseando tiempo: $time - $e");
        return null;
      }
    }

    // ✅ Helper para determinar si es URL o base64
    bool _isUrl(String? value) {
      if (value == null) return false;
      return value.startsWith('http://') || value.startsWith('https://');
    }

    // ✅ Procesar imagen miniatura
    String? imagenMiniaturaUrl;
    Uint8List? imagenMiniaturaBytes;
    
    final imagenMini = json["ImagenEnMiniatura"];
    if (imagenMini != null && imagenMini is String) {
      if (_isUrl(imagenMini)) {
        imagenMiniaturaUrl = imagenMini;
      } else {
        try {
          imagenMiniaturaBytes = base64Decode(imagenMini);
        } catch (e) {
          print("⚠️ Error decodificando imagen miniatura: $e");
        }
      }
    }

    // ✅ Procesar imagen general
    String? imagenGeneralUrl;
    Uint8List? imagenGeneralBytes;
    
    final imagenGen = json["ImagenGeneral"];
    if (imagenGen != null && imagenGen is String) {
      if (_isUrl(imagenGen)) {
        imagenGeneralUrl = imagenGen;
      } else {
        try {
          imagenGeneralBytes = base64Decode(imagenGen);
        } catch (e) {
          print("⚠️ Error decodificando imagen general: $e");
        }
      }
    }

    return Empresa(
      Id: json["Id"],
      Nombre: json["Nombre"],
      Estrellas: json["Extrellas"] != null 
          ? (json["Extrellas"] as num).toDouble() 
          : null,
      Correo: json["Correo"],
      DescripcionUbicacion: json["DescripciondelaUbicacion"],
      WhatsApp: json["Whatsapp"],
      Facebook: json["Facebook"],
      Instagram: json["Instagram"],
      ImagenMiniatura: imagenMiniaturaBytes,
      ImagenGeneral: imagenGeneralBytes,
      ImagenMiniaturaUrl: imagenMiniaturaUrl,
      ImagenGeneralUrl: imagenGeneralUrl,
      ComienzoLaboral: parseTime(json["ComienzoLaboral"]),
      FinalizacionLaboral: parseTime(json["FinalizacionLaboral"]),
      usuario: json["Id_Usuario"] != null 
          ? Usuario(Id: json["Id_Usuario"]) 
          : null,
      ubicacion: json["Id_Ubicacion"] != null 
          ? Ubicacion(Id: json["Id_Ubicacion"]) 
          : null,
    );
  }

  // ✅ Helper para obtener la URL de imagen (prioriza URL sobre bytes)
  String? getImagenMiniaturaUrl() {
    return ImagenMiniaturaUrl;
  }

  String? getImagenGeneralUrl() {
    return ImagenGeneralUrl;
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