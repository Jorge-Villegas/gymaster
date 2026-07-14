import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// Widget de input reutilizable con diseño consistente para GyMaster
///
/// Características:
/// - Bordes redondeados y colores del tema
/// - Validaciones integradas
/// - Estados visuales (normal, error, enfocado)
/// - Soporte para íconos y sufijos
/// - Diferentes tipos de teclado
class GyMasterInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool isRequired;
  final String? helpText;

  const GyMasterInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.isRequired = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con color primario y tamaño grande
        Padding(
          padding: const EdgeInsets.only(
            left: Espaciado.xs,
            bottom: Espaciado.xs,
          ),
          child: RichText(
            text: TextSpan(
              style: GymType.section.copyWith(
                color: context.gym.ink,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: context.gym.danger,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Campo de entrada con fondo transparente
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Espaciado.md),
            color: Colors.transparent,
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            enabled: enabled,
            maxLines: maxLines,
            maxLength: maxLength,
            onTap: onTap,
            onChanged: onChanged,
            focusNode: focusNode,
            style: GymType.body.copyWith(
              color: enabled ? context.gym.ink : context.gym.faint,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GymType.body.copyWith(
                color: context.gym.muted,
                fontWeight: FontWeight.w300,
              ),
              prefixIcon: prefixIcon != null
                  ? Container(
                      margin: const EdgeInsets.all(Espaciado.xs),
                      padding: const EdgeInsets.all(Espaciado.xs),
                      decoration: BoxDecoration(
                        color: context.gym.brand.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Espaciado.sm),
                      ),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon,
              filled: false,

              // Bordes estilo Duolingo con gradientes
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.brand.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.brand.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.brand,
                  width: 3,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.danger,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.danger,
                  width: 3,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Espaciado.md),
                borderSide: BorderSide(
                  color: context.gym.line,
                  width: 1,
                ),
              ),

              // Padding interno aumentado
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Espaciado.lg,
                vertical: Espaciado.md,
              ),

              // Contador de caracteres estilizado
              counterStyle: GymType.label.copyWith(
                fontWeight: FontWeight.w400,
                color: context.gym.faint,
              ),
            ),
          ),
        ),

        // Texto de ayuda mejorado
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: Espaciado.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Espaciado.sm,
                vertical: Espaciado.xs,
              ),
              decoration: BoxDecoration(
                color: context.gym.xpInk.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Espaciado.sm),
                border: Border.all(
                  color: context.gym.xpInk.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: context.gym.xpInk,
                  ),
                  const SizedBox(width: Espaciado.xs),
                  Expanded(
                    child: Text(
                      helpText!,
                      style: GymType.label.copyWith(
                        fontWeight: FontWeight.w400,
                        color: context.gym.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget especializado para campos numéricos
class GyMasterNumberInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool allowDecimals;
  final int? maxLength;
  final String? suffixText;
  final Widget? suffixIcon;
  final bool isRequired;
  final String? helpText;
  final double? min;
  final double? max;

  const GyMasterNumberInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.allowDecimals = false,
    this.maxLength,
    this.suffixText,
    this.suffixIcon,
    this.isRequired = false,
    this.helpText,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return GyMasterInputField(
      label: label,
      hintText: hintText,
      controller: controller,
      validator: validator ?? _defaultValidator,
      keyboardType: allowDecimals
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        if (allowDecimals)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
        else
          FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength!),
      ],
      suffixIcon: suffixIcon ??
          (suffixText != null
              ? Padding(
                  padding: const EdgeInsets.only(right: Espaciado.md),
                  child: Center(
                    widthFactor: 1.0,
                    child: Text(
                      suffixText!,
                      style: GymType.body.copyWith(
                        color: context.gym.muted,
                      ),
                    ),
                  ),
                )
              : null),
      isRequired: isRequired,
      helpText: helpText,
    );
  }

  String? _defaultValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return '$label es obligatorio';
    }

    if (value != null && value.isNotEmpty) {
      final number =
          allowDecimals ? double.tryParse(value) : int.tryParse(value);

      if (number == null) {
        return 'Ingresa un número válido';
      }

      if (min != null && number < min!) {
        return '$label debe ser mayor a $min';
      }

      if (max != null && number > max!) {
        return '$label debe ser menor a $max';
      }
    }

    return null;
  }
}

/// Widget especializado para campos de email
class GyMasterEmailInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool isRequired;
  final String? helpText;

  const GyMasterEmailInputField({
    super.key,
    this.label = 'Correo electrónico',
    this.controller,
    this.isRequired = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return GyMasterInputField(
      label: label,
      hintText: 'ejemplo@correo.com',
      controller: controller,
      validator: _emailValidator,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(
        Icons.email_outlined,
        color: context.gym.faint,
      ),
      isRequired: isRequired,
      helpText: helpText,
    );
  }

  String? _emailValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return '$label es obligatorio';
    }

    if (value != null && value.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Ingresa un correo válido';
      }
    }

    return null;
  }
}
