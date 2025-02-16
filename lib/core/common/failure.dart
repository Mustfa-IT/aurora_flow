import 'package:meta/meta.dart';

@immutable
abstract class Failure {
  /// A human-readable error message.
  final String message;
  final String? exceptionMessage;
  const Failure({required this.message, this.exceptionMessage});

  @override
  String toString() => 'Failure(message: $message)';
}

/// Represents a failure coming from the server.
class ServerFailure extends Failure {
  const ServerFailure(
      {super.message = 'Server Failure', super.exceptionMessage});
}

/// Represents a failure coming from the network.
class NetworkFailure extends Failure {
  /// Optional error code that may come from a network response.
  final int? errorCode;

  const NetworkFailure({super.message = 'Network Failure', this.errorCode});

  @override
  String toString() =>
      'NetworkFailure(message: $message, errorCode: $errorCode)';
}

/// Represents a failure related to the database.
class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message = 'Database Failure'});
}

class VailditonFailure extends Failure {
  const VailditonFailure({super.message = 'Invaild Data Input'});
}
