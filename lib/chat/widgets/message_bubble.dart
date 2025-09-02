import 'package:flutter/material.dart';
import '../chat_controller.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Animation<double> animation;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: message.isMe 
            ? Offset(1, 0) 
            : Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: message.isMe 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isMe) _buildAvatar(),
              SizedBox(width: !message.isMe ? 8.0 : 0),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: message.isMe 
                      ? Colors.blue[400] 
                      : Colors.grey[300],
                    borderRadius: BorderRadius.circular(18.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!message.isMe)
                        Text(
                          message.senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      if (!message.isMe) SizedBox(height: 4.0),
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        DateFormat('h:mm a').format(message.timestamp),
                        style: TextStyle(
                          color: message.isMe 
                            ? Colors.white.withOpacity(0.7) 
                            : Colors.black.withOpacity(0.6),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: message.isMe ? 8.0 : 0),
              if (message.isMe) _buildAvatar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return message.avatarUrl != null
        ? CircleAvatar(
            backgroundImage: NetworkImage(message.avatarUrl!),
            radius: 16.0,
          )
        : CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              message.senderName[0].toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            radius: 16.0,
          );
  }
}
