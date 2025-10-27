class Ubicacion {
  String Id;
  double? Latitud;
  double? Longitud;

  Ubicacion({

    required this.Id,
    required this.Latitud,
    required this.Longitud,

  });

  Ubicacion.vacio()
    : Id= "",
      Latitud = null,
      Longitud = null;

}