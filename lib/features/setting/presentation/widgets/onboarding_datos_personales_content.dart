import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/shared/widgets/gymaster_input_field.dart';
import 'package:gymaster/shared/widgets/gymaster_choice_chip.dart';

class OnboardingDatosPersonalesContent extends StatefulWidget {
  const OnboardingDatosPersonalesContent({super.key});

  @override
  State<OnboardingDatosPersonalesContent> createState() =>
      _OnboardingDatosPersonalesContentState();
}

class _OnboardingDatosPersonalesContentState
    extends State<OnboardingDatosPersonalesContent> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();

  Genero? _generoSeleccionado;
  DateTime? _fechaNacimiento;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Espaciado.lg),
      child: Form(
        key: _formKey,
        onChanged: _validarYGuardar,
        child: Column(
          spacing: Espaciado.lg,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuéntanos sobre ti',
              style: GymType.title,
            ),
            Text(
              'Necesitamos algunos datos para personalizar tu experiencia',
              style: GymType.body.copyWith(
                color: context.gym.muted,
              ),
            ),
            _construirCampoNombre(),
            _construirCampoCorreo(),
            _construirSelectorGenero(),
            _construirCampoFechaNacimiento(),
            _construirCampoAltura(),
            _construirCampoPeso(),
          ],
        ),
      ),
    );
  }

  Widget _construirCampoNombre() {
    return GyMasterInputField(
      label: 'Nombre completo',
      hintText: 'Ingresa tu nombre completo',
      controller: _nombreController,
      isRequired: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es obligatorio';
        }
        if (value.trim().length < 2) {
          return 'El nombre debe tener al menos 2 caracteres';
        }
        return null;
      },
      prefixIcon: Icon(
        Icons.person_outline,
        color: context.gym.muted,
      ),
    );
  }

  Widget _construirCampoCorreo() {
    return GyMasterEmailInputField(
      label: 'Correo electrónico (opcional)',
      controller: _correoController,
      isRequired: false,
      helpText: 'Te ayudará a recuperar tu cuenta si olvidas tu información',
    );
  }

  Widget _construirSelectorGenero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género',
          style: GymType.section,
        ),
        const SizedBox(height: Espaciado.sm),
        Wrap(
          spacing: Espaciado.sm,
          runSpacing: Espaciado.sm,
          children: Genero.values.map((genero) {
            final isSelected = _generoSeleccionado == genero;
            return GyMasterChoiceChip(
              texto: genero.nombre,
              emoji: _getGeneroEmoji(genero),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _generoSeleccionado = genero;
                  _validarYGuardar();
                });
              },
              tamano: TamanoChoiceChip.regular,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _construirCampoFechaNacimiento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GymType.section.copyWith(
              color: context.gym.ink,
            ),
            children: [
              const TextSpan(text: 'Fecha de nacimiento '),
              TextSpan(text: '*', style: TextStyle(color: context.gym.brand)),
            ],
          ),
        ),
        const SizedBox(height: Espaciado.xs),
        GestureDetector(
          onTap: () => _seleccionarFechaNacimiento(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Espaciado.md,
              vertical: Espaciado.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Espaciado.md),
              border: Border.all(
                color: _fechaNacimiento == null
                    ? context.gym.muted
                    : context.gym.brand,
                width: _fechaNacimiento == null ? 1 : 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: _fechaNacimiento == null
                      ? context.gym.muted
                      : context.gym.brand,
                ),
                const SizedBox(width: Espaciado.sm),
                Expanded(
                  child: Text(
                    _fechaNacimiento == null
                        ? 'Selecciona tu fecha de nacimiento'
                        : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}${_obtenerEdadTexto()}',
                    style: GymType.body.copyWith(
                      color: _fechaNacimiento == null
                          ? context.gym.muted
                          : context.gym.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_fechaNacimiento == null)
          Padding(
            padding: const EdgeInsets.only(top: Espaciado.xs),
            child: Text(
              'Necesario para personalizar tu entrenamiento',
              style: GymType.label.copyWith(
                fontWeight: FontWeight.w400,
                color: context.gym.muted,
              ),
            ),
          ),
        if (_fechaNacimiento != null && _calcularEdad() < 13)
          Padding(
            padding: const EdgeInsets.only(top: Espaciado.xs),
            child: Text(
              'Debes tener al menos 13 años para usar la aplicación',
              style: GymType.label.copyWith(
                fontWeight: FontWeight.w400,
                color: context.gym.danger,
              ),
            ),
          ),
      ],
    );
  }

  Widget _construirCampoAltura() {
    return GyMasterNumberInputField(
      label: 'Altura',
      hintText: '170',
      controller: _alturaController,
      allowDecimals: false,
      maxLength: 3,
      suffixText: 'cm',
      min: 100,
      max: 250,
      helpText: 'Información opcional para cálculos personalizados',
    );
  }

  Widget _construirCampoPeso() {
    return GyMasterNumberInputField(
      label: 'Peso',
      hintText: '70.0',
      controller: _pesoController,
      allowDecimals: true,
      suffixText: 'kg',
      min: 30,
      max: 300,
      helpText: 'Información opcional para cálculos personalizados',
    );
  }

  Future<void> _seleccionarFechaNacimiento() async {
    final DateTime ahora = DateTime.now();
    final DateTime fechaMinima = DateTime(ahora.year - 100);
    final DateTime fechaMaxima = DateTime(ahora.year - 13);

    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? fechaMaxima,
      firstDate: fechaMinima,
      lastDate: fechaMaxima,
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      locale: const Locale('es', 'ES'),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimiento = fechaSeleccionada;
        _validarYGuardar();
      });
    }
  }

  int _calcularEdad() {
    if (_fechaNacimiento == null) return 0;

    final DateTime ahora = DateTime.now();
    int edad = ahora.year - _fechaNacimiento!.year;

    if (ahora.month < _fechaNacimiento!.month ||
        (ahora.month == _fechaNacimiento!.month &&
            ahora.day < _fechaNacimiento!.day)) {
      edad--;
    }

    return edad;
  }

  String _obtenerEdadTexto() {
    if (_fechaNacimiento == null) return '';
    final edad = _calcularEdad();
    return ' ($edad años)';
  }

  String _getGeneroEmoji(Genero genero) {
    switch (genero) {
      case Genero.masculino:
        return '👨';
      case Genero.femenino:
        return '👩';
      case Genero.otro:
        return '🧑';
      case Genero.prefiero_no_decir:
        return '😊';
    }
  }

  void _validarYGuardar() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_generoSeleccionado != null &&
          _fechaNacimiento != null &&
          _calcularEdad() >= 13) {
        final datosPersonales = {
          'nombre': _nombreController.text.trim(),
          'correo': _correoController.text.trim(),
          'genero': _generoSeleccionado!.name,
          'fechaNacimiento': _fechaNacimiento?.toIso8601String(),
          'altura': _alturaController.text.isNotEmpty
              ? int.parse(_alturaController.text)
              : null,
          'peso': _pesoController.text.isNotEmpty
              ? double.parse(_pesoController.text)
              : null,
        };

        context.read<OnboardingCubit>().updateDatosPersonales(datosPersonales);
      }
    }
  }
}
