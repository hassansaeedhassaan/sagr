import 'package:dartz/dartz.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';

/// Repository interface for attendance data operations
/// Follows the Repository pattern from Clean Architecture
abstract class AttendanceRepository {
  /// Retrieves attendance report for a specific user
  /// 
  /// Parameters:
  /// - [userId]: The ID of the user to fetch attendance for
  /// - [startDate]: Optional start date for filtering (format: YYYY-MM-DD)
  /// - [endDate]: Optional end date for filtering (format: YYYY-MM-DD)
  /// 
  /// Returns:
  /// - [Right(Attendance)]: On successful data retrieval
  /// - [Left(Failure)]: On error (ServerFailure, NetworkFailure, ValidationFailure, etc.)
  Future<Either<Failure, Attendance>> getAttendanceReport({
    required int userId,
    String? startDate,
    String? endDate,
  });

  /// Retrieves attendance report for the current authenticated user
  /// 
  /// Parameters:
  /// - [startDate]: Optional start date for filtering (format: YYYY-MM-DD)
  /// - [endDate]: Optional end date for filtering (format: YYYY-MM-DD)
  /// 
  /// Returns:
  /// - [Right(Attendance)]: On successful data retrieval
  /// - [Left(Failure)]: On error
  Future<Either<Failure, Attendance>> getCurrentUserAttendanceReport({
    String? startDate,
    String? endDate,
  });

  /// Retrieves attendance summary for multiple users (admin feature)
  /// 
  /// Parameters:
  /// - [userIds]: List of user IDs to fetch attendance for
  /// - [startDate]: Optional start date for filtering
  /// - [endDate]: Optional end date for filtering
  /// 
  /// Returns:
  /// - [Right(List<Attendance>)]: On successful data retrieval
  /// - [Left(Failure)]: On error
  Future<Either<Failure, List<Attendance>>> getMultipleUsersAttendance({
    required List<int> userIds,
    String? startDate,
    String? endDate,
  });
}