// import 'package:flutter/material.dart';

// class ExampleUsage extends StatefulWidget {
//   @override
//   _ExampleUsageState createState() => _ExampleUsageState();
// }

// class _ExampleUsageState extends State<ExampleUsage> {
//   bool _showIndicator = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Circle Indicator Example')),
//       body: ScreenWithOverlay(
//         showIndicator: _showIndicator,
//         indicatorColor: Colors.red,
//         indicatorSize: 120.0,
//         indicatorChild: Icon(
//           Icons.wifi,
//           color: Colors.white,
//           size: 40,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Your main screen content here'),
//             SizedBox(height: 20),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     setState(() {
//             //       _showIndicator = !_showIndicator;
//             //     });
//             //   },
//             //   child: Text(_showIndicator ? 'Hide Indicator' : 'Show Indicator'),
//             // ),
//             // SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Using global overlay
//                 GlobalCircleIndicator.show(
//                   context,
//                   color: Colors.green,
//                   size: 100,
//                   child: Icon(Icons.check, color: Colors.white, size: 30),
//                 );
//               },
//               child: Text('Show Global Indicator'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 GlobalCircleIndicator.hide();
//               },
//               child: Text('Hide Global Indicator'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class ScreenWithOverlay extends StatefulWidget {
//   final Widget child;
//   final bool showIndicator;
//   final Color indicatorColor;
//   final double indicatorSize;
//   final Widget? indicatorChild;

//   const ScreenWithOverlay({
//     Key? key,
//     required this.child,
//     this.showIndicator = false,
//     this.indicatorColor = Colors.blue,
//     this.indicatorSize = 100.0,
//     this.indicatorChild,
//   }) : super(key: key);

//   @override
//   State<ScreenWithOverlay> createState() => _ScreenWithOverlayState();
// }

// class _ScreenWithOverlayState extends State<ScreenWithOverlay> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Your main screen content
//         widget.child,
        
//         // Overlay indicator
//         if (widget.showIndicator)
//           Positioned.fill(
//             child: AnimatedCircleIndicator(
//               color: widget.indicatorColor,
//               size: widget.indicatorSize,
//               isVisible: widget.showIndicator,
//               child: widget.indicatorChild,
//             ),
//           ),
//       ],
//     );
//   }
// }

// // Alternative: Global Overlay using Overlay widget
// class GlobalCircleIndicator {
//   static OverlayEntry? _overlayEntry;

//   static void show(
//     BuildContext context, {
//     Color color = Colors.blue,
//     double size = 100.0,
//     Widget? child,
//   }) {
//     if (_overlayEntry != null) return;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Material(
//         color: Colors.transparent,
//         child: CircleIndicatorOverlay(
//           color: color,
//           size: size,
//           child: child,
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   static void hide() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
// }

// class CircleIndicatorOverlay extends StatelessWidget {
//   final Color color;
//   final double size;
//   final bool isVisible;
//   final Widget? child; // Optional content inside the circle

//   const CircleIndicatorOverlay({
//     Key? key,
//     this.color = Colors.blue,
//     this.size = 100.0,
//     this.isVisible = true,
//     this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (!isVisible) return const SizedBox.shrink();

//     return Center(
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color.withOpacity(0.8),
//           border: Border.all(
//             color: color,
//             width: 2.0,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: child,
//       ),
//     );
//   }
// }


// class AnimatedCircleIndicator extends StatefulWidget {
//   final Color color;
//   final double size;
//   final bool isVisible;
//   final Widget? child;

//   const AnimatedCircleIndicator({
//     Key? key,
//     this.color = Colors.blue,
//     this.size = 100.0,
//     this.isVisible = true,
//     this.child,
//   }) : super(key: key);

//   @override
//   _AnimatedCircleIndicatorState createState() => _AnimatedCircleIndicatorState();
// }

// class _AnimatedCircleIndicatorState extends State<AnimatedCircleIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );

//     if (widget.isVisible) {
//       _controller.forward();
//     }
//   }

//   @override
//   void didUpdateWidget(AnimatedCircleIndicator oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isVisible != oldWidget.isVisible) {
//       if (widget.isVisible) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: widget.color.withOpacity(0.8),
//                 border: Border.all(
//                   color: widget.color,
//                   width: 2.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: widget.child,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class CenterCircleOverlay extends StatelessWidget {
  final Widget child;
  final bool showIndicator;
  final Color circleColor;
  final double circleSize;
  final double strokeWidth;
  final bool isAnimated;

  const CenterCircleOverlay({
    Key? key,
    required this.child,
    this.showIndicator = true,
    this.circleColor = Colors.red,
    this.circleSize = 50.0,
    this.strokeWidth = 3.0,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your main screen content
        child,
        
        // Overlay indicator
        if (showIndicator)
          Positioned.fill(
            child: Center(
              child: isAnimated
                  ? AnimatedCircleIndicator(
                      color: circleColor,
                      size: circleSize,
                      strokeWidth: strokeWidth,
                    )
                  : StaticCircleIndicator(
                      color: circleColor,
                      size: circleSize,
                      strokeWidth: strokeWidth,
                    ),
            ),
          ),
      ],
    );
  }
}

// Static circle indicator
class StaticCircleIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const StaticCircleIndicator({
    Key? key,
    required this.color,
    required this.size,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: strokeWidth,
        ),
      ),
    );
  }
}

// Animated circle indicator
class AnimatedCircleIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const AnimatedCircleIndicator({
    Key? key,
    required this.color,
    required this.size,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  State<AnimatedCircleIndicator> createState() => _AnimatedCircleIndicatorState();
}

class _AnimatedCircleIndicatorState extends State<AnimatedCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
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
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              child: const CircularProgressIndicator(),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color,
                  width: widget.strokeWidth,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for more complex indicators
class CustomCircleIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final bool showCrosshair;

  const CustomCircleIndicator({
    Key? key,
    required this.color,
    required this.size,
    required this.strokeWidth,
    this.showCrosshair = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CircleIndicatorPainter(
        color: color,
        strokeWidth: strokeWidth,
        showCrosshair: showCrosshair,
      ),
    );
  }
}

class CircleIndicatorPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool showCrosshair;

  CircleIndicatorPainter({
    required this.color,
    required this.strokeWidth,
    required this.showCrosshair,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw circle
    canvas.drawCircle(center, radius, paint);

    // Draw crosshair if enabled
    if (showCrosshair) {
      final crosshairLength = radius * 0.3;
      
      // Horizontal line
      canvas.drawLine(
        Offset(center.dx - crosshairLength, center.dy),
        Offset(center.dx + crosshairLength, center.dy),
        paint,
      );
      
      // Vertical line
      canvas.drawLine(
        Offset(center.dx, center.dy - crosshairLength),
        Offset(center.dx, center.dy + crosshairLength),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Usage examples
class ExampleScreen extends StatefulWidget {
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool _showIndicator = true;
  bool _useAnimation = false;
  bool _showCrosshair = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Circle Indicator Overlay')),
      body: CenterCircleOverlay(
        showIndicator: _showIndicator,
        isAnimated: _useAnimation,
        circleColor: Colors.red,
        circleSize: 120.0,
        strokeWidth: 4.0,
        child: Column(
          children: [
            // Your main content here
            Expanded(
              child: Container(
                color: Colors.blue.shade50,
                child: Center(
                  child: Text(
                    'Your main screen content goes here',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            
            // Controls
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Show Indicator'),
                    value: _showIndicator,
                    onChanged: (value) {
                      setState(() {
                        _showIndicator = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Animated'),
                    value: _useAnimation,
                    onChanged: (value) {
                      setState(() {
                        _useAnimation = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Alternative: Show custom painted indicator
      floatingActionButton: _showIndicator && _showCrosshair
          ? Positioned(
              top: MediaQuery.of(context).size.height / 2 - 60,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: CustomCircleIndicator(
                color: Colors.green,
                size: 120,
                strokeWidth: 3,
                showCrosshair: true,
              ),
            )
          : null,
    );
  }
}