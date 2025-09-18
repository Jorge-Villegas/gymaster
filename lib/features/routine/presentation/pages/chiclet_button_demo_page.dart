import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/shared/widgets/tarjeta_Estado.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Página de ejemplo que demuestra el uso de ChicletButtons
/// en el contexto de una sesión de rutina activa
///
/// Esta página sirve como:
/// 1. Demo de todos los tipos de botones chiclet
/// 2. Ejemplo de implementación en rutinas reales
/// 3. Referencia para desarrolladores
class ChicletButtonDemoPage extends StatefulWidget {
  final String? rutinaId;
  final String? sesionId;

  const ChicletButtonDemoPage({
    super.key,
    this.rutinaId,
    this.sesionId,
  });

  @override
  State<ChicletButtonDemoPage> createState() => _ChicletButtonDemoPageState();
}

class _ChicletButtonDemoPageState extends State<ChicletButtonDemoPage> {
  bool _serieCompletada = false;
  bool _isLoading = false;
  bool _rutinaIniciada = false;
  bool _enDescanso = false;
  int _serieActual = 1;
  final int _totalSeries = 4;
  final String _ejercicioActual = 'Press de Banca';
  final String _musculoActual = 'Pecho';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo ChicletButtons'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_rutinaIniciada) ...[
            ChicletButton(
              texto: 'Pausar',
              icono: Icons.pause,
              colorFondo: AppColors.calmBlue,
              colorTexto: Colors.white,
              onPressed: _pausarRutina,
              estaHabilitado: true,
              tamano: TamanoBotonChiclet.mediano,
              estilo: EstiloBotonChiclet.relleno,
              radioBorde: 22,
            ),
            const SizedBox(width: 8),
            ChicletButton(
              texto: 'Terminar Rutina',
              icono: Icons.check_circle_outline,
              colorFondo: AppColors.motivationRed,
              colorTexto: Colors.white,
              onPressed: _mostrarDialogoTerminarRutina,
              tamano: TamanoBotonChiclet.grande,
              estilo: EstiloBotonChiclet.relleno,
              radioBorde: 28,
              ancho: double.infinity,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TarjetaEstado(
              titulo: 'INCREÍBLE',
              textoCuerpo: '100 %',
              icono: Icons.check_circle,
              colorFondo: Color(0xFF7ED321),
            ),
            _buildInfoRutina(),
            const SizedBox(height: 24),
            _buildEjercicioActual(),
            const SizedBox(height: 24),
            _buildBotonesPrincipales(),
            const SizedBox(height: 24),
            _buildBotonesSecundarios(),
            const SizedBox(height: 24),
            _buildBotonesEspeciales(),
            const SizedBox(height: 24),
            _buildDemoCompleta(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRutina() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rutina: Push Day - Fuerza',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estado: ${_rutinaIniciada ? "En progreso" : "No iniciada"}',
              style: TextStyle(
                color: _rutinaIniciada
                    ? AppColors.success
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!_rutinaIniciada) ...[
              const SizedBox(height: 16),
              ChicletButton(
                texto: 'Iniciar Rutina',
                icono: Icons.play_arrow,
                colorFondo: AppColors.energyOrange,
                colorTexto: Colors.white,
                onPressed: _iniciarRutina,
                estaCargando: _isLoading,
                estaHabilitado: true,
                tamano: TamanoBotonChiclet.grande,
                estilo: EstiloBotonChiclet.relleno,
                radioBorde: 26,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEjercicioActual() {
    if (!_rutinaIniciada) return const SizedBox.shrink();

    return Card(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ejercicioActual,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$_musculoActual • Serie $_serieActual/$_totalSeries',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEjercicioStat('Peso', '60 kg'),
                  _buildEjercicioStat('Reps', '12'),
                  _buildEjercicioStat(
                      'Descanso', _enDescanso ? '01:30' : '02:00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEjercicioStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: _enDescanso && label == 'Descanso'
                ? AppColors.warning
                : AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBotonesPrincipales() {
    if (!_rutinaIniciada) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Principales',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Botón principal - Completar Serie
        if (!_enDescanso)
          ChicletButton(
            texto: 'Completar Serie',
            colorFondo: AppColors.success,
            colorTexto: Colors.white,
            onPressed: _serieCompletada ? null : _completarSerie,
            estaCargando: _isLoading,
            estaHabilitado: !_serieCompletada,
            tamano: TamanoBotonChiclet.grande,
            estilo: EstiloBotonChiclet.relleno,
            radioBorde: 28,
            ancho: double.infinity,
            conSombreado: true,
            conBordes: true,
          )
        else
          ChicletButton(
            texto: 'Descansando... 01:30',
            icono: Icons.access_time,
            colorFondo: AppColors.restTeal,
            colorTexto: Colors.white,
            onPressed: _terminarDescanso,
            estaHabilitado: true,
            estaCargando: true,
            tamano: TamanoBotonChiclet.mediano,
            estilo: EstiloBotonChiclet.relleno,
            radioBorde: 20,
          ),

        const SizedBox(height: 12),
        ChicletButton(
          texto: 'Pausar',
          icono: Icons.pause,
          colorFondo: AppColors.calmBlue,
          colorTexto: Colors.white,
          onPressed: _pausarRutina,
          tamano: TamanoBotonChiclet.mediano,
          estilo: EstiloBotonChiclet.relleno,
          radioBorde: 22,
        ),

        const SizedBox(height: 12),
        // Botón de terminar rutina con mismas dimensiones que completarSerie
        ChicletButton(
          texto: 'Terminar',
          icono: Icons.check_circle_outline,
          colorFondo: AppColors.motivationRed,
          colorTexto: Colors.white,
          onPressed: _mostrarDialogoTerminarRutina,
          tamano: TamanoBotonChiclet.grande,
          estilo: EstiloBotonChiclet.relleno,
          radioBorde: 28,
          ancho: double.infinity,
        ),
      ],
    );
  }

  Widget _buildBotonesSecundarios() {
    if (!_rutinaIniciada) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Secundarias',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ChicletButton(
                texto: 'Saltar Serie',
                icono: Icons.skip_next,
                colorFondo: AppColors.textSecondary,
                colorTexto: AppColors.textSecondary,
                onPressed: _saltarSerie,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.contorno,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChicletButton(
                texto: 'Editar Peso',
                icono: Icons.edit,
                colorFondo: AppColors.focusIndigo,
                colorTexto: Colors.white,
                onPressed: _editarPeso,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.relleno,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ChicletButton(
                texto: 'Agregar Ejercicio',
                icono: Icons.add_circle,
                colorFondo: AppColors.achievementGold,
                colorTexto: Colors.white,
                onPressed: _agregarEjercicio,
                estaHabilitado: true,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.relleno,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChicletButton(
                texto: 'Ver Historial',
                icono: Icons.history,
                colorFondo: AppColors.peacefulBlue,
                colorTexto: Colors.white,
                onPressed: _verHistorial,
                tamano: TamanoBotonChiclet.pequeno,
                estilo: EstiloBotonChiclet.relleno,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBotonesEspeciales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Botones Especiales',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ChicletButton(
          texto: '¡Rutina Completada!',
          icono: Icons.celebration,
          colorFondo: AppColors.celebrationPurple,
          colorTexto: Colors.white,
          onPressed: _celebrarLogro,
          tamano: TamanoBotonChiclet.grande,
          estilo: EstiloBotonChiclet.relleno,
          elevacion: 8,
          radioBorde: 30,
        ),

        const SizedBox(height: 12),

        // Botón de record personal
        ChicletButton(
          texto: '¡Nuevo Record Personal!',
          icono: Icons.emoji_events,
          colorFondo: AppColors.achievementGold,
          colorTexto: Colors.white,
          onPressed: _celebrarRecord,
          tamano: TamanoBotonChiclet.grande,
          estilo: EstiloBotonChiclet.relleno,
          elevacion: 10,
          radioBorde: 32,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ChicletButton(
                texto: 'Ver estadísticas',
                icono: Icons.analytics,
                colorFondo: AppColors.primary,
                onPressed: _verEstadisticas,
                tamano: TamanoBotonChiclet.pequeno,
                estilo: EstiloBotonChiclet.texto,
              ),
            ),
            Expanded(
              child: ChicletButton(
                texto: 'Configurar',
                icono: Icons.settings,
                colorFondo: AppColors.textSecondary,
                colorTexto: AppColors.textSecondary,
                onPressed: _configurarEjercicio,
                tamano: TamanoBotonChiclet.mediano,
                estilo: EstiloBotonChiclet.contorno,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDemoCompleta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Completa de Estilos',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Tamaños
        Text('Tamaños:', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),

        ChicletButton(
          texto: 'Pequeño',
          tamano: TamanoBotonChiclet.pequeno,
          colorFondo: AppColors.primary,
          onPressed: () => _mostrarSnackbar('Botón pequeño'),
        ),
        const SizedBox(height: 8),

        ChicletButton(
          texto: 'Mediano',
          tamano: TamanoBotonChiclet.mediano,
          colorFondo: AppColors.secondary,
          onPressed: () => _mostrarSnackbar('Botón mediano'),
        ),
        const SizedBox(height: 8),

        ChicletButton(
          texto: 'Grande',
          tamano: TamanoBotonChiclet.grande,
          colorFondo: AppColors.success,
          onPressed: () => _mostrarSnackbar('Botón grande'),
        ),

        const SizedBox(height: 16),

        // Botones Solo con Iconos Centrados
        Text('Botones Solo con Iconos:',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botón agregar (filled)
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.add,
              estilo: EstiloBotonChiclet.relleno,
              tamano: TamanoBotonChiclet.pequeno,
              colorFondo: AppColors.success,
              onPressed: () => _mostrarSnackbar('Agregar elemento'),
            ),
            // Botón eliminar (outlined)
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.minus,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              colorFondo: AppColors.motivationRed,
              onPressed: () => _mostrarSnackbar('Eliminar elemento'),
            ),
            // Botón configuración (text)
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.setting_2,
              estilo: EstiloBotonChiclet.texto,
              tamano: TamanoBotonChiclet.pequeno,
              colorFondo: AppColors.primary,
              onPressed: () => _mostrarSnackbar('Configuración'),
            ),
            // Botón editar (filled mediano)
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.edit,
              estilo: EstiloBotonChiclet.relleno,
              tamano: TamanoBotonChiclet.mediano,
              colorFondo: AppColors.energyOrange,
              onPressed: () => _mostrarSnackbar('Editar'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Botones solo iconos con diferentes tamaños
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pequeño
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.heart,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              colorFondo: AppColors.motivationRed,
              radioBorde: 18,
              onPressed: () => _mostrarSnackbar('Favorito - Pequeño'),
            ),
            // Mediano
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.star,
              estilo: EstiloBotonChiclet.relleno,
              tamano: TamanoBotonChiclet.mediano,
              colorFondo: AppColors.achievementGold,
              radioBorde: 24,
              onPressed: () => _mostrarSnackbar('Estrella - Mediano'),
            ),
            // Grande
            ChicletButton(
              texto: '',
              icono: IconsaxPlusLinear.crown,
              estilo: EstiloBotonChiclet.relleno,
              tamano: TamanoBotonChiclet.grande,
              colorFondo: AppColors.celebrationPurple,
              radioBorde: 28,
              onPressed: () => _mostrarSnackbar('Corona - Grande'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Estilos
        Text('Estilos:', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: ChicletButton(
                texto: 'Filled',
                estilo: EstiloBotonChiclet.relleno,
                colorFondo: AppColors.energyOrange,
                onPressed: () => _mostrarSnackbar('Estilo filled'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChicletButton(
                texto: 'Outlined',
                estilo: EstiloBotonChiclet.contorno,
                colorFondo: AppColors.calmBlue,
                onPressed: () => _mostrarSnackbar('Estilo outlined'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChicletButton(
                texto: 'Text',
                estilo: EstiloBotonChiclet.texto,
                colorFondo: AppColors.achievementGold,
                onPressed: () => _mostrarSnackbar('Estilo text'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== MÉTODOS DE ACCIÓN ==========

  void _iniciarRutina() async {
    setState(() => _isLoading = true);
    await HapticFeedbackHelper.vibracionMotivacionalInicioRutina();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _rutinaIniciada = true;
    });
    _mostrarSnackbar('¡Rutina iniciada! 💪', color: AppColors.success);
  }

  void _completarSerie() async {
    setState(() => _isLoading = true);
    await HapticFeedbackHelper.vibracionExito();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _serieCompletada = true;
      _enDescanso = true;
    });

    _mostrarSnackbar('¡Serie completada! 🎉', color: AppColors.success);

    // Simular descanso automático
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _enDescanso = false;
          _serieCompletada = false;
          _serieActual = _serieActual < _totalSeries ? _serieActual + 1 : 1;
        });
      }
    });
  }

  void _terminarDescanso() {
    setState(() {
      _enDescanso = false;
      _serieCompletada = false;
    });
    _mostrarSnackbar('Descanso terminado', color: AppColors.info);
  }

  void _pausarRutina() {
    HapticFeedbackHelper.vibracionTransicion();
    _mostrarSnackbar('Rutina pausada', color: AppColors.warning);
  }

  void _saltarSerie() {
    setState(() {
      _serieActual = _serieActual < _totalSeries ? _serieActual + 1 : 1;
      _serieCompletada = false;
      _enDescanso = false;
    });
    _mostrarSnackbar('Serie saltada', color: AppColors.warning);
  }

  void _editarPeso() {
    _mostrarSnackbar('Editar peso/repeticiones');
  }

  void _agregarEjercicio() {
    _mostrarSnackbar('Agregar nuevo ejercicio');
  }

  void _verHistorial() {
    _mostrarSnackbar('Navegando al historial');
  }

  void _verEstadisticas() {
    _mostrarSnackbar('Mostrando estadísticas');
  }

  void _configurarEjercicio() {
    _mostrarSnackbar('Configurando ejercicio');
  }

  void _celebrarLogro() async {
    await HapticFeedbackHelper.vibracionLogro();
    _mostrarSnackbar('¡Celebrando logro! 🎉',
        color: AppColors.celebrationPurple);
  }

  void _celebrarRecord() async {
    await HapticFeedbackHelper.vibracionLogro();
    _mostrarSnackbar('¡Nuevo Record Personal! 🏆',
        color: AppColors.achievementGold);
  }

  void _mostrarDialogoTerminarRutina() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminar Rutina'),
        content: const Text('¿Estás seguro de que quieres terminar la rutina?'),
        actions: [
          ChicletButton(
            texto: 'Terminar Rutina',
            colorFondo: AppColors.primary,
            onPressed: () => Navigator.pop(context),
            tamano: TamanoBotonChiclet.pequeno,
            estilo: EstiloBotonChiclet.texto,
          ),
          ChicletButton(
            texto: 'Terminar Rutina',
            icono: Icons.check_circle_outline,
            colorFondo: AppColors.motivationRed,
            colorTexto: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              _terminarRutina();
            },
            tamano: TamanoBotonChiclet.grande,
            estilo: EstiloBotonChiclet.relleno,
            radioBorde: 28,
            ancho: double.infinity,
          ),
        ],
      ),
    );
  }

  void _terminarRutina() {
    setState(() {
      _rutinaIniciada = false;
      _serieCompletada = false;
      _enDescanso = false;
      _serieActual = 1;
    });
    _mostrarSnackbar('Rutina terminada', color: AppColors.motivationRed);
  }

  void _mostrarSnackbar(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color ?? AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
