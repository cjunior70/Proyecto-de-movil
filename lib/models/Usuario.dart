import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Empresa.dart';

class Usuario extends Datospersonales {
  
  List<Empresa>? ListaDeEmpresas;

  Usuario({
    //El super es para poder acceder a los atributos de la clase datosperonales y lo agrega autamticamente a la clase Usuarios
    required super.Id,
    required super.Cedula,
    required super.PrimerNombre,
             super.SegundoNombre,
    required super.PrimerApellido,
             super.SegundoApellido,
    required super.Telefono,
             super.Correo,
    required super.Sexo,
             super.Foto,
      required super.Rol,
            this.ListaDeEmpresas,

  });

}