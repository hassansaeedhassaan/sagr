// Main Evocation model
import 'package:equatable/equatable.dart';

class EvocationModel extends Equatable {
  final int? id;
  final EvocationType type;
  final int duration; // Duration in minutes
  final int eventId;
  final int userId;
  final int zoneId;
  final String? notes;
  final String? zone;
  final String? event;
  final String? attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Related entities

  const EvocationModel({
    this.id,
    required this.type,
    required this.duration,
    required this.eventId,
    required this.userId,
    required this.zoneId,
    this.zone,
    this.event,
    this.notes,
    this.attachment,
    this.createdAt,
    this.updatedAt
  });

  /// Create Evocation from JSON
  factory EvocationModel.fromJson(Map<String, dynamic> json) {
    return EvocationModel(
     id: json['id'] as int?,
      type: EvocationType.fromString(json['type'] as String? ?? 'prayer'), // Safe default
      duration: json['duration'] as int? ?? 0, // Safe default
      eventId: json['event_id'] as int? ?? 0, // Safe default
      userId: json['user_id'] as int? ?? 0, // Safe default
      zoneId: json['zone_id'] as int? ?? 0, // Safe default
      zone: json['zone'] as String? ?? "", //
      event: json['event'] as String? ?? "", //
      notes: json['notes'] as String?,
      attachment: json['attachment'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'] as String? ?? '') // Use tryParse for safety
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'] as String? ?? '') // Added missing field
          : null,
    );
  }

  /// Convert Evocation to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type.toJson(),
      'duration': duration,
      'event_id': eventId,
      'user_id': userId,
      'zone_id': zoneId,
      'notes': notes,
      'zone': zone,
      'event': event,
      'attachment': attachment,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  EvocationModel copyWith({
    int? id,
    EvocationType? type,
    int? duration,
    int? eventId,
    int? userId,
    int? zoneId,
    String? notes,
    String? zone,
    String? event,
    String? attachment,
    DateTime? createdAt,
    DateTime? updatedAt,
  
  }) {
    return EvocationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      zoneId: zoneId ?? this.zoneId,
      notes: notes ?? this.notes,
      event: event??this.event,
      zone: event??this.zone,
      attachment: attachment ?? this.attachment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

    );
  }

  /// Get formatted duration (e.g., "1h 30m" or "45m")
  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get duration in hours as double
  double get durationInHours => duration / 60.0;

  /// Check if evocation has an attachment
  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;

  /// Get attachment URL (assuming base URL is provided elsewhere)
  String getAttachmentUrl([String? baseUrl]) {
    if (!hasAttachment) return '';
    final base = baseUrl ?? 'https://your-api-domain.com';
    return '$base/storage/evocations/$attachment';
  }

  /// Check if this is a new evocation (not saved to server)
  bool get isNew => id == null;

  /// Check if evocation was modified since creation
  bool get wasModified {
    if (createdAt == null || updatedAt == null) return false;
    return updatedAt!.isAfter(createdAt!);
  }

  /// Get time since creation
  String get timeAgo {
    if (createdAt == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate evocation data
  List<String> validate() {
    final errors = <String>[];
    
    if (duration <= 0) {
      errors.add('Duration must be greater than 0');
    }
    
    if (duration > 1440) { // 24 hours
      errors.add('Duration cannot exceed 24 hours');
    }
    
    if (eventId <= 0) {
      errors.add('Valid event must be selected');
    }
    
    if (userId <= 0) {
      errors.add('Valid user must be selected');
    }
    
    if (zoneId <= 0) {
      errors.add('Valid zone must be selected');
    }
    
    if (notes != null && notes!.length > 2000) {
      errors.add('Notes cannot exceed 2000 characters');
    }
    
    return errors;
  }

  /// Check if evocation is valid
  bool get isValid => validate().isEmpty;

  @override
  List<Object?> get props => [
    id,
    type,
    duration,
    eventId,
    userId,
    zoneId,
    notes,
    zone,
    event,
    attachment,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Evocation(id: $id, type: $type, duration: ${formattedDuration})';
  }
}

/// Extension for List<Evocation> with useful methods
extension EvocationListExtensions on List<EvocationModel> {
  /// Filter by type
  List<EvocationModel> filterByType(EvocationType type) {
    return where((evocation) => evocation.type == type).toList();
  }

  /// Get only prayer evocations
  List<EvocationModel> get prayers => filterByType(EvocationType.prayer);

  /// Get only food evocations
  List<EvocationModel> get foods => filterByType(EvocationType.food);

  /// Calculate total duration in minutes
  int get totalDuration => fold(0, (sum, evocation) => sum + evocation.duration);

  /// Calculate total duration in hours
  double get totalDurationInHours => totalDuration / 60.0;

  /// Get formatted total duration
  String get formattedTotalDuration {
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Calculate average duration
  double get averageDuration {
    if (isEmpty) return 0;
    return totalDuration / length;
  }

  /// Group by date
  Map<DateTime, List<EvocationModel>> groupByDate() {
    final grouped = <DateTime, List<EvocationModel>>{};
    
    for (final evocation in this) {
      if (evocation.createdAt == null) continue;
      
      final date = DateTime(
        evocation.createdAt!.year,
        evocation.createdAt!.month,
        evocation.createdAt!.day,
      );
      
      grouped.putIfAbsent(date, () => []).add(evocation);
    }
    
    return grouped;
  }

  /// Sort by creation date (newest first)
  List<EvocationModel> sortByNewest() {
    final sorted = List<EvocationModel>.from(this);
    sorted.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
    return sorted;
  }

  /// Sort by duration (longest first)
  List<EvocationModel> sortByDuration({bool ascending = false}) {
    final sorted = List<EvocationModel>.from(this);
    sorted.sort((a, b) {
      return ascending 
          ? a.duration.compareTo(b.duration)
          : b.duration.compareTo(a.duration);
    });
    return sorted;
  }
}

/// Enum for evocation types
enum EvocationType {
  prayer,
  food;

  /// Convert string to enum
  static EvocationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'prayer':
        return EvocationType.prayer;
      case 'food':
        return EvocationType.food;
      default:
        throw ArgumentError('Invalid evocation type: $value');
    }
  }

  /// Convert enum to string
  String toJson() => name;

  /// Get display name
  String get displayName {
    switch (this) {
      case EvocationType.prayer:
        return 'Prayer';
      case EvocationType.food:
        return 'Food';
    }
  }

  /// Get icon name for UI
  String get iconName {
    switch (this) {
      case EvocationType.prayer:
        return 'prayer';
      case EvocationType.food:
        return 'restaurant';
    }
  }
}