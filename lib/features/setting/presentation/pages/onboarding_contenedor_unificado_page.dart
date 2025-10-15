import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_state.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/shared/widgets/onboarding_header_widget.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_motivaciones_page.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_desafios_page.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_sentimientos_page.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_notificaciones_page.dart';
import 'package:gymaster/features/setting/presentation/widgets/onboarding_avatar_content.dart';
import 'package:gymaster/features/setting/presentation/widgets/onboarding_datos_personales_content.dart';
import 'package:gymaster/features/setting/presentation/widgets/onboarding_objetivos_content.dart';
import 'package:gymaster/features/setting/presentation/widgets/onboarding_nivel_experiencia_content.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';

class OnboardingContenedorUnificadoPage extends StatefulWidget {
  const OnboardingContenedorUnificadoPage({super.key});

  @override
  State<OnboardingContenedorUnificadoPage> createState() =>
      _OnboardingContenedorUnificadoPageState();
}

class _OnboardingContenedorUnificadoPageState
    extends State<OnboardingContenedorUnificadoPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OnboardingCubit>();
    _pageController = PageController(initialPage: cubit.currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      body: MultiBlocListener(
        listeners: [
          BlocListener<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingPageChanged) {
                _animateToPage(state.currentPage);
              } else if (state is OnboardingCompleted) {
                _crearPerfilCompleto(context);
              } else if (state is OnboardingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          BlocListener<OnboardingUsuarioCubit, OnboardingUsuarioState>(
            listener: (context, state) {
              if (state is OnboardingUsuarioPerfilCreado) {
                context.pushReplacementNamed('listaRutinas');
              } else if (state is OnboardingUsuarioError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.mensaje),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              const OnboardingHeaderWidget(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {},
                  children: _buildPages(),
                ),
              ),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      const OnboardingAvatarContent(),
      const OnboardingDatosPersonalesContent(),
      const OnboardingObjetivosContent(),
      const OnboardingNivelExperienciaContent(),
      const OnboardingMotivacionesPage(),
      const OnboardingDesafiosPage(),
      const OnboardingSentimientosPage(),
      const OnboardingNotificacionesPage(),
    ];
  }

  /// Botones de navegación
  Widget _buildNavigationButtons(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final canContinue = cubit.canContinueFromCurrentPage();
        final isLastStep = cubit.isLastPage;
        final currentPage = cubit.currentPage;

        const buttonTexts = [
          'Siguiente 🎯',
          'Continuar 📝',
          'Siguiente 💪',
          'Continuar ⚡',
          '¡Sigamos! 🎯',
          '¡Continuar! 💪',
          '¡Siguiente! ⚡',
          '🚀 ¡Comenzar mi aventura!',
        ];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.fondoPrincipal,
                AppColors.acento.withValues(alpha: 0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              if (currentPage > 0)
                Expanded(
                  child: ChicletButton(
                    texto: 'Anterior',
                    onPressed: () => cubit.previousPage(),
                    colorFondo: Colors.white,
                    colorTexto: AppColors.acento,
                    colorBorde: AppColors.acento,
                    estilo: EstiloBotonChiclet.contorno,
                    tamano: TamanoBotonChiclet.grande,
                    conSombreado: true,
                    grosorSombreado: 4.0,
                  ),
                ),
              if (currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: ChicletButton(
                  texto: buttonTexts[
                      currentPage < buttonTexts.length ? currentPage : 0],
                  onPressed: canContinue
                      ? () {
                          if (isLastStep) {
                            cubit.completeOnboarding();
                          } else {
                            cubit.nextPage();
                          }
                        }
                      : null,
                  colorFondo: canContinue
                      ? AppColors.acento
                      : AppColors.textoDeshabilitado,
                  colorTexto: Colors.white,
                  estaHabilitado: canContinue,
                  tamano: TamanoBotonChiclet.grande,
                  conSombreado: true,
                  grosorSombreado: 6.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _crearPerfilCompleto(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final datosPersonales = cubit.datosPersonales;

    // Extraer datos con valores por defecto
    final nombre = datosPersonales['nombre'] as String? ?? 'Usuario';
    final correo = datosPersonales['correo'] as String?;
    final avatar = cubit.avatarSeleccionado ?? 'perfil_1';

    // Parse fecha de nacimiento
    DateTime? fechaNacimiento;
    if (datosPersonales['fechaNacimiento'] != null) {
      fechaNacimiento =
          DateTime.tryParse(datosPersonales['fechaNacimiento'] as String);
    }

    // Parse género
    Genero genero = Genero.prefiero_no_decir;
    if (datosPersonales['genero'] != null) {
      final generoStr = datosPersonales['genero'] as String;
      genero = Genero.values.firstWhere(
        (g) => g.name == generoStr,
        orElse: () => Genero.prefiero_no_decir,
      );
    }

    // Parse objetivo
    ObjetivoFitness objetivo = ObjetivoFitness.mantenimiento;
    if (cubit.objetivoSeleccionado != null) {
      objetivo = ObjetivoFitness.values.firstWhere(
        (o) => o.name == cubit.objetivoSeleccionado,
        orElse: () => ObjetivoFitness.mantenimiento,
      );
    }

    // Parse nivel experiencia
    NivelExperiencia nivel = NivelExperiencia.principiante;
    if (cubit.nivelExperiencia != null) {
      nivel = NivelExperiencia.values.firstWhere(
        (n) => n.name == cubit.nivelExperiencia,
        orElse: () => NivelExperiencia.principiante,
      );
    }

    context.read<OnboardingUsuarioCubit>().crearPerfilCompleto(
          nombreUsuario: nombre,
          correo: correo?.isEmpty ?? true ? null : correo,
          fotoPerfil: avatar,
          nombreCompleto: nombre,
          fechaNacimiento: fechaNacimiento,
          genero: genero,
          objetivoFitness: objetivo,
          nivelExperiencia: nivel,
          alturaCm: datosPersonales['altura'] as int?,
          pesoActualKg: datosPersonales['peso'] as double?,
          pesoObjetivoKg: null,
        );
  }

  void _animateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
