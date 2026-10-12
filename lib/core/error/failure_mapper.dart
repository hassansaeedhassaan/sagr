import 'package:dio/dio.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';

/// Turns anything a data source can throw into a [Failure], so a timeout or
/// a dropped connection reaches the controller as a Left (and its loading
/// flag gets cleared) instead of escaping as an uncaught DioException.
Failure failureFromException(Object error) {
  if (error is ValidationException) {
    return ValidationFailure(message: error.message);
  }
  if (error is ServerException) return const ServerFailure();
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        final message = serverMessage(error.response?.data);
        if (status == 401) return const UnauthorizedFailure();
        if (status == 403) {
          return PermissionDeniedFailure(message: message ?? 'Permission denied.');
        }
        if (status == 404) return NotFoundFailure(message: message ?? 'Resource not found.');
        if (status == 400 || status == 409 || status == 422) {
          return ValidationFailure(
            message: message ?? 'Validation failed.',
            errors: fieldErrors(error.response?.data),
          );
        }
        if (status == 429) return const RateLimitFailure();
        return const ServerFailure();
      default:
        return const NetworkFailure();
    }
  }
  if (error is TypeError || error is FormatException) {
    return const DataParsingFailure();
  }
  return const UnknownFailure();
}

/// The human-readable reason in a Laravel error body, if there is one:
/// the first validation error, else `message`.
String? serverMessage(dynamic data) {
  if (data is! Map) return null;
  final errors = data['errors'];
  if (errors is Map && errors.isNotEmpty) {
    final first = errors.values.first;
    if (first is List && first.isNotEmpty) return '${first.first}';
    if (first is String) return first;
  }
  final message = data['message'] ?? data['error'];
  if (message is String && message.isNotEmpty) return message;
  return null;
}

/// Laravel's `errors` bag as field -> messages.
Map<String, List<String>> fieldErrors(dynamic data) {
  if (data is! Map || data['errors'] is! Map) return const {};
  final result = <String, List<String>>{};
  (data['errors'] as Map).forEach((key, value) {
    if (value is List) {
      result['$key'] = value.map((e) => '$e').toList();
    } else if (value != null) {
      result['$key'] = ['$value'];
    }
  });
  return result;
}
