
class ServerException implements Exception {}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class ValidationException implements Exception {
  final dynamic data;
  final String message;
  final int? statusCode;
  final DateTime timestamp;

  ValidationException(
    this.data, {
    this.message = 'Validation Error',
    this.statusCode,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'ValidationException: $message';
  }

  // Method to get formatted debug information
  String getFormattedDebugInfo() {
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════╗');
    buffer.writeln('║         VALIDATION EXCEPTION        ║');
    buffer.writeln('╠══════════════════════════════════════╣');
    buffer.writeln('║ Message: $message');
    if (statusCode != null) {
      buffer.writeln('║ Status Code: $statusCode');
    }
    buffer.writeln('║ Timestamp: ${timestamp.toIso8601String()}');
    buffer.writeln('║ Data Type: ${data.runtimeType}');
    buffer.writeln('╠══════════════════════════════════════╣');
    buffer.writeln('║ Response Data:');
    buffer.writeln('║ ${_formatData(data)}');
    buffer.writeln('╚══════════════════════════════════════╝');
    return buffer.toString();
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';
    
    try {
      if (data is Map) {
        final formatted = StringBuffer();
        data.forEach((key, value) {
          formatted.writeln('║   $key: $value');
        });
        return formatted.toString().trimRight();
      } else if (data is List) {
        final formatted = StringBuffer();
        for (int i = 0; i < data.length; i++) {
          formatted.writeln('║   [$i]: ${data[i]}');
        }
        return formatted.toString().trimRight();
      } else {
        return data.toString();
      }
    } catch (e) {
      return 'Error formatting data: ${data.toString()}';
    }
  }
}


class ServerExceptionFailure implements Exception {

  final Map<String, dynamic> data;
  ServerExceptionFailure(this.data);

}

class NotFoundException implements Exception {


  final Map<String, dynamic> data;
  NotFoundException(this.data);

}


class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message ${statusCode != null ? '(Status code: $statusCode)' : ''}';
}

// For server-side errors (5xx)
// class ServerException extends ApiException {
//   ServerException([String message = 'Server error']) : super(message, 500);
// }

// For unauthorized access (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized']) : super(message, 401);
}

// For not found resources (404)
// class NotFoundException extends ApiException {
//   NotFoundException([String message = 'Resource not found']) : super(message, 404);
// }

// For network-related issues
class NetworkException extends ApiException {
  NetworkException([String message = 'Network error']) : super(message);
}

// For data parsing issues
class DataParsingException extends ApiException {
  DataParsingException([String message = 'Failed to parse data']) : super(message);
}

// For unexpected errors
class UnknownException extends ApiException {
  UnknownException([String message = 'Unknown error']) : super(message);
}




