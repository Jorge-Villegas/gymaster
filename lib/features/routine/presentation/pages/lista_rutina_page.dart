import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/routine_search_delegate.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ListaRutinasPage extends StatelessWidget {
  const ListaRutinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        color: AppColors.backgroundLight,
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
                _buildRoutineList(),
              ],
            ),
          ),
        ),
      ),
      // Botón flotante mejorado con ChicletButton estilo
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha((0.3 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ChicletButton(
          texto: '',
          icono: Icons.add,
          tamano: TamanoBotonChiclet.grande,
          estilo: EstiloBotonChiclet.relleno,
          radioBorde: 16,
          ancho: 64,
          alto: 64,
          colorFondo: AppColors.primary,
          conSombreado: false, // Ya tiene sombra personalizada
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
                  style: TextStyle(
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
                    fontSize: TipografiaGyMaster.tamanoLg,
                    color: AppColors.motivacionPrincipal,
                  ),
                ),
                ChicletButton(
                  texto: '',
                  icono: Icons.add_rounded,
                  tamano: TamanoBotonChiclet.mediano,
                  estilo: EstiloBotonChiclet.contorno,
                  colorFondo:
                      AppColors.motivacionPrincipal.withValues(alpha: 0.1),
                  colorBorde: AppColors.motivacionPrincipal,
                  colorTexto: AppColors.motivacionPrincipal,
                  radioBorde: 12,
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
                        style: TextStyle(
                          fontWeight: TipografiaGyMaster.pesoSemiBold,
                          fontSize: TipografiaGyMaster.tamano2xl,
                          color: AppColors.primario,
                          height: 1.2,
                        ),
                      ),
                      if (state.routines.isNotEmpty)
                        Text(
                          '${state.routines.length} rutina${state.routines.length == 1 ? '' : 's'} para conquistar',
                          style: TextStyle(
                            fontWeight: TipografiaGyMaster.pesoLigero,
                            fontSize: TipografiaGyMaster.tamanoMd,
                            height: 1.3,
                            color: AppColors.motivacionPrincipal,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Botón de búsqueda mejorado
                ChicletButton(
                  texto: '',
                  icono: IconsaxPlusLinear.search_normal_1,
                  tamano: TamanoBotonChiclet.mediano,
                  estilo: EstiloBotonChiclet.contorno,
                  colorFondo: AppColors.descansoActivo.withValues(alpha: 0.1),
                  colorBorde: AppColors.descansoActivo,
                  colorTexto: AppColors.descansoActivo,
                  radioBorde: 12,
                  conSombreado: true,
                  grosorSombreado: 2.0,
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

  Widget _buildRoutineList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.backgroundLight.withOpacity(0.3),
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
                            AppColors.descansoActivo.withOpacity(0.1),
                            AppColors.descansoActivo.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.descansoActivo.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.descansoActivo.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: AppColors.descansoActivo,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Preparando tus rutinas increíbles...',
                              style: EstilosTextoEmocional.amigable.copyWith(
                                fontSize: 16,
                                color: AppColors.descansoActivo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Shimmer mejorado
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: AppColors.descansoActivo.withOpacity(0.1),
                        highlightColor:
                            AppColors.descansoActivo.withOpacity(0.3),
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
                                        Colors.white,
                                        AppColors.backgroundLight,
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
                                          color: AppColors.descansoActivo
                                              .withOpacity(0.2),
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
                                                color: AppColors.descansoActivo
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 16,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: AppColors.descansoActivo
                                                    .withOpacity(0.2),
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
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animación Lottie emocional
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.motivacionPrincipal.withOpacity(0.1),
                            AppColors.motivacionPrincipal.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.motivacionPrincipal.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Lottie.asset(
                        'assets/lottie/alzando_pesas.json',
                        width: 200,
                        height: 200,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Título motivacional
                    Text(
                      '¡Tu historia fitness comienza aquí!',
                      textAlign: TextAlign.center,
                      style: EstilosTextoEmocional.motivacional.copyWith(
                        fontSize: 26,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mensaje inspirador
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primario.withOpacity(0.1),
                            AppColors.exitoCompletado.withOpacity(0.05),
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
                        style: EstilosTextoEmocional.amigable.copyWith(
                          fontSize: 16,
                          color: AppColors.textDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botón principal mejorado
                    ChicletButton(
                      texto: '¡Crear Mi Primera Rutina!',
                      icono: Icons.rocket_launch_rounded,
                      tamano: TamanoBotonChiclet.grande,
                      estilo: EstiloBotonChiclet.relleno,
                      colorFondo: AppColors.primary,
                      radioBorde: 20,
                      conSombreado: true,
                      grosorSombreado: 8.0,
                      onPressed: () => _navegarAAgregarRutina(context),
                    ),
                    const SizedBox(height: 16),
                    // Botón secundario de ayuda
                    ChicletButton(
                      texto: 'Necesito ayuda para empezar',
                      icono: Icons.help_outline_rounded,
                      tamano: TamanoBotonChiclet.grande,
                      estilo: EstiloBotonChiclet.contorno,
                      colorBorde: AppColors.descansoActivo,
                      colorTexto: AppColors.descansoActivo,
                      radioBorde: 16,
                      onPressed: () {
                        // TODO: Implementar guía de inicio
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡Próximamente tendremos una guía completa para ti!',
                              style: EstilosTextoEmocional.amigable.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: AppColors.descansoActivo,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
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
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ilustración motivacional
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.exitoCompletado.withOpacity(0.1),
                              AppColors.exitoCompletado.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.exitoCompletado.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.fitness_center_rounded,
                          size: 120,
                          color: AppColors.exitoCompletado.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Mensaje inspirador
                      Text(
                        '¡Es hora de comenzar tu transformación!',
                        textAlign: TextAlign.center,
                        style: EstilosTextoEmocional.motivacional.copyWith(
                          fontSize: 24,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.logroDesbloqueado.withOpacity(0.1),
                              AppColors.motivacionPrincipal.withOpacity(0.05),
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
                          style: EstilosTextoEmocional.aliento.copyWith(
                            fontSize: 16,
                            color: AppColors.textDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Botón principal
                      ChicletButton(
                        texto: '¡Empezar Mi Rutina!',
                        icono: Icons.play_arrow_rounded,
                        tamano: TamanoBotonChiclet.grande,
                        estilo: EstiloBotonChiclet.relleno,
                        colorFondo: AppColors.primary,
                        radioBorde: 18,
                        conSombreado: true,
                        grosorSombreado: 6.0,
                        onPressed: () => _navegarAAgregarRutina(context),
                      ),
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
                              color: AppColors.primary.withOpacity(0.1),
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
                      color: AppColors.descansoActivo.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Preparando tu experiencia fitness...',
                      style: EstilosTextoEmocional.amigable.copyWith(
                        color: AppColors.descansoActivo,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ChicletButton(
                      texto: 'Actualizar',
                      icono: Icons.refresh,
                      tamano: TamanoBotonChiclet.mediano,
                      estilo: EstiloBotonChiclet.contorno,
                      colorBorde: AppColors.descansoActivo,
                      colorTexto: AppColors.descansoActivo,
                      radioBorde: 12,
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
