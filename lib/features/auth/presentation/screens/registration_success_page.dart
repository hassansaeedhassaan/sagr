import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class RegistrationSuccessPage extends StatefulWidget {
  const RegistrationSuccessPage({Key? key}) : super(key: key);

  @override
  State<RegistrationSuccessPage> createState() => _RegistrationSuccessPageState();
}

class _RegistrationSuccessPageState extends State<RegistrationSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _checkmarkAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final List<ConfettiParticle> _confettiParticles = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));
    
    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Generate confetti particles
    _generateConfetti();
    
    // Start animations with delays
    _startAnimations();
  }

  void _generateConfetti() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _confettiParticles.add(
        ConfettiParticle(
          x: random.nextDouble(),
          y: random.nextDouble() * 0.3,
          color: _getRandomColor(),
          size: random.nextDouble() * 8 + 4,
          rotation: random.nextDouble() * 2 * math.pi,
          velocity: random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.pink,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.yellow,
      Colors.red,
      Colors.teal,
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  void _startAnimations() async {
    // Start confetti immediately
    _confettiController.forward();
    
    // Delay for checkmark
    await Future.delayed(const Duration(milliseconds: 300));
    _checkmarkController.forward();
    
    // Delay for text fade-in
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    
    // Delay for content scale
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();
    
    // Delay for button slide
    await Future.delayed(const Duration(milliseconds: 400));
    _slideController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _confettiController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Confetti Animation
              AnimatedBuilder(
                animation: _confettiAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConfettiPainter(
                      particles: _confettiParticles,
                      animation: _confettiAnimation.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
              
              // Main Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success Icon with Animation
                      AnimatedBuilder(
                        animation: _checkmarkAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _checkmarkAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: CheckmarkPainter(
                                  progress: _checkmarkAnimation.value,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Success Text with Fade Animation
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'Success!'.tr,
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your account has been\ncreated successfully!'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.4,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Welcome Message
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.celebration,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Welcome to our community!'.tr,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Back to Login Button with Slide Animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    colors: [Colors.white, Colors.white],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate back to login
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login',
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.login,
                                        color: Color(0xFF667eea),
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Back to Login'.tr,
                                        style: TextStyle(
                                          color: Color(0xFF667eea),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  double rotation;
  final double velocity;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
    required this.velocity,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animation;

  ConfettiPainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      // Update particle position
      final x = particle.x * size.width;
      final y = particle.y * size.height + (animation * particle.velocity * size.height);
      
      // Only draw if particle is visible
      if (y < size.height + particle.size) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(particle.rotation + animation * 4);
        
        // Draw different shapes
        if (particle.size > 6) {
          // Draw rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        } else {
          // Draw circle
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
        }
        
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final checkmarkSize = size.width * 0.3;

    // Define checkmark path
    final path = Path();
    path.moveTo(center.dx - checkmarkSize * 0.5, center.dy);
    path.lineTo(center.dx - checkmarkSize * 0.1, center.dy + checkmarkSize * 0.3);
    path.lineTo(center.dx + checkmarkSize * 0.5, center.dy - checkmarkSize * 0.3);

    // Draw checkmark with progress
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractedPath = pathMetric.extractPath(
        0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractedPath, paint);
    }
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Example usage in your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Success Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', // Use your preferred font
      ),
      home: const RegistrationSuccessPage(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

// Placeholder login page
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome back to Login!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Your login form would go here...'),
          ],
        ),
      ),
    );
  }
}