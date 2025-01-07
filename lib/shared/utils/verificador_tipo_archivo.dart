class VerificadorTipoArchivo {
  // Constantes para las extensiones de archivos
  static const String _jpg = '.jpg';
  static const String _jpeg = '.jpeg';
  static const String _png = '.png';
  static const String _svg = '.svg';
  static const String _pdf = '.pdf';

  /// Verifica si la dirección del archivo es un archivo de imagen (JPG, JPEG, PNG, SVG).
  static bool esImagen(String direccion) {
    return _tieneExtension(direccion, [_jpg, _jpeg, _png, _svg]);
  }

  /// Verifica si la dirección del archivo es un archivo SVG.
  static bool esSvg(String direccion) {
    return _tieneExtension(direccion, [_svg]);
  }

  /// Verifica si la dirección del archivo es un archivo PNG.
  static bool esPng(String direccion) {
    return _tieneExtension(direccion, [_png]);
  }

  /// Verifica si la dirección del archivo es un archivo JPG.
  static bool esJpg(String direccion) {
    return _tieneExtension(direccion, [_jpg]);
  }

  /// Verifica si la dirección del archivo es un archivo PDF.
  static bool esPdf(String direccion) {
    return _tieneExtension(direccion, [_pdf]);
  }

  /// Método genérico que verifica si la dirección del archivo tiene alguna de las extensiones especificadas.
  static bool _tieneExtension(String direccion, List<String> extensiones) {
    if (direccion.isEmpty) {
      return false;
    }
    final direccionLower = direccion.toLowerCase();
    return extensiones.any((extension) => direccionLower.endsWith(extension));
  }
}