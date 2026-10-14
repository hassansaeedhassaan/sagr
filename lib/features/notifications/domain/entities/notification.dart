import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  // Kept as a string so both numeric and UUID ids parse.
  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final String? created_at;
  final String? action;
  final bool? is_read;

  /// Backend category: success / error / warning / info ...
  final String? type;

  /// Free-form payload, e.g. {"event_id": 12}.
  final Map<String, dynamic> data;

  Notification({
    required this.id,
    this.title,
    this.content,
    this.image,
    this.created_at,
    this.action,
    this.is_read,
    this.type,
    this.data = const {},
  });

  /// Event this notification is about, when there is one.
  int? get eventId {
    final raw = data['event_id'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '');
  }

  @override
  List<Object?> get props =>
      [id, title, content, image, created_at, action, is_read, type, data];
}
