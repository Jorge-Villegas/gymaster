import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/shared/utils/logger.dart';

class EjerciciosService {
  eliminarEjercicios() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rest =
          await db.rawDelete('DELETE FROM $DatabaseHelper.tableEjercicio');
      return rest;
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  eliminarEjercicoMusculo() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rest =
          await db.rawDelete('DELETE FROM $DatabaseHelper.tableEjercicio');
      return rest;
    } catch (e) {
      logger.e(e);
      return;
    }
  }
}
