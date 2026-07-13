import 'package:flutter/material.dart';

/// =============================================================================
/// TOKENS DE COLOR — paleta candy "Duolingo del gym" 🐀
/// -----------------------------------------------------------------------------
/// Fuente ÚNICA de verdad para el color. Se expone como [ThemeExtension] para
/// que cualquier widget lea el color correcto según el tema (claro/oscuro) con
/// `context.gym.brand`, sin hardcodear `Colors.white` ni pasar variables a mano.
///
/// Reemplaza a `AppColors` (que tenía ~40 colores, funciones muertas y no
/// reaccionaba al tema → causa del dark mode roto).
/// =============================================================================
@immutable
class GymColors extends ThemeExtension<GymColors> {
  // Superficies y neutros
  final Color bg;
  final Color panel;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color muted;
  final Color faint;
  final Color line;
  final Color lineStrong;

  // Marca y acentos
  final Color brand;
  final Color brandInk; // sombra del botón 3D / texto sobre brandSoft
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

  // Semánticos
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
    required this.danger,
  });

  static const GymColors light = GymColors(
    bg: Color(0xFFEFF4EC),
    panel: Color(0xFFE4EBE0),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF5F8F3),
    ink: Color(0xFF14201A),
    muted: Color(0xFF5F6F65),
    faint: Color(0xFF8A998F),
    line: Color(0xFFE1E9DD),
    lineStrong: Color(0xFFCBD6C6),
    brand: Color(0xFF3FC55F),
    brandInk: Color(0xFF2A9D48),
    brandSoft: Color(0xFFE4F7E9),
    coral: Color(0xFFFF6B4A),
    coralInk: Color(0xFFE0492B),
    coralSoft: Color(0xFFFFE7E0),
    xp: Color(0xFFFFC531),
    xpInk: Color(0xFFE0A800),
    xpSoft: Color(0xFFFFF3D1),
    info: Color(0xFF38B6FF),
    infoSoft: Color(0xFFDBF0FF),
    plum: Color(0xFF7B61FF),
    plumSoft: Color(0xFFEAE5FF),
    danger: Color(0xFFFF4D5E),
  );

  static const GymColors dark = GymColors(
    bg: Color(0xFF0D1210),
    panel: Color(0xFF141C17),
    surface: Color(0xFF18211C),
    surface2: Color(0xFF1F2A23),
    ink: Color(0xFFEAF2EA),
    muted: Color(0xFF9AA79F),
    faint: Color(0xFF6E7D73),
    line: Color(0xFF263029),
    lineStrong: Color(0xFF334037),
    brand: Color(0xFF4BD46B),
    brandInk: Color(0xFF2F8F46),
    brandSoft: Color(0xFF17301E),
    coral: Color(0xFFFF7A5C),
    coralInk: Color(0xFFC9432A),
    coralSoft: Color(0xFF3A1E17),
    xp: Color(0xFFFFD24D),
    xpInk: Color(0xFFB8860B),
    xpSoft: Color(0xFF33290B),
    info: Color(0xFF54BEFF),
    infoSoft: Color(0xFF12293A),
    plum: Color(0xFF9985FF),
    plumSoft: Color(0xFF241E42),
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
      danger: l(danger, other.danger),
    );
  }
}

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
  GymColors get gym =>
      Theme.of(this).extension<GymColors>() ?? GymColors.dark;
}
