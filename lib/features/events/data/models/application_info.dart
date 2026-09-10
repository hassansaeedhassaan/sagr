/// The caller's latest application to an event, from the event payload's
/// `application` block: its status, each stage it reached with the time, the
/// contract link, whether (re-)applying is allowed, and the zone assignment.
class ApplicationInfo {
  final int? id;
  final String status;
  final DateTime? submittedAt;
  final DateTime? updatedAt;
  final String? contractUrl;
  final bool canApply;
  final List<ApplicationStage> timeline;
  final AssignmentInfo? assignment;

  const ApplicationInfo({
    this.id,
    required this.status,
    this.submittedAt,
    this.updatedAt,
    this.contractUrl,
    required this.canApply,
    this.timeline = const [],
    this.assignment,
  });

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) {
    final rawTimeline = json['timeline'];
    final rawAssignment = json['assignment'];
    final contract = json['contract_url']?.toString() ?? '';

    return ApplicationInfo(
      id: json['id'] is int ? json['id'] as int : null,
      status: json['status']?.toString() ?? 'undefined',
      submittedAt: _parseDate(json['submitted_at']),
      updatedAt: _parseDate(json['updated_at']),
      contractUrl: contract.isEmpty ? null : contract,
      canApply: json['can_apply'] == true,
      timeline: rawTimeline is List
          ? rawTimeline
              .whereType<Map>()
              .map((e) => ApplicationStage.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      assignment: rawAssignment is Map
          ? AssignmentInfo.fromJson(Map<String, dynamic>.from(rawAssignment))
          : null,
    );
  }

  /// Whether the application ever reached [status].
  bool reached(String status) => timeline.any((s) => s.status == status);

  /// When the application first reached [status], if it did.
  DateTime? firstAt(String status) {
    for (final stage in timeline) {
      if (stage.status == status) return stage.at;
    }
    return null;
  }

  /// When the application last reached [status], if it did.
  DateTime? lastAt(String status) {
    for (final stage in timeline.reversed) {
      if (stage.status == status) return stage.at;
    }
    return null;
  }
}

/// One status the application went through, and when.
class ApplicationStage {
  final String status;
  final DateTime? at;

  const ApplicationStage({required this.status, this.at});

  factory ApplicationStage.fromJson(Map<String, dynamic> json) {
    return ApplicationStage(
      status: json['status']?.toString() ?? '',
      at: _parseDate(json['at']),
    );
  }
}

/// The zone and role the user was assigned on the event.
class AssignmentInfo {
  final int? zoneId;
  final String? zoneName;
  final String role;
  final DateTime? assignedAt;

  const AssignmentInfo({
    this.zoneId,
    this.zoneName,
    required this.role,
    this.assignedAt,
  });

  bool get isSupervisor => role == 'supervisor';

  factory AssignmentInfo.fromJson(Map<String, dynamic> json) {
    return AssignmentInfo(
      zoneId: json['zone_id'] is int ? json['zone_id'] as int : null,
      zoneName: json['zone_name']?.toString(),
      role: json['role']?.toString() ?? 'employee',
      assignedAt: _parseDate(json['assigned_at']),
    );
  }
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}
