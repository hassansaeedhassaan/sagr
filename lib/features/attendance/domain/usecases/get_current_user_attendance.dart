import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/core/usecase/usecase.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';
import 'package:sagr/features/attendance/domain/repositories/attendance_repository.dart';

/// Use case for retrieving current user's attendance report
/// Used when the user wants to view their own attendance
class GetCurrentUserAttendanceUseCase
    implements UseCase<Attendance, GetCurrentUserAttendanceParams> {
  final AttendanceRepository repository;

  GetCurrentUserAttendanceUseCase(this.repository);

  @override
  Future<Either<Failure, Attendance>> call(
      GetCurrentUserAttendanceParams params) async {
    return await repository.getCurrentUserAttendanceReport(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

/// Parameters for GetCurrentUserAttendanceUseCase
class GetCurrentUserAttendanceParams extends Equatable {
  final String? startDate;
  final String? endDate;

  const GetCurrentUserAttendanceParams({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];

  /// Validates the parameters
  String? validate() {
    if (startDate != null && endDate != null) {
      try {
        final start = DateTime.parse(startDate!);
        final end = DateTime.parse(endDate!);
        
        if (start.isAfter(end)) {
          return 'Start date must be before end date';
        }
        
        if (end.isAfter(DateTime.now())) {
          return 'End date cannot be in the future';
        }

        // Check if date range is not too large (e.g., max 1 year)
        final difference = end.difference(start).inDays;
        if (difference > 365) {
          return 'Date range cannot exceed 365 days';
        }
      } catch (e) {
        return 'Invalid date format. Use YYYY-MM-DD';
      }
    }

    return null;
  }

  /// Creates a copy with modified parameters
  GetCurrentUserAttendanceParams copyWith({
    String? startDate,
    String? endDate,
  }) {
    return GetCurrentUserAttendanceParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  /// Helper method to create params for current month
  factory GetCurrentUserAttendanceParams.currentMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    
    return GetCurrentUserAttendanceParams(
      startDate: _formatDate(firstDay),
      endDate: _formatDate(lastDay),
    );
  }

  /// Helper method to create params for last 30 days
  factory GetCurrentUserAttendanceParams.last30Days() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    return GetCurrentUserAttendanceParams(
      startDate: _formatDate(thirtyDaysAgo),
      endDate: _formatDate(now),
    );
  }

  /// Helper method to create params for custom date range
  factory GetCurrentUserAttendanceParams.dateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return GetCurrentUserAttendanceParams(
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}