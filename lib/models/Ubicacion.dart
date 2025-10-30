class Ubicacion {
  String? Id;
  double? Latitud;
  double? Longitud;

  Ubicacion({

    this.Id,
    this.Latitud,
    this.Longitud,

  });

  Ubicacion.vacio()
    : Id= "",
      Latitud = null,
      Longitud = null;

}