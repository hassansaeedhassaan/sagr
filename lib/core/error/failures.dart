// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {}

// class OfflineFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }

// class ServerFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }

// class EmptyCacheFailure extends Failure {
//   @override
//   List<Object?> get props => [];
// }


// class NotFoundFailure extends Failure {

//   final Map<String, dynamic>? data;
//   NotFoundFailure({this.data});

//   @override
//   List<Object?> get props => [data];
// }


import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Follows the Failure pattern from Clean Architecture
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Server-related failures (5xx errors)
class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred. Please try again later.',
  }) : super(message: message);
}

/// Network-related failures (connection issues)
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection. Please check your network.',
  }) : super(message: message);
}

/// Unauthorized access failures (401, 403)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized access. Please login again.',
  }) : super(message: message);
}

/// Resource not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found.',
  }) : super(message: message);
}

/// Validation failures (400, 422)
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    String message = 'Validation failed.',
    this.errors = const {},
  }) : super(message: message);

  @override
  List<Object?> get props => [message, errors];

  /// Gets all error messages as a single list
  List<String> get allErrors {
    return errors.values.expand((e) => e).toList();
  }

  /// Gets the first error message
  String? get firstError {
    if (errors.isEmpty) return null;
    final firstKey = errors.keys.first;
    return errors[firstKey]?.first;
  }

  /// Gets errors for a specific field
  List<String>? getFieldErrors(String field) {
    return errors[field];
  }

  /// Checks if a specific field has errors
  bool hasFieldError(String field) {
    return errors.containsKey(field) && errors[field]!.isNotEmpty;
  }

  @override
  String toString() {
    if (errors.isEmpty) return message;
    return '$message\n${_formatErrors()}';
  }

  String _formatErrors() {
    final buffer = StringBuffer();
    errors.forEach((field, messages) {
      buffer.writeln('  • $field: ${messages.join(", ")}');
    });
    return buffer.toString().trimRight();
  }
}

/// Data parsing failures
class DataParsingFailure extends Failure {
  const DataParsingFailure({
    String message = 'Failed to parse data.',
  }) : super(message: message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred.',
  }) : super(message: message);
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unexpected error occurred.',
  }) : super(message: message);
}

/// Empty data failures (when API returns empty data)
class EmptyDataFailure extends Failure {
  const EmptyDataFailure({
    String message = 'No data available.',
  }) : super(message: message);
}

/// Permission denied failures
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({
    String message = 'Permission denied.',
  }) : super(message: message);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timeout. Please try again.',
  }) : super(message: message);
}

/// Rate limit failures
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    String message = 'Too many requests. Please try again later.',
  }) : super(message: message);
}