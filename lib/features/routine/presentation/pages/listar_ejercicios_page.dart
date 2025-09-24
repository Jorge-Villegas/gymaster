import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ListarEjerciciosPage extends StatelessWidget {
  final String idMusculo;
  final String idSesion;
  final String nombreMusculo;
  final String idRutina;

  const ListarEjerciciosPage({
    super.key,
    required this.idSesion,
    required this.nombreMusculo,
    required this.idMusculo,
    required this.idRutina,
  });

  @override
  Widget build(BuildContext context) {
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: idMusculo,
          rutinaId: idRutina,
        );
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header emocional mejorado
              _construirHeaderEmocional(context),
              // Cuerpo principal con ejercicios
              Expanded(
                child: BlocBuilder<EjercicioCubit, EjercicioState>(
                  builder: (context, state) {
                    if (state is EjercicioGetAllSuccess) {
                      return _construirListaEjercicios(context, state);
                    }
                    if (state is EjercicioLoading) {
                      return _construirEfectoCargaShimmer();
                    }
                    if (state is EjercicioError) {
                      return _construirEstadoError(context, state.message);
                    } else {
                      return _construirEstadoError(
                          context, 'Ocurrió un error inesperado');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget del header emocional motivacional
  Widget _construirHeaderEmocional(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Botón de volver minimalista
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.motivationRed.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.motivationRed,
                  size: 20,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 16),
            // Título emocional simple
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Elige tu ejercicio!',
                    style: EstilosTextoEmocional.energetico.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TextFormatter.capitalize(nombreMusculo),
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.motivationRed,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirEfectoCargaShimmer() {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header de carga
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.energyOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.energyOrange.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.energyOrange),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cargando ejercicios...',
                          style: EstilosTextoEmocional.energetico.copyWith(
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Preparando los mejores ejercicios para ti',
                          style: EstilosTextoEmocional.amigable.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Lista shimmer
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 16.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 120,
                                  height: 12.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirEstadoError(BuildContext context, String mensajeError) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.motivationRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_rounded,
                    size: 64,
                    color: AppColors.motivationRed,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Ups! Algo salió mal',
                style: EstilosTextoEmocional.energetico.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                mensajeError,
                style: EstilosTextoEmocional.amigable.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ChicletButton(
                onPressed: () {
                  context.read<EjercicioCubit>().setEjercicio(
                        musculoId: idMusculo,
                        rutinaId: idRutina,
                      );
                },
                texto: 'Reintentar',
                icono: Icons.refresh_rounded,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.relleno,
                colorFondo: AppColors.motivationRed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirListaEjercicios(
      BuildContext context, EjercicioGetAllSuccess state) {
    if (state.ejercicios.isEmpty) {
      return _construirEstadoVacio(context);
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Header de la lista con contador
            Container(
              margin: const EdgeInsets.only(bottom: 16, top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.successGreen.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    IconsaxPlusLinear.task_square,
                    color: AppColors.successGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${state.ejercicios.length} ejercicios disponibles',
                      style: EstilosTextoEmocional.aliento.copyWith(
                        color: AppColors.successGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.successGreen,
                    size: 18,
                  ),
                ],
              ),
            ),
            // Lista de ejercicios
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.ejercicios.length,
                itemBuilder: (context, i) {
                  final retraso =
                      Duration(milliseconds: 100 + (50 * (i < 8 ? i : 8)));
                  final ejercicio = state.ejercicios[i];
                  final direccionImagen =
                      ejercicio.imagenDireccion?.isNotEmpty == true
                          ? ejercicio.imagenDireccion!
                          : AppConfig.defaultImagePath;
                  final bool esSvg =
                      VerificadorTipoArchivo.esSvg(direccionImagen);

                  return FadeInLeft(
                    duration: retraso,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: ejercicio.seleccionado
                            ? Border.all(
                                color: AppColors.successGreen, width: 2)
                            : Border.all(color: Colors.grey.shade200, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: ejercicio.seleccionado
                                ? AppColors.successGreen.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.1),
                            offset: const Offset(0, 4),
                            blurRadius: ejercicio.seleccionado ? 12 : 8,
                            spreadRadius: ejercicio.seleccionado ? 1 : 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: ejercicio.seleccionado
                              ? null
                              : () {
                                  print(
                                      'ListarEjerciciosPage -> idSesion: $idSesion');
                                  context.push(
                                    '/agregar-ejercicio-rutina/$idRutina/${ejercicio.id}/${ejercicio.nombre}/$idSesion',
                                    extra: {
                                      'ejercicioImagenDireccion':
                                          ejercicio.imagenDireccion,
                                    },
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Imagen del ejercicio con Hero
                                Hero(
                                  tag: 'exercise-image-${ejercicio.id}',
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: ejercicio.seleccionado
                                          ? AppColors.successGreen
                                              .withValues(alpha: 0.1)
                                          : AppColors.backgroundLight,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ejercicio.seleccionado
                                            ? AppColors.successGreen
                                                .withValues(alpha: 0.3)
                                            : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: esSvg
                                          ? SvgPicture.asset(
                                              direccionImagen,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                ejercicio.seleccionado
                                                    ? AppColors.successGreen
                                                    : AppColors.primary,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : Image.asset(
                                              direccionImagen,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.fitness_center_rounded,
                                                  color: ejercicio.seleccionado
                                                      ? AppColors.successGreen
                                                      : AppColors.primary,
                                                  size: 32,
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Información del ejercicio
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ejercicio.nombre,
                                        style: EstilosTextoEmocional.aliento
                                            .copyWith(
                                          color: ejercicio.seleccionado
                                              ? AppColors.successGreen
                                              : AppColors.primary,
                                          fontSize: 16,
                                          fontWeight: ejercicio.seleccionado
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ejercicio.seleccionado
                                            ? '¡Ya agregado!'
                                            : 'Toca para agregar',
                                        style: EstilosTextoEmocional.amigable
                                            .copyWith(
                                          color: ejercicio.seleccionado
                                              ? AppColors.successGreen
                                              : AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (ejercicio.seleccionado)
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.successGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.check_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirEstadoVacio(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.calmBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: AppColors.calmBlue,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No hay ejercicios disponibles',
                style: EstilosTextoEmocional.energetico.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'No encontramos ejercicios para ${TextFormatter.capitalize(nombreMusculo)} en este momento.',
                style: EstilosTextoEmocional.amigable.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ChicletButton(
                onPressed: () => context.pop(),
                texto: 'Volver',
                icono: Icons.arrow_back_rounded,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.contorno,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
