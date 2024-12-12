
import 'package:gymaster/core/database/models/rutina.dart';

abstract class IRutinaDataSource {
  Future<List<Rutina>> getRutinas();
  Future<Rutina> createRutina(Rutina rutina);
  Future<Rutina> updateRutina(Rutina rutina);
  Future<bool> deleteRutina(String id);
  Future<Rutina> getRutinaById(String id);
  Future<List<Rutina>> getRutinasByEstado(int estado);
  Future<List<Rutina>> getRutinasByFechaRealizacion(String fechaRealizacion);
  Future<List<Rutina>> getRutinasByFechaCreacion(String fechaCreacion);
  Future<List<Rutina>> getRutinasByColor(int color);
  Future<List<Rutina>> getRutinasByNombre(String nombre);
  Future<List<Rutina>> getRutinasByDescripcion(String descripcion);
  Future<List<Rutina>> getRutinasByEstadoAndFechaRealizacion(int estado, String fechaRealizacion);
  Future<List<Rutina>> getRutinasByEstadoAndFechaCreacion(int estado, String fechaCreacion);
}