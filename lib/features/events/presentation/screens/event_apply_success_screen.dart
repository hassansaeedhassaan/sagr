import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobApplicationSuccessPage extends StatefulWidget {
  @override
  _JobApplicationSuccessPageState createState() => _JobApplicationSuccessPageState();
}

class _JobApplicationSuccessPageState extends State<JobApplicationSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  
  late Animation<double> _checkAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _checkController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Initialize animations
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    ));
    
    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOutQuart,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    // Start animations
    _startAnimations();
  }
  
  void _startAnimations() async {
    await _slideController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    _checkController.forward();
    await Future.delayed(Duration(milliseconds: 300));
    _confettiController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE9ECEF),
                  ],
                ),
              ),
            ),
            
            // Confetti animation
            AnimatedBuilder(
              animation: _confettiAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_confettiAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main content
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon with animation
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFF6C757D).withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6C757D).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: AnimatedBuilder(
                            animation: _checkAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: CheckmarkPainter(
                                  _checkAnimation.value,
                                  Color(0xFF495057),
                                ),
                                size: Size(120, 120),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Success title
                  Text(
                    'Application Submitted!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF343A40),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Success message
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Your job application has been successfully submitted. Please wait for the App Manager\'s response.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C757D),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Status card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.08),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xFF28A745),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Status: Under Review',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF495057),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Color(0xFF6C757D),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Expected response: 3-5 business days',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Color(0xFF6C757D),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'You\'ll receive updates via email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Action buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Get.offNamedUntil('/home', (route) => false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF495057),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back to Home',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to applications tracking
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF495057),
                              side: BorderSide(color: Color(0xFF6C757D)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Track Applications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for animated checkmark
class CheckmarkPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  
  CheckmarkPainter(this.animationValue, this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final checkPath = Path();
    
    // Define checkmark points
    final p1 = Offset(center.dx - 15, center.dy);
    final p2 = Offset(center.dx - 5, center.dy + 10);
    final p3 = Offset(center.dx + 15, center.dy - 10);
    
    if (animationValue > 0.0) {
      checkPath.moveTo(p1.dx, p1.dy);
      
      if (animationValue <= 0.5) {
        // First part of checkmark
        final t = animationValue * 2;
        final currentPoint = Offset.lerp(p1, p2, t)!;
        checkPath.lineTo(currentPoint.dx, currentPoint.dy);
      } else {
        // Complete first part, animate second part
        checkPath.lineTo(p2.dx, p2.dy);
        final t = (animationValue - 0.5) * 2;
        final currentPoint = Offset.lerp(p2, p3, t)!;
        checkPath.lineTo(currentPoint.dx, currentPoint.dy);
      }
      
      canvas.drawPath(checkPath, paint);
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom painter for confetti animation
class ConfettiPainter extends CustomPainter {
  final double animationValue;
  
  ConfettiPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue == 0.0) return;
    
    final paint = Paint()..style = PaintingStyle.fill;
    
    final colors = [
      Color(0xFF6C757D).withOpacity(0.6),
      Color(0xFF495057).withOpacity(0.6),
      Color(0xFFADB5BD).withOpacity(0.6),
      Color(0xFF28A745).withOpacity(0.6),
    ];
    
    // Draw confetti pieces
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (0.2 + (i % 6) * 0.15)) + 
                (animationValue * 50 * (i % 3 - 1));
      final y = size.height * 0.3 + 
                (animationValue * size.height * 0.8) + 
                (i % 4 * 20);
      
      paint.color = colors[i % colors.length];
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(animationValue * 3.14159 * 2 * (i % 4));
      
      if (i % 2 == 0) {
        // Rectangle confetti
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: 8, height: 12),
            Radius.circular(2),
          ),
          paint,
        );
      } else {
        // Circle confetti
        canvas.drawCircle(Offset.zero, 4, paint);
      }
      
      canvas.restore();
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}