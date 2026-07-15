import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

/// Abre la creación de rutina como bottom sheet (patrón quick-add: menos
/// fricción, mantiene el contexto de la lista detrás). Es el punto de entrada
/// recomendado desde el botón "+".
Future<void> mostrarCrearRutinaSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // permite subir sobre el teclado
    backgroundColor: Colors.transparent,
    builder: (_) => const _CrearRutinaSheet(),
  );
}

class _CrearRutinaSheet extends StatelessWidget {
  const _CrearRutinaSheet();

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final maxH = MediaQuery.of(context).size.height * 0.9;
    return Padding(
      // Sube la hoja por encima del teclado.
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Container(
          decoration: BoxDecoration(
            color: c.bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Manija de arrastre (affordance de bottom sheet).
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.lineStrong,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text('Nueva rutina',
                    style: GymType.title.copyWith(color: c.ink)),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: const CrearRutinaForm(enSheet: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formulario de creación de rutina, reutilizable por el bottom sheet y por la
/// página completa. Único paso obligatorio: el nombre.
class CrearRutinaForm extends StatefulWidget {
  /// Si se muestra dentro de un bottom sheet (para cerrarlo al crear).
  final bool enSheet;

  const CrearRutinaForm({super.key, this.enSheet = false});

  @override
  State<CrearRutinaForm> createState() => _CrearRutinaFormState();
}

class _CrearRutinaFormState extends State<CrearRutinaForm> {
  final _controladorTexto = TextEditingController();

  // Acentos = los 5 tonos de la paleta candy (la tarjeta normaliza por matiz).
  static const List<Color> _paleta = [
    Color(0xFF3D5AFE), // brand (cobalto)
    Color(0xFFFF5470), // coral
    Color(0xFFFFC531), // xp
    Color(0xFF38B6FF), // info
    Color(0xFF7B61FF), // plum
  ];

  final List<String> _iconos = [
    Assets.icons.otros.biceps.path,
    Assets.icons.otros.pesas.path,
    Assets.icons.otros.manosConOpesas.path,
    Assets.icons.otros.gymEquipamiento.path,
    Assets.icons.otros.pierna.path,
    Assets.icons.otros.bicicletaDeSpinning.path,
    Assets.icons.otros.corazon.path,
    Assets.icons.otros.quemar.path,
    Assets.icons.otros.estirar.path,
    Assets.icons.otros.yoga.path,
    Assets.icons.otros.ejercicio.path,
  ];

  late Color _colorSeleccionado = _paleta.first;
  late String _iconoSeleccionado = _iconos.first;
  String? _mensajeError;
  bool _estaGuardando = false;

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  Future<void> _guardarRutina() async {
    final nombre = _controladorTexto.text.trim();
    if (nombre.length < 3) {
      setState(() => _mensajeError =
          '¡Dale un nombre de al menos 3 letras a tu rutina! 💪');
      return;
    }

    // Capturamos referencias antes de cualquier await/pop para no usar un
    // BuildContext posiblemente inválido después.
    final router = GoRouter.of(context);
    final routineCubit = BlocProvider.of<RoutineCubit>(context);

    setState(() {
      _estaGuardando = true;
      _mensajeError = null;
    });

    await routineCubit.addRoutine(
      name: nombre,
      description: '',
      creationDate: DateTime.now(),
      done: false,
      color: _colorSeleccionado.toARGB32(),
      imagenDireccion: _iconoSeleccionado,
    );

    if (!mounted) return;
    setState(() => _estaGuardando = false);

    if (routineCubit.state is RoutineAddSuccess) {
      final rutinaId = (routineCubit.state as RoutineAddSuccess).rutina.id!;
      SnackbarHelper.showSafeSnackBar(
        context,
        "¡Rutina '$nombre' creada! 🎉",
        SnackBarType.success,
      );
      // Cierra la hoja (si aplica) y continúa al detalle para agregar ejercicios.
      if (widget.enSheet && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      router.go('/rutina/detalle/$rutinaId');
    } else if (routineCubit.state is RoutineError) {
      setState(
          () => _mensajeError = 'Ops, algo salió mal. ¡Inténtalo de nuevo! 🔄');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _campoNombre(c),
        if (_mensajeError != null) ...[
          const SizedBox(height: 8),
          _errorInline(c),
        ],
        const SizedBox(height: 22),
        _etiqueta(c, 'Color'),
        const SizedBox(height: 10),
        _selectorColores(c),
        const SizedBox(height: 22),
        _etiqueta(c, 'Icono'),
        const SizedBox(height: 10),
        _selectorIconos(c),
        const SizedBox(height: 24),
        GymButton(
          onPressed: _estaGuardando ? null : _guardarRutina,
          label: _estaGuardando ? 'Creando...' : 'Crear rutina',
          icon: _estaGuardando ? null : IconsaxPlusLinear.add,
          size: GymButtonSize.large,
          variant: GymButtonVariant.primary,
          expand: true,
        ),
      ],
    );
  }

  Widget _etiqueta(GymColors c, String texto) => Text(
        texto,
        style: GymType.label.copyWith(
          color: c.muted,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      );

  Widget _campoNombre(GymColors c) {
    OutlineInputBorder borde(Color color, [double ancho = 1]) =>
        OutlineInputBorder(
          borderRadius: GymRadius.rMd,
          borderSide: BorderSide(color: color, width: ancho),
        );
    return TextField(
      controller: _controladorTexto,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 30,
      onChanged: (_) => setState(() => _mensajeError = null),
      style: GymType.title.copyWith(color: c.ink),
      decoration: InputDecoration(
        hintText: 'Nombre de tu rutina',
        hintStyle: GymType.title.copyWith(color: c.faint),
        counterText: '',
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: borde(c.line),
        border: borde(c.line),
        focusedBorder: borde(c.brand, 1.5),
      ),
    );
  }

  Widget _errorInline(GymColors c) => Row(
        children: [
          Icon(IconsaxPlusLinear.info_circle, color: c.danger, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(_mensajeError!,
                style: GymType.label
                    .copyWith(color: c.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      );

  Widget _selectorColores(GymColors c) {
    return Row(
      children: _paleta.map((color) {
        final sel = _colorSeleccionado == color;
        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            onTap: () => setState(() {
              _colorSeleccionado = color;
              _mensajeError = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: sel ? 44 : 38,
              height: sel ? 44 : 38,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: sel ? Border.all(color: c.surface, width: 3) : null,
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.45),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: sel
                  ? const Icon(IconsaxPlusBold.tick_circle,
                      color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _selectorIconos(GymColors c) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _iconos.map((ruta) {
        final sel = _iconoSeleccionado == ruta;
        return GestureDetector(
          onTap: () => setState(() {
            _iconoSeleccionado = ruta;
            _mensajeError = null;
          }),
          child: Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  sel ? _colorSeleccionado.withValues(alpha: 0.16) : c.surface,
              borderRadius: GymRadius.rSm,
              border: Border.all(
                color: sel ? _colorSeleccionado : c.line,
                width: sel ? 2 : 1,
              ),
            ),
            child: SvgPicture.asset(
              ruta,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                sel ? _colorSeleccionado : c.muted,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
