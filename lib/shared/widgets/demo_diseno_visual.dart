import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/shared/widgets/componentes_gym_reutilizables.dart';

/// Página de demostración para las reglas de diseño visual de GyMaster
///
/// Muestra ejemplos de:
/// - Sistema de espaciado de 8 puntos
/// - Tipografía limitada (4 tamaños, 2 pesos)
/// - Componentes reutilizables
/// - Colores del sistema HSB
class PaginaDemostracionDiseno extends StatelessWidget {
  const PaginaDemostracionDiseno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guía de Diseño GyMaster',
          style: TipografiaGyMaster.titulo,
        ),
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: Espaciado.rellenoHorizontalMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Espaciado.separacionVerticalMd,

            // === SECCIÓN TIPOGRAFÍA ===
            _buildSeccionTipografia(),

            Espaciado.separacionVerticalLg,

            // === SECCIÓN ESPACIADO ===
            _buildSeccionEspaciado(),

            Espaciado.separacionVerticalLg,

            // === SECCIÓN COMPONENTES REUTILIZABLES ===
            _buildSeccionComponentes(),

            Espaciado.separacionVerticalLg,

            // === SECCIÓN COLORES ===
            _buildSeccionColores(),

            Espaciado.separacionVerticalXl,
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionTipografia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📝 Tipografía Obligatoria',
          style: TipografiaGyMaster.titulo,
        ),

        Espaciado.separacionVerticalSm,

        Text(
          'Solo 4 tamaños permitidos: 12, 15, 18, 24 px\nSolo 2 pesos: Light (300) y SemiBold (600)',
          style: TipografiaGyMaster.textoPrincipal,
        ),

        Espaciado.separacionVerticalMd,

        // Ejemplos de tipografía
        Container(
          padding: Espaciado.rellenoMd,
          decoration: BoxDecoration(
            color: AppColors.fondoSecundarioClaro,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Título (24px, SemiBold)',
                style: TipografiaGyMaster.titulo,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Subtítulo (18px, SemiBold)',
                style: TipografiaGyMaster.subtitulo,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Texto principal (15px, Light)',
                style: TipografiaGyMaster.textoPrincipal,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Texto secundario (12px, Light)',
                style: TipografiaGyMaster.textoSecundario,
              ),
              Espaciado.separacionVerticalSm,
              Text(
                'Específicos del gimnasio:',
                style: TipografiaGyMaster.textoPrincipal,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Rutina de Pecho',
                style: TipografiaGyMaster.nombreRutina,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Press de banca',
                style: TipografiaGyMaster.nombreEjercicio,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                '3 series × 12 reps',
                style: TipografiaGyMaster.infoSeriesReps,
              ),
              Espaciado.separacionVerticalXs,
              Text(
                'Pecho',
                style: TipografiaGyMaster.grupoMuscular,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionEspaciado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📏 Sistema de Espaciado (8 puntos)',
          style: TipografiaGyMaster.titulo,
        ),

        Espaciado.separacionVerticalSm,

        Text(
          'Solo múltiplos de 8: 0, 8, 16, 24, 32, 40, 48...',
          style: TipografiaGyMaster.textoPrincipal,
        ),

        Espaciado.separacionVerticalMd,

        // Ejemplos de espaciado
        Container(
          padding: Espaciado.rellenoMd,
          decoration: BoxDecoration(
            color: AppColors.fondoSecundarioClaro,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ejemplos de espaciado:',
                style: TipografiaGyMaster.subtitulo,
              ),
              Espaciado.separacionVerticalSm,
              _buildEjemploEspaciado(
                  'XS - 8px', Espaciado.xs, AppColors.primario),
              _buildEjemploEspaciado(
                  'SM - 16px', Espaciado.sm, AppColors.secundario),
              _buildEjemploEspaciado(
                  'MD - 24px', Espaciado.md, AppColors.acento),
              _buildEjemploEspaciado(
                  'LG - 32px', Espaciado.lg, AppColors.exito),
              _buildEjemploEspaciado(
                  'XL - 40px', Espaciado.xl, AppColors.acentoCalido),
              Espaciado.separacionVerticalSm,
              Text(
                'Padding pre-configurados:',
                style: TipografiaGyMaster.textoPrincipal,
              ),
              Espaciado.separacionVerticalXs,
              Container(
                padding: Espaciado.rellenoXs,
                color: AppColors.primario.withValues(alpha: 0.2),
                child: Text(
                  'Espaciado.rellenoXs (8px)',
                  style: TipografiaGyMaster.textoSecundario,
                ),
              ),
              Espaciado.separacionVerticalXs,
              Container(
                padding: Espaciado.rellenoSm,
                color: AppColors.secundario.withValues(alpha: 0.2),
                child: Text(
                  'Espaciado.rellenoSm (16px)',
                  style: TipografiaGyMaster.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEjemploEspaciado(String etiqueta, double valor, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: Espaciado.xs),
      child: Row(
        children: [
          Container(
            width: valor,
            height: Espaciado.sm,
            color: color,
          ),
          Espaciado.separacionHorizontalSm,
          Text(
            etiqueta,
            style: TipografiaGyMaster.textoSecundario,
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionComponentes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🧩 Componentes Reutilizables',
          style: TipografiaGyMaster.titulo,
        ),

        Espaciado.separacionVerticalSm,

        Text(
          'Widgets que implementan automáticamente las reglas de diseño',
          style: TipografiaGyMaster.textoPrincipal,
        ),

        Espaciado.separacionVerticalMd,

        // Ejemplos de componentes
        TarjetaRutina(
          nombreRutina: 'Rutina de Pecho y Tríceps',
          descripcionSeries: '6 ejercicios • 18 series totales',
          grupoMuscular: 'Pecho, Tríceps',
          estadoRutina: 'Completada',
          colorPersonalizado: AppColors.acento,
        ),

        TarjetaEjercicio(
          nombreEjercicio: 'Press de banca',
          seriesRepeticiones: '3 series × 10 reps',
          pesoUtilizado: '80 kg',
          completado: true,
        ),

        Espaciado.separacionVerticalSm,

        Row(
          children: [
            Expanded(
              child: ContadorPesoTiempo(
                valor: '80',
                unidad: 'kg',
                etiqueta: 'Peso',
              ),
            ),
            Espaciado.separacionHorizontalSm,
            Expanded(
              child: ContadorPesoTiempo(
                valor: '45',
                unidad: 'seg',
                etiqueta: 'Descanso',
              ),
            ),
          ],
        ),

        Espaciado.separacionVerticalSm,

        MensajeEstado(
          mensaje: '¡Excelente trabajo! Has completado tu rutina.',
          tipo: TipoMensaje.exito,
        ),

        Espaciado.separacionVerticalXs,

        MensajeEstado(
          mensaje: '¡Vamos, solo te faltan 2 ejercicios más!',
          tipo: TipoMensaje.motivacional,
        ),
      ],
    );
  }

  Widget _buildSeccionColores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎨 Sistema de Colores HSB',
          style: TipografiaGyMaster.titulo,
        ),
        Espaciado.separacionVerticalSm,
        Text(
          'Todos los colores definidos usando HSB (Hue, Saturation, Brightness)',
          style: TipografiaGyMaster.textoPrincipal,
        ),
        Espaciado.separacionVerticalMd,
        Wrap(
          spacing: Espaciado.xs,
          runSpacing: Espaciado.xs,
          children: [
            _buildEjemploColor('Primario', AppColors.primario),
            _buildEjemploColor('Secundario', AppColors.secundario),
            _buildEjemploColor('Motivación', AppColors.acento),
            _buildEjemploColor('Éxito', AppColors.exito),
            _buildEjemploColor('Energía', AppColors.acentoCalido),
            _buildEjemploColor('Descanso', AppColors.secundarioClaro),
            _buildEjemploColor('Advertencia', AppColors.advertencia),
            _buildEjemploColor('Error', AppColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildEjemploColor(String nombre, Color color) {
    return Container(
      padding: Espaciado.rellenoSm,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        nombre,
        style: TipografiaGyMaster.textoSecundario.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Validadores para asegurar cumplimiento de reglas
class ValidadorDiseno {
  /// Valida que un valor de espaciado sea múltiplo de 8
  static bool validarEspaciado(double valor) {
    return valor % 8 == 0;
  }

  /// Valida que un tamaño de fuente esté permitido
  static bool validarTamanoFuente(double tamano) {
    return TipografiaGyMaster.esTamanoValido(tamano);
  }

  /// Valida que un peso de fuente esté permitido
  static bool validarPesoFuente(FontWeight peso) {
    return TipografiaGyMaster.esPesoValido(peso);
  }

  /// Obtiene el espaciado válido más cercano (múltiplo de 8)
  static double obtenerEspaciadoValido(double valor) {
    return (valor / 8).round() * 8.0;
  }

  /// Obtiene el tamaño de fuente válido más cercano
  static double obtenerTamanoFuenteValido(double tamano) {
    const tamanosPermitidos = [12.0, 15.0, 18.0, 24.0];

    double menorDiferencia = double.infinity;
    double tamanoMasCercano = tamanosPermitidos.first;

    for (final tamanoPermitido in tamanosPermitidos) {
      final diferencia = (tamano - tamanoPermitido).abs();
      if (diferencia < menorDiferencia) {
        menorDiferencia = diferencia;
        tamanoMasCercano = tamanoPermitido;
      }
    }

    return tamanoMasCercano;
  }
}
