import 'package:sagr/features/attendance/domain/entities/attendance.dart';

/// Model for Attendance data with JSON serialization
class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.userId,
    required super.userName,
    required super.dailyReports,
    required super.eventTotals,
    required super.grandTotalHours,
    required super.grandTotalMinutes,
    required super.grandTotalFormatted,
  });

  /// Creates an AttendanceModel from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    try {
      return AttendanceModel(
        userId: _parseInt(json['user_id']),
        userName: _parseString(json['user_name']),
        dailyReports: _parseDailyReports(json['daily_reports']),
        eventTotals: _parseEventTotals(json['event_totals']),
        grandTotalHours: _parseInt(json['grand_total_hours']),
        grandTotalMinutes: _parseInt(json['grand_total_minutes']),
        grandTotalFormatted: _parseString(json['grand_total_formatted']),
      );
    } catch (e, stackTrace) {
      throw FormatException(
        'Failed to parse AttendanceModel: $e',
        json,
        stackTrace.toString().length,
      );
    }
  }

  /// Converts the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'daily_reports': (dailyReports as List<DailyReportModel>)
          .map((e) => e.toJson())
          .toList(),
      'event_totals': (eventTotals as List<EventTotalModel>)
          .map((e) => e.toJson())
          .toList(),
      'grand_total_hours': grandTotalHours,
      'grand_total_minutes': grandTotalMinutes,
      'grand_total_formatted': grandTotalFormatted,
    };
  }

  /// Helper method to parse integer safely
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  /// Helper method to parse string safely
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Helper method to parse daily reports list
  static List<DailyReportModel> _parseDailyReports(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];
    
    return value
        .map((e) {
          try {
            return DailyReportModel.fromJson(e as Map<String, dynamic>);
          } catch (error) {
            print('Error parsing daily report: $error');
            return null;
          }
        })
        .where((e) => e != null)
        .cast<DailyReportModel>()
        .toList();
  }

  /// Helper method to parse event totals list
  static List<EventTotalModel> _parseEventTotals(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];
    
    return value
        .map((e) {
          try {
            return EventTotalModel.fromJson(e as Map<String, dynamic>);
          } catch (error) {
            print('Error parsing event total: $error');
            return null;
          }
        })
        .where((e) => e != null)
        .cast<EventTotalModel>()
        .toList();
  }

  @override
  String toString() {
    return 'AttendanceModel(userId: $userId, userName: $userName, totalHours: $grandTotalHours, totalMinutes: $grandTotalMinutes)';
  }
}

/// Model for DailyReport with JSON serialization
class DailyReportModel extends DailyReport {
  const DailyReportModel({
    required super.date,
    required super.eventId,
    required super.eventName,
    required super.zoneName,
    required super.totalHours,
    required super.totalMinutes,
    required super.formattedDuration,
    required super.attendanceTime,
    required super.departureTime,
    required super.sessions,
    required super.recordsCount,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    try {
      return DailyReportModel(
        date: json['date']?.toString() ?? '',
        eventId: json['event_id']?.toString() ?? '',
        eventName: json['event_name']?.toString() ?? '',
        zoneName: json['zone_name']?.toString() ?? '',
        totalHours: _parseInt(json['total_hours']),
        totalMinutes: _parseDouble(json['total_minutes']),
        formattedDuration: json['formatted_duration']?.toString() ?? '',
        attendanceTime: json['attendance_time']?.toString() ?? '',
        departureTime: json['departure_time']?.toString() ?? '',
        sessions: _parseSessions(json['sessions']),
        recordsCount: _parseInt(json['records_count']),
      );
    } catch (e, stackTrace) {
      throw FormatException(
        'Failed to parse DailyReportModel: $e',
        json,
        stackTrace.toString().length,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'event_id': eventId,
      'event_name': eventName,
      'zone_name': zoneName,
      'total_hours': totalHours,
      'total_minutes': totalMinutes,
      'formatted_duration': formattedDuration,
      'attendance_time': attendanceTime,
      'departure_time': departureTime,
      'sessions': (sessions as List<SessionModel>)
          .map((e) => e.toJson())
          .toList(),
      'records_count': recordsCount,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static List<SessionModel> _parseSessions(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];
    
    return value
        .map((e) {
          try {
            return SessionModel.fromJson(e as Map<String, dynamic>);
          } catch (error) {
            print('Error parsing session: $error');
            return null;
          }
        })
        .where((e) => e != null)
        .cast<SessionModel>()
        .toList();
  }
}

/// Model for Session with JSON serialization
class SessionModel extends Session {
  const SessionModel({
    required super.attendance,
    required super.departure,
    required super.durationMinutes,
    required super.durationFormatted,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    try {
      return SessionModel(
        attendance: json['attendance']?.toString() ?? '',
        departure: json['departure']?.toString() ?? '',
        durationMinutes: _parseDouble(json['duration_minutes']),
        durationFormatted: json['duration_formatted']?.toString() ?? '',
      );
    } catch (e, stackTrace) {
      throw FormatException(
        'Failed to parse SessionModel: $e',
        json,
        stackTrace.toString().length,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance': attendance,
      'departure': departure,
      'duration_minutes': durationMinutes,
      'duration_formatted': durationFormatted,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

/// Model for EventTotal with JSON serialization
class EventTotalModel extends EventTotal {
  const EventTotalModel({
    required super.eventId,
    required super.eventName,
    required super.totalMinutes,
    required super.daysCount,
    required super.totalHours,
    required super.remainingMinutes,
    required super.formattedDuration,
  });

  factory EventTotalModel.fromJson(Map<String, dynamic> json) {
    try {
      return EventTotalModel(
        eventId: json['event_id']?.toString() ?? '',
        eventName: json['event_name']?.toString() ?? '',
        totalMinutes: _parseDouble(json['total_minutes']),
        daysCount: _parseInt(json['days_count']),
        totalHours: _parseInt(json['total_hours']),
        remainingMinutes: _parseInt(json['remaining_minutes']),
        formattedDuration: json['formatted_duration']?.toString() ?? '',
      );
    } catch (e, stackTrace) {
      throw FormatException(
        'Failed to parse EventTotalModel: $e',
        json,
        stackTrace.toString().length,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'event_name': eventName,
      'total_minutes': totalMinutes,
      'days_count': daysCount,
      'total_hours': totalHours,
      'remaining_minutes': remainingMinutes,
      'formatted_duration': formattedDuration,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}