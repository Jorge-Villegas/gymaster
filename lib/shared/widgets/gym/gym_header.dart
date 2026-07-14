import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/widgets/gym/gym_containers.dart';

/// =============================================================================
/// ADN COMPARTIDO DE ENCABEZADOS — GyMaster
/// -----------------------------------------------------------------------------
/// Piezas base que TODAS las pantallas reutilizan para que se sientan de la
/// misma app (mismo color, tipografía y radios) aunque cada pantalla componga
/// su header de forma única. Reemplaza estilos hardcodeados como el viejo
/// `AppBarCustom` (que fijaba `Colors.white` y rompía el modo oscuro).
/// =============================================================================

/// Píldora de estadística viva (racha 🔥, XP ⭐, gemas, etc.).
///
/// Es el "gancho" de retención: muestra el dato más importante siempre visible
/// y tocable. El color se toma del [tone] con significado fijo
/// (coral = racha, xp = experiencia), igual que el código de color de Duolingo.
class GymStatPill extends StatelessWidget {
  /// Emoji o texto corto que actúa como icono (ej. '🔥', '⭐').
  final String icon;

  /// Valor a mostrar (ej. '5', '120').
  final String value;

  /// Tono semántico que define el color de fondo y texto.
  final GymTone tone;

  /// Acción al tocar (abre el detalle → "inversión" del Hook Model).
  final VoidCallback? onTap;

  const GymStatPill({
    super.key,
    required this.icon,
    required this.value,
    this.tone = GymTone.neutral,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final (Color bg, Color fg) = switch (tone) {
      GymTone.brand => (c.brandSoft, c.brandInk),
      GymTone.coral => (c.coralSoft, c.coralInk),
      GymTone.xp => (c.xpSoft, c.xpInk),
      GymTone.info => (c.infoSoft, c.info),
      GymTone.plum => (c.plumSoft, c.plum),
      GymTone.neutral => (c.surface2, c.muted),
    };

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: GymRadius.rSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 5),
          Text(
            value,
            style: GymType.label.copyWith(
              color: fg,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: GymRadius.rSm,
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// Botón redondo de icono, temático y consistente (atrás, ajustes, campana…).
///
/// Un solo estilo para todos los headers, en lugar de que cada pantalla dibuje
/// su propio botón. Respeta claro/oscuro vía [context.gym].
class GymIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  /// Color del icono (por defecto `ink`). El fondo siempre es una superficie
  /// suave del tema.
  final Color? iconColor;

  /// Badge opcional (punto de notificación) en la esquina superior derecha.
  final bool showBadge;

  final String? tooltip;

  const GymIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.showBadge = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    Widget boton = Material(
      color: c.surface,
      shape: CircleBorder(side: BorderSide(color: c.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: iconColor ?? c.ink),
        ),
      ),
    );

    if (showBadge) {
      boton = Stack(
        clipBehavior: Clip.none,
        children: [
          boton,
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: c.danger,
                shape: BoxShape.circle,
                border: Border.all(color: c.bg, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: boton);
    }
    return boton;
  }
}
