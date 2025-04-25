import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_rutina_detalle.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'rutina_detalle_state.dart';

class RutinaDetalleCubit extends Cubit<RutinaDetalleState> {
  final ObtenerRutinaDetalle obtenerRutinaDetalle;

  RutinaDetalleCubit(
    this.obtenerRutinaDetalle,
  ) : super(RutinaDetalleInitial());
}
