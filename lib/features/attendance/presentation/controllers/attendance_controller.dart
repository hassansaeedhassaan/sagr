import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';
import 'package:sagr/features/attendance/domain/usecases/get_attendance_report.dart';
import 'package:sagr/features/attendance/domain/usecases/get_current_user_attendance.dart';

/// Controller for managing attendance data and UI state
/// Uses GetX for reactive state management
class AttendanceController extends GetxController {
  final GetCurrentUserAttendanceUseCase getCurrentUserAttendanceUseCase;
  final GetAttendanceReportUseCase getAttendanceReportUseCase;

  AttendanceController({
    required this.getCurrentUserAttendanceUseCase,
    required this.getAttendanceReportUseCase,
  });

  // Observable state variables
  final _isLoading = false.obs;
  final _attendance = Rx<Attendance?>(null);
  final _errorMessage = Rx<String?>(null);
  final _startDate = Rx<DateTime?>(null);
  final _endDate = Rx<DateTime?>(null);

  // Getters for reactive state
  bool get isLoading => _isLoading.value;
  Attendance? get attendance => _attendance.value;
  String? get errorMessage => _errorMessage.value;
  DateTime? get startDate => _startDate.value;
  DateTime? get endDate => _endDate.value;

  // Computed properties
  bool get hasData => _attendance.value != null;
  bool get hasError => _errorMessage.value != null;
  int get totalDays => _attendance.value?.dailyReports.length ?? 0;
  int get totalEvents => _attendance.value?.eventTotals.length ?? 0;

  @override
  void onInit() {
    super.onInit();
    // Load current user's attendance on initialization
    fetchCurrentUserAttendance();
  }

  /// Fetches attendance report for the current user
  Future<void> fetchCurrentUserAttendance({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      // Update date filters if provided
      if (startDate != null) _startDate.value = startDate;
      if (endDate != null) _endDate.value = endDate;

      final params = GetCurrentUserAttendanceParams(
        startDate: _formatDate(_startDate.value),
        endDate: _formatDate(_endDate.value),
      );

      // Validate parameters
      final validationError = params.validate();
      if (validationError != null) {
        _handleError(ValidationFailure(message: validationError));
        return;
      }

      final result = await getCurrentUserAttendanceUseCase(params);

        print("🤝 $result ");
      result.fold(
        (failure) => _handleError(failure),
        (attendanceData) {
          print("🤝 $attendanceData ");
          _attendance.value = attendanceData;
          _errorMessage.value = null;
        },
      );
    } catch (e) {
      _handleError(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    } finally {
      _isLoading.value = false;
    }
  }

  /// Fetches attendance report for a specific user (admin feature)
  Future<void> fetchUserAttendance({
    required int userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      // Update date filters if provided
      if (startDate != null) _startDate.value = startDate;
      if (endDate != null) _endDate.value = endDate;

      final params = GetAttendanceReportParams(
        userId: userId,
        startDate: _formatDate(_startDate.value),
        endDate: _formatDate(_endDate.value),
      );

      // Validate parameters
      final validationError = params.validate();
      if (validationError != null) {
        _handleError(ValidationFailure(message: validationError));
        return;
      }

      final result = await getAttendanceReportUseCase(params);

      result.fold(
        (failure) => _handleError(failure),
        (attendanceData) {
          _attendance.value = attendanceData;
          _errorMessage.value = null;
        },
      );
    } catch (e) {
      _handleError(UnknownFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refreshes the current attendance data
  Future<void> refresh() async {
    await fetchCurrentUserAttendance(
      startDate: _startDate.value,
      endDate: _endDate.value,
    );
  }

  /// Sets the date range filter
  void setDateRange({DateTime? startDate, DateTime? endDate}) {
    _startDate.value = startDate;
    _endDate.value = endDate;
  }

  /// Clears the date range filter
  void clearDateRange() {
    _startDate.value = null;
    _endDate.value = null;
  }

  /// Loads attendance for current month
  Future<void> loadCurrentMonth() async {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    
    await fetchCurrentUserAttendance(
      startDate: firstDay,
      endDate: lastDay,
    );
  }

  /// Loads attendance for last 30 days
  Future<void> loadLast30Days() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    await fetchCurrentUserAttendance(
      startDate: thirtyDaysAgo,
      endDate: now,
    );
  }

  /// Loads attendance for a custom date range
  Future<void> loadCustomRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await fetchCurrentUserAttendance(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Clears all data and error state
  void clearData() {
    _attendance.value = null;
    _errorMessage.value = null;
    _startDate.value = null;
    _endDate.value = null;
  }

  /// Clears only the error message
  void clearError() {
    _errorMessage.value = null;
  }

  /// Handles errors and converts them to user-friendly messages
  void _handleError(Failure failure) {
    _errorMessage.value = _getErrorMessage(failure);
    
    // Show snackbar for certain error types
    if (failure is NetworkFailure || failure is ServerFailure) {
      Get.snackbar(
        'خطأ',
        _errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  /// Converts Failure to user-friendly error message
  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصال الشبكة.';
    } else if (failure is UnauthorizedFailure) {
      return 'غير مصرح. يرجى تسجيل الدخول مرة أخرى.';
    } else if (failure is NotFoundFailure) {
      return 'لم يتم العثور على بيانات الحضور.';
    } else if (failure is ValidationFailure) {
      return failure.firstError ?? failure.message;
    } else if (failure is DataParsingFailure) {
      return 'فشل في معالجة البيانات. يرجى المحاولة مرة أخرى.';
    } else if (failure is TimeoutFailure) {
      return 'انتهى وقت الطلب. يرجى المحاولة مرة أخرى.';
    } else if (failure is UnknownFailure) {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    } else {
      return failure.message;
    }
  }

  /// Helper method to format date to string
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}