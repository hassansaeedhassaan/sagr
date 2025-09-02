// class ApiConstants {
//   // static const String baseUrl = 'http://localhost:8000/api';
//   static const String baseUrl = 'http://10.0.2.2:8000/api';
//   // http://10.0.2.2:8000/api/v1/
  
//   // Auth endpoints
//   static const String login = '/auth/login';
//   static const String register = '/auth/register';
//   static const String logout = '/auth/logout';
//   static const String refreshToken = '/auth/refresh';
  
//   // Chat endpoints
//   static const String chats = '/chats';
//   static const String messages = '/messages';
//   static const String sendMessage = '/messages/send';
//   static const String uploadMedia = '/upload/media';
//   static const String getOrCreateIndividualChat = '/chats/individual'; // إضافة
  
//   // User endpoints
//   static const String users = '/users';
//   static const String updateProfile = '/users/profile';
//   static const String updateFcmToken = '/users/fcm-token';
//   static const String uploadAvatar = '/users/avatar'; // إضافة
  
//   // Group endpoints
//   static const String groups = '/groups';
//   static const String createGroup = '/groups/create';
//   static const String addToGroup = '/groups/add-member';
//   static const String removeFromGroup = '/groups/remove-member';
// }


class ApiConstants {
  static const String baseUrl = 'https://chat.zcodenest.com/public/api'; // For Android emulator
  // static const String baseUrl = 'http://192.168.1.1:8000/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // For iOS simulator
  // static const String baseUrl = 'https://your-domain.com/api'; // For production
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String updateFcmToken = '/auth/fcm-token';
  
  // Chat endpoints
  static const String chats = '/chats';
  static const String getOrCreateIndividualChat = '/chats/individual';
  
  // Message endpoints
  static const String sendMessage = '/messages/send';
  static const String uploadMedia = '/upload/media';
  
  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';
  static const String userSearch = '/users/search';
  static const String userContacts = '/users/contacts';
  
  // Group endpoints
  static const String groups = '/groups';
  static const String createGroup = '/groups/create';
  
  // Helper methods
  static String chatMessages(String chatId) => '/chats/$chatId/messages';
  static String chatDetails(String chatId) => '/chats/$chatId';
  static String markChatAsRead(String chatId) => '/chats/$chatId/mark-read';
  static String addGroupMember(String chatId) => '/groups/$chatId/add-member';
  static String removeGroupMember(String chatId) => '/groups/$chatId/remove-member';
  static String leaveGroup(String chatId) => '/groups/$chatId/leave';
  static String updateGroup(String chatId) => '/groups/$chatId';
  static String transferGroupOwnership(String chatId) => '/groups/$chatId/transfer-ownership';
  static String userDetails(String userId) => '/users/$userId';
}