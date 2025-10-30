import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Reservacion.dart';

class Cliente extends Datospersonales {

    List<Reservacion>? ListaDeReservaciones = [];

    Cliente({
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
            this.ListaDeReservaciones,
    });

}