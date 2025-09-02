class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String status;
  final DateTime? lastSeen;
  final String? fcmToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.status,
    this.lastSeen,
    this.fcmToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      status: json['status'] ?? 'offline',
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'status': status,
      'last_seen': lastSeen?.toIso8601String(),
      'fcm_token': fcmToken,
    };
  }

  bool get isOnline => status == 'online';
  bool get isOffline => status == 'offline';
  bool get isAway => status == 'away';

  String get statusDisplay {
    if (isOnline) return 'Online';
    if (isAway) return 'Away';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      if (difference.inMinutes < 1) return 'Last seen just now';
      if (difference.inHours < 1) return 'Last seen ${difference.inMinutes}m ago';
      if (difference.inDays < 1) return 'Last seen ${difference.inHours}h ago';
      return 'Last seen ${difference.inDays}d ago';
    }
    return 'Offline';
  }
}