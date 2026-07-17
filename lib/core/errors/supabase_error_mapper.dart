import 'dart:io';

import 'package:eventix/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Mapea excepciones del SDK de Supabase a [Failure]. Es el equivalente del
/// mapeo que hace `DioHttpService` para Dio: los datasources de Supabase
/// llaman esto en su único try/catch y dejan burbujear el [Failure] resultante.
Failure mapSupabaseError(Object error) {
  if (error is AuthException) {
    final String message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return const UnauthorizedFailure('Correo o contraseña incorrectos');
    }
    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return const ServerFailure('Ya existe una cuenta con este correo');
    }
    return ServerFailure(error.message);
  }

  if (error is PostgrestException) {
    if (error.code == 'PGRST116') return const NotFoundFailure();
    return ServerFailure(error.message);
  }

  if (error is SocketException) {
    return const ConnectionFailure();
  }

  return UnexpectedFailure(error.toString());
}
