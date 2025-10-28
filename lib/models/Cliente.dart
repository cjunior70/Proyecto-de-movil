import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Reservacion.dart';

class Cliente extends Datospersonales {

    List<Reservacion>? ListaDeReservaciones;

    Cliente({
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
            this.ListaDeReservaciones,
    });

}