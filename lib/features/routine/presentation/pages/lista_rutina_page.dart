import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/routine_search_delegate.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ListaRutinasPage extends StatelessWidget {
  const ListaRutinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        color: context.gym.bg,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _construirCabeceraReutilizable(context),
                const SizedBox(height: 20),
                _buildSearchBar(context),
                const SizedBox(height: 10),
                _buildRoutineList(context),
              ],
            ),
          ),
        ),
      ),
      // Botón flotante mejorado
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.gym.brand.withAlpha((0.3 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GymButton(
          label: '',
          icon: Icons.add,
          size: GymButtonSize.large,
          variant: GymButtonVariant.primary,
          expand: false,
          onPressed: () => _navegarAAgregarRutina(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Navega a la página de agregar rutina
  void _navegarAAgregarRutina(BuildContext context) {
    context.go('/rutina/create');
  }

  /// Construye la cabecera usando el componente reutilizable
  Widget _construirCabeceraReutilizable(BuildContext context) {
    // Generar saludo dinámico
    final hour = DateTime.now().hour;
    String timeGreeting;
    String emoji;

    if (hour < 12) {
      timeGreeting = 'Buenos días';
      emoji = '☀️';
    } else if (hour < 18) {
      timeGreeting = 'Buenas tardes';
      emoji = '🌤️';
    } else {
      timeGreeting = 'Buenas noches';
      emoji = '🌙';
    }

    return CabeceraReutilizable(
      titulo: '$timeGreeting, Jorge $emoji',
      subtitulo: _getMotivationalMessage(),
      botonIzquierdo: ConfiguracionBotonIzquierdo.menu(),
      accionesDerecha: [
        BotonAccionDerecha.actualizar(
          onPressed: () {
            BlocProvider.of<RoutineCubit>(context).getAllRoutine();
          },
          tooltip: 'Actualizar rutinas',
        ),
      ],
    );
  }

  /// Genera mensajes motivacionales dinámicos basados en la hora
  String _getMotivationalMessage() {
    final hour = DateTime.now().hour;
    final motivationalMessages = {
      'morning': [
        '¡Perfecto momento para activar el cuerpo! 💪',
        '¿Listo para conquistar el día con energía?',
        'Tu cuerpo te va a agradecer este momento',
        'Cada día es una nueva oportunidad de mejorar',
      ],
      'afternoon': [
        '¡Hora de recargar energías! ⚡',
        'Una rutina ahora te dará fuerza para el resto del día',
        '¿Qué tal si liberamos un poco de estrés?',
        'Tu yo del futuro te va a agradecer este entrenamiento',
      ],
      'evening': [
        'Perfecto para relajar tensiones del día 🌅',
        'Un entrenamiento nocturno para desconectar',
        '¿Terminamos el día con una nota alta?',
        'Nada mejor que dormir después de un buen entreno',
      ],
    };

    List<String> messages;
    if (hour < 12) {
      messages = motivationalMessages['morning']!;
    } else if (hour < 18) {
      messages = motivationalMessages['afternoon']!;
    } else {
      messages = motivationalMessages['evening']!;
    }

    // Rotar mensajes basado en el día del año para variedad
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return messages[dayOfYear % messages.length];
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<RoutineCubit, RoutineState>(
        builder: (context, state) {
          if (state is RoutineError) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis Rutinas',
                  style: GymType.section.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                GymButton(
                  label: '',
                  icon: Icons.add_rounded,
                  size: GymButtonSize.medium,
                  variant: GymButtonVariant.ghost,
                  expand: false,
                  onPressed: () => _navegarAAgregarRutina(context),
                ),
              ],
            );
          }

          if (state is RoutineGetAllSuccess) {
            return Row(
              children: [
                // Título de sección con contador emocional
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis Rutinas',
                        style: GymType.display.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      if (state.routines.isNotEmpty)
                        Text(
                          '${state.routines.length} rutina${state.routines.length == 1 ? '' : 's'} para conquistar',
                          style: GymType.body.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.3,
                            color: context.gym.muted,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Botón de búsqueda mejorado
                GymButton(
                  label: '',
                  icon: IconsaxPlusLinear.search_normal_1,
                  size: GymButtonSize.medium,
                  variant: GymButtonVariant.ghost,
                  expand: false,
                  onPressed: () async {
                    final routineCubit = BlocProvider.of<RoutineCubit>(context);
                    final result = await showSearch(
                      context: context,
                      delegate: RoutineSearchDelegate(),
                    );
                    if (result != null && context.mounted) {
                      routineCubit.getAllRoutine();
                    }
                  },
                ),
              ],
            );
          }

          return Container(); // Estado por defecto
        },
      ),
    );
  }

  Widget _buildRoutineList(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<RoutineCubit, RoutineState>(
          builder: (context, state) {
            if (state is RoutineLoading) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Mensaje motivacional de carga
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.gym.info.withValues(alpha: 0.1),
                            context.gym.info.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.gym.info.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.gym.info.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: context.gym.info,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Preparando tus rutinas increíbles...',
                              style: GymType.section.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Shimmer mejorado
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: context.gym.info.withValues(alpha: 0.1),
                        highlightColor: context.gym.info.withValues(alpha: 0.3),
                        period: const Duration(milliseconds: 1200),
                        child: ListView.builder(
                          itemCount: 4, // Menos elementos para mejor UX
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  height: 120,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        context.gym.surface,
                                        context.gym.surface2,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: context.gym.info
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: context.gym.info
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 16,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: context.gym.info
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is RoutineError) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Animación Lottie emocional
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.gym.xpInk.withValues(alpha: 0.1),
                            context.gym.xpInk.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: context.gym.xpInk.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Lottie.asset(
                        'assets/lottie/alzando_pesas.json',
                        width: 160,
                        height: 160,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Título motivacional
                    Text(
                      '¡Tu historia fitness comienza aquí!',
                      textAlign: TextAlign.center,
                      style: GymType.display.copyWith(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Mensaje inspirador
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.gym.brand.withValues(alpha: 0.1),
                            context.gym.brand.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Cada gran transformación empieza con una decisión. '
                        'Tu primera rutina será el primer paso hacia la mejor versión de ti mismo. '
                        '¡Vamos a crear algo increíble juntos! 💪',
                        textAlign: TextAlign.center,
                        style: GymType.section.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: context.gym.ink,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botón principal mejorado
                    GymButton(
                      label: '¡Crear Mi Primera Rutina!',
                      icon: Icons.rocket_launch_rounded,
                      size: GymButtonSize.large,
                      variant: GymButtonVariant.primary,
                      expand: false,
                      onPressed: () => _navegarAAgregarRutina(context),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            }
            if (state is RoutineAddSuccess) {
              BlocProvider.of<RoutineCubit>(context).getAllRoutine();
            }
            if (state is RoutineGetAllSuccess) {
              if (state.routines.isEmpty) {
                // Estado vacío con diseño emocional mejorado
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Ilustración motivacional
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.gym.brand.withValues(alpha: 0.1),
                              context.gym.brand.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.gym.brand.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.fitness_center_rounded,
                          size: 100,
                          color: context.gym.brand.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Mensaje inspirador
                      Text(
                        '¡Es hora de comenzar tu transformación!',
                        textAlign: TextAlign.center,
                        style: GymType.display.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.gym.xpInk.withValues(alpha: 0.1),
                              context.gym.xpInk.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Tu gimnasio personal está listo. '
                          'Crear tu primera rutina es el primer paso hacia '
                          'lograr todos tus objetivos fitness. '
                          '¡Hagámoslo realidad juntos! 🎯',
                          textAlign: TextAlign.center,
                          style: GymType.section.copyWith(
                            fontSize: 14,
                            color: context.gym.ink,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Botón principal
                      GymButton(
                        label: '¡Empezar Mi Rutina!',
                        icon: Icons.play_arrow_rounded,
                        size: GymButtonSize.large,
                        variant: GymButtonVariant.primary,
                        expand: false,
                        onPressed: () => _navegarAAgregarRutina(context),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }

              // Lista de rutinas existentes con animaciones mejoradas
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.routines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final rutina = state.routines[i];
                    final cantidadTexto = _getCantidadTexto(
                      rutina.cantidadEjercicios,
                    );

                    // Animación escalonada mejorada
                    final delay = Duration(milliseconds: 80 * (i < 6 ? i : 6));

                    return FadeInLeft(
                      delay: delay,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: context.gym.brand.withValues(alpha: 0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: RoutineCard(
                          color: rutina.color,
                          title: rutina.name,
                          cantidadEjerciciosPorSeries: cantidadTexto,
                          imagenDireccion: rutina.imagenDireccion,
                          routineId: rutina.id,
                          onTap: () {
                            BlocProvider.of<EjerciciosByRutinaCubit>(
                              context,
                            ).getAllEjercicios(idRutina: rutina.id!);
                            context.push('/rutina/detalle/${rutina.id!}');
                          },
                          onDeleted: () {
                            // Eliminar la rutina usando el cubit
                            if (rutina.id != null) {
                              BlocProvider.of<RoutineCubit>(context)
                                  .deleteRoutine(
                                id: rutina.id!,
                                routineName: rutina.name,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              // Estado por defecto con mensaje amigable
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 64,
                      color: context.gym.info.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Preparando tu experiencia fitness...',
                      style: GymType.section.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GymButton(
                      label: 'Actualizar',
                      icon: Icons.refresh,
                      size: GymButtonSize.medium,
                      variant: GymButtonVariant.ghost,
                      expand: false,
                      onPressed: () {
                        BlocProvider.of<RoutineCubit>(context).getAllRoutine();
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String _getCantidadTexto(int cantidadEjercicios) {
    if (cantidadEjercicios == 0) {
      return 'No hay Ejercicios';
    } else if (cantidadEjercicios == 1) {
      return '$cantidadEjercicios Ejercicio';
    } else {
      return '$cantidadEjercicios Ejercicios';
    }
  }
}
