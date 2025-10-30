// import 'package:flutter/material.dart';
// import 'package:proyecto/Controllers/ClienteController.dart';
// import 'package:proyecto/Models/Cliente.dart';
// import 'package:intl/intl.dart';

// class ClienteReservacionesPage extends StatefulWidget {
//   const ClienteReservacionesPage({super.key});

//   @override
//   State<ClienteReservacionesPage> createState() =>
//       _ClienteReservacionesPageState();
// }

// class _ClienteReservacionesPageState extends State<ClienteReservacionesPage> {
//   final ClienteController _clienteController = ClienteController();
//   Cliente? cliente;

//   @override
//   void initState() {
//     super.initState();
//     cliente = _clienteController.obtenerCliente();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (cliente == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text("Mis Reservaciones"),
//           backgroundColor: Colors.orange,
//         ),
//         body: const Center(
//           child: Text("No hay reservaciones registradas."),
//         ),
//       );
//     }

//     final reservaciones = cliente!.ListaDeReservaciones ?? [];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mis Reservaciones"),
//         backgroundColor: Colors.orange,
//       ),
//       body: reservaciones.isEmpty
//           ? const Center(child: Text("No hay reservaciones aún."))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: reservaciones.length,
//               itemBuilder: (context, index) {
//                 final reservacion = reservaciones[index];
//                 final fechaFormateada =
//                     DateFormat('dd/MM/yyyy').format(reservacion.Fecha);
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text(reservacion.empresa.Nombre,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Estado: ${reservacion.Estado}"),
//                         Text("Fecha: $fechaFormateada"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
