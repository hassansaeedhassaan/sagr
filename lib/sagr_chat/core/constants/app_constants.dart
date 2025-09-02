class AppConstants {
  // App Info
  static const String appName = 'Chat App';
  static const String appVersion = '1.0.0';
  
  // Limits
  static const int maxMessageLength = 5000;
  static const int maxGroupMembers = 100;
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const int maxAudioDuration = 300; // 5 minutes
  
  // UI Constants
  static const double chatBubbleRadius = 16.0;
  static const double avatarRadius = 25.0;
  static const double smallAvatarRadius = 15.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Cache Keys
  static const String userCacheKey = 'cached_user';
  static const String chatsCacheKey = 'cached_chats';
  static const String messagesCacheKey = 'cached_messages';
  
  // Notification Settings
  static const String notificationChannelId = 'chat_messages';
  static const String notificationChannelName = 'Chat Messages';
  static const String notificationChannelDescription = 'Notifications for new chat messages';
  
  // File Types
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> supportedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];
  static const List<String> supportedAudioTypes = ['mp3', 'wav', 'aac', 'm4a'];
  static const List<String> supportedDocumentTypes = ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'pptx'];
}