import 'package:dartz/dartz.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/attendance/data/datasource/attendance_data_source.dart';
import 'package:sagr/features/attendance/data/models/attendance_model.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';
import 'package:sagr/features/attendance/domain/repositories/attendance_repository.dart';

/// Implementation of AttendanceRepository
/// Handles data operations and error mapping from exceptions to failures
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDataSource dataSource;

  AttendanceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Attendance>> getAttendanceReport({
    required int userId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final result = await dataSource.getAttendanceReport(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        message: 'Server error occurred. Please try again later.',
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
      ));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(
        message: e.message,
      ));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(
        message: e.data['message']?.toString() ?? 'Attendance data not found',
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        errors: _extractValidationErrors(e.data),
      ));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(
        message: 'Failed to process attendance data: ${e.message}',
      ));
    } on ServerExceptionFailure catch (e) {
      return Left(ServerFailure(
        message: e.data['message']?.toString() ?? 'Server error occurred',
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Attendance>> getCurrentUserAttendanceReport({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final result = await dataSource.getCurrentUserAttendanceReport(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        message: 'Server error occurred. Please try again later.',
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
      ));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(
        message: e.message,
      ));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(
        message: e.data['message']?.toString() ?? 'Attendance data not found',
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        errors: _extractValidationErrors(e.data),
      ));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(
        message: 'Failed to process attendance data: ${e.message}',
      ));
    } on ServerExceptionFailure catch (e) {
      return Left(ServerFailure(
        message: e.data['message']?.toString() ?? 'Server error occurred',
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getMultipleUsersAttendance({
    required List<int> userIds,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final result = await dataSource.getMultipleUsersAttendance(
        userIds: userIds,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        message: 'Server error occurred. Please try again later.',
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
      ));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(
        message: e.message,
      ));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(
        message: e.data['message']?.toString() ?? 'Attendance data not found',
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        errors: _extractValidationErrors(e.data),
      ));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(
        message: 'Failed to process attendance data: ${e.message}',
      ));
    } on ServerExceptionFailure catch (e) {
      return Left(ServerFailure(
        message: e.data['message']?.toString() ?? 'Server error occurred',
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Extracts validation errors from exception data
  Map<String, List<String>> _extractValidationErrors(dynamic data) {
    final errors = <String, List<String>>{};
    
    if (data == null) return errors;
    
    try {
      if (data is Map<String, dynamic>) {
        // Check for 'errors' key (Laravel validation format)
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map<String, dynamic>;
          errorsMap.forEach((key, value) {
            if (value is List) {
              errors[key] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              errors[key] = [value];
            } else {
              errors[key] = [value.toString()];
            }
          });
        }
        // Check for direct field errors
        else {
          data.forEach((key, value) {
            if (value is List) {
              errors[key] = value.map((e) => e.toString()).toList();
            } else if (value is String && key != 'message') {
              errors[key] = [value];
            }
          });
        }
      }
    } catch (e) {
      print('Error extracting validation errors: $e');
    }
    
    return errors;
  }
}