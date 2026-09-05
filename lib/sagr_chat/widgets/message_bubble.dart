import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/message.dart';
import '../theme/chat_theme.dart';
import '../utils/chat_time.dart';
import 'voice_message_player.dart';
import 'document_message_widget.dart';
import 'video_message_widget.dart';

/// Stateless message bubble.
///
/// Note: this is intentionally stateless. The previous version created one
/// [AnimationController] *per bubble* with an elastic entry animation, which
/// caused jank on long lists (dozens of live controllers, re-running on every
/// scroll rebuild). List entry is now cheap; animate the list itself if needed.
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;
  final VoidCallback? onLongPress;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    this.onLongPress,
  }) : super(key: key);

  // Video/document/voice widgets render their own card or pill, so the wrapping
  // bubble must be transparent and the footer sits below them.
  bool get _isBareMedia =>
      message.type == 'video' ||
      message.type == 'document' ||
      message.type == 'voice_note';

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: _isBareMedia
          ? ChatTheme.mediaBubblePadding
          : ChatTheme.bubblePadding,
      decoration: _isBareMedia
          ? null
          : BoxDecoration(
              color: isMe ? palette.ownBubble : palette.otherBubble,
              borderRadius: _bubbleRadius(),
              boxShadow: ChatTheme.softShadow(palette.navy),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.replyTo != null) _buildReplyPreview(palette),
          _buildContent(palette),
          if (!_isBareMedia) _footer(palette),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _leadingAvatar(palette),
              Flexible(
                child: GestureDetector(
                  onLongPress: onLongPress,
                  child: bubble,
                ),
              ),
            ],
          ),
          if (_isBareMedia)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: isMe ? 0 : 40,
                top: 2,
              ),
              child: _footer(palette),
            ),
        ],
      ),
    );
  }

  BorderRadiusDirectional _bubbleRadius() {
    const r = Radius.circular(ChatTheme.bubbleRadius);
    const tail = Radius.circular(ChatTheme.bubbleTail);
    return isMe
        ? const BorderRadiusDirectional.only(
            topStart: r, topEnd: tail, bottomStart: r, bottomEnd: r)
        : const BorderRadiusDirectional.only(
            topStart: tail, topEnd: r, bottomStart: r, bottomEnd: r);
  }

  Widget _leadingAvatar(ChatPalette palette) {
    // Reserve the avatar slot so grouped messages stay aligned.
    if (!showAvatar) return const SizedBox(width: 40);
    final sender = message.sender;
    final name = sender?.name ?? 'U';
    final hasImage = sender?.avatar != null && sender!.avatar!.isNotEmpty;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: CircleAvatar(
        radius: ChatTheme.avatarRadiusSmall,
        backgroundColor: ChatTheme.avatarColorFor(name),
        backgroundImage:
            hasImage ? CachedNetworkImageProvider(sender.avatar!) : null,
        child: hasImage
            ? null
            : Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _footer(ChatPalette palette) {
    final timeColor = _isBareMedia ? palette.timeText : palette.timeText;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isEdited) ...[
            Text(
              'edited'.tr,
              style: TextStyle(fontSize: 10, color: timeColor),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            ChatTime.clock(message.createdAt),
            style: TextStyle(fontSize: 11, color: timeColor),
          ),
          if (isMe) ...[
            const SizedBox(width: 3),
            Icon(
              message.statuses.any((s) => s.isRead)
                  ? Icons.done_all
                  : Icons.done,
              size: 15,
              color: message.statuses.any((s) => s.isRead)
                  ? palette.tickRead
                  : palette.tickSent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyPreview(ChatPalette palette) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: palette.navy.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: BorderDirectional(
          start: BorderSide(color: palette.primary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyTo!.sender?.name ?? 'Unknown'.tr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.primary,
            ),
          ),
          Text(
            message.replyTo!.displayContent,
            style: TextStyle(fontSize: 12, color: palette.subtitle),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ChatPalette palette) {
    final textColor = isMe ? palette.ownText : palette.otherText;
    switch (message.type) {
      case 'text':
        return Text(
          message.content ?? '',
          style: TextStyle(fontSize: 15.5, height: 1.3, color: textColor),
        );
      case 'image':
        return _buildImage();
      case 'video':
        return VideoMessageWidget(
          videoUrl: message.media_url,
          thumbnailUrl: message.media_url,
          duration: message.duration ?? 0,
          fileSize: message.fileSize,
          isMe: isMe,
          onLongPress: onLongPress,
        );
      case 'voice_note':
        return VoiceMessagePlayer(
          audioUrl: message.media_url ?? '',
          isMe: isMe,
          durationInSeconds: message.duration,
        );
      case 'document':
        return DocumentMessageWidget(
          documentUrl: message.media_url,
          fileName: message.fileName,
          fileSize: message.fileSize,
          isMe: isMe,
          onLongPress: onLongPress,
        );
      default:
        return Text(
          message.displayContent,
          style: TextStyle(fontSize: 15.5, color: textColor),
        );
    }
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: '${message.media_url}',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 220,
          height: 220,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: 220,
          height: 220,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
