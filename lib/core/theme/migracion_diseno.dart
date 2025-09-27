import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/espaciado.dart';

/// Utilidad para migrar automáticamente widgets que no cumplen las reglas de diseño
///
/// Esta clase proporciona métodos estáticos para:
/// - Convertir fontSize no conformes a TipografiaGyMaster
/// - Convertir EdgeInsets no conformes a Espaciado
/// - Validar cumplimiento de reglas
class MigracionDiseno {
  /// Mapea fontSize no conformes a los más cercanos conformes
  static final Map<double, TextStyle> _mapeoFontSize = {
    14.0: TipografiaGyMaster.textoSecundario, // 12px
    16.0: TipografiaGyMaster.textoPrincipal, // 15px
    17.0: TipografiaGyMaster.subtitulo, // 18px
    20.0: TipografiaGyMaster.subtitulo, // 18px
    22.0: TipografiaGyMaster.titulo, // 24px
    32.0: TipografiaGyMaster.titulo, // 24px (máximo permitido)
    50.0: TipografiaGyMaster.titulo, // 24px (máximo permitido)
    60.0: TipografiaGyMaster.titulo, // 24px (máximo permitido)
  };

  /// Mapea EdgeInsets no conformes a los más cercanos conformes
  static final Map<double, double> _mapeoEspaciado = {
    2.5: 8.0, // xs
    6.0: 8.0, // xs
    10.0: 8.0, // xs
    12.0: 16.0, // sm
    14.0: 16.0, // sm
    15.0: 16.0, // sm
    18.0: 16.0, // sm
    20.0: 24.0, // md
    22.0: 24.0, // md
    25.0: 24.0, // md
  };

  /// Obtiene el TextStyle conforme más cercano para un fontSize dado
  static TextStyle obtenerEstiloConforme(double fontSize) {
    // Si ya es conforme, usar el estilo correspondiente
    if (fontSize == 12.0) return TipografiaGyMaster.textoSecundario;
    if (fontSize == 15.0) return TipografiaGyMaster.textoPrincipal;
    if (fontSize == 18.0) return TipografiaGyMaster.subtitulo;
    if (fontSize == 24.0) return TipografiaGyMaster.titulo;

    // Si no es conforme, usar el mapeo
    if (_mapeoFontSize.containsKey(fontSize)) {
      return _mapeoFontSize[fontSize]!;
    }

    // Si no está en el mapeo, buscar el más cercano
    double menorDiferencia = double.infinity;
    TextStyle estiloMasCercano = TipografiaGyMaster.textoPrincipal;

    for (final entry in _mapeoFontSize.entries) {
      final diferencia = (fontSize - entry.key).abs();
      if (diferencia < menorDiferencia) {
        menorDiferencia = diferencia;
        estiloMasCercano = entry.value;
      }
    }

    return estiloMasCercano;
  }

  /// Obtiene el espaciado conforme más cercano
  static double obtenerEspaciadoConforme(double espaciado) {
    // Si ya es múltiplo de 8, devolver tal como está
    if (espaciado % 8 == 0) return espaciado;

    // Si está en el mapeo, usar el valor mapeado
    if (_mapeoEspaciado.containsKey(espaciado)) {
      return _mapeoEspaciado[espaciado]!;
    }

    // Si no, redondear al múltiplo de 8 más cercano
    return (espaciado / 8).round() * 8.0;
  }

  /// Convierte EdgeInsets.all() no conforme a conforme
  static EdgeInsets convertirEdgeInsetsAll(double valor) {
    final valorConforme = obtenerEspaciadoConforme(valor);

    // Usar constantes predefinidas cuando sea posible
    if (valorConforme == 8.0) return Espaciado.rellenoXs;
    if (valorConforme == 16.0) return Espaciado.rellenoSm;
    if (valorConforme == 24.0) return Espaciado.rellenoMd;
    if (valorConforme == 32.0) return Espaciado.rellenoLg;
    if (valorConforme == 40.0) return Espaciado.rellenoXl;

    return EdgeInsets.all(valorConforme);
  }

  /// Convierte EdgeInsets.symmetric() no conforme a conforme
  static EdgeInsets convertirEdgeInsetsSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    final horizontalConforme = obtenerEspaciadoConforme(horizontal);
    final verticalConforme = obtenerEspaciadoConforme(vertical);

    // Usar constantes predefinidas cuando sea posible
    if (horizontalConforme == 16.0 && verticalConforme == 0.0) {
      return Espaciado.rellenoHorizontalSm;
    }
    if (horizontalConforme == 24.0 && verticalConforme == 0.0) {
      return Espaciado.rellenoHorizontalMd;
    }
    if (horizontalConforme == 0.0 && verticalConforme == 16.0) {
      return Espaciado.rellenoVerticalSm;
    }
    if (horizontalConforme == 0.0 && verticalConforme == 24.0) {
      return Espaciado.rellenoVerticalMd;
    }

    return EdgeInsets.symmetric(
      horizontal: horizontalConforme,
      vertical: verticalConforme,
    );
  }

  /// Obtiene un SizedBox conforme para separación
  static Widget obtenerSeparacion({
    double? width,
    double? height,
  }) {
    if (width != null && height == null) {
      // Separación horizontal
      final widthConforme = obtenerEspaciadoConforme(width);
      if (widthConforme == 8.0) return Espaciado.separacionHorizontalXs;
      if (widthConforme == 16.0) return Espaciado.separacionHorizontalSm;
      if (widthConforme == 24.0) return Espaciado.separacionHorizontalMd;
      if (widthConforme == 32.0) return Espaciado.separacionHorizontalLg;
      return SizedBox(width: widthConforme);
    }

    if (height != null && width == null) {
      // Separación vertical
      final heightConforme = obtenerEspaciadoConforme(height);
      if (heightConforme == 8.0) return Espaciado.separacionVerticalXs;
      if (heightConforme == 16.0) return Espaciado.separacionVerticalSm;
      if (heightConforme == 24.0) return Espaciado.separacionVerticalMd;
      if (heightConforme == 32.0) return Espaciado.separacionVerticalLg;
      return SizedBox(height: heightConforme);
    }

    // Si tiene ambos o ninguno, usar SizedBox estándar con valores conformes
    return SizedBox(
      width: width != null ? obtenerEspaciadoConforme(width) : null,
      height: height != null ? obtenerEspaciadoConforme(height) : null,
    );
  }

  /// Valida si un fontSize es conforme
  static bool esFontSizeConforme(double fontSize) {
    return [12.0, 15.0, 18.0, 24.0].contains(fontSize);
  }

  /// Valida si un espaciado es conforme (múltiplo de 8)
  static bool esEspaciadoConforme(double espaciado) {
    return espaciado % 8 == 0;
  }

  /// Genera reporte de conversiones sugeridas
  static Map<String, dynamic> generarReporteConversiones({
    required List<double> fontSizesEncontrados,
    required List<double> espaciadosEncontrados,
  }) {
    final fontSizesNoConformes = fontSizesEncontrados
        .where((fs) => !esFontSizeConforme(fs))
        .toSet()
        .toList();

    final espaciadosNoConformes = espaciadosEncontrados
        .where((esp) => !esEspaciadoConforme(esp))
        .toSet()
        .toList();

    return {
      'fontSize': {
        'noConformes': fontSizesNoConformes,
        'conversiones': Map.fromEntries(
          fontSizesNoConformes.map((fs) => MapEntry(
                fs,
                obtenerEstiloConforme(fs).fontSize,
              )),
        ),
      },
      'espaciado': {
        'noConformes': espaciadosNoConformes,
        'conversiones': Map.fromEntries(
          espaciadosNoConformes.map((esp) => MapEntry(
                esp,
                obtenerEspaciadoConforme(esp),
              )),
        ),
      },
    };
  }

  /// Constantes de reemplazo para búsqueda y reemplazo automático
  static const Map<String, String> patronesReemplazo = {
    // FontSize patterns
    'fontSize: 14': 'fontSize: TipografiaGyMaster.textoSecundario.fontSize',
    'fontSize: 16': 'fontSize: TipografiaGyMaster.textoPrincipal.fontSize',
    'fontSize: 17': 'fontSize: TipografiaGyMaster.subtitulo.fontSize',
    'fontSize: 20': 'fontSize: TipografiaGyMaster.subtitulo.fontSize',
    'fontSize: 22': 'fontSize: TipografiaGyMaster.titulo.fontSize',
    'fontSize: 32': 'fontSize: TipografiaGyMaster.titulo.fontSize',

    // EdgeInsets patterns
    'EdgeInsets.all(2.5)': 'Espaciado.rellenoXs',
    'EdgeInsets.all(6)': 'Espaciado.rellenoXs',
    'EdgeInsets.all(12)': 'Espaciado.rellenoSm',
    'EdgeInsets.all(20)': 'Espaciado.rellenoMd',

    // SizedBox patterns
    'SizedBox(width: 20)': 'Espaciado.separacionHorizontalMd',
    'SizedBox(height: 16)': 'Espaciado.separacionVerticalSm',
    'SizedBox(width: 16)': 'Espaciado.separacionHorizontalSm',
    'SizedBox(height: 8)': 'Espaciado.separacionVerticalXs',
  };

  /// Imports necesarios para usar el sistema de diseño
  static const List<String> importsNecesarios = [
    "import 'package:gymaster/core/theme/tipografia_gymaster.dart';",
    "import 'package:gymaster/core/theme/espaciado.dart';",
  ];

  /// Verifica si un archivo ya tiene los imports necesarios
  static bool tieneImportsNecesarios(String contenidoArchivo) {
    return importsNecesarios.every(
      (import) => contenidoArchivo.contains(import),
    );
  }

  /// Agrega los imports necesarios al inicio de un archivo
  static String agregarImports(String contenidoArchivo) {
    if (tieneImportsNecesarios(contenidoArchivo)) return contenidoArchivo;

    final lineas = contenidoArchivo.split('\n');
    int indiceInsercion = 0;

    // Buscar dónde insertar (después de los imports existentes)
    for (int i = 0; i < lineas.length; i++) {
      if (lineas[i].startsWith('import ') || lineas[i].startsWith("import '")) {
        indiceInsercion = i + 1;
      } else if (lineas[i].trim().isEmpty && indiceInsercion > 0) {
        break;
      }
    }

    // Insertar los imports necesarios
    final importsToAdd = importsNecesarios
        .where(
          (import) => !contenidoArchivo.contains(import),
        )
        .toList();

    if (importsToAdd.isNotEmpty) {
      lineas.insertAll(indiceInsercion, importsToAdd);
    }

    return lineas.join('\n');
  }
}

/// Extensiones útiles para aplicar el sistema de diseño
extension TextStyleConformeExtension on TextStyle {
  /// Convierte este TextStyle a uno conforme si no lo es
  TextStyle toConforme() {
    if (fontSize == null) return this;

    if (MigracionDiseno.esFontSizeConforme(fontSize!)) {
      return this;
    }

    final estiloConforme = MigracionDiseno.obtenerEstiloConforme(fontSize!);
    return copyWith(
      fontSize: estiloConforme.fontSize,
      fontWeight: fontWeight ?? estiloConforme.fontWeight,
    );
  }
}

extension EdgeInsetsConformeExtension on EdgeInsets {
  /// Convierte estos EdgeInsets a conformes si no lo son
  EdgeInsets toConforme() {
    return EdgeInsets.only(
      left: MigracionDiseno.obtenerEspaciadoConforme(left),
      top: MigracionDiseno.obtenerEspaciadoConforme(top),
      right: MigracionDiseno.obtenerEspaciadoConforme(right),
      bottom: MigracionDiseno.obtenerEspaciadoConforme(bottom),
    );
  }
}
