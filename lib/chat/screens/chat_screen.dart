import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ChatV2Controller _chatController = Get.put(ChatV2Controller());
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final RxBool _isTyping = false.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Simulate typing indicator after some time
    Future.delayed(Duration(seconds: 5), () {
      _isTyping.value = true;
      Future.delayed(Duration(seconds: 3), () {
        _isTyping.value = false;
        _simulateReceivedMessage();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _chatController.updateScrollPosition(_scrollController.position.pixels);
  }

  void _simulateReceivedMessage() {
    final message = _chatController.messages.length;
    _chatController.messages.add(
      Message(
        text: "This chat UI looks great! I love the animations when scrolling.",
        senderName: "Jane",
        isMe: false,
        timestamp: DateTime.now(),
        avatarUrl: "https://randomuser.me/api/portraits/women/65.jpg",
      ),
    );
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(message);
      _scrollToBottom();
    }
  }

  void _handleSendMessage(String text) {
    final message = _chatController.messages.length;
    _chatController.sendMessage(text);
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(message);
      _scrollToBottom();
    }
    
    // Simulate typing response
    Future.delayed(Duration(seconds: 1), () {
      _isTyping.value = true;
      Future.delayed(Duration(seconds: 2), () {
        _isTyping.value = false;
        _simulateReceivedMessage();
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 600,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/65.jpg"),
              radius: 16.0,
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jane Smith",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              return AnimatedList(
                key: _listKey,
                controller: _scrollController,
                initialItemCount: _chatController.messages.length,
                itemBuilder: (context, index, animation) {
                  final message = _chatController.messages[index];
                  return MessageBubble(
                    message: message,
                    animation: animation,
                  );
                },
              );
            }),
          ),
          Obx(() => TypingIndicator(isTyping: _isTyping.value)),
          ChatInput(onSendMessage: _handleSendMessage),
        ],
      ),
    );
  }
}