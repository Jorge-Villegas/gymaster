import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<T> runWithTimeout<T>(Future<T> Function() function) async {
  final timeoutDuration = Duration(
    milliseconds: int.parse(
      dotenv.env['MAX_LOAD_TIME'] ?? '1000',
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
