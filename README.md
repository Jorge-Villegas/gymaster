# gymaster

A new Flutter project.

## Convención de Nombres de Ramas

Para mantener un desarrollo organizado y estructurado en este proyecto, se sugiere seguir la siguiente convención al nombrar las ramas:

- `feature/`: Utiliza este prefijo para nuevas características que estés desarrollando. Ejemplo: `feature/nueva-funcionalidad`.

- `bugfix/`: Utiliza este prefijo para corrección de errores. Ejemplo: `bugfix/arreglo-error`.

- `hotfix/`: Para solucionar problemas críticos en producción. Ejemplo: `hotfix/fix-importante`.

- `release/`: Utiliza para preparar una versión específica para su lanzamiento. Ejemplo: `release/v1.0`.

- `chore/` o `refactor/`: Para tareas de mantenimiento o refactorización del código. Ejemplo: `chore/actualizar-dependencias`.

- `docs/`: Para tareas relacionadas con la documentación. Ejemplo: `docs/actualizar-manual-de-usuario`.

- `test/`: Utiliza para tareas relacionadas con pruebas. Ejemplo: `test/agregar-pruebas-unitarias`.

- `fix/`: Utilizado en caso de correcciones en general. Ejemplo: `fix/mejora-en-el-procesamiento`.

Por favor, sigue esta convención al nombrar tus ramas para mantener un desarrollo organizado y facilitar la colaboración en el proyecto.


## Generador de recursos 

Este proyecto utiliza dos generadores de código importantes: `build_runner` para `isar` y `flutter_gen` para la gestión de recursos.

Ejecute el siguiente comando para poder generar los archivos necesarios para la aplicación.

```bash
flutter pub run build_runner build
```

### Generación de base de datos con Isar

Isar es una base de datos NoSQL orientada a objetos para Flutter. Utilizamos `build_runner` para generar el código de la base de datos. Ejecute el siguiente comando cada vez que modifique su modelo de datos:


### Generación de recursos con Flutter Gen

Flutter Gen se utiliza para manejar recursos de la aplicación como imágenes, fuentes, colores, etc. Genera un archivo Dart que contiene referencias a todos estos recursos, lo que permite un acceso más fácil y seguro a los mismos.


### Probable direccion de donde se guarda la base de datos

C:\Users\Jorge Villegas\AppData\Local\Google\AndroidStudio2024.2\device-explorer\Pixel 9 Pro API VanillaIceCream\_\data\data\com.example.gymaster\databases

C:\Users\Jorge Villegas\Desktop\gymaster\dart_tool\sqflite_common_ffi\databases\gymaster.db