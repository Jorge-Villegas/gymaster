import 'package:flutter/material.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';

class ChicletButtonTestPage extends StatelessWidget {
  const ChicletButtonTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test ChicletButton'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ChicletButton Tamaño Pequeño:'),
            const SizedBox(height: 16),

            // Test en Row como en los headers
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ChicletButton(
                    onPressed: () {},
                    texto: 'Volver',
                    icono: Icons.arrow_back_ios_rounded,
                    tamano: TamanoBotonChiclet.pequeno,
                    estilo: EstiloBotonChiclet.contorno,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¡Texto principal!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Texto secundario más pequeño',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('Comparación de tamaños:'),
            const SizedBox(height: 16),

            // Comparación de tamaños
            Row(
              children: [
                ChicletButton(
                  onPressed: () {},
                  texto: 'Pequeño',
                  icono: Icons.star,
                  tamano: TamanoBotonChiclet.pequeno,
                  estilo: EstiloBotonChiclet.contorno,
                ),
                const SizedBox(width: 16),
                ChicletButton(
                  onPressed: () {},
                  texto: 'Mediano',
                  icono: Icons.star,
                  tamano: TamanoBotonChiclet.mediano,
                  estilo: EstiloBotonChiclet.contorno,
                ),
                const SizedBox(width: 16),
                ChicletButton(
                  onPressed: () {},
                  texto: 'Grande',
                  icono: Icons.star,
                  tamano: TamanoBotonChiclet.grande,
                  estilo: EstiloBotonChiclet.contorno,
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text('Diferentes estilos pequeño:'),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChicletButton(
                  onPressed: () {},
                  texto: 'Contorno',
                  icono: Icons.favorite_border,
                  tamano: TamanoBotonChiclet.pequeno,
                  estilo: EstiloBotonChiclet.contorno,
                ),
                const SizedBox(height: 12),
                ChicletButton(
                  onPressed: () {},
                  texto: 'Relleno',
                  icono: Icons.favorite,
                  tamano: TamanoBotonChiclet.pequeno,
                  estilo: EstiloBotonChiclet.relleno,
                ),
                const SizedBox(height: 12),
                ChicletButton(
                  onPressed: () {},
                  texto: 'Solo Texto',
                  icono: Icons.text_fields,
                  tamano: TamanoBotonChiclet.pequeno,
                  estilo: EstiloBotonChiclet.texto,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
