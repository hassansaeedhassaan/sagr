import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;
  final VoidCallback? onLongPress;
  final int index; // Add index for staggered animation

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

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    // Slide animation - from bottom for incoming, from right for outgoing
    _slideAnimation = Tween<Offset>(
      begin: widget.isMe 
        ? const Offset(0.3, 0.2) 
        : const Offset(-0.3, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Scale animation for a subtle bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // Start animation with staggered delay
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
                child: Row(
                  mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isMe && widget.showAvatar)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: widget.message.sender?.avatar != null
                              ? CachedNetworkImageProvider(widget.message.sender!.avatar!)
                              : null,
                          child: widget.message.sender?.avatar == null
                              ? Text(widget.message.sender?.name[0].toUpperCase() ?? 'U')
                              : null,
                        ),
                      ),
                    if (!widget.isMe && !widget.showAvatar) const SizedBox(width: 32),
                    const SizedBox(width: 8),
                    Flexible(
                      child: GestureDetector(
                        onLongPress: widget.onLongPress,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: widget.isMe 
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
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
                              if (widget.message.replyTo != null) _buildReplyPreview(),
                              _buildMessageContent(),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timeago.format(widget.message.createdAt),
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
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        widget.message.statuses.any((s) => s.isRead)
                                            ? Icons.done_all
                                            : Icons.done,
                                        key: ValueKey(widget.message.statuses.any((s) => s.isRead)),
                                        size: 14,
                                        color: widget.message.statuses.any((s) => s.isRead)
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
          imageUrl: widget.message.mediaUrl ?? '',
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_circle_fill,
            size: 48,
            color: Colors.white,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Icon(
              Icons.videocam,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: widget.isMe ? Colors.white : Colors.blue,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: widget.isMe ? Colors.white54 : Colors.grey[400],
            ),
          ),
          Text(
            '${widget.message.duration ?? 0}s',
            style: TextStyle(
              fontSize: 12,
              color: widget.isMe ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentMessage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.fileName ?? 'Document',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (widget.message.fileSize != null)
                  Text(
                    '${(widget.message.fileSize! / 1024).round()} KB',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../models/message.dart';

// class MessageBubble extends StatelessWidget {
//   final Message message;
//   final bool isMe;
//   final bool showAvatar;
//   final VoidCallback? onLongPress;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isMe,
//     required this.showAvatar,
//     this.onLongPress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isMe && showAvatar)
//             CircleAvatar(
//               radius: 16,
//               backgroundImage: message.sender?.avatar != null
//                   ? CachedNetworkImageProvider(message.sender!.avatar!)
//                   : null,
//               child: message.sender?.avatar == null
//                   ? Text(message.sender?.name[0].toUpperCase() ?? 'U')
//                   : null,
//             ),
//           if (!isMe && !showAvatar) const SizedBox(width: 32),
//           const SizedBox(width: 8),
//           Flexible(
//             child: GestureDetector(
//               onLongPress: onLongPress,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: isMe 
//                       ? Theme.of(context).colorScheme.primary
//                       : Theme.of(context).colorScheme.surface,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 2,
//                       offset: const Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (message.replyTo != null) _buildReplyPreview(),
//                     _buildMessageContent(),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           timeago.format(message.createdAt),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: isMe 
//                                 ? Colors.white70 
//                                 : Colors.grey[600],
//                           ),
//                         ),
//                         if (isMe) ...[
//                           const SizedBox(width: 4),
//                           Icon(
//                             message.statuses.any((s) => s.isRead)
//                                 ? Icons.done_all
//                                 : Icons.done,
//                             size: 14,
//                             color: message.statuses.any((s) => s.isRead)
//                                 ? Colors.blue
//                                 : Colors.white70,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReplyPreview() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             message.replyTo!.sender?.name ?? 'Unknown',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             message.replyTo!.displayContent,
//             style: const TextStyle(fontSize: 12),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageContent() {
//     switch (message.type) {
//       case 'text':
//         return Text(
//           message.content ?? '',
//           style: TextStyle(
//             fontSize: 16,
//             color: isMe ? Colors.white : Colors.black87,
//           ),
//         );
//       case 'image':
//         return _buildImageMessage();
//       case 'video':
//         return _buildVideoMessage();
//       case 'voice_note':
//         return _buildVoiceMessage();
//       case 'document':
//         return _buildDocumentMessage();
//       default:
//         return Text(
//           message.displayContent,
//           style: TextStyle(
//             fontSize: 16,
//             color: isMe ? Colors.white : Colors.black87,
//           ),
//         );
//     }
//   }

//   Widget _buildImageMessage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: CachedNetworkImage(
//         imageUrl: message.mediaUrl ?? '',
//         width: 200,
//         height: 200,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => Container(
//           width: 200,
//           height: 200,
//           color: Colors.grey[300],
//           child: const Center(child: CircularProgressIndicator()),
//         ),
//         errorWidget: (context, url, error) => Container(
//           width: 200,
//           height: 200,
//           color: Colors.grey[300],
//           child: const Icon(Icons.error),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoMessage() {
//     return Container(
//       width: 200,
//       height: 150,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Stack(
//         alignment: Alignment.center,
//         children: [
//           Icon(
//             Icons.play_circle_fill,
//             size: 48,
//             color: Colors.white,
//           ),
//           Positioned(
//             bottom: 8,
//             right: 8,
//             child: Icon(
//               Icons.videocam,
//               size: 16,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVoiceMessage() {
//     return Container(
//       width: 200,
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         children: [
//           Icon(
//             Icons.play_arrow,
//             color: isMe ? Colors.white : Colors.blue,
//           ),
//           Expanded(
//             child: Container(
//               height: 2,
//               color: isMe ? Colors.white54 : Colors.grey[400],
//             ),
//           ),
//           Text(
//             '${message.duration ?? 0}s',
//             style: TextStyle(
//               fontSize: 12,
//               color: isMe ? Colors.white70 : Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentMessage() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.description, size: 24),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   message.fileName ?? 'Document',
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 if (message.fileSize != null)
//                   Text(
//                     '${(message.fileSize! / 1024).round()} KB',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }