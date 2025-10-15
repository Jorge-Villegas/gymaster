abstract class LocalizationServiceInterface {
  String get idiomActual;
  Future<void> cambiarIdioma(String nuevoIdioma);
  String traducir(String clave, {Map<String, String>? parametros});
  List<String> get idiomasDisponibles;
  Map<String, String> get etiquetasIdiomas;
}

class LocalizationService implements LocalizationServiceInterface {
  static const String _idiomaDefault = 'es';
  String _idiomActual = _idiomaDefault;

  @override
  String get idiomActual => _idiomActual;

  @override
  List<String> get idiomasDisponibles => ['es', 'en'];

  @override
  Map<String, String> get etiquetasIdiomas => {
        'es': 'Español',
        'en': 'English',
      };

  // Traducciones estáticas para el módulo de configuraciones
  static const Map<String, Map<String, String>> _traducciones = {
    'es': {
      // Configuración General
      'configuracion': 'Configuración',
      'unidades_medida': 'Unidades de Medida',
      'unidad_peso': 'Unidad de Peso',
      'unidad_longitud': 'Unidad de Longitud',
      'formato_hora': 'Formato de Hora',
      'formato_fecha': 'Formato de Fecha',
      'dia_inicio_semana': 'Día de Inicio de Semana',
      'unidad_calorias': 'Unidad de Calorías',

      // Entrenamiento
      'configuracion_entrenamiento': 'Configuración de Entrenamiento',
      'tiempo_descanso_defecto': 'Tiempo de Descanso por Defecto',
      'sonidos_habilitados': 'Sonidos Habilitados',
      'vibracion_habilitada': 'Vibración Habilitada',
      'volumen_sonidos': 'Volumen de Sonidos',
      'intensidad_vibracion': 'Intensidad de Vibración',
      'auto_siguiente_ejercicio':
          'Avanzar Automáticamente al Siguiente Ejercicio',

      // Notificaciones
      'notificaciones': 'Notificaciones',
      'notificaciones_habilitadas': 'Notificaciones Habilitadas',
      'recordatorio_entrenar': 'Recordatorio para Entrenar',
      'recordatorio_racha': 'Recordatorio de Racha',
      'recordatorio_descanso': 'Recordatorio de Descanso',
      'hora_recordatorio_manana': 'Hora de Recordatorio Mañana',
      'hora_recordatorio_tarde': 'Hora de Recordatorio Tarde',

      // Personalización
      'personalizacion': 'Personalización',
      'modo_oscuro': 'Modo Oscuro',
      'idioma': 'Idioma',

      // Perfil
      'perfil_usuario': 'Perfil de Usuario',
      'nombre_usuario': 'Nombre de Usuario',
      'correo': 'Correo Electrónico',
      'nombre_completo': 'Nombre Completo',
      'foto_perfil': 'Foto de Perfil',
      'fecha_nacimiento': 'Fecha de Nacimiento',
      'genero': 'Género',
      'objetivo_fitness': 'Objetivo Fitness',
      'nivel_experiencia': 'Nivel de Experiencia',
      'altura_cm': 'Altura (cm)',
      'peso_actual_kg': 'Peso Actual (kg)',
      'peso_objetivo_kg': 'Peso Objetivo (kg)',

      // Géneros
      'masculino': 'Masculino',
      'femenino': 'Femenino',
      'otro': 'Otro',
      'prefiero_no_decir': 'Prefiero no decir',

      // Objetivos Fitness
      'perder_peso': 'Perder Peso',
      'ganar_musculo': 'Ganar Músculo',
      'mantenimiento': 'Mantenimiento',
      'fuerza': 'Fuerza',
      'resistencia': 'Resistencia',
      'tonificar': 'Tonificar',

      // Niveles de Experiencia
      'principiante': 'Principiante',
      'intermedio': 'Intermedio',
      'avanzado': 'Avanzado',

      // Información de Aplicación
      'informacion_aplicacion': 'Información de la Aplicación',
      'version_app': 'Versión de la Aplicación',
      'fecha_instalacion': 'Fecha de Instalación',
      'numero_inicios_sesion': 'Número de Inicios de Sesión',
      'racha_actual': 'Racha Actual',
      'racha_maxima': 'Racha Máxima',
      'total_rutinas_completadas': 'Total de Rutinas Completadas',
      'total_ejercicios_realizados': 'Total de Ejercicios Realizados',
      'tiempo_total_entrenamiento': 'Tiempo Total de Entrenamiento',

      // Unidades
      'kg': 'Kilogramos',
      'lb': 'Libras',
      'cm': 'Centímetros',
      'in': 'Pulgadas',
      'kcal': 'Kilocalorías',
      'kj': 'Kilojulios',

      // Días de la semana
      'lunes': 'Lunes',
      'domingo': 'Domingo',

      // Intensidades
      'baja': 'Baja',
      'media': 'Media',
      'alta': 'Alta',

      // Acciones
      'guardar': 'Guardar',
      'cancelar': 'Cancelar',
      'editar': 'Editar',
      'eliminar': 'Eliminar',
      'aceptar': 'Aceptar',
      'aplicar': 'Aplicar',
      'resetear': 'Resetear',

      // Mensajes
      'configuracion_guardada': 'Configuración guardada exitosamente',
      'perfil_actualizado': 'Perfil actualizado exitosamente',
      'error_guardar_configuracion': 'Error al guardar la configuración',
      'error_actualizar_perfil': 'Error al actualizar el perfil',
      'campos_requeridos': 'Todos los campos marcados son requeridos',
      'formato_invalido': 'Formato inválido',
    },
    'en': {
      // General Configuration
      'configuracion': 'Settings',
      'unidades_medida': 'Units of Measurement',
      'unidad_peso': 'Weight Unit',
      'unidad_longitud': 'Length Unit',
      'formato_hora': 'Time Format',
      'formato_fecha': 'Date Format',
      'dia_inicio_semana': 'Week Start Day',
      'unidad_calorias': 'Calorie Unit',

      // Training
      'configuracion_entrenamiento': 'Training Settings',
      'tiempo_descanso_defecto': 'Default Rest Time',
      'sonidos_habilitados': 'Sounds Enabled',
      'vibracion_habilitada': 'Vibration Enabled',
      'volumen_sonidos': 'Sound Volume',
      'intensidad_vibracion': 'Vibration Intensity',
      'auto_siguiente_ejercicio': 'Automatically Advance to Next Exercise',

      // Notifications
      'notificaciones': 'Notifications',
      'notificaciones_habilitadas': 'Notifications Enabled',
      'recordatorio_entrenar': 'Training Reminder',
      'recordatorio_racha': 'Streak Reminder',
      'recordatorio_descanso': 'Rest Reminder',
      'hora_recordatorio_manana': 'Morning Reminder Time',
      'hora_recordatorio_tarde': 'Evening Reminder Time',

      // Personalization
      'personalizacion': 'Personalization',
      'modo_oscuro': 'Dark Mode',
      'idioma': 'Language',

      // Profile
      'perfil_usuario': 'User Profile',
      'nombre_usuario': 'Username',
      'correo': 'Email',
      'nombre_completo': 'Full Name',
      'foto_perfil': 'Profile Picture',
      'fecha_nacimiento': 'Birth Date',
      'genero': 'Gender',
      'objetivo_fitness': 'Fitness Goal',
      'nivel_experiencia': 'Experience Level',
      'altura_cm': 'Height (cm)',
      'peso_actual_kg': 'Current Weight (kg)',
      'peso_objetivo_kg': 'Target Weight (kg)',

      // Genders
      'masculino': 'Male',
      'femenino': 'Female',
      'otro': 'Other',
      'prefiero_no_decir': 'Prefer not to say',

      // Fitness Goals
      'perder_peso': 'Lose Weight',
      'ganar_musculo': 'Gain Muscle',
      'mantenimiento': 'Maintenance',
      'fuerza': 'Strength',
      'resistencia': 'Endurance',
      'tonificar': 'Tone',

      // Experience Levels
      'principiante': 'Beginner',
      'intermedio': 'Intermediate',
      'avanzado': 'Advanced',

      // App Information
      'informacion_aplicacion': 'App Information',
      'version_app': 'App Version',
      'fecha_instalacion': 'Installation Date',
      'numero_inicios_sesion': 'Number of Sessions',
      'racha_actual': 'Current Streak',
      'racha_maxima': 'Best Streak',
      'total_rutinas_completadas': 'Total Routines Completed',
      'total_ejercicios_realizados': 'Total Exercises Performed',
      'tiempo_total_entrenamiento': 'Total Training Time',

      // Units
      'kg': 'Kilograms',
      'lb': 'Pounds',
      'cm': 'Centimeters',
      'in': 'Inches',
      'kcal': 'Kilocalories',
      'kj': 'Kilojoules',

      // Week days
      'lunes': 'Monday',
      'domingo': 'Sunday',

      // Intensities
      'baja': 'Low',
      'media': 'Medium',
      'alta': 'High',

      // Actions
      'guardar': 'Save',
      'cancelar': 'Cancel',
      'editar': 'Edit',
      'eliminar': 'Delete',
      'aceptar': 'Accept',
      'aplicar': 'Apply',
      'resetear': 'Reset',

      // Messages
      'configuracion_guardada': 'Settings saved successfully',
      'perfil_actualizado': 'Profile updated successfully',
      'error_guardar_configuracion': 'Error saving settings',
      'error_actualizar_perfil': 'Error updating profile',
      'campos_requeridos': 'All marked fields are required',
      'formato_invalido': 'Invalid format',
    },
  };

  @override
  Future<void> cambiarIdioma(String nuevoIdioma) async {
    if (!idiomasDisponibles.contains(nuevoIdioma)) {
      return;
    }

    _idiomActual = nuevoIdioma;

    // TODO: Notificar a la aplicación del cambio de idioma
    // Esto puede requerir rebuild de widgets que usen traducciones
  }

  @override
  String traducir(String clave, {Map<String, String>? parametros}) {
    final traducciones =
        _traducciones[_idiomActual] ?? _traducciones[_idiomaDefault]!;
    String traduccion = traducciones[clave] ?? clave;

    // Reemplazar parámetros si se proporcionan
    if (parametros != null) {
      parametros.forEach((parametro, valor) {
        traduccion = traduccion.replaceAll('{$parametro}', valor);
      });
    }

    return traduccion;
  }

  /// Métodos helper para obtener traducciones específicas del dominio fitness
  String obtenerEtiquetaObjetivoFitness(String objetivo) {
    return traducir(objetivo);
  }

  String obtenerEtiquetaNivelExperiencia(String nivel) {
    return traducir(nivel);
  }

  String obtenerEtiquetaGenero(String genero) {
    return traducir(genero);
  }

  String obtenerEtiquetaUnidad(String unidad) {
    return traducir(unidad);
  }

  String obtenerMensajeError(String tipoError) {
    return traducir('error_$tipoError');
  }

  String obtenerMensajeExito(String tipoExito) {
    return traducir('${tipoExito}_guardada');
  }
}
