import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({super.key});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  final CountDownController controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    //final sp = Provider.of<SerieProvider>(context);
    const int duracion = 30; //sp.serie.tiempoDescanso;
    return Scaffold(
      appBar: AppBar(
        title: const Text("temporizador"),
      ),
      body: Center(
        child: CircularCountDownTimer(
          // Duración de la cuenta regresiva en segundos.
          duration: duracion,

          // Duración inicial de cuenta regresiva transcurrida en segundos.
          initialDuration: 0,

          // Controla (i.e Start, Pause, Resume, Restart) el temporizador de cuenta regresiva.
          controller: controller,

          // Ancho del widget de cuenta regresiva.
          width: MediaQuery.of(context).size.width / 2,

          // Altura del widget de cuenta regresiva.
          height: MediaQuery.of(context).size.height / 2,

          // Color del anillo para el widget de cuenta regresiva.
          ringColor: Colors.grey[300]!,

          // Gradiente de anillo para el widget de cuenta regresiva.
          ringGradient: null,

          // Color de relleno para el widget de cuenta regresiva.
          fillColor: Colors.purpleAccent[100]!,

          // Gradiente de relleno para el widget de cuenta regresiva.
          fillGradient: null,

          // Color de fondo para el widget de cuenta regresiva.
          backgroundColor: Colors.purple[500],

          // Gradiente de fondo para el widget de cuenta regresiva.
          backgroundGradient: null,

          // Grosor del borde del anillo de cuenta atrás.
          strokeWidth: 20.0,

          // Comience y finalice los contornos con un borde plano y sin extensión.
          strokeCap: StrokeCap.round,

          // Estilo de texto para texto de cuenta regresiva.
          textStyle: const TextStyle(
            fontSize: 50.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          // Formato para el Texto de Cuenta Regresiva.
          textFormat: CountdownTextFormat.S,

          // Maneja el temporizador de cuenta regresiva (verdadero para cuenta regresiva inversa (máx. a 0), falso para cuenta regresiva hacia adelante (0 a máx.)).
          isReverse: true,

          // Maneja la dirección de la animación (verdadero para la animación inversa, falso para la animación directa).
          isReverseAnimation: true,

          // Maneja la visibilidad del texto de cuenta regresiva.
          isTimerTextShown: true,

          // Maneja el inicio del temporizador.
          autoStart: true, //para que inicie acutomaticamente

          // Esta devolución de llamada se ejecutará cuando comience la cuenta regresiva.
          onStart: () {
            // Aquí, haz lo que quieras
            debugPrint('Cuenta regresiva iniciada');
          },

          // Esta devolución de llamada se ejecutará cuando finalice la cuenta regresiva.
          onComplete: () {
            // Aquí, haz lo que quieras
            debugPrint('Cuenta atrás terminada');

            //regresar a la pantalla anterior
            context.pop();
          },

          // Esta devolución de llamada se ejecutará cuando cambie la cuenta regresiva.
          onChange: (String timeStamp) {
            // Aquí, haz lo que quieras
            debugPrint('Cuenta regresiva cambiada $timeStamp');
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          _button(
            title: "Reiniciar",
            onPressed: () => controller.start(),
          ),
          const SizedBox(
            width: 5,
          ),
          _button(
            title: "Pausa",
            onPressed: () => controller.pause(),
          ),
          const SizedBox(
            width: 5,
          ),
          _button(
            title: "Iniciar",
            onPressed: () => controller.resume(),
          ),
          const SizedBox(
            width: 5,
          ),
          _button(
            title: "Avanzar",
            onPressed: () => GoRouter.of(context).go('/'),
          ),
        ],
      ),
    );
  }
}

Widget _button({required String title, VoidCallback? onPressed}) {
  return Expanded(
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.purple),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
