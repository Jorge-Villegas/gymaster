import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/espaciado.dart';

class ItemsPesosWidget extends StatefulWidget {
  final int items;
  const ItemsPesosWidget({
    super.key,
    required this.items,
  });

  @override
  State<ItemsPesosWidget> createState() => _ItemsPesosWidgetState();
}

class _ItemsPesosWidgetState extends State<ItemsPesosWidget> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  double peso1 = 0;
  double peso2 = 0;
  double peso3 = 0;
  double peso4 = 0;
  double peso5 = 0;
  double peso6 = 0;
  double peso7 = 0;
  double peso8 = 0;
  double peso9 = 0;
  double peso10 = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('1  :    ', style: TipografiaGyMaster.textoPrincipal),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                style: TipografiaGyMaster.contadorPesoTiempo,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: Espaciado.rellenoXs,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                onPressed: () {
                  setState(() {});
                },
                child: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                child: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('2  :    ', style: TipografiaGyMaster.textoPrincipal),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller2,
                keyboardType: TextInputType.number,
                style: TipografiaGyMaster.contadorPesoTiempo,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: Espaciado.rellenoXs,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                onPressed: () {
                  setState(() {});
                },
                child: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                child: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('3  :    ', style: TipografiaGyMaster.textoPrincipal),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                style: TipografiaGyMaster.contadorPesoTiempo,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: Espaciado.rellenoXs,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                onPressed: () {
                  setState(() {});
                },
                child: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textoSecundarioClaro,
                  backgroundColor: AppColors.fondoSecundarioClaro,
                ),
                child: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
