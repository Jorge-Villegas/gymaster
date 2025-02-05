import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';
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
  bool _isMessageShown = false;

  @override
  void initState() {
    super.initState();
    // Fetch all rutinas when the page is initialized
    BlocProvider.of<RecordCubit>(context).fetchAllRutinas();
  }

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
                    final state = context.read<RecordCubit>().state;
                    if (state is RecordLoaded) {
                      bool hasRutina = state.rutinas.any(
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
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        if (state is RecordLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecordLoaded) {
          final rutinasDelDia = state.rutinas
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
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
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
                            padding:
                                const EdgeInsets.all(0), // Optional padding
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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        subtitle: Text(
                          ejercicio.seriesDelEjercicio.map((serie) {
                            return '${serie.peso.toInt()}x${serie.repeticiones}';
                          }).join(', '),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
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
        } else if (state is RecordError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No se pudo cargar el historial de ejercicios.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
      },
    );
  }

  bool _hasRutina(DateTime date) {
    final state = context.read<RecordCubit>().state;
    if (state is RecordLoaded) {
      return state.rutinas
          .any((rutina) => isSameDay(rutina.fechaRealizada, date));
    }
    return false;
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
