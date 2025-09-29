import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';
import 'package:gymaster/features/record/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistorialEjerciciosPage extends StatefulWidget {
  const HistorialEjerciciosPage({super.key});

  @override
  State<HistorialEjerciciosPage> createState() =>
      _HistorialEjerciciosPageState();
}

class _HistorialEjerciciosPageState extends State<HistorialEjerciciosPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _isCalendarVisible = false;
  bool _isMessageShown = false;

  @override
  void initState() {
    super.initState();
    // Fetch all rutinas when the page is initialized
    BlocProvider.of<RecordCubit>(context).getAllRutinas();
  }

  /// Construye la cabecera usando el componente reutilizable
  Widget _construirCabeceraReutilizable(BuildContext context) {
    return CabeceraReutilizable(
      titulo: 'Historial de Ejercicios',
      subtitulo: 'Revisa tu progreso y entrenamientos',
      botonIzquierdo: ConfiguracionBotonIzquierdo.menu(),
      accionesDerecha: [
        BotonAccionDerecha.actualizar(
          onPressed: () {
            BlocProvider.of<RecordCubit>(context).getAllRutinas();
          },
          tooltip: 'Actualizar historial',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro,
      body: SafeArea(
        child: Column(
          children: [
            // Header emocional mejorado
            _construirCabeceraReutilizable(context),
            // Contenido principal con gradiente
            Expanded(
              child: Container(
                color: AppColors.fondoPrincipalClaro,
                child: Column(
                  spacing: Espaciado.sm,
                  children: [
                    _buildDatePickerSection(),
                    Expanded(child: _buildRoutineInfoSection()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: Espaciado.rellenoHorizontalMd,
        padding: Espaciado.rellenoSm,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primario.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Selector de fecha mejorado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón anterior
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primario,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      IconsaxPlusLinear.arrow_left_1,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _navigateToPreviousRoutine,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                // Botón central de fecha
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primario,
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: AppColors.primarioOscuro,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCalendarVisible = !_isCalendarVisible;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primario,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        DateFormat.yMMMMd('es').format(selectedDate),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: TipografiaGyMaster.tamanoSm,
                          fontWeight: TipografiaGyMaster.pesoSemiBold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Botón siguiente
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primario,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      IconsaxPlusLinear.arrow_right_3,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _navigateToNextRoutine,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            // Calendario mejorado con animación
            if (_isCalendarVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  margin: EdgeInsets.only(top: Espaciado.sm),
                  child: TableCalendar(
                    locale: 'es_ES',
                    focusedDay: selectedDate,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                        _isCalendarVisible = false;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    enabledDayPredicate: (day) {
                      return _hasRutina(day);
                    },
                    // Estilos mejorados del calendario
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: AppColors.primario,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: AppColors.primario,
                      ),
                      titleTextStyle: TextStyle(
                        fontSize: TipografiaGyMaster.tamanoMd,
                        fontWeight: TipografiaGyMaster.pesoSemiBold,
                        color: AppColors.textoPrincipalOscuro,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: TipografiaGyMaster.tamanoSm,
                        fontWeight: TipografiaGyMaster.pesoSemiBold,
                        color: AppColors.textoTerciario,
                      ),
                      weekendStyle: TextStyle(
                        fontSize: TipografiaGyMaster.tamanoSm,
                        fontWeight: TipografiaGyMaster.pesoSemiBold,
                        color: AppColors.textoTerciario,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(
                        color: AppColors.textoTerciario,
                      ),
                      defaultTextStyle: TextStyle(
                        color: AppColors.textoTerciario,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.secundario,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primario.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        final state = context.read<RecordCubit>().state;
                        if (state is RecordLoaded) {
                          bool hasRutina = state.rutinas.any(
                            (rutina) => isSameDay(rutina.fechaRealizada, date),
                          );
                          if (hasRutina) {
                            return Container(
                              margin: EdgeInsets.all(Espaciado.xxs),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primario,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primario
                                        .withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                                  fontSize: TipografiaGyMaster.tamanoSm,
                                ),
                              ),
                            );
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineInfoSection() {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        if (state is RecordLoading) {
          return _buildLoadingState();
        } else if (state is RecordLoaded) {
          final rutinasDelDia = state.rutinas
              .where(
                (rutina) => isSameDay(rutina.fechaRealizada, selectedDate),
              )
              .toList();

          if (rutinasDelDia.isEmpty) {
            return _buildEmptyState();
          }
          return FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: ListView.builder(
              padding: Espaciado.rellenoHorizontalMd,
              itemCount: rutinasDelDia.length,
              itemBuilder: (context, index) {
                final rutina = rutinasDelDia[index];
                return Container(
                  margin: EdgeInsets.only(bottom: Espaciado.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primario.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: Espaciado.sm,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header de la rutina mejorado
                      Container(
                        padding: Espaciado.rellenoSm,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(rutina.color).withValues(alpha: 0.1),
                              Color(rutina.color).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Ícono de la rutina
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Color(rutina.color),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(rutina.color)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            Espaciado.separacionHorizontalSm,
                            // Información de la rutina
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalizarPrimeraLetra(rutina.nombre),
                                    style: TextStyle(
                                      fontSize: TipografiaGyMaster.tamanoLg,
                                      fontWeight:
                                          TipografiaGyMaster.pesoSemiBold,
                                      color: Color(rutina.color),
                                    ),
                                  ),
                                  Espaciado.separacionVerticalXxs,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 16,
                                        color: Color(rutina.color),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Tiempo: ${rutina.tiempoRealizado}',
                                        style: TextStyle(
                                          fontSize: TipografiaGyMaster.tamanoSm,
                                          fontWeight:
                                              TipografiaGyMaster.pesoRegular,
                                          color: Color(rutina.color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Botón de edición
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primario.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  IconsaxPlusLinear.edit,
                                  color: AppColors.primario,
                                  size: 20,
                                ),
                                onPressed: () {},
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Lista de ejercicios
                      Container(
                        padding: EdgeInsets.only(
                          left: Espaciado.sm,
                          right: Espaciado.sm,
                          bottom: Espaciado.sm,
                        ),
                        child: Column(
                          spacing: Espaciado.sm,
                          children: rutina.ejercicios.map((ejercicio) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: Espaciado.cero),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Espaciado.cero,
                                  vertical: Espaciado.cero,
                                ),
                                leading: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primario
                                          .withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                    color: AppColors.fondoPrincipalClaro,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: ejercicio.iconoPath.endsWith('.svg')
                                        ? SvgPicture.asset(
                                            ejercicio.iconoPath,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              AppColors.primario,
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : Image.asset(
                                            ejercicio.iconoPath,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  capitalizarPrimeraLetra(ejercicio.nombre),
                                  style: TextStyle(
                                    fontSize: TipografiaGyMaster.tamanoMd,
                                    fontWeight: TipografiaGyMaster.pesoRegular,
                                    height: 1.2,
                                    color: AppColors.textoPrincipalOscuro,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Espaciado.separacionVerticalXxs,
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.fitness_center,
                                          size: 14,
                                          color: AppColors.textoTerciario,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            ejercicio.seriesDelEjercicio
                                                .map((serie) {
                                              return '${serie.peso.toInt()}kg × ${serie.repeticiones}';
                                            }).join(' • '),
                                            style: TextStyle(
                                              fontSize:
                                                  TipografiaGyMaster.tamanoSm,
                                              fontWeight: TipografiaGyMaster
                                                  .pesoRegular,
                                              color: AppColors.textoTerciario,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secundario
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.secundario,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetalleEjercicioPage(
                                            recordEjercicios: ejercicio,
                                            rutina: rutina,
                                          ),
                                        ),
                                      );
                                    },
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is RecordError) {
          return _buildErrorState(state.message);
        } else {
          return _buildErrorState(
              'No se pudo cargar el historial de ejercicios.');
        }
      },
    );
  }

  bool _hasRutina(DateTime date) {
    final state = context.read<RecordCubit>().state;
    if (state is RecordLoaded) {
      return state.rutinas.any(
        (rutina) => isSameDay(rutina.fechaRealizada, date),
      );
    }
    return false;
  }

  void _navigateToNextRoutine() {
    // Debouncing: Evitar múltiples clics en un corto período de tiempo
    /*
    if (_lastClickTime != null &&
        now.difference(_lastClickTime!) < Duration(seconds: 1)) {
      return; // Ignorar clics rápidos
    }

     */

    DateTime nextDate = selectedDate.add(const Duration(days: 1));
    bool foundNextRoutine = false;

    while (nextDate.isBefore(DateTime(2030))) {
      if (_hasRutina(nextDate)) {
        setState(() {
          selectedDate = nextDate;
          _isMessageShown = false; // Reiniciar el control de mensajes
        });
        foundNextRoutine = true;
        break;
      }
      nextDate = nextDate.add(const Duration(days: 1));
    }

    if (!foundNextRoutine && !_isMessageShown) {
      _isMessageShown = true; // Evitar mensajes repetidos

      SnackbarHelper.showSafeSnackBar(
        context,
        "No hay más rutinas registradas después de esta fecha.",
        SnackBarType.info,
      );
    }
  }

  void _navigateToPreviousRoutine() {
    // Debouncing: Evitar múltiples clics en un corto período de tiempo
    /*
    if (_lastClickTime != null &&
        now.difference(_lastClickTime!) < const Duration(milliseconds: 500)) {
      return; // Ignorar clics rápidos
    }
     */

    DateTime previousDate = selectedDate.subtract(const Duration(days: 1));
    bool foundPreviousRoutine = false;

    while (previousDate.isAfter(DateTime(2020))) {
      if (_hasRutina(previousDate)) {
        setState(() {
          selectedDate = previousDate;
          _isMessageShown = false; // Reiniciar el control de mensajes
        });
        foundPreviousRoutine = true;
        break;
      }
      previousDate = previousDate.subtract(const Duration(days: 1));
    }

    if (!foundPreviousRoutine && !_isMessageShown) {
      _isMessageShown = true; // Evitar mensajes repetidos
      SnackbarHelper.showSafeSnackBar(
        context,
        "No hay más rutinas registradas antes de esta fecha.",
        SnackBarType.info,
      );
    }
  }

  // Estados mejorados siguiendo el patrón de detalle_ejercicio_page
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primario,
            strokeWidth: 3,
          ),
          Espaciado.separacionVerticalSm,
          Text(
            'Cargando historial...',
            style: TextStyle(
              color: AppColors.textoTerciario,
              fontSize: TipografiaGyMaster.tamanoMd,
              fontWeight: TipografiaGyMaster.pesoRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: Espaciado.rellenoXl,
              decoration: BoxDecoration(
                color: AppColors.primario.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconsaxPlusLinear.calendar_remove,
                size: 64,
                color: AppColors.primario,
              ),
            ),
            Espaciado.separacionVerticalMd,
            Text(
              'Sin rutinas esta fecha',
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoXl,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
                color: AppColors.primario,
              ),
            ),
            Espaciado.separacionVerticalSm,
            Text(
              'No hay rutinas registradas para\n${DateFormat.yMMMMd('es').format(selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoSm,
                fontWeight: TipografiaGyMaster.pesoRegular,
                color: AppColors.textoTerciario,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: Espaciado.rellenoXl,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            Espaciado.separacionVerticalMd,
            Text(
              'Error al cargar datos',
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoLg,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
                color: AppColors.textoPrincipalOscuro,
              ),
            ),
            Espaciado.separacionVerticalSm,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoSm,
                fontWeight: TipografiaGyMaster.pesoRegular,
                color: AppColors.textoTerciario,
              ),
            ),
            Espaciado.separacionVerticalMd,
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<RecordCubit>(context).getAllRutinas();
              },
              icon: Icon(
                Icons.refresh,
                size: 20,
                color: Colors.white,
              ),
              label: Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: TipografiaGyMaster.tamanoSm,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primario,
                padding: EdgeInsets.symmetric(
                  horizontal: Espaciado.lg,
                  vertical: Espaciado.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
