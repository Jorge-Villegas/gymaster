// import 'package:asistente_de_entrenamientos/providers/serie_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DetalleRutina extends StatefulWidget {
//   const DetalleRutina({super.key});

//   @override
//   State<DetalleRutina> createState() => _DetalleRutinaState();
// }

// class _DetalleRutinaState extends State<DetalleRutina> {
//   final repeticiones = <Repeticion>[];

//   @override
//   Widget build(BuildContext context) {
//     int contador = 1;
//     final sp = Provider.of<SerieProvider>(context);

//     return DataTable(
//       //altura de las filas
//       headingRowHeight: 30,
//       dataRowHeight: 25,
//       //Espaciado entre las filas
//       columnSpacing: 20,
//       columns: const <DataColumn>[
//         DataColumn(label: Expanded(child: Text('Serie'))),
//         DataColumn(label: Expanded(child: Text('Peso'))),
//         DataColumn(label: Expanded(child: Text('Reps'))),
//       ],
//       rows: sp
//           .getRepeticionesTodo()
//           .map((repeticion) => DataRow(cells: [
//                 DataCell(Text('${contador++}')),
//                 DataCell(Text('${repeticion.peso}')),
//                 DataCell(Text('${repeticion.cantidad}')),
//               ]))
//           .toList(),
//     );
//   }
// }
