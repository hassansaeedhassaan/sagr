import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/attendance/presentation/controllers/attendance_controller.dart';

import '../../../attendance/domain/entities/attendance.dart';

class AttendanceReportPage extends StatelessWidget {
  AttendanceReportPage({Key? key}) : super(key: key);


  AttendanceController _attendanceController = Get.put(AttendanceController(
      getCurrentUserAttendanceUseCase: Get.find(),
      getAttendanceReportUseCase: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'تقرير الحضور',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share, color: Color(0xFF4299E1)),
        //     onPressed: () {
        //       // Share functionality
        //     },
        //   ),
        // ],
      ),
      body: Obx( () => SingleChildScrollView(
        child: _attendanceController.isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: [
            _buildUserHeader(),
            _buildGrandTotalCard(),
            _buildEventSummarySection(),
            _buildDailyReportsSection(),
            const SizedBox(height: 24),
          ],
        ),
      )),
    );
  }

  Widget _buildUserHeader() {
    return GetBuilder<AttendanceController>(
        init: AttendanceController(
          getCurrentUserAttendanceUseCase: Get.find(),
          getAttendanceReportUseCase: Get.find(),
        ),
        builder: (AttendanceController attendanceController) {
          return attendanceController.isLoading
              ? CircularProgressIndicator()
              : Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [SAGR_PRIMARY, SAGR_PRIMARY],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            attendanceController.attendance!.userName
                                .split(' ')
                                .map((e) => e[0])
                                .take(2)
                                .join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attendanceController.attendance!.userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'رقم الموظف: ${attendanceController.attendance!.userId}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        });
  }

  Widget _buildGrandTotalCard() {
    return Obx( () =>  _attendanceController.isLoading ? Center(child: CircularProgressIndicator(),) : Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
             colors: [SAGR_PRIMARY, SAGR_PRIMARY],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'إجمالي ساعات الحضور',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _attendanceController.attendance!.grandTotalFormatted,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.event_note,
                label: 'عدد الفعاليات',
                value: '${_attendanceController.attendance!.eventTotals.length}',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
              ),
              _buildStatItem(
                icon: Icons.calendar_today,
                label: 'أيام الحضور',
                value: '${_attendanceController.attendance!.dailyReports.length}',
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventSummarySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12, right: 4),
            child: Text(
              'ملخص الفعاليات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          ..._attendanceController.attendance!.eventTotals.map((event) => _buildEventCard(event)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventTotal event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.event,
              color: Color(0xFF4299E1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${event.daysCount} أيام حضور',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event.formattedDuration,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF48BB78),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12, right: 4),
            child: Text(
              'السجل اليومي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          ..._attendanceController.attendance!.dailyReports
              .map((report) => _buildDailyReportCard(report))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDailyReportCard(DailyReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4299E1),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(report.date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          report.eventName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4299E1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    report.formattedDuration,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4299E1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeInfo(
                        icon: Icons.login,
                        label: 'وقت الدخول',
                        time: report.attendanceTime,
                        color: const Color(0xFF48BB78),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeInfo(
                        icon: Icons.logout,
                        label: 'وقت الخروج',
                        time: report.departureTime,
                        color: const Color(0xFFED8936),
                      ),
                    ),
                  ],
                ),
                if (report.sessions.length > 1) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                  ),
                  _buildSessionsList(report.sessions),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF718096),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            report.zoneName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.analytics,
                            size: 16,
                            color: Color(0xFF718096),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${report.recordsCount} سجل',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(List<Session> sessions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'الجلسات',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        ...sessions.asMap().entries.map((entry) {
          int idx = entry.key;
          Session session = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4299E1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${idx + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4299E1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        session.attendance,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.arrow_back,
                          size: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      Text(
                        session.departure,
                        style: TextStyle(
                          fontSize: 13,
                          color: session.departure == 'Still present'
                              ? const Color(0xFF48BB78)
                              : const Color(0xFF2D3748),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.durationFormatted,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4299E1),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('EEEE، d MMMM yyyy', 'ar');
      return formatter.format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}

// Data Models
// class AttendanceData {
//   final int userId;
//   final String userName;
//   final List<DailyReport> dailyReports;
//   final List<EventTotal> eventTotals;
//   final int grandTotalHours;
//   final int grandTotalMinutes;
//   final String grandTotalFormatted;

//   AttendanceData({
//     required this.userId,
//     required this.userName,
//     required this.dailyReports,
//     required this.eventTotals,
//     required this.grandTotalHours,
//     required this.grandTotalMinutes,
//     required this.grandTotalFormatted,
//   });

//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     return AttendanceData(
//       userId: json['user_id'],
//       userName: json['user_name'],
//       dailyReports: (json['daily_reports'] as List)
//           .map((e) => DailyReport.fromJson(e))
//           .toList(),
//       eventTotals: (json['event_totals'] as List)
//           .map((e) => EventTotal.fromJson(e))
//           .toList(),
//       grandTotalHours: json['grand_total_hours'],
//       grandTotalMinutes: json['grand_total_minutes'],
//       grandTotalFormatted: json['grand_total_formatted'],
//     );
//   }
// }

// class DailyReport {
//   final String date;
//   final String eventId;
//   final String eventName;
//   final String zoneName;
//   final int totalHours;
//   final double totalMinutes;
//   final String formattedDuration;
//   final String attendanceTime;
//   final String departureTime;
//   final List<Session> sessions;
//   final int recordsCount;

//   DailyReport({
//     required this.date,
//     required this.eventId,
//     required this.eventName,
//     required this.zoneName,
//     required this.totalHours,
//     required this.totalMinutes,
//     required this.formattedDuration,
//     required this.attendanceTime,
//     required this.departureTime,
//     required this.sessions,
//     required this.recordsCount,
//   });

//   factory DailyReport.fromJson(Map<String, dynamic> json) {
//     return DailyReport(
//       date: json['date'],
//       eventId: json['event_id'],
//       eventName: json['event_name'],
//       zoneName: json['zone_name'],
//       totalHours: json['total_hours'],
//       totalMinutes: json['total_minutes'].toDouble(),
//       formattedDuration: json['formatted_duration'],
//       attendanceTime: json['attendance_time'],
//       departureTime: json['departure_time'],
//       sessions:
//           (json['sessions'] as List).map((e) => Session.fromJson(e)).toList(),
//       recordsCount: json['records_count'],
//     );
//   }
// }

// class Session {
//   final String attendance;
//   final String departure;
//   final double durationMinutes;
//   final String durationFormatted;

//   Session({
//     required this.attendance,
//     required this.departure,
//     required this.durationMinutes,
//     required this.durationFormatted,
//   });

//   factory Session.fromJson(Map<String, dynamic> json) {
//     return Session(
//       attendance: json['attendance'],
//       departure: json['departure'],
//       durationMinutes: json['duration_minutes'].toDouble(),
//       durationFormatted: json['duration_formatted'],
//     );
//   }
// }

// class EventTotal {
//   final String eventId;
//   final String eventName;
//   final double totalMinutes;
//   final int daysCount;
//   final int totalHours;
//   final int remainingMinutes;
//   final String formattedDuration;

//   EventTotal({
//     required this.eventId,
//     required this.eventName,
//     required this.totalMinutes,
//     required this.daysCount,
//     required this.totalHours,
//     required this.remainingMinutes,
//     required this.formattedDuration,
//   });

//   factory EventTotal.fromJson(Map<String, dynamic> json) {
//     return EventTotal(
//       eventId: json['event_id'],
//       eventName: json['event_name'],
//       totalMinutes: json['total_minutes'].toDouble(),
//       daysCount: json['days_count'],
//       totalHours: json['total_hours'],
//       remainingMinutes: json['remaining_minutes'],
//       formattedDuration: json['formatted_duration'],
//     );
//   }
// }

// Example usage:
/*
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Cairo', // Add Arabic font
    ),
    home: AttendanceReportPage(
      data: AttendanceData.fromJson(yourJsonData['data']),
    ),
  ));
}
*/
