import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/record/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistorialEjerciciosPage extends StatefulWidget {
  @override
  _HistorialEjerciciosPageState createState() =>
      _HistorialEjerciciosPageState();
}

class _HistorialEjerciciosPageState extends State<HistorialEjerciciosPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _isCalendarVisible = false;

  // Variables para controlar mensajes y clics
  bool _isMessageShown = false; // Evita mensajes repetidos

  final List<RecordRutina> _rutinas = [
    RecordRutina(
      nombre: 'Rutina de Pecho',
      fechaRealizada: DateTime(2025, 1, 8),
      tiempoRealizado: '1h 30m',
      color: 0xFFF48FB1,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Press de Pecho Plano con Barra de Pesas',
          series: ['20x8', '25x8', '30x8', '35x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Cruzadas con Cable-Polea (de pie)',
          series: ['30x8', '35x8', '40x8', '45x8', '50x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
            SeriesDelEjercicio(peso: 40, repeticiones: 8),
            SeriesDelEjercicio(peso: 45, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
          ],
        ),
      ],
    ),
    RecordRutina(
      nombre: 'Rutina de Piernas',
      fechaRealizada: DateTime(2025, 1, 15),
      tiempoRealizado: '1h 45m',
      color: 0xFFB39DDB,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Sentadillas con Barra',
          series: ['50x8', '55x8', '60x8', '65x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Peso Muerto',
          series: ['60x8', '65x8', '70x8', '75x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 70, repeticiones: 8),
            SeriesDelEjercicio(peso: 75, repeticiones: 8),
          ],
        ),
      ],
    ),
    RecordRutina(
      nombre: 'Rutina full body',
      fechaRealizada: DateTime(2025, 1, 16),
      tiempoRealizado: '2h 00m',
      color: 0xFFF48FB1,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Press de Pecho Plano con Barra de Pesas',
          series: ['20x8', '25x8', '30x8', '35x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Cruzadas con Cable-Polea (de pie)',
          series: ['30x8', '35x8', '40x8', '45x8', '50x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
            SeriesDelEjercicio(peso: 40, repeticiones: 8),
            SeriesDelEjercicio(peso: 45, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
            SeriesDelEjercicio(peso: 40, repeticiones: 8),
            SeriesDelEjercicio(peso: 45, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Sentadillas con Barra',
          series: ['50x8', '55x8', '60x8', '65x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Peso Muerto',
          series: ['60x8', '65x8', '70x8', '75x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 70, repeticiones: 8),
            SeriesDelEjercicio(peso: 75, repeticiones: 8),
          ],
        ),
      ],
    ),
    RecordRutina(
      nombre: 'Rutina full body',
      fechaRealizada: DateTime(2025, 1, 28),
      tiempoRealizado: '2h 00m',
      color: 0xFF90CAF9,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Press de Pecho Plano con Barra de Pesas',
          series: ['20x8', '25x8', '30x8', '35x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Cruzadas con Cable-Polea (de pie)',
          series: ['30x8', '35x8', '40x8', '45x8', '50x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
            SeriesDelEjercicio(peso: 40, repeticiones: 8),
            SeriesDelEjercicio(peso: 45, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Sentadillas con Barra',
          series: ['50x8', '55x8', '60x8', '65x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
            SeriesDelEjercicio(peso: 55, repeticiones: 8),
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Peso Muerto',
          series: ['60x8', '65x8', '70x8', '75x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 70, repeticiones: 8),
            SeriesDelEjercicio(peso: 75, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Press de Pecho Plano con Barra de Pesas',
          series: ['60x8', '65x8', '70x8', '75x8'],
          iconoPath: Assets.imagenes.musculos.pecho
              .pressDePechoPlanoConBarraDePesasAgarreAmplioDeclinado.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 60, repeticiones: 8),
            SeriesDelEjercicio(peso: 65, repeticiones: 8),
            SeriesDelEjercicio(peso: 70, repeticiones: 8),
            SeriesDelEjercicio(peso: 75, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre:
              'Press de pecho plano con barra de pesas, agarre amplio (inclinado)',
          series: ['20x8', '25x8', '30x8', '35x8'],
          iconoPath: Assets.imagenes.musculos.pecho
              .pressDePechoPlanoConBarraDePesasAgarreAmplioInclinado.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Press de pecho plano con maquina smith',
          series: [],
          iconoPath: Assets
              .imagenes.musculos.pecho.pressDePechoPlanoConMaquinaSmith.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Abdominales Parciales Laterales con Hiperextension',
          series: [],
          iconoPath: Assets.imagenes.musculos.abdomen
              .abdominalesParcialesLateralesConHyperextension.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Abdominales Parciales Sostenidos (acostado)',
          series: [],
          iconoPath: Assets.imagenes.musculos.abdomen
              .abdominalesParcialesSostenidosAcostado.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Abdominales Parciales Sostenidos Laterales (acostado)',
          series: [],
          iconoPath: Assets.imagenes.musculos.abdomen
              .abdominalesParcialesSostenidosLateralesAcostado.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
      ],
    ),
    RecordRutina(
      nombre: 'Rutina de Espalda',
      fechaRealizada: DateTime(2025, 1, 20),
      tiempoRealizado: '1h 30m',
      color: 0xFF80DEEA,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Dominadas',
          series: ['10x8', '15x8', '20x8', '25x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 10, repeticiones: 8),
            SeriesDelEjercicio(peso: 15, repeticiones: 8),
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Remo con Barra',
          series: ['30x8', '35x8', '40x8', '45x8', '50x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
            SeriesDelEjercicio(peso: 40, repeticiones: 8),
            SeriesDelEjercicio(peso: 45, repeticiones: 8),
            SeriesDelEjercicio(peso: 50, repeticiones: 8),
          ],
        ),
      ],
    ),
    RecordRutina(
      nombre: 'Rutina de Hombros',
      fechaRealizada: DateTime(2025, 1, 22),
      tiempoRealizado: '1h 30m',
      color: 0xFFA5D6A7,
      ejercicios: [
        RecordEjercicios(
          nombre: 'Press Militar',
          series: ['20x8', '25x8', '30x8', '35x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
            SeriesDelEjercicio(peso: 35, repeticiones: 8),
          ],
        ),
        RecordEjercicios(
          nombre: 'Elevaciones Laterales',
          series: ['10x8', '15x8', '20x8', '25x8', '30x8'],
          iconoPath: Assets.imagenes.musculos.trapecio
              .encogimientoDeHombrosConBarraDePesas.path,
          seriesDelEjercicio: [
            SeriesDelEjercicio(peso: 10, repeticiones: 8),
            SeriesDelEjercicio(peso: 15, repeticiones: 8),
            SeriesDelEjercicio(peso: 20, repeticiones: 8),
            SeriesDelEjercicio(peso: 25, repeticiones: 8),
            SeriesDelEjercicio(peso: 30, repeticiones: 8),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ejercicios'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDatePickerSection(),
          Expanded(child: _buildRoutineInfoSection()),
        ],
      ),
    );
  }

  Widget _buildDatePickerSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400], // Background color
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.arrow_left_1,
                      color: Colors.white, // Icon color
                    ),
                    onPressed: () {
                      _navigateToPreviousRoutine();
                    },
                  ),
                ),
                Container(
                  height: 48, // Set the height to match the IconButton
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isCalendarVisible = !_isCalendarVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Original color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      DateFormat.yMMMMd('es').format(selectedDate),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400], // Background color
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.arrow_right_3,
                      color: Colors.white, // Icon color
                    ),
                    onPressed: () {
                      _navigateToNextRoutine();
                    },
                  ),
                ),
              ],
            ),
            if (_isCalendarVisible)
              TableCalendar(
                locale: 'es_ES', // Set the locale to Spanish
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
                  // Solo permitir la selección de días que tienen rutinas
                  return _hasRutina(day);
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    bool hasRutina = _rutinas.any(
                        (rutina) => isSameDay(rutina.fechaRealizada, date));
                    if (hasRutina) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineInfoSection() {
    final rutinasDelDia = _rutinas
        .where((rutina) => isSameDay(rutina.fechaRealizada, selectedDate))
        .toList();

    if (rutinasDelDia.isEmpty) {
      return const Center(
        child: Text(
          'No hay rutinas registradas para esta fecha.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rutinasDelDia.length,
      itemBuilder: (context, index) {
        final rutina = rutinasDelDia[index];
        return Card(
          elevation: 8,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(rutina.color), // Background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  rutina.nombre,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(rutina.color),
                  ),
                ),
                subtitle: Text(
                  'Tiempo: ${rutina.tiempoRealizado}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                trailing: IconButton(
                  icon: const Icon(IconsaxPlusLinear.edit),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 8),
              ...rutina.ejercicios.map(
                (ejercicio) => ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(230, 234, 236, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0), // Optional padding
                      child: ejercicio.iconoPath.endsWith('.svg')
                          ? SvgPicture.asset(
                              ejercicio.iconoPath,
                              width: 32,
                              height: 32,
                              color: Colors.deepPurple,
                            )
                          : Image.asset(
                              ejercicio.iconoPath,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    ejercicio.nombre,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  subtitle: Text(
                    ejercicio.seriesDelEjercicio.map((serie) {
                      return '${serie.peso.toInt()}x${serie.repeticiones}';
                    }).join(', '),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEjercicioPage(
                          recordEjercicios:
                              ejercicio, // Pass the required parameter here
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _hasRutina(DateTime date) {
    return _rutinas.any((rutina) => isSameDay(rutina.fechaRealizada, date));
  }

  void _navigateToNextRoutine() {
    // Debouncing: Evitar múltiples clics en un corto período de tiempo
    final now = DateTime.now();
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

      SnackbarHelper().showCustomSnackBar(
        context,
        "No hay más rutinas registradas después de esta fecha.",
        SnackBarType.info,
      );
    }
  }

  void _navigateToPreviousRoutine() {
    // Debouncing: Evitar múltiples clics en un corto período de tiempo
    final now = DateTime.now();
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
      SnackbarHelper().showCustomSnackBar(
        context,
        "No hay más rutinas registradas antes de esta fecha.",
        SnackBarType.info,
      );
    }
  }
}

class RecordRutina {
  final String nombre;
  final DateTime fechaRealizada;
  final String tiempoRealizado;
  final int color;
  final List<RecordEjercicios> ejercicios;

  RecordRutina({
    required this.nombre,
    required this.fechaRealizada,
    required this.tiempoRealizado,
    required this.color,
    required this.ejercicios,
  });

  RecordRutina copyWith({
    String? nombre,
    DateTime? fechaRealizada,
    String? tiempoRealizado,
    int? color,
    List<RecordEjercicios>? ejercicios,
  }) {
    return RecordRutina(
      nombre: nombre ?? this.nombre,
      fechaRealizada: fechaRealizada ?? this.fechaRealizada,
      tiempoRealizado: tiempoRealizado ?? this.tiempoRealizado,
      color: color ?? this.color,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }
}

class RecordEjercicios {
  final String nombre;
  final List<String> series;
  final String iconoPath;
  final List<SeriesDelEjercicio> seriesDelEjercicio;

  RecordEjercicios({
    required this.nombre,
    required this.series,
    required this.iconoPath,
    required this.seriesDelEjercicio,
  });

  RecordEjercicios copyWith({
    String? nombre,
    List<String>? series,
    String? iconoPath,
    List<SeriesDelEjercicio>? seriesDelEjercicio,
  }) {
    return RecordEjercicios(
      nombre: nombre ?? this.nombre,
      series: series ?? this.series,
      iconoPath: iconoPath ?? this.iconoPath,
      seriesDelEjercicio: seriesDelEjercicio ?? this.seriesDelEjercicio,
    );
  }
}

class SeriesDelEjercicio {
  final double peso;
  final int repeticiones;

  SeriesDelEjercicio({
    required this.peso,
    required this.repeticiones,
  });

  SeriesDelEjercicio copyWith({
    double? peso,
    int? repeticiones,
  }) {
    return SeriesDelEjercicio(
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
    );
  }
}
