import 'package:flutter/material.dart';
import 'dart:ui';

// ─────────────────────────────────────────────────────────────
//  PREMIUM AD CARD — Single-file, self-contained
//  Supports: Vertical & Horizontal layouts
//  Features: Scale animation, professional bottom sheet
// ─────────────────────────────────────────────────────────────

/// ── Design Tokens ──────────────────────────────────────────
class _T {
  _T._();

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF7F7F5);
  static const Color border = Color(0xFFE8E6E1);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color accent = Color(0xFF1A1A1A);
  static const Color accentLabel = Color(0xFFFFFFFF);
  static const Color eventBadgeBg = Color(0xFFEAF4EC);
  static const Color eventBadgeText = Color(0xFF2E7D47);
  static const Color sheetBarrier = Color(0xFF1A1A1A);
  static const Color divider = Color(0xFFF0EEEB);

  static const double cardRadius = 14;
  static const double badgeRadius = 6;
  static const double buttonRadius = 8;
  static const double sheetRadius = 22;

  static const double cardPadding = 14;
  static const double gap2 = 2;
  static const double gap4 = 4;
  static const double gap6 = 6;
  static const double gap8 = 8;
  static const double gap10 = 10;
  static const double gap12 = 12;
  static const double gap16 = 16;
  static const double gap20 = 20;
  static const double gap24 = 24;
}

/// ── Layout mode ────────────────────────────────────────────
enum AdCardLayout { vertical, horizontal }

/// ── Data model ─────────────────────────────────────────────
class AdCardData {
  const AdCardData({
    required this.companyName,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.imageUrl,
    this.eventLabel,
    this.fullArticle,
  });

  final String companyName;
  final String title;
  final String description;
  final DateTime dateTime;
  final String imageUrl;
  final String? eventLabel;
  final String? fullArticle;

  String get formattedDate {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    final h = dateTime.hour;
    final m = dateTime.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}  ·  $hour12:$m $period';
  }
}

// ═════════════════════════════════════════════════════════════
//  PREMIUM AD CARD — Main Widget
// ═════════════════════════════════════════════════════════════
class PremiumAdCard extends StatefulWidget {
  const PremiumAdCard({
    super.key,
    required this.data,
    this.layout = AdCardLayout.vertical,
    this.onReadMore,
  });

  final AdCardData data;
  final AdCardLayout layout;
  final VoidCallback? onReadMore;

  @override
  State<PremiumAdCard> createState() => _PremiumAdCardState();
}

class _PremiumAdCardState extends State<PremiumAdCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleCtrl.forward();
  void _onTapUp(TapUpDetails _) => _scaleCtrl.reverse();
  void _onTapCancel() => _scaleCtrl.reverse();

  void _handleReadMore() {
    _scaleCtrl.reverse();
    if (widget.onReadMore != null) {
      widget.onReadMore!();
    } else {
      _showDetailSheet(context);
    }
  }

  void _showDetailSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: _T.sheetBarrier.withOpacity(0.35),
      builder: (_) => _DetailBottomSheet(data: widget.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _handleReadMore,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: widget.layout == AdCardLayout.vertical ? 400 : 520,
          ),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(_T.cardRadius),
            border: Border.all(color: _T.border, width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_T.cardRadius),
            child: widget.layout == AdCardLayout.vertical
                ? _VerticalLayout(data: widget.data, onReadMore: _handleReadMore)
                : _HorizontalLayout(data: widget.data, onReadMore: _handleReadMore),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  VERTICAL LAYOUT
// ═════════════════════════════════════════════════════════════
class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({required this.data, required this.onReadMore});
  final AdCardData data;
  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AdImage(imageUrl: data.imageUrl, eventLabel: data.eventLabel, height: 170),
        _ContentBlock(data: data, onReadMore: onReadMore),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  HORIZONTAL LAYOUT
// ═════════════════════════════════════════════════════════════
class _HorizontalLayout extends StatelessWidget {
  const _HorizontalLayout({required this.data, required this.onReadMore});
  final AdCardData data;
  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_T.cardRadius),
                    bottomLeft: Radius.circular(_T.cardRadius),
                  ),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _T.surfaceAlt,
                      child: const Center(child: Icon(Icons.image_outlined, size: 28, color: _T.textTertiary)),
                    ),
                  ),
                ),
                if (data.eventLabel != null && data.eventLabel!.isNotEmpty)
                  Positioned(top: 8, left: 8, child: _EventBadge(label: data.eventLabel!)),
              ],
            ),
          ),
          Expanded(child: _ContentBlock(data: data, onReadMore: onReadMore, compact: true)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  SHARED — Image section (vertical)
// ═════════════════════════════════════════════════════════════
class _AdImage extends StatelessWidget {
  const _AdImage({required this.imageUrl, this.eventLabel, this.height = 170});
  final String imageUrl;
  final String? eventLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: _T.surfaceAlt,
              child: const Center(child: Icon(Icons.image_outlined, size: 32, color: _T.textTertiary)),
            ),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: _T.surfaceAlt,
                child: Center(
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                          : null,
                      color: _T.textTertiary,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0, left: 0, right: 0, height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.06)],
                ),
              ),
            ),
          ),
          if (eventLabel != null && eventLabel!.isNotEmpty)
            Positioned(top: 10, left: 10, child: _EventBadge(label: eventLabel!)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  SHARED — Content block
// ═════════════════════════════════════════════════════════════
class _ContentBlock extends StatelessWidget {
  const _ContentBlock({required this.data, required this.onReadMore, this.compact = false});
  final AdCardData data;
  final VoidCallback onReadMore;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? _T.gap12 : _T.cardPadding).copyWith(top: _T.gap12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.companyName.toUpperCase(),
            style: TextStyle(
              fontSize: compact ? 9.5 : 10.5, fontWeight: FontWeight.w700,
              letterSpacing: 1.4, color: _T.textTertiary, height: 1,
            ),
          ),
          SizedBox(height: compact ? _T.gap4 : _T.gap6),
          Text(
            data.title,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 14.5 : 17, fontWeight: FontWeight.w700,
              color: _T.textPrimary, height: 1.25, letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: compact ? _T.gap2 : _T.gap4),
          Text(
            data.description,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 12 : 13, fontWeight: FontWeight.w400,
              color: _T.textSecondary, height: 1.4,
            ),
          ),
          SizedBox(height: compact ? _T.gap8 : _T.gap10),
          compact
              ? _CompactBottom(data: data, onReadMore: onReadMore)
              : _FullBottom(data: data, onReadMore: onReadMore),
        ],
      ),
    );
  }
}

class _FullBottom extends StatelessWidget {
  const _FullBottom({required this.data, required this.onReadMore});
  final AdCardData data;
  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 13, color: _T.textTertiary),
        const SizedBox(width: _T.gap4),
        Expanded(
          child: Text(data.formattedDate,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: _T.textTertiary, height: 1)),
        ),
        _ReadMoreButton(onTap: onReadMore),
      ],
    );
  }
}

class _CompactBottom extends StatelessWidget {
  const _CompactBottom({required this.data, required this.onReadMore});
  final AdCardData data;
  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.schedule_rounded, size: 12, color: _T.textTertiary),
            const SizedBox(width: _T.gap4),
            Flexible(
              child: Text(data.formattedDate, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: _T.textTertiary, height: 1)),
            ),
          ],
        ),
        const SizedBox(height: _T.gap8),
        _ReadMoreButton(onTap: onReadMore, small: true),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  SHARED — Event badge
// ═════════════════════════════════════════════════════════════
class _EventBadge extends StatelessWidget {
  const _EventBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _T.eventBadgeBg,
        borderRadius: BorderRadius.circular(_T.badgeRadius),
        border: Border.all(color: _T.eventBadgeText.withOpacity(0.15), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 5,
            decoration: const BoxDecoration(color: _T.eventBadgeText, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _T.eventBadgeText, height: 1)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  SHARED — Read More button
// ═════════════════════════════════════════════════════════════
class _ReadMoreButton extends StatelessWidget {
  const _ReadMoreButton({required this.onTap, this.small = false});
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _T.accent,
      borderRadius: BorderRadius.circular(_T.buttonRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_T.buttonRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: small ? 12 : 14, vertical: small ? 7 : 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Read More',
                style: TextStyle(fontSize: small ? 11 : 12, fontWeight: FontWeight.w600, color: _T.accentLabel, height: 1)),
              SizedBox(width: small ? 3 : 4),
              Icon(Icons.arrow_forward_rounded, size: small ? 12 : 13, color: _T.accentLabel),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  BOTTOM SHEET — Professional detail view
// ═════════════════════════════════════════════════════════════
class _DetailBottomSheet extends StatefulWidget {
  const _DetailBottomSheet({required this.data});
  final AdCardData data;

  @override
  State<_DetailBottomSheet> createState() => _DetailBottomSheetState();
}

class _DetailBottomSheetState extends State<_DetailBottomSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.15, 1.0, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic)));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final data = widget.data;

    return Container(
      constraints: BoxConstraints(maxHeight: screenH * 0.88),
      decoration: const BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_T.sheetRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(width: 36, height: 4,
              decoration: BoxDecoration(color: _T.border, borderRadius: BorderRadius.circular(2))),
          ),
          // Scrollable content
          Flexible(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 210, width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(data.imageUrl, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: _T.surfaceAlt,
                                  child: const Center(child: Icon(Icons.image_outlined, size: 36, color: _T.textTertiary)))),
                              // Gradient scrim
                              Positioned(
                                bottom: 0, left: 0, right: 0, height: 70,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.25)],
                                    ),
                                  ),
                                ),
                              ),
                              if (data.eventLabel != null && data.eventLabel!.isNotEmpty)
                                Positioned(top: 12, left: 12, child: _EventBadge(label: data.eventLabel!)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: _T.gap20),

                      // Company pill + date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _T.surfaceAlt,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: _T.border, width: 0.5),
                            ),
                            child: Text(data.companyName.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                letterSpacing: 1.4, color: _T.textSecondary, height: 1)),
                          ),
                          const Spacer(),
                          const Icon(Icons.schedule_rounded, size: 13, color: _T.textTertiary),
                          const SizedBox(width: 4),
                          Text(data.formattedDate,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: _T.textTertiary, height: 1)),
                        ],
                      ),
                      const SizedBox(height: _T.gap16),

                      // Title
                      Text(data.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                          color: _T.textPrimary, height: 1.2, letterSpacing: -0.5)),
                      const SizedBox(height: _T.gap12),

                      // Divider
                      Container(height: 1, color: _T.divider),
                      const SizedBox(height: _T.gap16),

                      // Body
                      Text(data.fullArticle ?? data.description,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400,
                          color: _T.textSecondary, height: 1.65)),
                      const SizedBox(height: _T.gap24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(child: _SheetOutlineButton(
                            icon: Icons.share_outlined, label: 'Share',
                            onTap: () => Navigator.of(context).pop())),
                          const SizedBox(width: 12),
                          Expanded(flex: 2, child: _SheetFilledButton(
                            icon: Icons.open_in_new_rounded, label: 'Visit Website',
                            onTap: () => Navigator.of(context).pop())),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  BOTTOM SHEET — Buttons
// ═════════════════════════════════════════════════════════════
class _SheetOutlineButton extends StatelessWidget {
  const _SheetOutlineButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: _T.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: _T.textSecondary),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _T.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetFilledButton extends StatelessWidget {
  const _SheetFilledButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _T.accent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: _T.accentLabel),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _T.accentLabel)),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  DEMO PAGE
// ═════════════════════════════════════════════════════════════
class AdCardDemoPage extends StatelessWidget {
  const AdCardDemoPage({super.key});

  static const _sampleArticle =
      'Rivian is redefining the adventure vehicle category with its next-generation electric platform. '
      'Built from the ground up for off-road capability and long-range efficiency, the R2 lineup represents '
      'a significant leap in both technology and accessibility.\n\n'
      'The new dual-motor powertrain delivers 600+ horsepower while maintaining a range of over 350 miles '
      'on a single charge. Advanced air suspension with predictive terrain mapping adjusts ride height '
      'automatically as road conditions change.\n\n'
      'Inside, a panoramic glass roof spans the full cabin, while sustainably sourced materials replace '
      'traditional leather throughout. The 16-inch center display runs Rivian\'s proprietary software with '
      'over-the-air updates, ensuring the vehicle improves over time.\n\n'
      'Pre-orders open worldwide starting March 2026.';

  @override
  Widget build(BuildContext context) {
    final verticalData = AdCardData(
      companyName: 'Rivian Automotive',
      title: 'The Future of Adventure Vehicles Is Electric',
      description: 'Explore our newest lineup of all-electric trucks and SUVs, designed for those who refuse to compromise.',
      dateTime: DateTime(2026, 2, 14, 10, 30),
      imageUrl: 'https://picsum.photos/seed/rivian/800/500',
      eventLabel: 'Live Event',
      fullArticle: _sampleArticle,
    );

    final horizontalData = AdCardData(
      companyName: 'Aesop',
      title: 'A New Chapter in Botanical Skincare',
      description: 'Discover plant-based formulations crafted with meticulous care for discerning individuals worldwide.',
      dateTime: DateTime(2026, 3, 1, 14, 0),
      imageUrl: 'https://picsum.photos/seed/aesop/800/500',
      eventLabel: 'Workshop',
      fullArticle: 'For over three decades, Aesop has pursued a singular vision: to create skincare of the '
          'highest quality that respects both the individual and the environment.\n\n'
          'Our latest collection draws on botanical research from six continents, combining rare plant '
          'extracts with cutting-edge delivery systems. Each formulation undergoes 18 months of testing '
          'before reaching our shelves.\n\n'
          'Visit any of our 400+ signature stores worldwide to experience the collection firsthand.',
    );

    final horizontalNoEvent = AdCardData(
      companyName: 'Muji',
      title: 'Simplicity That Speaks Volumes',
      description: 'Thoughtfully designed essentials for everyday living — minimal waste, maximum purpose.',
      dateTime: DateTime(2026, 4, 10, 9, 0),
      imageUrl: 'https://picsum.photos/seed/muji/800/500',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
        title: const Text('Ad Cards',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _T.textPrimary, letterSpacing: -0.3)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('VERTICAL'),
              const SizedBox(height: 10),
              Center(child: PremiumAdCard(data: verticalData)),

              const SizedBox(height: 28),
              _SectionLabel('HORIZONTAL'),
              const SizedBox(height: 10),
              PremiumAdCard(data: horizontalData, layout: AdCardLayout.horizontal),

              const SizedBox(height: 16),
              PremiumAdCard(data: horizontalNoEvent, layout: AdCardLayout.horizontal),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: _T.textTertiary));
  }
}