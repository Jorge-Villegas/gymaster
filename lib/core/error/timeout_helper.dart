import 'dart:async';

Future<T> runWithTimeout<T>(Future<T> Function() function) async {
  final timeoutDuration = Duration(
    milliseconds: int.parse(
      '5000000',
    ),
  );

  return function().timeout(
    timeoutDuration,
    onTimeout: () {
      throw TimeoutException(
        'Se agotó el tiempo de solicitud después de ${timeoutDuration.inMilliseconds}ms',
      );
    },
  );
}
