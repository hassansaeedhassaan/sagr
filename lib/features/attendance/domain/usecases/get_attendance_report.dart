import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/core/usecase/usecase.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';
import 'package:sagr/features/attendance/domain/repositories/attendance_repository.dart';

/// Use case for retrieving attendance report
/// Follows the Single Responsibility Principle
class GetAttendanceReportUseCase
    implements UseCase<Attendance, GetAttendanceReportParams> {
  final AttendanceRepository repository;

  GetAttendanceReportUseCase(this.repository);

  @override
  Future<Either<Failure, Attendance>> call(
      GetAttendanceReportParams params) async {
    return await repository.getAttendanceReport(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

/// Parameters for GetAttendanceReportUseCase
class GetAttendanceReportParams extends Equatable {
  final int userId;
  final String? startDate;
  final String? endDate;

  const GetAttendanceReportParams({
    required this.userId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate];

  /// Validates the parameters
  String? validate() {
    if (userId <= 0) {
      return 'User ID must be greater than 0';
    }

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
      } catch (e) {
        return 'Invalid date format. Use YYYY-MM-DD';
      }
    }

    return null;
  }

  /// Creates a copy with modified parameters
  GetAttendanceReportParams copyWith({
    int? userId,
    String? startDate,
    String? endDate,
  }) {
    return GetAttendanceReportParams(
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}