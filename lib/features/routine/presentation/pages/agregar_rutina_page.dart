import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:animate_do/animate_do.dart';

class AgregarRutinaPage extends StatefulWidget {
  const AgregarRutinaPage({super.key});

  @override
  State<AgregarRutinaPage> createState() => _AgregarRutinaPageState();
}

class _AgregarRutinaPageState extends State<AgregarRutinaPage> {
  // Iconos temáticos para gimnasio con mejor organización
  String iconoSeleccionado = Assets.icons.otros.biceps.path;

  final List<Map<String, dynamic>> iconosTematicos = [
    // === ICONOS DE FUERZA ===
    {
      'ruta': Assets.icons.otros.biceps.path,
      'nombre': 'Fuerza Superior',
      'categoria': 'fuerza'
    },
    {
      'ruta': Assets.icons.otros.pesas.path,
      'nombre': 'Levantamiento',
      'categoria': 'fuerza'
    },
    {
      'ruta': Assets.icons.otros.pesas1.path,
      'nombre': 'Pesas Libres',
      'categoria': 'fuerza'
    },
    {
      'ruta': Assets.icons.otros.manosConOpesas.path,
      'nombre': 'Entrenamiento',
      'categoria': 'fuerza'
    },
    {
      'ruta': Assets.icons.otros.gymEquipamiento.path,
      'nombre': 'Máquinas',
      'categoria': 'fuerza'
    },
    {
      'ruta': Assets.icons.otros.fuerzaBrazos.path,
      'nombre': 'Fuerza Brazos',
      'categoria': 'fuerza'
    },
    {
      'ruta': 'assets/icons/colors/fuerza.png',
      'nombre': 'Potencia Total',
      'categoria': 'fuerza',
      'esImagen': true // Indicador para manejar PNG vs SVG
    },

    // === ICONOS DE CARDIO ===
    {
      'ruta': Assets.icons.otros.pierna.path,
      'nombre': 'Tren Inferior',
      'categoria': 'cardio'
    },
    {
      'ruta': Assets.icons.otros.pantorrillas.path,
      'nombre': 'Pantorrillas',
      'categoria': 'cardio'
    },
    {
      'ruta': Assets.icons.otros.bicicletaDeSpinning.path,
      'nombre': 'Cardio Intenso',
      'categoria': 'cardio'
    },
    {
      'ruta': 'assets/icons/colors/biciclera-de-spinnig.png',
      'nombre': 'Spinning Colorido',
      'categoria': 'cardio',
      'esImagen': true
    },
    {
      'ruta': Assets.icons.otros.corazon.path,
      'nombre': 'Cardio Saludable',
      'categoria': 'cardio'
    },
    {
      'ruta': Assets.icons.otros.quemar.path,
      'nombre': 'Quemar Grasa',
      'categoria': 'cardio'
    },
    {
      'ruta': 'assets/icons/colors/quemar.png',
      'nombre': 'Quemar Calorías',
      'categoria': 'cardio',
      'esImagen': true
    },

    // === ICONOS DE RECOVERY/BIENESTAR ===
    {
      'ruta': Assets.icons.otros.estirar.path,
      'nombre': 'Flexibilidad',
      'categoria': 'recovery'
    },
    {
      'ruta': Assets.icons.otros.yoga.path,
      'nombre': 'Yoga & Meditación',
      'categoria': 'recovery'
    },

    // === ICONOS GENERALES ===
    {
      'ruta': Assets.icons.otros.ejercicio.path,
      'nombre': 'Ejercicio General',
      'categoria': 'general'
    },
  ];

  // Paleta de colores emocionales para gimnasio
  final List<Map<String, dynamic>> coloresEmocionales = [
    {
      'color': const Color(0xFFFF6B35), // Energía naranja
      'nombre': 'Energía Explosiva',
      'emocion': 'motivacion'
    },
    {
      'color': const Color(0xFFE74C3C), // Rojo motivacional
      'nombre': 'Fuerza Pura',
      'emocion': 'intensidad'
    },
    {
      'color': const Color(0xFF9B59B6), // Morado celebración
      'nombre': 'Logro Épico',
      'emocion': 'celebracion'
    },
    {
      'color': const Color(0xFF3498DB), // Azul calmado
      'nombre': 'Resistencia',
      'emocion': 'calma'
    },
    {
      'color': const Color(0xFF27AE60), // Verde éxito
      'nombre': 'Crecimiento',
      'emocion': 'exito'
    },
    {
      'color': const Color(0xFFF39C12), // Dorado logros
      'nombre': 'Victoria',
      'emocion': 'logro'
    },
    {
      'color': const Color(0xFF1ABC9C), // Teal descanso
      'nombre': 'Recuperación',
      'emocion': 'descanso'
    },
    {
      'color': const Color(0xFFE91E63), // Rosa inspiración
      'nombre': 'Inspiración',
      'emocion': 'inspiracion'
    },
    {
      'color': const Color(0xFF34495E), // Gris profesional
      'nombre': 'Foco Total',
      'emocion': 'concentracion'
    },
  ];

  Color colorSeleccionado =
      const Color(0xFFFF6B35); // Color por defecto energético
  final controladorTexto = TextEditingController();
  String? mensajeError;
  bool estaGuardando = false;

  @override
  void dispose() {
    controladorTexto.dispose();
    super.dispose();
  }

  Future<void> _guardarRutina() async {
    final nombreRutina = controladorTexto.text.trim();

    // Validaciones con mensajes motivacionales
    if (nombreRutina.isEmpty) {
      _mostrarMensajeError("¡Dale un nombre poderoso a tu rutina! 💪");
      return;
    }

    if (nombreRutina.length < 3) {
      _mostrarMensajeError("Tu rutina merece un nombre más descriptivo 😊");
      return;
    }

    setState(() {
      estaGuardando = true;
      mensajeError = null;
    });

    final nuevaRutina = Routine(
      fechaCreacion: DateTime.now(),
      name: nombreRutina,
      echo: false,
      color: colorSeleccionado.value,
      description: _generarDescripcionAutomatica(nombreRutina),
      cantidadEjercicios: 0,
      imagenDireccion: iconoSeleccionado,
    );

    final routineCubit = BlocProvider.of<RoutineCubit>(context);

    await routineCubit.addRoutine(
      name: nuevaRutina.name,
      description: nuevaRutina.description ?? '',
      creationDate: nuevaRutina.fechaCreacion,
      done: nuevaRutina.echo,
      color: nuevaRutina.color,
      imagenDireccion: iconoSeleccionado,
    );

    if (!mounted) return;

    setState(() {
      estaGuardando = false;
    });

    if (routineCubit.state is RoutineAddSuccess) {
      final rutinaId = (routineCubit.state as RoutineAddSuccess).rutina.id!;

      // Mostrar mensaje de éxito motivacional
      SnackbarHelper.showSafeSnackBar(
        context,
        "¡Rutina '$nombreRutina' creada con éxito! 🎉",
        SnackBarType.success,
      );

      // Navegación al detalle de la rutina
      context.go('/rutina/detalle/$rutinaId');
    } else if (routineCubit.state is RoutineError) {
      _mostrarMensajeError("Ops, algo salió mal. ¡Inténtalo de nuevo! 🔄");
    }
  }

  void _mostrarMensajeError(String mensaje) {
    setState(() {
      mensajeError = mensaje;
    });

    SnackbarHelper.showSafeSnackBar(
      context,
      mensaje,
      SnackBarType.error,
    );
  }

  String _generarDescripcionAutomatica(String nombre) {
    final horaActual = DateTime.now().hour;
    String momento;

    if (horaActual < 12) {
      momento = "rutina matutina";
    } else if (horaActual < 18) {
      momento = "rutina vespertina";
    } else {
      momento = "rutina nocturna";
    }

    return "Mi $momento personalizada: $nombre - Creada para superar mis límites 💪";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipal,
              Colors.white,
              AppColors.fondoPrincipal.withOpacity(0.8),
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
              _construirHeaderEmocional(),
              // Cuerpo principal con scroll
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // Preview de la rutina
                      _construirPreviewRutina(),
                      const SizedBox(height: 32),
                      // Selector de colores emocionales
                      _construirSelectorColores(),
                      const SizedBox(height: 32),
                      // Selector de iconos temáticos
                      _construirSelectorIconos(),
                      const SizedBox(height: 40),
                      // Botón de guardar motivacional
                      _construirBotonGuardar(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget del header emocional motivacional
  Widget _construirHeaderEmocional() {
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
                    color: AppColors.exito.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  // Usar context.go('/') para volver al inicio, igual que en detalle_rutina_page
                  context.go('/');
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.exito,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡Crea tu rutina perfecta!',
                    style: EstilosTextoEmocional.energetico.copyWith(
                      color: AppColors.primario,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personaliza cada detalle para tu éxito',
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.exito,
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

  // Widget de preview de la rutina
  Widget _construirPreviewRutina() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorSeleccionado,
              colorSeleccionado.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorSeleccionado.withOpacity(0.4),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Patrón de fondo decorativo
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono de la rutina
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconoSeleccionado,
                        width: 32,
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Campo de texto del nombre
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: controladorTexto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombre de tu rutina...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLength: 30,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        return Text(
                          '$currentLength/$maxLength',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Información adicional
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '0 ejercicios • Recién creada',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Mensaje de error si existe
            if (mensajeError != null)
              Positioned(
                bottom: 8,
                left: 24,
                right: 24,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          mensajeError!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget selector de colores emocionales
  Widget _construirSelectorColores() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorSeleccionado,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Elige tu color de poder',
                style: EstilosTextoEmocional.energetico.copyWith(
                  color: AppColors.primario,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Cada color transmite una energía única para tu entrenamiento',
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textoTerciario,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: coloresEmocionales.length,
              itemBuilder: (context, index) {
                final colorData = coloresEmocionales[index];
                final color = colorData['color'] as Color;
                final nombre = colorData['nombre'] as String;
                final estaSeleccionado = colorSeleccionado == color;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      colorSeleccionado = color;
                      mensajeError = null; // Limpiar error al interactuar
                    });
                  },
                  child: Container(
                    width: 90,
                    margin: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: estaSeleccionado ? 64 : 56,
                          height: estaSeleccionado ? 64 : 56,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: estaSeleccionado
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: estaSeleccionado ? 16 : 8,
                                spreadRadius: estaSeleccionado ? 2 : 0,
                              ),
                            ],
                          ),
                          child: estaSeleccionado
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nombre,
                          style: TextStyle(
                            color: estaSeleccionado
                                ? AppColors.primario
                                : AppColors.textoTerciario,
                            fontSize: 11,
                            fontWeight: estaSeleccionado
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget selector de iconos temáticos
  Widget _construirSelectorIconos() {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorSeleccionado,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Selecciona el ícono perfecto',
                style: EstilosTextoEmocional.energetico.copyWith(
                  color: AppColors.primario,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Representa visualmente el tipo de entrenamiento que vas a hacer',
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textoTerciario,
            ),
          ),
          const SizedBox(height: 20),
          // Agrupación por categorías
          ...['fuerza', 'cardio', 'recovery', 'general'].map((categoria) {
            final iconosCategoria = iconosTematicos
                .where((icono) => icono['categoria'] == categoria)
                .toList();
            if (iconosCategoria.isEmpty) return const SizedBox.shrink();

            String nombreCategoria;
            Color colorCategoria;
            IconData iconoCategoria;

            switch (categoria) {
              case 'fuerza':
                nombreCategoria = 'Fuerza & Músculo';
                colorCategoria = AppColors.primarioCalido; // Usando colores HSB
                iconoCategoria = Icons.fitness_center_rounded;
                break;
              case 'cardio':
                nombreCategoria = 'Cardio & Resistencia';
                colorCategoria = AppColors.secundarioClaro; // Azul suave HSB
                iconoCategoria = Icons.directions_run_rounded;
                break;
              case 'recovery':
                nombreCategoria = 'Flexibilidad & Descanso';
                colorCategoria = AppColors.exito; // Verde natural HSB
                iconoCategoria = Icons.self_improvement_rounded;
                break;
              case 'general':
                nombreCategoria = 'Ejercicio General';
                colorCategoria = AppColors.acentoCalido; // Naranja dorado HSB
                iconoCategoria = Icons.sports_gymnastics_rounded;
                break;
              default:
                return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        iconoCategoria,
                        color: colorCategoria,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        nombreCategoria,
                        style: EstilosTextoEmocional.aliento.copyWith(
                          color: colorCategoria,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: iconosCategoria.length,
                    itemBuilder: (context, index) {
                      final iconoData = iconosCategoria[index];
                      final rutaIcono = iconoData['ruta'] as String;
                      final nombreIcono = iconoData['nombre'] as String;
                      final estaSeleccionado = iconoSeleccionado == rutaIcono;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            iconoSeleccionado = rutaIcono;
                            mensajeError = null; // Limpiar error al interactuar
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: EdgeInsets.only(
                            right: 12,
                            left: index == 0 ? 0 : 0,
                          ),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: estaSeleccionado ? 56 : 48,
                                height: estaSeleccionado ? 56 : 48,
                                decoration: BoxDecoration(
                                  color: estaSeleccionado
                                      ? colorSeleccionado
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                  border: estaSeleccionado
                                      ? Border.all(
                                          color: Colors.white, width: 2)
                                      : Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                  boxShadow: estaSeleccionado
                                      ? [
                                          BoxShadow(
                                            color: colorSeleccionado
                                                .withOpacity(0.4),
                                            offset: const Offset(0, 4),
                                            blurRadius: 12,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: _construirIconoWidget(
                                    iconoData,
                                    rutaIcono,
                                    estaSeleccionado,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                nombreIcono,
                                style: TextStyle(
                                  color: estaSeleccionado
                                      ? AppColors.primario
                                      : AppColors.textoTerciario,
                                  fontSize: 10,
                                  fontWeight: estaSeleccionado
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (categoria != 'general') const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Widget del botón guardar motivacional
  Widget _construirBotonGuardar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: ChicletButton(
        onPressed: estaGuardando ? null : _guardarRutina,
        texto: estaGuardando ? 'Creando tu rutina...' : '¡Crear mi rutina!',
        icono: estaGuardando ? null : Icons.rocket_launch_rounded,
        tamano: TamanoBotonChiclet.grande,
        estilo: EstiloBotonChiclet.relleno,
        colorFondo: colorSeleccionado,
        estaCargando: estaGuardando,
      ),
    );
  }

  // Método helper para construir iconos (SVG o PNG)
  Widget _construirIconoWidget(
    Map<String, dynamic> iconoData,
    String rutaIcono,
    bool estaSeleccionado,
  ) {
    final esImagen = iconoData['esImagen'] == true;
    final tamano = estaSeleccionado ? 28.0 : 24.0;

    if (esImagen) {
      // Para iconos PNG coloridos
      return Image.asset(
        rutaIcono,
        width: tamano,
        height: tamano,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback a un icono por defecto si no se encuentra la imagen
          return Icon(
            Icons.fitness_center_rounded,
            size: tamano,
            color: estaSeleccionado ? Colors.white : Colors.grey.shade600,
          );
        },
      );
    } else {
      // Para iconos SVG (comportamiento original)
      return SvgPicture.asset(
        rutaIcono,
        width: tamano,
        height: tamano,
        colorFilter: ColorFilter.mode(
          estaSeleccionado ? Colors.white : Colors.grey.shade600,
          BlendMode.srcIn,
        ),
      );
    }
  }
}
