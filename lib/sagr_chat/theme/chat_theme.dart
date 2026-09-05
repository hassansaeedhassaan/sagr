import 'package:flutter/material.dart';

/// Central design tokens for the chat module.
///
/// Light-only for now, but every color/dimension is funneled through
/// [ChatTheme.of] so adding a dark palette later is a one-file change:
/// add a `_dark` [ChatPalette] and switch on `Theme.of(context).brightness`.
class ChatTheme {
  const ChatTheme._();

  /// Resolve the active palette. Today this always returns [_light]; wire in
  /// `brightness == Brightness.dark ? _dark : _light` when dark mode lands.
  static ChatPalette of(BuildContext context) => _light;

  static const ChatPalette _light = ChatPalette(
    // Brand
    primary: Color(0xff06987d), // SAGR teal
    primaryDark: Color(0xff047d66),
    navy: Color(0xff0f172a),

    // Surfaces
    scaffold: Color(0xfff0f2f5), // clean neutral chat backdrop
    appBar: Color(0xffffffff),
    surface: Color(0xffffffff),
    searchField: Color(0xffeef1f4),

    // Bubbles (WhatsApp-style: own = light brand tint, dark text)
    ownBubble: Color(0xffd6f2ec),
    otherBubble: Color(0xffffffff),
    ownText: Color(0xff0d2b25),
    otherText: Color(0xff0f172a),

    // Text
    title: Color(0xff0f172a),
    body: Color(0xff1f2937),
    subtitle: Color(0xff667085),
    hint: Color(0xff98a2b3),
    timeText: Color(0xff8b9a96),

    // Status / accents
    online: Color(0xff22c55e),
    tickSent: Color(0xff9aa6a3),
    tickRead: Color(0xff06987d),
    unreadBadge: Color(0xff06987d),
    divider: Color(0xffe4e8ec),
    dateChipBg: Color(0xffe7ecf0),
    dateChipText: Color(0xff5b6b78),

    // Voice notes (dark pill for a professional, premium feel)
    voiceOwnBg: Color(0xff0b5345), // deep teal
    voiceOtherBg: Color(0xff1f2937), // dark slate
    voicePlayed: Color(0xff2dd4bf), // bright teal progress
    voiceTrack: Color(0x66ffffff), // muted light track
    voiceText: Color(0xffe5eeec),
    recordDot: Color(0xffef4444),
    recordWave: Color(0xff06987d),
  );

  // ---- Dimensions (shared across brightnesses) ----
  static const double bubbleRadius = 18;
  static const double bubbleTail = 6;
  static const double avatarRadius = 27;
  static const double avatarRadiusSmall = 16;
  static const double tileVPad = 8;
  static const double tileHPad = 14;
  static const double gap = 8;

  static const EdgeInsets bubblePadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 7);
  static const EdgeInsets mediaBubblePadding = EdgeInsets.all(4);

  /// Soft elevation used on other-party bubbles and the input bar.
  static List<BoxShadow> softShadow(Color shadow) => [
        BoxShadow(
          color: shadow.withOpacity(0.06),
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ];

  /// Deterministic avatar background derived from a display name, so
  /// initials avatars stay colorful but stable per user.
  static Color avatarColorFor(String seed) {
    if (seed.isEmpty) return _avatarPalette.first;
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return _avatarPalette[hash % _avatarPalette.length];
  }

  static const List<Color> _avatarPalette = [
    Color(0xff06987d),
    Color(0xff0ea5e9),
    Color(0xff6366f1),
    Color(0xfff59e0b),
    Color(0xffec4899),
    Color(0xff14b8a6),
    Color(0xff8b5cf6),
    Color(0xffef4444),
  ];
}

/// Immutable color set for one brightness.
class ChatPalette {
  final Color primary;
  final Color primaryDark;
  final Color navy;

  final Color scaffold;
  final Color appBar;
  final Color surface;
  final Color searchField;

  final Color ownBubble;
  final Color otherBubble;
  final Color ownText;
  final Color otherText;

  final Color title;
  final Color body;
  final Color subtitle;
  final Color hint;
  final Color timeText;

  final Color online;
  final Color tickSent;
  final Color tickRead;
  final Color unreadBadge;
  final Color divider;
  final Color dateChipBg;
  final Color dateChipText;

  final Color voiceOwnBg;
  final Color voiceOtherBg;
  final Color voicePlayed;
  final Color voiceTrack;
  final Color voiceText;
  final Color recordDot;
  final Color recordWave;

  const ChatPalette({
    required this.primary,
    required this.primaryDark,
    required this.navy,
    required this.scaffold,
    required this.appBar,
    required this.surface,
    required this.searchField,
    required this.ownBubble,
    required this.otherBubble,
    required this.ownText,
    required this.otherText,
    required this.title,
    required this.body,
    required this.subtitle,
    required this.hint,
    required this.timeText,
    required this.online,
    required this.tickSent,
    required this.tickRead,
    required this.unreadBadge,
    required this.divider,
    required this.dateChipBg,
    required this.dateChipText,
    required this.voiceOwnBg,
    required this.voiceOtherBg,
    required this.voicePlayed,
    required this.voiceTrack,
    required this.voiceText,
    required this.recordDot,
    required this.recordWave,
  });
}
