
// File: lib/controllers/chat_controller.dart
import 'package:get/get.dart';

// First, let's create our project structure
// File: lib/models/message_model.dart
class Message {
  final String text;
  final String senderName;
  final bool isMe;
  final DateTime timestamp;
  final String? avatarUrl;

  Message({
    required this.text,
    required this.senderName,
    required this.isMe,
    required this.timestamp,
    this.avatarUrl,
  });
}


class ChatV2Controller extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxDouble scrollPosition = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    isLoading.value = true;
    // Simulating loading messages from an API
    Future.delayed(Duration(seconds: 1), () {
      messages.addAll([
        Message(
          text: "Hey there! How's it going?",
          senderName: "Jane",
          isMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
        ),
        Message(
          text: "Hi Jane! I'm good, just working on this Flutter app",
          senderName: "Me",
          isMe: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 25)),
          avatarUrl: null,
        ),
        Message(
          text: "That sounds interesting! What kind of app are you building?",
          senderName: "Jane",
          isMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 20)),
          avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
        ),
        Message(
          text: "It's a chat application with some cool animations. I'm using GetX for state management.",
          senderName: "Me",
          isMe: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          avatarUrl: null,
        ),
        Message(
          text: "GetX is awesome! I've been using it in my projects too.",
          senderName: "Jane",
          isMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
          avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
        ),
        Message(
          text: "The animations really make the UI feel more polished and engaging.",
          senderName: "Me",
          isMe: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          avatarUrl: null,
        ),
        Message(
          text: "I agree! Good animations can really enhance the user experience. Can you show me what you've built so far?",
          senderName: "Jane",
          isMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 2)),
          avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
        ),
      ]);
      isLoading.value = false;
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    messages.add(Message(
      text: text,
      senderName: "Me",
      isMe: true,
      timestamp: DateTime.now(),
      avatarUrl: null,
    ));
  }

  void updateScrollPosition(double position) {
    scrollPosition.value = position;
  }
}