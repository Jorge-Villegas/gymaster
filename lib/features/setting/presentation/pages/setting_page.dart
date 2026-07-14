import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/presentation/cubits/setting_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/setting_state.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_state.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';

import 'package:gymaster/features/setting/presentation/pages/onboarding_emocional_page.dart';
import 'package:gymaster/init_dependencies.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    // Cargar configuraciones después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingCubit>().loadSettings();
      // Cargar perfil del usuario para mostrar en settings
      context.read<OnboardingUsuarioCubit>().obtenerPerfilCompleto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          if (state is SettingLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando configuración...'),
                ],
              ),
            );
          }

          if (state is SettingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconsaxPlusLinear.close_circle,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar configuración',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SettingCubit>().loadSettings(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header con información del usuario
              BlocBuilder<OnboardingUsuarioCubit, OnboardingUsuarioState>(
                builder: (context, perfilState) {
                  return _buildUserHeader(context, perfilState);
                },
              ),
              const SizedBox(height: 24),

              // Información del perfil del usuario
              BlocBuilder<OnboardingUsuarioCubit, OnboardingUsuarioState>(
                builder: (context, perfilState) {
                  return _buildUserProfileSection(context, perfilState);
                },
              ),
              const SizedBox(height: 16),

              // Configuración de apariencia
              _buildAppearanceSection(context, state),
              const SizedBox(height: 16),

              // Preferencias de entrenamiento
              _buildTrainingSection(context, state),
              const SizedBox(height: 16),

              // Sistema emocional y bienestar
              _buildWellnessSection(context),
              const SizedBox(height: 16),

              // Configuración de la aplicación
              _buildAppSection(context, state),
              const SizedBox(height: 16),

              // Información y acciones
              _buildInfoSection(context),
            ],
          );
        },
        ),
      ),
    );
  }

  Widget _buildUserHeader(
      BuildContext context, OnboardingUsuarioState perfilState) {
    PerfilUsuarioCompleto? perfil = _obtenerPerfilDelEstado(perfilState);

    // Datos por defecto si no hay perfil
    String nombreUsuario = perfil?.nombreCompleto ?? 'Usuario GyMaster';
    String descripcion = _construirDescripcionUsuario(perfil);
    String? rutaAvatar = _obtenerRutaAvatar(perfil?.fotoPerfil);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage:
                  rutaAvatar != null ? AssetImage(rutaAvatar) : null,
              child: rutaAvatar == null
                  ? const Icon(
                      IconsaxPlusLinear.profile,
                      size: 30,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombreUsuario,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  if (perfil != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.weight,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          perfil.objetivoFitness.nombre,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          IconsaxPlusLinear.trend_up,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          perfil.nivelExperiencia.nombre,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares para obtener datos del perfil
  PerfilUsuarioCompleto? _obtenerPerfilDelEstado(
      OnboardingUsuarioState estado) {
    if (estado is OnboardingUsuarioPerfilCargado) {
      return estado.perfil;
    }
    return null;
  }

  String _construirDescripcionUsuario(PerfilUsuarioCompleto? perfil) {
    if (perfil == null) return 'Usuario GyMaster';

    String genero = perfil.genero.nombre;
    int? edad = perfil.edad;

    if (edad != null) {
      return '$genero • $edad años';
    }
    return genero;
  }

  String? _obtenerRutaAvatar(String? fotoPerfil) {
    if (fotoPerfil == null) return null;

    // Mapear los avatares del onboarding a rutas de imágenes
    final Map<String, String> avatares = {
      'perfil_1': 'assets/imagenes/perfil_avatar/perfil1.jpg',
      'perfil_2': 'assets/imagenes/perfil_avatar/perfil2.jpg',
      'perfil_3': 'assets/imagenes/perfil_avatar/perfil3.jpg',
      'perfil_4': 'assets/imagenes/perfil_avatar/perfil4.jpg',
      'perfil_5': 'assets/imagenes/perfil_avatar/perfil5.jpg',
      'perfil_6': 'assets/imagenes/perfil_avatar/perfil6.jpg',
      'perfil_7': 'assets/imagenes/perfil_avatar/perfil7.jpg',
      'perfil_8': 'assets/imagenes/perfil_avatar/perfil8.jpg',
      'perfil_9': 'assets/imagenes/perfil_avatar/perfil9.jpg',
      'perfil_10': 'assets/imagenes/perfil_avatar/perfil10.jpg',
      'perfil_11': 'assets/imagenes/perfil_avatar/perfil11.jpg',
      'perfil_12': 'assets/imagenes/perfil_avatar/perfil12.jpg',
    };

    return avatares[fotoPerfil];
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    final c = context.gym;
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.brandSoft,
              borderRadius: GymRadius.rSm,
            ),
            child: Icon(icon, size: 18, color: c.brandInk),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GymType.section.copyWith(color: c.ink),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, SettingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Apariencia', IconsaxPlusLinear.colorfilter),
        Card(
          child: Column(
            children: [
              if (state is SettingLoaded) ...[
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.moon),
                  title: const Text('Modo Oscuro'),
                  subtitle: Text(state.isDarkMode ? 'Activado' : 'Desactivado'),
                  trailing: CupertinoSwitch(
                    value: state.isDarkMode,
                    onChanged: (value) {
                      context.read<SettingCubit>().toggleDarkMode();
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.language_square),
                  title: const Text('Idioma'),
                  subtitle: Text(state.language),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showLanguageBottomSheet(context, state),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingSection(BuildContext context, SettingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            'Preferencias de Entrenamiento', IconsaxPlusLinear.weight),
        Card(
          child: Column(
            children: [
              if (state is SettingLoaded) ...[
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.weight),
                  title: const Text('Unidad de Peso'),
                  subtitle: Text(state.weightUnit),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showWeightUnitBottomSheet(context, state),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.ruler),
                  title: const Text('Unidad de Longitud'),
                  subtitle: Text(state.lengthUnit),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showLengthUnitBottomSheet(context, state),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.clock),
                  title: const Text('Formato de Hora'),
                  subtitle: Text(state.timeFormat),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showTimeFormatBottomSheet(context, state),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Bienestar y Motivación', IconsaxPlusLinear.heart),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(IconsaxPlusLinear.emoji_happy,
                    color: Colors.orange),
                title: const Text('Onboarding Emocional'),
                subtitle: const Text('Configurar motivación y objetivos'),
                trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<OnboardingCubit>(),
                      child: const OnboardingEmocionalPage(),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(IconsaxPlusLinear.cup, color: Colors.amber),
                title: const Text('Mis Logros'),
                subtitle: const Text('Ver progreso y achievements'),
                trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                onTap: () => _showAchievementsDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading:
                    const Icon(IconsaxPlusLinear.chart, color: Colors.green),
                title: const Text('Detector de Ánimo'),
                subtitle: const Text('Análisis emocional personalizado'),
                trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                onTap: () => _showMoodDetectorDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context, SettingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Configuración de App', IconsaxPlusLinear.setting_2),
        Card(
          child: Column(
            children: [
              if (state is SettingLoaded) ...[
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.notification),
                  title: const Text('Notificaciones'),
                  subtitle: Text(state.isNotificationEnabled
                      ? 'Activadas'
                      : 'Desactivadas'),
                  trailing: CupertinoSwitch(
                    value: state.isNotificationEnabled,
                    onChanged: (value) {
                      context.read<SettingCubit>().toggleNotification(value);
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.calendar),
                  title: const Text('Formato de Fecha'),
                  subtitle: Text(state.dateFormat),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showDateFormatBottomSheet(context, state),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.calendar_tick),
                  title: const Text('Inicio de Semana'),
                  subtitle: Text(state.weekStart),
                  trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                  onTap: () => _showWeekStartBottomSheet(context, state),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            'Información y Herramientas', IconsaxPlusLinear.info_circle),
        Card(
          child: Column(
            children: [
              ListTile(
                leading:
                    const Icon(IconsaxPlusLinear.refresh, color: Colors.blue),
                title: const Text('Recargar Configuración'),
                subtitle: const Text('Actualizar todas las configuraciones'),
                onTap: () {
                  context.read<SettingCubit>().loadSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Configuración recargada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(IconsaxPlusLinear.info_circle,
                    color: Colors.purple),
                title: const Text('Información de la App'),
                subtitle: const Text('Versión y detalles técnicos'),
                trailing: const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                onTap: () => _showAppInfoDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bottom Sheets y Diálogos
  void _showLanguageBottomSheet(BuildContext context, SettingLoaded state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Seleccionar Idioma',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...state.languages.map((language) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.language_square,
                    color:
                        state.language == language ? Colors.blue : Colors.grey,
                  ),
                  title: Text(language),
                  trailing: state.language == language
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().updateLanguage(language);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Idioma cambiado a $language')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showWeightUnitBottomSheet(BuildContext context, SettingLoaded state) {
    final units = ['kg', 'lb'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Unidad de Peso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...units.map((unit) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.weight,
                    color: state.weightUnit == unit ? Colors.blue : Colors.grey,
                  ),
                  title: Text(unit),
                  trailing: state.weightUnit == unit
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().setWeightUnit(unit);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Unidad de peso cambiada a $unit')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLengthUnitBottomSheet(BuildContext context, SettingLoaded state) {
    final units = ['cm', 'inch'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Unidad de Longitud',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...units.map((unit) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.ruler,
                    color: state.lengthUnit == unit ? Colors.blue : Colors.grey,
                  ),
                  title: Text(unit),
                  trailing: state.lengthUnit == unit
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().setLengthUnit(unit);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Unidad de longitud cambiada a $unit')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showTimeFormatBottomSheet(BuildContext context, SettingLoaded state) {
    final formats = ['24h', '12h'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Formato de Hora',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...formats.map((format) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.clock,
                    color:
                        state.timeFormat == format ? Colors.blue : Colors.grey,
                  ),
                  title: Text(format),
                  trailing: state.timeFormat == format
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().setTimeFormat(format);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Formato de hora cambiado a $format')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showDateFormatBottomSheet(BuildContext context, SettingLoaded state) {
    final formats = ['31.01', '01/31', '31-01'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Formato de Fecha',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...formats.map((format) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.calendar,
                    color:
                        state.dateFormat == format ? Colors.blue : Colors.grey,
                  ),
                  title: Text(format),
                  trailing: state.dateFormat == format
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().setDateFormat(format);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Formato de fecha cambiado a $format')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showWeekStartBottomSheet(BuildContext context, SettingLoaded state) {
    final days = ['Lunes', 'Domingo'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Inicio de Semana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...days.map((day) => ListTile(
                  leading: Icon(
                    IconsaxPlusLinear.calendar_tick,
                    color: state.weekStart == day ? Colors.blue : Colors.grey,
                  ),
                  title: Text(day),
                  trailing: state.weekStart == day
                      ? const Icon(IconsaxPlusLinear.tick_square, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.read<SettingCubit>().setWeekStart(day);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Inicio de semana cambiado a $day')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showAchievementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(IconsaxPlusLinear.cup, color: Colors.amber),
            SizedBox(width: 8),
            Text('🏆 Mis Logros'),
          ],
        ),
        content: const SizedBox(
          height: 250,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sistema de Logros Implementado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('🎯 Logros Disponibles:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(IconsaxPlusLinear.tick_circle, color: Colors.green),
                  title: Text('Primera rutina completada'),
                  dense: true,
                ),
                ListTile(
                  leading:
                      Icon(IconsaxPlusLinear.flash_1, color: Colors.orange),
                  title: Text('7 días consecutivos'),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(IconsaxPlusLinear.star, color: Colors.yellow),
                  title: Text('30 días de racha'),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(IconsaxPlusLinear.weight, color: Colors.blue),
                  title: Text('100 ejercicios realizados'),
                  dense: true,
                ),
                SizedBox(height: 16),
                Text(
                  '💡 Los logros se desbloquean automáticamente según tu progreso.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showMoodDetectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(IconsaxPlusLinear.emoji_happy, color: Colors.green),
            SizedBox(width: 8),
            Text('😊 Detector de Ánimo'),
          ],
        ),
        content: const SizedBox(
          height: 200,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Análisis Emocional Personalizado',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('📊 Esta funcionalidad analiza:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Estado emocional actual'),
              Text('• Motivación para entrenar'),
              Text('• Recomendaciones personalizadas'),
              Text('• Seguimiento del bienestar'),
              Text('• Patrones de ánimo'),
              SizedBox(height: 16),
              Text(
                '🤖 Usa inteligencia artificial para adaptar tu experiencia de entrenamiento.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(IconsaxPlusLinear.info_circle, color: Colors.blue),
            SizedBox(width: 8),
            Text('ℹ️ GyMaster Info'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📱 GyMaster v1.0.0',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('🛠️ Tecnologías:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Flutter & Dart'),
              Text('• Clean Architecture'),
              Text('• BLoC/Cubit (Estado)'),
              Text('• SQLite (Base de datos)'),
              Text('• GetIt (Inyección de dependencias)'),
              SizedBox(height: 16),
              Text('🎯 Módulos Implementados:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('✅ Rutinas y ejercicios'),
              Text('✅ Configuración completa'),
              Text('✅ Sistema de logros'),
              Text('✅ Onboarding emocional'),
              Text('✅ Historial y estadísticas'),
              Text('✅ Gestión emocional'),
              SizedBox(height: 16),
              Text(
                '🏆 Desarrollado siguiendo las mejores prácticas de Flutter y patrones de diseño.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(
      BuildContext context, OnboardingUsuarioState perfilState) {
    final perfil = _obtenerPerfilDelEstado(perfilState);

    if (perfil == null) {
      return const SizedBox.shrink(); // No mostrar nada si no hay perfil
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título fuera de la tarjeta, igual que las demás secciones.
        _buildSectionTitle('Información del Perfil', IconsaxPlusLinear.profile),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Datos del perfil en formato de filas
                if (perfil.correo != null && perfil.correo!.isNotEmpty)
              _buildProfileRow('Correo', perfil.correo!, IconsaxPlusLinear.sms),

            _buildProfileRow('Género', perfil.genero.nombre, IconsaxPlusLinear.profile),

            if (perfil.edad != null)
              _buildProfileRow('Edad', '${perfil.edad} años', IconsaxPlusLinear.cake),

            if (perfil.alturaCm != null)
              _buildProfileRow('Altura', '${perfil.alturaCm} cm', IconsaxPlusLinear.ruler),

            if (perfil.pesoActualKg != null)
              _buildProfileRow(
                  'Peso Actual', '${perfil.pesoActualKg} kg', IconsaxPlusLinear.weight_1),

            if (perfil.pesoObjetivoKg != null)
              _buildProfileRow(
                  'Peso Objetivo', '${perfil.pesoObjetivoKg} kg', IconsaxPlusLinear.flag),

            _buildProfileRow('Objetivo Fitness', perfil.objetivoFitness.nombre,
                IconsaxPlusLinear.weight),

            _buildProfileRow(
                'Nivel', perfil.nivelExperiencia.nombre, IconsaxPlusLinear.trend_up),

            const SizedBox(height: 12),

            // Botón para editar perfil (opcional)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navegar a página de editar perfil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función de editar perfil próximamente'),
                    ),
                  );
                },
                icon: const Icon(IconsaxPlusLinear.edit_2),
                label: const Text('Editar Perfil'),
              ),
            ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
