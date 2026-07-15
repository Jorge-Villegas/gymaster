import 'package:flutter/material.dart';

/// Fuente ÚNICA de verdad para el color, expuesta como [ThemeExtension]: los
/// widgets leen el color del tema activo con `context.gym.brand`. La marca es
/// seleccionable por el usuario ([GymAccent] + [GymColors.withAccent]); el
/// verde queda reservado a `success`.
@immutable
class GymColors extends ThemeExtension<GymColors> {
  final Color bg;
  final Color panel;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color muted;
  final Color faint;
  final Color line;
  final Color lineStrong;

  final Color brand;
  final Color brandInk;
  final Color brandSoft;
  final Color coral;
  final Color coralInk;
  final Color coralSoft;
  final Color xp;
  final Color xpInk;
  final Color xpSoft;
  final Color info;
  final Color infoSoft;
  final Color plum;
  final Color plumSoft;

  final Color success; // verde reservado: "hecho / completado / logro"
  final Color successSoft;
  final Color danger;

  const GymColors({
    required this.bg,
    required this.panel,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.muted,
    required this.faint,
    required this.line,
    required this.lineStrong,
    required this.brand,
    required this.brandInk,
    required this.brandSoft,
    required this.coral,
    required this.coralInk,
    required this.coralSoft,
    required this.xp,
    required this.xpInk,
    required this.xpSoft,
    required this.info,
    required this.infoSoft,
    required this.plum,
    required this.plumSoft,
    required this.success,
    required this.successSoft,
    required this.danger,
  });

  static const GymColors light = GymColors(
    bg: Color(0xFFF4F5F7),
    panel: Color(0xFFE8EAEF),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF1F3F6),
    ink: Color(0xFF15181D),
    muted: Color(0xFF5C6470),
    faint: Color(0xFF6C7480),
    line: Color(0xFFE5E8ED),
    lineStrong: Color(0xFFD1D6DE),
    brand: Color(0xFF7C3AED),
    brandInk: Color(0xFF5B21B6),
    brandSoft: Color(0xFFEDE4FF),
    coral: Color(0xFFFF5470),
    coralInk: Color(0xFFE23457),
    coralSoft: Color(0xFFFFE1E7),
    xp: Color(0xFFFFC531),
    xpInk: Color(0xFFE0A800),
    xpSoft: Color(0xFFFFF3D1),
    info: Color(0xFF38B6FF),
    infoSoft: Color(0xFFDBF0FF),
    plum: Color(0xFF7B61FF),
    plumSoft: Color(0xFFEAE5FF),
    success: Color(0xFF2FBF5B),
    successSoft: Color(0xFFE0F6E7),
    danger: Color(0xFFFF4D5E),
  );

  static const GymColors dark = GymColors(
    bg: Color(0xFF0E1013),
    panel: Color(0xFF171A1F),
    surface: Color(0xFF1B1E24),
    surface2: Color(0xFF24272E),
    ink: Color(0xFFECEEF2),
    muted: Color(0xFF9AA2AE),
    faint: Color(0xFF858D99),
    line: Color(0xFF2C3038),
    lineStrong: Color(0xFF3B404A),
    brand: Color(0xFF9366F0),
    brandInk: Color(0xFF5B21B6),
    brandSoft: Color(0xFF241A3D),
    coral: Color(0xFFFF6A82),
    coralInk: Color(0xFFC93A54),
    coralSoft: Color(0xFF3A1A22),
    xp: Color(0xFFFFD24D),
    xpInk: Color(0xFFB8860B),
    xpSoft: Color(0xFF33290B),
    info: Color(0xFF54BEFF),
    infoSoft: Color(0xFF12293A),
    plum: Color(0xFF9985FF),
    plumSoft: Color(0xFF241E42),
    success: Color(0xFF3ED273),
    successSoft: Color(0xFF12301E),
    danger: Color(0xFFFF6472),
  );

  @override
  GymColors copyWith({
    Color? bg,
    Color? panel,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? muted,
    Color? faint,
    Color? line,
    Color? lineStrong,
    Color? brand,
    Color? brandInk,
    Color? brandSoft,
    Color? coral,
    Color? coralInk,
    Color? coralSoft,
    Color? xp,
    Color? xpInk,
    Color? xpSoft,
    Color? info,
    Color? infoSoft,
    Color? plum,
    Color? plumSoft,
    Color? success,
    Color? successSoft,
    Color? danger,
  }) {
    return GymColors(
      bg: bg ?? this.bg,
      panel: panel ?? this.panel,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      faint: faint ?? this.faint,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      brand: brand ?? this.brand,
      brandInk: brandInk ?? this.brandInk,
      brandSoft: brandSoft ?? this.brandSoft,
      coral: coral ?? this.coral,
      coralInk: coralInk ?? this.coralInk,
      coralSoft: coralSoft ?? this.coralSoft,
      xp: xp ?? this.xp,
      xpInk: xpInk ?? this.xpInk,
      xpSoft: xpSoft ?? this.xpSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
      plum: plum ?? this.plum,
      plumSoft: plumSoft ?? this.plumSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
    );
  }

  @override
  GymColors lerp(ThemeExtension<GymColors>? other, double t) {
    if (other is! GymColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return GymColors(
      bg: l(bg, other.bg),
      panel: l(panel, other.panel),
      surface: l(surface, other.surface),
      surface2: l(surface2, other.surface2),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      faint: l(faint, other.faint),
      line: l(line, other.line),
      lineStrong: l(lineStrong, other.lineStrong),
      brand: l(brand, other.brand),
      brandInk: l(brandInk, other.brandInk),
      brandSoft: l(brandSoft, other.brandSoft),
      coral: l(coral, other.coral),
      coralInk: l(coralInk, other.coralInk),
      coralSoft: l(coralSoft, other.coralSoft),
      xp: l(xp, other.xp),
      xpInk: l(xpInk, other.xpInk),
      xpSoft: l(xpSoft, other.xpSoft),
      info: l(info, other.info),
      infoSoft: l(infoSoft, other.infoSoft),
      plum: l(plum, other.plum),
      plumSoft: l(plumSoft, other.plumSoft),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      danger: l(danger, other.danger),
    );
  }

  /// Devuelve la paleta con el trío de marca (brand/brandInk/brandSoft) del
  /// [accent] elegido por el usuario. El resto de tokens (neutros, semánticos,
  /// acentos de gamificación) no cambian. [dark] selecciona el tono adecuado
  /// para el tema activo.
  GymColors withAccent(GymAccent accent, {required bool dark}) {
    final s = (dark ? _accentDark : _accentLight)[accent]!;
    return copyWith(
      brand: s.brand,
      brandInk: s.brandInk,
      brandSoft: s.brandSoft,
    );
  }
}

/// Acentos de marca seleccionables por el usuario en Ajustes.
enum GymAccent { violeta, magenta, turquesa }

/// Metadatos de cada acento para pintar el selector (nombre + swatch).
extension GymAccentMeta on GymAccent {
  String get etiqueta => switch (this) {
        GymAccent.violeta => 'Violeta eléctrico',
        GymAccent.magenta => 'Magenta fucsia',
        GymAccent.turquesa => 'Turquesa profundo',
      };

  /// Color representativo para el swatch del selector (tono claro).
  Color get swatch => _accentLight[this]!.brand;

  /// Parseo tolerante desde el string persistido (default: violeta).
  static GymAccent desde(String? nombre) => GymAccent.values.firstWhere(
        (a) => a.name == nombre,
        orElse: () => GymAccent.violeta,
      );
}

/// Trío de marca (brand, brandInk, brandSoft) por acento.
class _AccentSpec {
  final Color brand;
  final Color brandInk;
  final Color brandSoft;
  const _AccentSpec(this.brand, this.brandInk, this.brandSoft);
}

const Map<GymAccent, _AccentSpec> _accentLight = {
  GymAccent.violeta:
      _AccentSpec(Color(0xFF7C3AED), Color(0xFF5B21B6), Color(0xFFEDE4FF)),
  GymAccent.magenta:
      _AccentSpec(Color(0xFFE6007E), Color(0xFFB10062), Color(0xFFFFE0F0)),
  GymAccent.turquesa:
      _AccentSpec(Color(0xFF00BFA6), Color(0xFF00897B), Color(0xFFD6F7F1)),
};

const Map<GymAccent, _AccentSpec> _accentDark = {
  GymAccent.violeta:
      _AccentSpec(Color(0xFF9366F0), Color(0xFF5B21B6), Color(0xFF241A3D)),
  GymAccent.magenta:
      _AccentSpec(Color(0xFFFF3DA0), Color(0xFFB10062), Color(0xFF3A0F27)),
  GymAccent.turquesa:
      _AccentSpec(Color(0xFF1FDCC2), Color(0xFF00897B), Color(0xFF0C3330)),
};

/// Radios de esquina (estilo juguetón moderado).
class GymRadius {
  const GymRadius._();
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 26;
  static const double pill = 999;

  static const BorderRadius rSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(lg));
}

/// Acceso corto a los tokens desde cualquier widget: `context.gym.brand`.
extension GymThemeContext on BuildContext {
  GymColors get gym => Theme.of(this).extension<GymColors>() ?? GymColors.dark;
}
