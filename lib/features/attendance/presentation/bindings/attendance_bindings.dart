import 'package:get/get.dart';
import 'package:sagr/features/attendance/data/datasource/attendance_data_source.dart';
import 'package:sagr/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:sagr/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:sagr/features/attendance/domain/usecases/get_attendance_report.dart';
import 'package:sagr/features/attendance/domain/usecases/get_current_user_attendance.dart';
import 'package:sagr/features/attendance/presentation/controllers/attendance_controller.dart';

/// Dependency injection bindings for the Attendance module
/// Uses GetX for state management and dependency injection
class AttendanceBindings implements Bindings {
  @override
  void dependencies() {

    // Controller 
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(getCurrentUserAttendanceUseCase: Get.find(), getAttendanceReportUseCase: Get.find()),
    );


    // Data Source
    Get.lazyPut<AttendanceDataSource>(
      () => AttendanceDataSourceImpl(dio: Get.find()),
    );

    // Repository
    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepositoryImpl(
        dataSource: Get.find<AttendanceDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut(
      () => GetAttendanceReportUseCase(
        Get.find<AttendanceRepository>(),
      ),
    );

    Get.lazyPut(
      () => GetCurrentUserAttendanceUseCase(
        Get.find<AttendanceRepository>(),
      ),
    );

    // Controller
    Get.lazyPut(
      () => AttendanceController(
        getCurrentUserAttendanceUseCase: Get.find<GetCurrentUserAttendanceUseCase>(),
        getAttendanceReportUseCase: Get.find<GetAttendanceReportUseCase>(),
      ),
    );
  }
}

/// Bindings for permanent services (use sparingly)
class AttendancePermanentBindings implements Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.put<AttendanceDataSource>(
      AttendanceDataSourceImpl(dio: Get.find()),
      permanent: true,
    );

    // Repository
    Get.put<AttendanceRepository>(
      AttendanceRepositoryImpl(
        dataSource: Get.find<AttendanceDataSource>(),
      ),
      permanent: true,
    );

    // Use Cases
    Get.put(
      GetAttendanceReportUseCase(
        Get.find<AttendanceRepository>(),
      ),
      permanent: true,
    );

    Get.put(
      GetCurrentUserAttendanceUseCase(
        Get.find<AttendanceRepository>(),
      ),
      permanent: true,
    );
  }
}