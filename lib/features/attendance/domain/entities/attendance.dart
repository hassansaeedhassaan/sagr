import 'package:equatable/equatable.dart';

/// Main attendance data entity containing user information and reports
class Attendance extends Equatable {
  final int userId;
  final String userName;
  final List<DailyReport> dailyReports;
  final List<EventTotal> eventTotals;
  final int grandTotalHours;
  final int grandTotalMinutes;
  final String grandTotalFormatted;

  const Attendance({
    required this.userId,
    required this.userName,
    required this.dailyReports,
    required this.eventTotals,
    required this.grandTotalHours,
    required this.grandTotalMinutes,
    required this.grandTotalFormatted,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        dailyReports,
        eventTotals,
        grandTotalHours,
        grandTotalMinutes,
        grandTotalFormatted,
      ];

  Attendance copyWith({
    int? userId,
    String? userName,
    List<DailyReport>? dailyReports,
    List<EventTotal>? eventTotals,
    int? grandTotalHours,
    int? grandTotalMinutes,
    String? grandTotalFormatted,
  }) {
    return Attendance(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      dailyReports: dailyReports ?? this.dailyReports,
      eventTotals: eventTotals ?? this.eventTotals,
      grandTotalHours: grandTotalHours ?? this.grandTotalHours,
      grandTotalMinutes: grandTotalMinutes ?? this.grandTotalMinutes,
      grandTotalFormatted: grandTotalFormatted ?? this.grandTotalFormatted,
    );
  }
}

/// Daily attendance report entity
class DailyReport extends Equatable {
  final String date;
  final String eventId;
  final String eventName;
  final String zoneName;
  final int totalHours;
  final double totalMinutes;
  final String formattedDuration;
  final String attendanceTime;
  final String departureTime;
  final List<Session> sessions;
  final int recordsCount;

  const DailyReport({
    required this.date,
    required this.eventId,
    required this.eventName,
    required this.zoneName,
    required this.totalHours,
    required this.totalMinutes,
    required this.formattedDuration,
    required this.attendanceTime,
    required this.departureTime,
    required this.sessions,
    required this.recordsCount,
  });

  @override
  List<Object?> get props => [
        date,
        eventId,
        eventName,
        zoneName,
        totalHours,
        totalMinutes,
        formattedDuration,
        attendanceTime,
        departureTime,
        sessions,
        recordsCount,
      ];

  DailyReport copyWith({
    String? date,
    String? eventId,
    String? eventName,
    String? zoneName,
    int? totalHours,
    double? totalMinutes,
    String? formattedDuration,
    String? attendanceTime,
    String? departureTime,
    List<Session>? sessions,
    int? recordsCount,
  }) {
    return DailyReport(
      date: date ?? this.date,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      zoneName: zoneName ?? this.zoneName,
      totalHours: totalHours ?? this.totalHours,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      formattedDuration: formattedDuration ?? this.formattedDuration,
      attendanceTime: attendanceTime ?? this.attendanceTime,
      departureTime: departureTime ?? this.departureTime,
      sessions: sessions ?? this.sessions,
      recordsCount: recordsCount ?? this.recordsCount,
    );
  }
}

/// Session entity representing individual attendance sessions
class Session extends Equatable {
  final String attendance;
  final String departure;
  final double durationMinutes;
  final String durationFormatted;

  const Session({
    required this.attendance,
    required this.departure,
    required this.durationMinutes,
    required this.durationFormatted,
  });

  @override
  List<Object?> get props => [
        attendance,
        departure,
        durationMinutes,
        durationFormatted,
      ];

  Session copyWith({
    String? attendance,
    String? departure,
    double? durationMinutes,
    String? durationFormatted,
  }) {
    return Session(
      attendance: attendance ?? this.attendance,
      departure: departure ?? this.departure,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      durationFormatted: durationFormatted ?? this.durationFormatted,
    );
  }
}

/// Event total entity for summarizing attendance by event
class EventTotal extends Equatable {
  final String eventId;
  final String eventName;
  final double totalMinutes;
  final int daysCount;
  final int totalHours;
  final int remainingMinutes;
  final String formattedDuration;

  const EventTotal({
    required this.eventId,
    required this.eventName,
    required this.totalMinutes,
    required this.daysCount,
    required this.totalHours,
    required this.remainingMinutes,
    required this.formattedDuration,
  });

  @override
  List<Object?> get props => [
        eventId,
        eventName,
        totalMinutes,
        daysCount,
        totalHours,
        remainingMinutes,
        formattedDuration,
      ];

  EventTotal copyWith({
    String? eventId,
    String? eventName,
    double? totalMinutes,
    int? daysCount,
    int? totalHours,
    int? remainingMinutes,
    String? formattedDuration,
  }) {
    return EventTotal(
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      daysCount: daysCount ?? this.daysCount,
      totalHours: totalHours ?? this.totalHours,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      formattedDuration: formattedDuration ?? this.formattedDuration,
    );
  }
}