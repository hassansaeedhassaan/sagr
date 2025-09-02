// Enum for event status
enum EventStatus { 
  upcoming, 
  active, 
  finished 
}

// Extension to get status properties
extension EventStatusExtension on EventStatus {
  String get text {
    switch (this) {
      case EventStatus.upcoming:
        return 'Upcoming';
      case EventStatus.active:
        return 'Active';
      case EventStatus.finished:
        return 'Finished';
    }
  }

  String get description {
    switch (this) {
      case EventStatus.upcoming:
        return 'Event hasn\'t started yet';
      case EventStatus.active:
        return 'Event is currently running';
      case EventStatus.finished:
        return 'Event has ended';
    }
  }

  // Get color for UI
  int get colorValue {
    switch (this) {
      case EventStatus.upcoming:
        return 0xFF2196F3; // Blue
      case EventStatus.active:
        return 0xFF4CAF50; // Green
      case EventStatus.finished:
        return 0xFF9E9E9E; // Grey
    }
  }
}

class StartDateTimeModel {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isPast;
  final double totalSeconds;
  final String formatted;
  final EventStatus? status; // Optional status field

  StartDateTimeModel({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isPast,
    required this.totalSeconds,
    required this.formatted,
    this.status,
  });

  // Create from JSON
  factory StartDateTimeModel.fromJson(Map<String, dynamic> json) {
    // Parse status from string if available
    EventStatus? eventStatus;
    if (json['status'] != null) {
      switch (json['status'].toString().toLowerCase()) {
        case 'upcoming':
          eventStatus = EventStatus.upcoming;
          break;
        case 'active':
          eventStatus = EventStatus.active;
          break;
        case 'finished':
          eventStatus = EventStatus.finished;
          break;
      }
    }

    return StartDateTimeModel(
      days: json['days'] ?? 0,
      hours: json['hours'] ?? 0,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
      isPast: json['is_past'] ?? false,
      totalSeconds: (json['total_seconds'] ?? 0.0).toDouble(),
      formatted: json['formatted'] ?? '',
      status: eventStatus,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'is_past': isPast,
      'total_seconds': totalSeconds,
      'formatted': formatted,
      if (status != null) 'status': status!.name,
    };
  }

  // Get simple time string with status awareness
  String get timeString {
    if (status != null) {
      switch (status!) {
        case EventStatus.upcoming:
          return '${days}d ${hours}h ${minutes}m ${seconds}s';
        case EventStatus.active:
          return 'Active: ${days}d ${hours}h ${minutes}m ${seconds}s';
        case EventStatus.finished:
          return 'Finished';
      }
    }
    
    // Fallback to original logic
    if (isPast) return 'Event started';
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  // Get short format with status awareness
  String get shortTime {
    if (status != null) {
      switch (status!) {
        case EventStatus.upcoming:
          if (days > 0) return '${days}d ${hours}h';
          return '${hours}h ${minutes}m';
        case EventStatus.active:
          return 'Active';
        case EventStatus.finished:
          return 'Finished';
      }
    }
    
    // Fallback to original logic
    if (isPast) return 'Started';
    if (days > 0) return '${days}d ${hours}h';
    return '${hours}h ${minutes}m';
  }

  // Get status text
  String get statusText {
    return status?.text ?? (isPast ? 'Started' : 'Upcoming');
  }

  // Get status description
  String get statusDescription {
    return status?.description ?? (isPast ? 'Event has started' : 'Event is upcoming');
  }

  // Check if event is upcoming
  bool get isUpcoming {
    return status == EventStatus.upcoming || (!isPast && status == null);
  }

  // Check if event is active
  bool get isActive {
    return status == EventStatus.active;
  }

  // Check if event is finished
  bool get isFinished {
    return status == EventStatus.finished;
  }

  // Get urgency level (for UI styling)
  String get urgencyLevel {
    if (isFinished) return 'none';
    if (isActive) return 'active';
    
    if (days == 0 && hours == 0 && minutes < 30) return 'critical';
    if (days == 0 && hours < 2) return 'high';
    if (days == 0) return 'medium';
    return 'low';
  }

  // Check if countdown is urgent
  bool get isUrgent {
    return urgencyLevel == 'critical' || urgencyLevel == 'high';
  }

  // Copy with new status
  StartDateTimeModel copyWithStatus(EventStatus newStatus) {
    return StartDateTimeModel(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isPast: isPast,
      totalSeconds: totalSeconds,
      formatted: formatted,
      status: newStatus,
    );
  }

  // Create a copy with decremented time (for live countdown)
  StartDateTimeModel copyWithDecrementedSecond() {
    if (isPast || totalSeconds <= 0) {
      return StartDateTimeModel(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        isPast: true,
        totalSeconds: 0,
        formatted: 'Time is up!',
        status: EventStatus.finished,
      );
    }

    int newTotalSeconds = totalSeconds.floor() - 1;
    int newDays = newTotalSeconds ~/ 86400;
    int remainingSeconds = newTotalSeconds % 86400;
    int newHours = remainingSeconds ~/ 3600;
    remainingSeconds = remainingSeconds % 3600;
    int newMinutes = remainingSeconds ~/ 60;
    int newSecondsOnly = remainingSeconds % 60;

    return StartDateTimeModel(
      days: newDays,
      hours: newHours,
      minutes: newMinutes,
      seconds: newSecondsOnly,
      isPast: newTotalSeconds <= 0,
      totalSeconds: newTotalSeconds.toDouble(),
      formatted: '${newDays} days, ${newHours} hours, ${newMinutes} minutes, ${newSecondsOnly} seconds',
      status: newTotalSeconds <= 0 ? EventStatus.finished : status,
    );
  }

  @override
  String toString() {
    return 'StartDateTime(days: $days, hours: $hours, minutes: $minutes, seconds: $seconds, status: ${status?.name})';
  }
}


// class StartDateTimeModel {
//   final int days;
//   final int hours;
//   final int minutes;
//   final int seconds;
//   final bool isPast;
//   final double totalSeconds;
//   final String formatted;

//   StartDateTimeModel({
//     required this.days,
//     required this.hours,
//     required this.minutes,
//     required this.seconds,
//     required this.isPast,
//     required this.totalSeconds,
//     required this.formatted,
//   });

//   // Create from JSON
//   factory StartDateTimeModel.fromJson(Map<String, dynamic> json) {
//     return StartDateTimeModel(
//       days: json['days'] ?? 0,
//       hours: json['hours'] ?? 0,
//       minutes: json['minutes'] ?? 0,
//       seconds: json['seconds'] ?? 0,
//       isPast: json['is_past'] ?? false,
//       totalSeconds: (json['total_seconds'] ?? 0.0).toDouble(),
//       formatted: json['formatted'] ?? '',
//     );
//   }

//   // Convert to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'days': days,
//       'hours': hours,
//       'minutes': minutes,
//       'seconds': seconds,
//       'is_past': isPast,
//       'total_seconds': totalSeconds,
//       'formatted': formatted,
//     };
//   }

//   // Get simple time string
//   String get timeString {
//     if (isPast) return 'Event started';
//     return '${days}d ${hours}h ${minutes}m ${seconds}s';
//   }

//   // Get short format
//   String get shortTime {
//     if (isPast) return 'Started';
//     if (days > 0) return '${days}d ${hours}h';
//     return '${hours}h ${minutes}m';
//   }

//   @override
//   String toString() {
//     return 'StartDateTime(days: $days, hours: $hours, minutes: $minutes, seconds: $seconds)';
//   }
// }