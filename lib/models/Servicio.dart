
class Servicio {

  String Id;
  String? Nombre;
  double? Precio;
  Duration TiempoPromedio;
  String? Descripcion;

  Servicio({

    required this.Id,
    this.Nombre,
    this.Precio,
    required this.TiempoPromedio,
    this.Descripcion
  });

}