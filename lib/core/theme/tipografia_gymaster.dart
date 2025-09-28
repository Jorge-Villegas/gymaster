import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Sistema de Tipografía Obligatorio para GyMaster
///
/// Implementa la regla estricta de tipografía:
/// - Solo 4 tamaños: 12, 15, 18, 24 px
/// - Solo 2 pesos: Light (300) y SemiBold (600)
/// - Nombres en español para elementos del dominio fitness
class TipografiaGyMaster {
  // ==============================================
  // TAMAÑOS PERMITIDOS (solo estos 4)
  // ==============================================
  /// Etiquetas, ayudas, info secundaria, badges
  static const double tamanoXs = 12.0;

  /// Texto de botones, inputs, subtítulos secundarios
  static const double tamanoSm = 14.0;

  /// Texto base, párrafos, descripciones principales
  static const double tamanoMd = 16.0;

  /// Subtítulos, encabezados de sección, cards
  static const double tamanoLg = 18.0;

  /// Títulos destacados, headers de pantalla
  static const double tamanoXl = 20.0;

  /// Títulos principales, hero, números grandes
  static const double tamano2xl = 24.0;

  /// Títulos principales, hero, números grandes
  static const double tamano3xl = 30.0;

  // ==============================================
  // PESOS PERMITIDOS (solo estos 2)
  // ==============================================

  /// Peso ligero para lectura cómoda
  static const FontWeight pesoLigero = FontWeight.w300; // Light

  /// Peso semi-bold para énfasis y jerarquía
  static const FontWeight pesoSemiBold = FontWeight.w600; // SemiBold

  // ==============================================
  // ESTILOS BASE PARA TEXTOS GENERALES
  // ==============================================

  /// Texto principal para lectura (15px, ligero)
  static TextStyle get textoPrincipal => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoLigero,
        color: AppColors.textoPrincipalClaro,
        height: 1.4,
      );

  /// Texto secundario para información adicional (12px, ligero)
  static TextStyle get textoSecundario => TextStyle(
        fontSize: tamanoXs,
        fontWeight: pesoLigero,
        color: AppColors.textoSecundarioClaro,
        height: 1.3,
      );

  /// Subtítulos importantes (18px, semibold)
  static TextStyle get subtitulo => TextStyle(
        fontSize: tamanoMd,
        fontWeight: pesoSemiBold,
        color: AppColors.textoPrincipalClaro,
        height: 1.3,
      );

  /// Títulos principales (24px, semibold)
  static TextStyle get titulo => TextStyle(
        fontSize: tamanoLg,
        fontWeight: pesoSemiBold,
        color: AppColors.textoPrincipalClaro,
        height: 1.2,
      );

  // ==============================================
  // ESTILOS ESPECÍFICOS DEL GIMNASIO (en español)
  // ==============================================

  /// Estilo para nombres de rutinas
  static TextStyle get nombreRutina => TextStyle(
        fontSize: tamanoMd,
        fontWeight: pesoSemiBold,
        color: AppColors.motivacionPrincipal,
        height: 1.2,
      );

  /// Estilo para nombres de ejercicios
  static TextStyle get nombreEjercicio => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoSemiBold,
        color: AppColors.textoPrincipalClaro,
        height: 1.3,
      );

  /// Estilo para información de series y repeticiones
  static TextStyle get infoSeriesReps => TextStyle(
        fontSize: tamanoXs,
        fontWeight: pesoLigero,
        color: AppColors.textoSecundarioClaro,
        height: 1.2,
      );

  /// Estilo para contadores de peso y tiempo
  static TextStyle get contadorPesoTiempo => TextStyle(
        fontSize: tamanoLg,
        fontWeight: pesoSemiBold,
        color: AppColors.energiaActiva,
        height: 1.0,
      );

  /// Estilo para grupos musculares
  static TextStyle get grupoMuscular => TextStyle(
        fontSize: tamanoXs,
        fontWeight: pesoSemiBold,
        color: AppColors.secundario,
        height: 1.2,
      );

  /// Estilo para estado de ejercicio (completado, en progreso)
  static TextStyle get estadoEjercicio => TextStyle(
        fontSize: tamanoXs,
        fontWeight: pesoLigero,
        color: AppColors.exitoCompletado,
        height: 1.2,
      );

  // ==============================================
  // ESTILOS PARA BOTONES
  // ==============================================

  /// Botón principal (15px, semibold)
  static TextStyle get botonPrincipal => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoSemiBold,
        color: Colors.white,
        height: 1.0,
      );

  /// Botón secundario (12px, semibold)
  static TextStyle get botonSecundario => TextStyle(
        fontSize: tamanoXs,
        fontWeight: pesoSemiBold,
        color: AppColors.secundario,
        height: 1.0,
      );

  // ==============================================
  // ESTILOS PARA ESTADOS EMOCIONALES
  // ==============================================

  /// Mensajes de éxito (15px, semibold, verde)
  static TextStyle get mensajeExito => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoSemiBold,
        color: AppColors.exitoCompletado,
        height: 1.3,
      );

  /// Mensajes de error (15px, semibold, rojo)
  static TextStyle get mensajeError => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoSemiBold,
        color: AppColors.errorAmigable,
        height: 1.3,
      );

  /// Mensajes de advertencia (15px, ligero, naranja)
  static TextStyle get mensajeAdvertencia => TextStyle(
        fontSize: tamanoSm,
        fontWeight: pesoLigero,
        color: AppColors.advertenciaSutil,
        height: 1.3,
      );

  /// Mensajes motivacionales (18px, semibold, primario)
  static TextStyle get mensajeMotivacional => TextStyle(
        fontSize: tamanoMd,
        fontWeight: pesoSemiBold,
        color: AppColors.motivacionPrincipal,
        height: 1.2,
      );

  // ==============================================
  // MÉTODOS HELPER PARA VARIACIONES
  // ==============================================

  /// Crea variación con color personalizado manteniendo reglas de tipografía
  static TextStyle conColor(TextStyle estilo, Color color) {
    return estilo.copyWith(color: color);
  }

  /// Crea variación itálica
  static TextStyle enItalica(TextStyle estilo) {
    return estilo.copyWith(fontStyle: FontStyle.italic);
  }

  /// Valida que un tamaño de fuente esté permitido
  static bool esTamanoValido(double tamano) {
    return tamano == tamanoXs ||
        tamano == tamanoSm ||
        tamano == tamanoMd ||
        tamano == tamanoLg;
  }

  /// Valida que un peso de fuente esté permitido
  static bool esPesoValido(FontWeight peso) {
    return peso == pesoLigero || peso == pesoSemiBold;
  }
}

/// Extensión para facilitar aplicación de estilos tipográficos
extension TipografiaExtension on Text {
  /// Aplica estilo de título
  Text comoTitulo() => Text(
        data!,
        style: TipografiaGyMaster.titulo,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  /// Aplica estilo de subtítulo
  Text comoSubtitulo() => Text(
        data!,
        style: TipografiaGyMaster.subtitulo,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  /// Aplica estilo de nombre de rutina
  Text comoNombreRutina() => Text(
        data!,
        style: TipografiaGyMaster.nombreRutina,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  /// Aplica estilo de nombre de ejercicio
  Text comoNombreEjercicio() => Text(
        data!,
        style: TipografiaGyMaster.nombreEjercicio,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
}
