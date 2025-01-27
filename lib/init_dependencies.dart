import 'package:get_it/get_it.dart';
import 'package:gymaster/features/routine/data/datasources/routine_local_data_source.dart';
import 'package:gymaster/features/routine/data/repositories/routine_repository_impl.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/add_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/delete_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_musculo_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_musculos_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_serie_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/update_serie.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizacion_ejercicio/realizacion_ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizar_ejercicio_rutina/realizar_ejercicio_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/serie/serie_cubit.dart';
import 'package:gymaster/features/setting/data/implements/implements.dart';
import 'package:gymaster/features/setting/data/sources/config_local_data_source.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';
import 'package:gymaster/features/setting/domain/usecases/get_language_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/get_theme_mode_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/set_lenguage_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/set_theme_mode_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

part 'init_dependencies.main.dart';
