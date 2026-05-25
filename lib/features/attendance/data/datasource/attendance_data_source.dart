import 'package:dio/dio.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/attendance/data/models/attendance_model.dart';
import 'package:sagr/helper/base_url.dart';

/// Abstract data source interface for attendance operations
abstract class AttendanceDataSource {
  /// Fetches attendance report for a specific user
  Future<AttendanceModel> getAttendanceReport({
    required int userId,
    String? startDate,
    String? endDate,
  });

  /// Fetches attendance report for the current authenticated user
  Future<AttendanceModel> getCurrentUserAttendanceReport({
    String? startDate,
    String? endDate,
  });

  /// Fetches attendance for multiple users
  Future<List<AttendanceModel>> getMultipleUsersAttendance({
    required List<int> userIds,
    String? startDate,
    String? endDate,
  });
}

/// Implementation of AttendanceDataSource using Dio for HTTP requests
class AttendanceDataSourceImpl implements AttendanceDataSource {
  final Dio dio;

  AttendanceDataSourceImpl({required this.dio});

  @override
  Future<AttendanceModel> getAttendanceReport({
    required int userId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await dio.get(
        '$BASEURL/attendance/report',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<AttendanceModel> getCurrentUserAttendanceReport({
    String? startDate,
    String? endDate,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await dio.get(
        '$BASEURL/attendance/reports/my-report',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<AttendanceModel>> getMultipleUsersAttendance({
    required List<int> userIds,
    String? startDate,
    String? endDate,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'user_ids': userIds.join(','),
      };
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await dio.get(
        '$BASEURL/attendance/report',
        queryParameters: queryParams,
      );

      return _handleMultipleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Handles successful response and parses data
  AttendanceModel _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = response.data;
        
        // Handle different response structures
        final attendanceData = data is Map<String, dynamic>
            ? (data.containsKey('data') ? data['data'] : data)
            : throw DataParsingException('Invalid response structure');

        if (attendanceData == null) {
          throw DataParsingException('Response data is null');
        }

        return AttendanceModel.fromJson(
          attendanceData as Map<String, dynamic>,
        );
      } catch (e) {
        if (e is DataParsingException) rethrow;
        throw DataParsingException('Failed to parse attendance data: ${e.toString()}');
      }
    } else if (response.statusCode == 404) {
      throw NotFoundException({
        'message': 'Attendance data not found',
        'status_code': 404,
      });
    } else if (response.statusCode! >= 500) {
      throw ServerException();
    } else {
      throw ServerExceptionFailure({
        'message': 'Unexpected status code: ${response.statusCode}',
        'status_code': response.statusCode,
        'data': response.data,
      });
    }
  }

  /// Handles successful response with multiple attendance records
  List<AttendanceModel> _handleMultipleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = response.data;
        
        // Handle different response structures
        final attendanceList = data is Map<String, dynamic>
            ? (data.containsKey('data') ? data['data'] : data)
            : data;

        if (attendanceList == null) {
          throw DataParsingException('Response data is null');
        }

        if (attendanceList is! List) {
          throw DataParsingException('Expected list of attendance data');
        }

        return attendanceList
            .map((item) {
              try {
                return AttendanceModel.fromJson(item as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing attendance item: $e');
                return null;
              }
            })
            .where((item) => item != null)
            .cast<AttendanceModel>()
            .toList();
      } catch (e) {
        if (e is DataParsingException) rethrow;
        throw DataParsingException('Failed to parse attendance list: ${e.toString()}');
      }
    } else if (response.statusCode == 404) {
      throw NotFoundException({
        'message': 'Attendance data not found',
        'status_code': 404,
      });
    } else if (response.statusCode! >= 500) {
      throw ServerException();
    } else {
      throw ServerExceptionFailure({
        'message': 'Unexpected status code: ${response.statusCode}',
        'status_code': response.statusCode,
        'data': response.data,
      });
    }
  }

  /// Handles Dio errors and converts them to custom exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
        
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
        
      case DioExceptionType.badCertificate:
        return NetworkException('Invalid SSL certificate');
        
      case DioExceptionType.unknown:
        return NetworkException('Unknown network error: ${error.message}');
        
      default:
        return UnknownException('Unexpected error: ${error.message}');
    }
  }

  /// Handles bad response errors (4xx, 5xx status codes)
  Exception _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(
          data,
          message: _extractErrorMessage(data) ?? 'Invalid request',
          statusCode: 400,
        );
        
      case 401:
        return UnauthorizedException(
          _extractErrorMessage(data) ?? 'Unauthorized. Please login again.',
        );
        
      case 403:
        return UnauthorizedException(
          _extractErrorMessage(data) ?? 'Access denied',
        );
        
      case 404:
        return NotFoundException({
          'message': _extractErrorMessage(data) ?? 'Resource not found',
          'status_code': 404,
          'data': data,
        });
        
      case 422:
        return ValidationException(
          data,
          message: _extractErrorMessage(data) ?? 'Validation failed',
          statusCode: 422,
        );
        
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException();
        
      default:
        return ServerExceptionFailure({
          'message': _extractErrorMessage(data) ?? 'Server error occurred',
          'status_code': statusCode,
          'data': data,
        });
    }
  }

  /// Extracts error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      // Try common error message keys
      if (data.containsKey('message')) return data['message']?.toString();
      if (data.containsKey('error')) return data['error']?.toString();
      if (data.containsKey('msg')) return data['msg']?.toString();
      if (data.containsKey('detail')) return data['detail']?.toString();
      
      // Try to get validation errors
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first?.toString();
          }
          return firstError?.toString();
        }
      }
    }
    
    if (data is String) return data;
    
    return null;
  }
}