import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../theme/chat_theme.dart';
import '../utils/chat_time.dart';
import 'chat_avatar.dart';

/// Compact, WhatsApp-style conversation row: avatar + online dot, name,
/// last-message preview (with media glyph and own-message tick), trailing
/// time and unread badge.
class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final int currentUserId;
  final VoidCallback onTap;

  const ConversationTile({
    Key? key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final displayName = conversation.getDisplayName(currentUserId);
    final displayAvatar = conversation.getDisplayAvatar(currentUserId);
    final lastMessage = conversation.lastMessage;
    final otherParticipant = conversation.getOtherParticipant(currentUserId);
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: palette.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatTheme.tileHPad,
            vertical: ChatTheme.tileVPad,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ChatAvatar(
                name: displayName,
                imageUrl: displayAvatar,
                radius: ChatTheme.avatarRadius,
                showOnlineDot: true,
                isOnline: otherParticipant?.isOnline == true,
              ),
              const SizedBox(width: ChatTheme.tileHPad),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight:
                                  hasUnread ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 16,
                              color: palette.title,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (lastMessage != null)
                          Text(
                            ChatTime.listTime(lastMessage.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w400,
                              color: hasUnread
                                  ? palette.primary
                                  : palette.timeText,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(child: _buildPreview(palette, lastMessage)),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          _unreadBadge(palette),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(ChatPalette palette, Message? lastMessage) {
    if (lastMessage == null) {
      return Text(
        'Tap to start chatting'.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: palette.hint,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final isMine = lastMessage.senderId == currentUserId;
    final glyph = _previewGlyph(lastMessage.type);
    final text = _previewText(lastMessage);

    return Row(
      children: [
        if (isMine) ...[
          Icon(
            lastMessage.statuses.any((s) => s.isRead)
                ? Icons.done_all
                : Icons.done,
            size: 16,
            color: lastMessage.statuses.any((s) => s.isRead)
                ? palette.tickRead
                : palette.tickSent,
          ),
          const SizedBox(width: 3),
        ],
        if (glyph != null) ...[
          Icon(glyph, size: 15, color: palette.subtitle),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.subtitle, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _unreadBadge(ChatPalette palette) {
    final count = conversation.unreadCount;
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: palette.unreadBadge,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  IconData? _previewGlyph(String type) {
    switch (type) {
      case 'image':
        return Icons.photo_camera_outlined;
      case 'video':
        return Icons.videocam_outlined;
      case 'voice_note':
        return Icons.mic_none_outlined;
      case 'audio':
        return Icons.music_note_outlined;
      case 'document':
        return Icons.insert_drive_file_outlined;
      default:
        return null;
    }
  }

  String _previewText(Message m) {
    switch (m.type) {
      case 'text':
        return m.content ?? '';
      case 'image':
        return 'Photo'.tr;
      case 'video':
        return 'Video'.tr;
      case 'voice_note':
        return 'Voice message'.tr;
      case 'audio':
        return 'Audio'.tr;
      case 'document':
        return m.fileName ?? 'Document'.tr;
      default:
        return m.displayContent;
    }
  }
}
