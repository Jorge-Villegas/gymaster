import 'package:flutter/material.dart';

class SerieItem extends StatelessWidget {
  final String ejercicioId;
  final String nombreEjercicio;
  final String? imagenDireccion;
  final bool estadoSerie;
  final int numeroSeries;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const SerieItem({
    super.key,
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.numeroSeries,
    required this.onDismissed,
    required this.onTap,
    this.imagenDireccion,
    required this.estadoSerie,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 200,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                width: constraints.maxWidth < 100 ? 150 : constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: const Color(0xffECEEF0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(imagenDireccion ??
                                  'assets/images/default_image.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              nombreEjercicio,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formatoNumeroSeries(numeroSeries),
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatoNumeroSeries(int numeroSeries) {
    return numeroSeries == 1 ? '1 serie' : '$numeroSeries series';
  }
}
