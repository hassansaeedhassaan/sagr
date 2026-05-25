import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/message.dart';
import 'voice_message_player.dart';
import 'document_message_widget.dart';
import 'video_message_widget.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;
  final VoidCallback? onLongPress;
  final int index;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    this.onLongPress,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.isMe 
        ? const Offset(0.3, 0.2) 
        : const Offset(-0.3, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Determine if message needs special bubble styling
  bool get _needsMinimalPadding {
    return widget.message.type == 'voice_note' ||
           widget.message.type == 'video' ||
           widget.message.type == 'document';
  }

  // Determine if timestamp should be shown separately
  bool get _showTimestampInBubble {
    return widget.message.type != 'voice_note' &&
           widget.message.type != 'video' &&
           widget.message.type != 'document';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: widget.isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.isMe && widget.showAvatar)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: widget.message.sender?.avatar != null
                                  ? CachedNetworkImageProvider(
                                      widget.message.sender!.avatar!)
                                  : null,
                              child: widget.message.sender?.avatar == null
                                  ? Text(widget.message.sender?.name[0]
                                          .toUpperCase() ??
                                      'U')
                                  : null,
                            ),
                          ),
                        if (!widget.isMe && !widget.showAvatar)
                          const SizedBox(width: 32),
                        const SizedBox(width: 8),
                        Flexible(
                          child: GestureDetector(
                            onLongPress: widget.onLongPress,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: _needsMinimalPadding
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: widget.message.type == 'video' ||
                                        widget.message.type == 'document'
                                    ? Colors.transparent
                                    : widget.isMe
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: widget.message.type == 'video' ||
                                        widget.message.type == 'document'
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.message.replyTo != null)
                                    _buildReplyPreview(),
                                  _buildMessageContent(),
                                  if (_showTimestampInBubble)
                                    const SizedBox(height: 4),
                                  if (_showTimestampInBubble)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          timeago.format(
                                              widget.message.createdAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: widget.isMe
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        if (widget.isMe) ...[
                                          const SizedBox(width: 4),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Icon(
                                              widget.message.statuses
                                                      .any((s) => s.isRead)
                                                  ? Icons.done_all
                                                  : Icons.done,
                                              key: ValueKey(widget
                                                  .message.statuses
                                                  .any((s) => s.isRead)),
                                              size: 14,
                                              color: widget.message.statuses
                                                      .any((s) => s.isRead)
                                                  ? Colors.blue
                                                  : Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Timestamp for media messages (shown below)
                    if (!_showTimestampInBubble)
                      Padding(
                        padding: EdgeInsets.only(
                          left: widget.isMe ? 0 : 40,
                          right: widget.isMe ? 8 : 0,
                          top: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timeago.format(widget.message.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (widget.isMe) ...[
                              const SizedBox(width: 4),
                              Icon(
                                widget.message.statuses.any((s) => s.isRead)
                                    ? Icons.done_all
                                    : Icons.done,
                                size: 14,
                                color: widget.message.statuses.any((s) => s.isRead)
                                    ? Colors.blue
                                    : Colors.grey[600],
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReplyPreview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.replyTo!.sender?.name ?? 'Unknown',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.message.replyTo!.displayContent,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (widget.message.type) {
      case 'text':
        return Text(
          widget.message.content ?? '',
          style: TextStyle(
            fontSize: 16,
            color: widget.isMe ? Colors.white : Colors.black87,
          ),
        );
      case 'image':
        return _buildImageMessage();
      case 'video':
        return _buildVideoMessage();
      case 'voice_note':
        return _buildVoiceMessage();
      case 'document':
        return _buildDocumentMessage();
      default:
        return Text(
          widget.message.displayContent,
          style: TextStyle(
            fontSize: 16,
            color: widget.isMe ? Colors.white : Colors.black87,
          ),
        );
    }
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: CachedNetworkImage(
          imageUrl: "${widget.message.media_url}",
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoMessage() {
    return VideoMessageWidget(
      videoUrl: widget.message.media_url,
      thumbnailUrl: widget.message.media_url, // You might want a separate thumbnail field
      
      duration: widget.message.duration??0,
      fileSize: widget.message.fileSize,
      isMe: widget.isMe,
      onLongPress: widget.onLongPress,
    );
  }

  Widget _buildVoiceMessage() {
    return VoiceMessagePlayer(
      audioUrl: widget.message.media_url ?? '',
      isMe: widget.isMe,
      durationInSeconds: widget.message.duration,
    );
  }

  Widget _buildDocumentMessage() {
    return DocumentMessageWidget(
      documentUrl: widget.message.media_url,
      fileName: widget.message.fileName,
      fileSize: widget.message.fileSize,
      isMe: widget.isMe,
      onLongPress: widget.onLongPress,
    );
  }
}