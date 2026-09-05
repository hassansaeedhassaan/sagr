import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _orbitController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _indicatorFade;

  final SagrAuthController authController = Get.find<SagrAuthController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.brandDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _logoFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
    ));
    _taglineFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
    );
    _indicatorFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    _entryController.forward();
    _scheduleRedirect();
  }

  void _scheduleRedirect() {
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      if (authController.isLoggedIn.value) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildOrbitLayer(size),
          _buildContent(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.brand,
            AppTheme.brandDark,
            AppTheme.navy,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }

  Widget _buildOrbitLayer(Size size) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (_, __) {
          final t = _orbitController.value * 2 * math.pi;
          return Stack(
            children: [
              _glowBlob(
                left: -80 + 30 * math.sin(t),
                top: 80 + 20 * math.cos(t),
                size: 220,
                color: Colors.white.withOpacity(0.10),
              ),
              _glowBlob(
                right: -60 + 25 * math.cos(t),
                top: size.height * 0.35 + 20 * math.sin(t),
                size: 260,
                color: AppTheme.brand.withOpacity(0.35),
              ),
              _glowBlob(
                left: size.width * 0.2 + 25 * math.sin(t * 0.7),
                bottom: -100,
                size: 300,
                color: AppTheme.sky.withOpacity(0.22),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _glowBlob({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: _buildLogoCard(),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _titleFade,
              child: SlideTransition(
                position: _titleSlide,
                child: const Text(
                  'Sagr',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _taglineFade,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                  ),
                ),
                child: Text(
                  'منصة الفعاليات والوظائف'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64),
            FadeTransition(
              opacity: _indicatorFade,
              child: const _DotsLoader(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoCard() {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.20),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/sagr-logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: FadeTransition(
        opacity: _indicatorFade,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'v1.0',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.55),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Powered by Sagr',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_controller.value + i * 0.18) % 1.0;
            final scale =
                0.6 + 0.4 * (math.sin(phase * 2 * math.pi).abs());
            final opacity = 0.35 + 0.65 * scale;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 10 * scale,
              height: 10 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}
