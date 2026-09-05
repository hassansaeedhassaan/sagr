import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/chat_theme.dart';

/// Circular avatar with cached image, colored initials fallback, and an
/// optional online dot. Used by the conversation list, chat app bar and
/// message bubbles for a consistent look.
class ChatAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;
  final bool showOnlineDot;
  final bool isOnline;

  const ChatAvatar({
    Key? key,
    required this.name,
    this.imageUrl,
    this.radius = ChatTheme.avatarRadius,
    this.showOnlineDot = false,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final bg = ChatTheme.avatarColorFor(name);

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      backgroundImage:
          hasImage ? CachedNetworkImageProvider(imageUrl!) : null,
      child: hasImage
          ? null
          : Text(
              initial,
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );

    if (!showOnlineDot || !isOnline) return avatar;

    final dot = radius * 0.5;
    return Stack(
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dot,
            height: dot,
            decoration: BoxDecoration(
              color: palette.online,
              shape: BoxShape.circle,
              border: Border.all(color: palette.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
