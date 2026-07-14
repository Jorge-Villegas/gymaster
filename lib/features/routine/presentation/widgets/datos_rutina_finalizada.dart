import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/widgets/tarjeta_estado.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class DatosRutinaFinalizada extends StatelessWidget {
  final int totalXp;
  final String porcentajeCompletado;
  final int totalEjercicios;

  const DatosRutinaFinalizada({
    super.key,
    required this.totalXp,
    required this.porcentajeCompletado,
    required this.totalEjercicios,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 32,
        vertical: isSmallScreen ? 8 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cards de estadísticas estilo GyMaster
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TarjetaEstado(
                  titulo: 'Total XP',
                  textoCuerpo: '$totalXp',
                  icono: IconsaxPlusLinear.flash,
                  colorFondo: context.gym.xpInk,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 24),
              Expanded(
                child: TarjetaEstado(
                  titulo: 'Completado',
                  textoCuerpo: porcentajeCompletado,
                  icono: IconsaxPlusLinear.tick_circle,
                  colorFondo: context.gym.brand,
                ),
              ),
              Expanded(
                child: TarjetaEstado(
                  titulo: 'Ejercicios',
                  textoCuerpo: totalEjercicios.toString(),
                  icono: IconsaxPlusLinear.weight,
                  colorFondo: context.gym.xpInk,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 32),
          // Botón continuar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.gym.brand,
                foregroundColor: Colors.white,
                padding:
                    EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 16 : 20,
                  letterSpacing: 1.2,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CONTINUAR'),
            ),
          ),
        ],
      ),
    );
  }
}
